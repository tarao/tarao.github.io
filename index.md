---
layout: default
repositories:
  maintaining:
    min_stargazers: 30
  contributing:
    min_stargazers: 50
---
{%- include profile.html author = site.author %}

<ul class="toc">
<li><a target="_self" href="#work-exp">Work Experience</a></li>
<li><a target="_self" href="#education">Education</a></li>
<li><a target="_self" href="#publications">Publications</a></li>
<li><a target="_self" href="#talks">Talks</a></li>
<li><a target="_self" href="#interviews">Interviews</a></li>
<li><a target="_self" href="#blog-posts">Blog Posts</a></li>
<li><a target="_self" href="#software">Software</a></li>
</ul>

## Work Experience <a id="work-exp"></a>

<ul class="work-experience">
{%- for work in site.data.work_experience %}
<li>
{% include work.html work = work %}
</li>
{%- endfor %}
</ul>

## Education <a id="education"></a>

<ul class="education">
{%- for education in site.data.education %}
<li>
{% include education.html education = education %}
</li>
{%- endfor %}
</ul>

## Publications <a id="publications"></a>

### Academic Papers

{% include bibliography.html
   category = 'papers'
   items = site.data.publications.papers %}

### Tech Magazine Articles

{% include bibliography.html
   category = 'magazine'
   items = site.data.publications.magazine %}

## Talks <a id="talks"></a>

### Research Talks

{% include bibliography.html
   category = 'research-talks'
   items = site.data.talks.research %}

### Tech Talks

{% include bibliography.html
   category = 'tech-talks'
   items = site.data.talks.tech %}

## Interviews <a id="interviews"></a>

{% include bibliography.html
   category = 'interviews'
   items = site.data.interviews %}

## Blog Posts <a id="blog-posts"></a>

### Personal Tech Blog Articles (with 50+ bookmarks)

<ul class="blog">
{%- rssfeed url: https://b.hatena.ne.jp/q/site%3Ahttps%3A%2F%2Ftarao.hatenablog.com%2F?mode=rss&target=text&users=50 %}
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
{%- rssfeed url: https://developer.hatenastaff.com/rss/author/tarao %}
<li>
{% include feed_item.html
   item = item %}
</li>
{%- endrssfeed %}
</ul>

<iframe src="https://blog.hatena.ne.jp/hatenatech/developer.hatenastaff.com/subscribe/iframe" allowtransparency="true" frameborder="0" scrolling="no" width="150" height="28"></iframe>

## Software <a id="software"></a>

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
