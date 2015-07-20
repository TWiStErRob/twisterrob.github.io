---
permalink: /work/jobs.html
redirect_from:
- /work/
title: "Róbert Papp's work experience"
breadcrumbs: true
---
{% for job in site.jobs reversed %}{% unless job.hidden %}
 * <span title="{{ job.from }}">{{ job.from | date: '%Y' }}</span> -- <span title="{{ job.to }}">{{ job.to | date: '%Y' }}</span> (~{% include datediff.liq begin=job.from end=job.to measure='dynamic' %} {{measure}}) {{ job.type }}: [**{{ job.title }}**]({{ site.baseurl }}{{ job.url }}){% endunless %}{% endfor %}
