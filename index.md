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
