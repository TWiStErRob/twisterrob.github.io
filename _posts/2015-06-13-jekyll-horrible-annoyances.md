---
title: "Horrible annoyances while setting up Jekyll"
subheadline: "Work around the quirks"
teaser: "Have you ever found that Jekyll or one of it's component is lacking a feature?"
category: dev
tags:
- Jekyll
- collection
---

<!--more-->

## Liquid

### Exceptionally weird error message
I wanted to sort tags case insensitively:
{% highlight liquid %}
{%raw%}{% assign tag_words = site_tags | split:',' | map: downcase | sort %}{%endraw%}
{% endhighlight %}
... and I got the following error message

> Liquid Exception: no implicit conversion from nil to integer in blog/tags.html

After minutes of trying to fix or remove parts of the file which are dealing with numbers like `0 < post.size`, I found out that this line gives the message:
{% highlight liquid %}
{%raw%}{% assign tag_words = site_tags | split:',' | map: "downcase" | sort %}{%endraw%}
{% endhighlight %}
