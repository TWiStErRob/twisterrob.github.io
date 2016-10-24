{% capture result %}
	{% assign begin_year = include.begin | date: '%Y' %}
	{% assign end_year = include.end | date: '%Y' %}
	{% assign begin_day = include.begin | date: '%j' %}
	{% assign end_day = include.end | date: '%j' %}

	{% assign year_diff = end_year | minus: begin_year %}
	{% assign day_diff = end_day | minus: begin_day %}
	{% if day_diff < 0 %}
		{% assign year_diff = year_diff | minus: 1 %}
		{% assign day_diff = day_diff | plus: 365 %}
	{% endif %}

	{% assign measure = include.measure %}
	{% if measure == 'dynamic' %}
		{% if 1 < year_diff or year_diff == 1 and day_diff > 180 %}
			{% assign measure = 'years' %}
		{% elsif year_diff == 0 and day_diff <= 42 %}
			{% assign measure = 'days' %}
		{% else %}
			{% assign measure = 'months' %}
		{% endif %}
	{% endif %}

	{% if measure == 'days' %}
		{% comment %} result = years * 365 + days, no fractions (integer arithmetic) {% endcomment %}
		{% assign date_diff = year_diff | times: 365 | plus: day_diff %}
		{{ date_diff }}
	{% elsif measure == 'months' %}
		{% comment %} result = years * 12 + days / 30 round up, .0 ending removed {% endcomment %}
		{% assign year_diff_mo = year_diff | times: 12 %}
		{% assign day_diff_mo = day_diff | divided_by: 30.0 %}
		{% assign day_diff_mo_fraction = day_diff_mo | modulo: 1 %}
		{% if 0.1 < day_diff_mo_fraction %}
			{% assign day_diff_mo = day_diff_mo | minus: day_diff_mo_fraction | plus: 1 %}
		{% else %}
			{% assign day_diff_mo = day_diff_mo | minus: day_diff_mo_fraction %}
		{% endif %}
		{% assign date_diff = year_diff_mo | plus: day_diff_mo %}
		{{ date_diff | remove: '.0' }}
	{% elsif measure == 'years' %}
		{% comment %} result = years + days / 365 rounded to nearest 0.1, .0 ending removed {% endcomment %}
		{% assign day_diff_yr = day_diff | divided_by: 365.0 %}
		{% assign date_diff = day_diff_yr | plus: year_diff | times: 10 %}
		{% assign date_diff_fraction = date_diff | modulo: 1 %}
		{% if 0.5 < date_diff_fraction %}
			{% assign date_diff = date_diff | minus: date_diff_fraction | plus: 1 %}
		{% else %}
			{% assign date_diff = date_diff | minus: date_diff_fraction %}
		{% endif %}
		{% assign date_diff = date_diff | divided_by: 10 %}
		{{ date_diff | remove: '.0' }}
	{% endif %}
{% endcapture %}{% assign result = result | times: 1 %}<!-- {{include.begin}}:{{begin_year}}/{{begin_day}} - {{include.end}}:{{end_year}}/{{end_day}} = {{year_diff}}/{{day_diff}}: {{measure}} -->