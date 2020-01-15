---
layout: default
repositories:
  maintaining:
    min_stargazers: 30
  contributing:
    min_stargazers: 50
---
{%- include profile.html author = site.author %}

## Work Experience

<ul class="work-experience">
{%- for work in site.data.work_experience %}
<li>
{% include work.html work = work %}
</li>
{%- endfor %}
</ul>

## Education

<ul class="education">
{%- for education in site.data.education %}
<li>
{% include education.html education = education %}
</li>
{%- endfor %}
</ul>

## Publications

### Academic Papers

{% include bibliography.html
   category = 'papers'
   items = site.data.publications.papers %}

### Tech Magazine Articles

{% include bibliography.html
   category = 'magazine'
   items = site.data.publications.magazine %}

## Talks

### Research Talks

{% include bibliography.html
   category = 'research-talks'
   items = site.data.talks.research %}

### Tech Talks

{% include bibliography.html
   category = 'tech-talks'
   items = site.data.talks.tech %}

## Interviews

{% include bibliography.html
   category = 'interviews'
   items = site.data.interviews %}

## Blog Posts

### Personal Tech Blog Articles (with 50+ bookmarks)

<ul class="blog">
{%- rssfeed url: https://b.hatena.ne.jp/search/text?q=site%3Ahttps%3A%2F%2Ftarao.hatenablog.com%2F&users=50&mode=rss %}
<li>
{% include feed_item.html
   item = item
   site_title = site.author.blog.title %}
</li>
{%- endrssfeed %}
</ul>

<iframe src="https://blog.hatena.ne.jp/tarao/tarao.hatenablog.com/subscribe/iframe" allowtransparency="true" frameborder="0" scrolling="no" width="150" height="28"></iframe>

### Contributed Articles to Hatena Developer Blog

<ul class="blog">
{%- scrape url: https://developer.hatenastaff.com/archive/author/tarao
           item:  section.archive-entry
           title: .entry-title-link
           link:  .entry-title-link
           date:  .archive-date %}
<li>
{% include feed_item.html
   item = item %}
</li>
{%- endscrape %}
</ul>

<iframe src="https://blog.hatena.ne.jp/hatenatech/developer.hatenastaff.com/subscribe/iframe" allowtransparency="true" frameborder="0" scrolling="no" width="150" height="28"></iframe>

## Software

### Web Services

<ul class="web-services">
{%- for service in site.data.software.web_services %}
<li>
{% include web_service.html service = service %}
</li>
{%- endfor %}
</ul>

### Maintaining Repositories (with ★{{ page.repositories.maintaining.min_stargazers }}+)

<ul class="repositories maintaining">
{%- githubrepos
    min_stargazers: page.repositories.maintaining.min_stargazers
    role: committer %}
<li>
{%- assign role = site.data.repositories.roles[repository.name] %}
{% include github_repo.html role = role %}
</li>
{%- endgithubrepos %}
</ul>

### Contributing Repositories (with ★{{ page.repositories.contributing.min_stargazers }}+)

<ul class="repositories contributing">
{%- githubrepos
    min_stargazers: page.repositories.contributing.min_stargazers
    role: contributor %}
<li>
{%- assign role = site.data.repositories.roles[repository.name] %}
{% include github_repo.html role = role %}
</li>
{%- endgithubrepos %}
</ul>
