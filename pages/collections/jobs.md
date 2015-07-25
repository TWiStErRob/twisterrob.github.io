---
permalink: /work/
title: "Róbert Papp's work experience"
breadcrumbs: true
---
<span class="icon-install"></span> Download my [CV]({{ site.data.links.cv-view }}) as a [PDF]({{ site.data.links.cv-download }}).  
{% comment %}<span class="icon-trophy"></span> Check out my [detailed skills]({{ site.baseurl }}/work/skills.html).{% endcomment %}

{% for job in site.jobs reversed %}{% unless job.hidden %}
 * <span title="{{ job.from }}">{{ job.from | date: '%Y' }}</span> -- <span title="{{ job.to }}">{{ job.to | date: '%Y' }}</span> (~{% include datediff.liq begin=job.from end=job.to measure='dynamic' %} {{measure}}) {{ job.type }}: [**{{ job.title }}**]({{ site.baseurl }}{{ job.url }}){% endunless %}{% endfor %}
