---
permalink: /contact/
layout: page
title: "Contact"
meta_title: "Contact Róbert Papp (TWiStErRob)"
show_meta: false
teaser: "Want to message me to ask a question or just tell me something?"
script: 'function rot13(c){return String.fromCharCode((c<="Z"?90:122)>=(c=c.charCodeAt(0)+13)?c:c-26)}'
---
You can find different ways to get in touch with me below.  
If you want to know more about me check out the [info page]({{ site.baseurl }}/info/).

## E-mail

{% assign email = site.data.authors[site.author].email %}
{% if email %}
You can reach me at {% include safe-email.html address=email %} where you can send attachments, images, etc. In case you just want to send me a quick message or want to stay anonymous, feel free to use the form below.
{% endif %}

<iframe src="https://docs.google.com/forms/d/1cG89BafxKwdxv9kzS-C_MjZfte0Ldlz37vr0m2U77jA/viewform?embedded=true"
	 width="100%" height="715" frameborder="0" marginwidth="0" marginheight="0" scrolling="no">Loading...</iframe>

## Social contacts

You can also find me on various social sites, check them out at the [bottom of the page](#subfooter).
