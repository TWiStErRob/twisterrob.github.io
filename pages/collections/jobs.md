---
permalink: /work/
title: "Róbert Papp's work experience"
breadcrumbs: true
---
<span class="icon-install"></span> Download my [CV]({{ site.data.links.cv-view }}){:target="_blank"} as a [PDF]({{ site.data.links.cv-download }}).  
{% comment %}<span class="icon-trophy"></span> Check out my [detailed skills]({{ site.baseurl }}/work/skills.html).{% endcomment %}


I'm also developing applications at home, to ease the pain of repetitive tasks and help myself (and others) to work/live more efficiently. It's also a good opportunity to keep myself challenged and keep my officially unused technical knowledge fresh. See the list of my [Projects]({{ site.baseurl }}/project/) for more information.

<section class="timeline clearfix">
	<h2 class="timeline-date">The Future</h2>
	{% assign lastYear = 0 %}
	{% for job in site.jobs reversed %}{% unless job.hidden %}
		<a href="{{ site.baseurl }}{{ job.url }}" title="{{ job.type }}: {{ job.jobtitle }} in {{ job.maintech }}">
		<article class="timeline-box {% if job.type == 'Company' %}left{% else %}right{% endif %}">
			<h3>{{ job.title }}</h3>
			<span class="icon-calendar">
				{% assign job_from = job.dates.from | date: '%Y' %}
				{% assign job_to = job.dates.to | date: '%Y' %}
				{% if job_from != job_to %}
				<span title="{{ job.dates.from }}">{{ job_from }}</span> &ndash; <span title="{{ job.dates.to }}">{{ job_to }}</span>
				{% else %}
				<span title="{{ job.dates.from }} &ndash; {{ job.dates.to }}">{{ job_from }}</span>
				{% endif %}
				{% if job_from != nil and job_to != nil %}
					(~{% include datediff.liq begin=job.dates.from end=job.dates.to measure='dynamic' %}{{ result }}&nbsp;{{ measure }})
				{% else %}
					current
				{% endif %}
			</span><br/>
			<strong>Role</strong>: {{ job.jobtitle }}<br/>
			<strong>Sector</strong>: {{ job.sector }}<br/>
			<strong>Main technologies</strong>: {{ job.maintech }}
		</article></a>

		{% assign currentYear = job.dates.from | date: '%Y' %}
		{% assign diff = currentYear | minus: lastYear %}{% if diff < 0 %}{% assign diff = 0 | minus: diff %}{% endif %}
		{% if forloop.first == false and lastYear <> currentYear and diff > 1 %}
			<h2 class="timeline-date">{{currentYear}}</h2>
			{% assign lastYear = currentYear %}
		{% endif %}
	{% endunless %}{% endfor %}
</section>

{%comment%}
{% for job in site.jobs reversed %}{% unless job.hidden %}
 * <span title="{{ job.dates.from }}">{{ job.dates.from | date: '%Y' }}</span>
   --
   <span title="{{ job.dates.to }}">{{ job.dates.to | date: '%Y' }}</span>
   {% include datediff.liq begin=job.dates.from end=job.dates.to measure='dynamic' %}
   {% if result != 0 %}(~{{ result }}&nbsp;{{ measure }}){% endif %}:
   [**{{ job.title }}**]({{ site.baseurl }}{{ job.url }}){: title="{{ job.type }}: {{ job.jobtitle }} in {{ job.maintech }}"}{% endunless %}{% endfor %}
{%endcomment%}
