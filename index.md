---
layout: default
---
{%- include profile.html author = site.author %}

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
