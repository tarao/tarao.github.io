require 'time'
require 'graphql/client'
require 'graphql/client/http'

module GitHubAPI
  HTTP = GraphQL::Client::HTTP.new('https://api.github.com/graphql') do
    def headers(context)
      { Authorization: "bearer #{ENV['GITHUB_TOKEN']}" }
    end
  end

  Schema = GraphQL::Client.load_schema(HTTP)

  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

  ContributionFragment = <<-'GRAPHQL'
    contributions {
      totalCount
    }
    repository {
      nameWithOwner
      description
      isArchived
      isDisabled
      isLocked
      isPrivate
      viewerPermission
      stargazers(first: 0) {
        totalCount
      }
      languages(first: 10, orderBy: { field: SIZE, direction: DESC }) {
        totalSize
        edges {
          size
          node {
            color
            name
          }
        }
      }
      repositoryTopics(first: 10) {
        nodes {
          topic {
            name
          }
          url
        }
      }
      url
    }
  GRAPHQL

  ContributingRepositoryQuery = Client.parse <<-"GRAPHQL"
    query($from: DateTime!, $to: DateTime!) {
      viewer {
        contributionsCollection(
          from: $from
          to: $to
        ) {
          commitContributionsByRepository(maxRepositories: 100) {
            #{ContributionFragment}
          }
          pullRequestContributionsByRepository(maxRepositories: 100) {
            #{ContributionFragment}
          }
          pullRequestReviewContributionsByRepository(maxRepositories: 100) {
            #{ContributionFragment}
          }
        }
      }
    }
  GRAPHQL

  def self.role_of_repository(repository)
    case repository.viewer_permission
    when 'ADMIN' then
      'committer'
    when 'MAINTAIN' then
      'committer'
    when 'WRITE' then
      'committer'
    else
      'contributor'
    end
  end

  def self.repository_to_hash(repository)
    size = repository.languages.total_size
    {
      'name' =>        repository.name_with_owner,
      'description' => repository.description,
      'url' =>         repository.url,
      'is_private' =>  repository.is_private,
      'is_active' =>   ![
        repository.is_archived,
        repository.is_disabled,
        repository.is_locked,
      ].any?,
      'permission' =>  repository.viewer_permission,
      'role' =>        self.role_of_repository(repository),
      'stargazers' =>  repository.stargazers.total_count,
      'languages' =>   repository.languages.edges.map do |l|
        {
          'name' =>     l.node.name,
          'color' =>    l.node.color,
          'size' =>     l.size,
          'coverage' => (l.size * 1.0 / size * 100).to_i,
        }
      end,
      'topics' =>      repository.repository_topics.nodes.map do |t|
        {
          'name' => t.topic.name,
          'url' =>  t.url,
        }
      end,
    }
  end

  def self.merge_repos(repo1, repo2)
    repo1.merge!(repo2) do |key, old, new|
      if key == 'contributions'
        old.merge!(new) do |key1, old1, new1|
          old1 + new1
        end
      else
        old
      end
    end
  end

  def self.repositories()
    to = Time.now
    repos = {}

    loop do
      from = to - 60 * 60 * 24 * 365 + 1

      result = GitHubAPI::Client.query(
        ContributingRepositoryQuery,
        variables: {
          from: from.iso8601,
          to: to.iso8601,
        }
      )

      contributions = result.data.viewer.contributions_collection

      contributions.commit_contributions_by_repository.each do |c|
        repo = self.repository_to_hash(c.repository).merge(
          {
            'contributions' => {
              'commits' => c.contributions.total_count,
            }
          }
        )
        name = repo['name']
        repos[name] = self.merge_repos(repos[name] || {}, repo)
      end

      contributions.pull_request_contributions_by_repository.each do |c|
        repo = self.repository_to_hash(c.repository).merge(
          {
            'contributions' => {
              'pull_requests' => c.contributions.total_count,
            }
          }
        )
        name = repo['name']
        repos[name] = self.merge_repos(repos[name] || {}, repo)
      end

      contributions.pull_request_review_contributions_by_repository.each do |c|
        repo = self.repository_to_hash(c.repository).merge(
          {
            'contributions' => {
              'reviews' => c.contributions.total_count,
            }
          }
        )
        name = repo['name']
        repos[name] = self.merge_repos(repos[name] || {}, repo)
      end

      size = contributions.commit_contributions_by_repository.size +
             contributions.pull_request_contributions_by_repository.size +
             contributions.pull_request_review_contributions_by_repository.size
      break if size <= 0

      to = from - 1
    end

    repos.values.select do |r|
      r['is_active'] && !r['is_private']
    end.sort do |a, b|
      b['stargazers'] <=> a['stargazers']
    end
  end
end

module Jekyll
  class GitHubRepos < Liquid::Block
    def initialize(tag_name, markup, parse_context)
      super

      @attributes = {}
      markup.scan(Liquid::TagAttributes) do |key, value|
        @attributes[key] = value
      end if markup
    end

    def cache
      @@cache ||= Jekyll::Cache.new(self.class.name)
    end

    def render(context)
      repositories = cache.getset('repositories') do
        GitHubAPI.repositories()
      end

      min_stargazers = @attributes['min_stargazers']
      min_stargazers = Liquid::VariableLookup.new(min_stargazers).evaluate(context) if min_stargazers.respond_to?(:scan)
      min_stargazers ||= @attributes['min_stargazers'].to_i || 0

      role = @attributes['role']
      role = Liquid::VariableLookup.new(role).evaluate(context) if role.respond_to?(:scan)
      role ||= @attributes['role'] || [ 'committer', 'contributor' ]
      role = [ role ] unless role.is_a?(Array)

      repositories = repositories.filter do |repo|
        [
          repo['stargazers'] >= min_stargazers,
          role.include?(repo['role']),
        ].all?
      end

      length = repositories.length
      result = []

      context.stack do
        repositories.each_with_index do |repo, index|
          context['repository'] = repo

          context['forloop'] = {
            'name'    => 'githubrepos',
            'length'  => length,
            'index'   => index + 1,
            'index0'  => index,
            'rindex'  => length - index,
            'rindex0' => length - index - 1,
            'first'   => (index == 0),
            'last'    => (index == length - 1),
          }

          result << nodelist.map do |n|
            if n.respond_to? :render
              n.render(context)
            else
              n
            end
          end.join('')
        end
      end

      result
    end
  end
end

Liquid::Template.register_tag('githubrepos', Jekyll::GitHubRepos)
