---
permalink: /contact/
layout: page
title: "Contact"
meta_title: "Contact Róbert Papp (TWiStErRob)"
teaser: "Want to message me to ask a question or just tell me something?"
script:
  head: >
    function rot5(c){return c.length>1?c.replace(/[0-9]/g, rot5):String.fromCharCode((c<="9"?57:57)>=(c=c.charCodeAt(0)+5)?c:c-10);}
    function rot13(c){return c.length>1?c.replace(/[a-zA-Z]/g, rot13):String.fromCharCode((c<="Z"?90:122)>=(c=c.charCodeAt(0)+13)?c:c-26);}
---
You can find different ways to get in touch with me below.  
If you want to know more about me check out the [info page]({{ site.baseurl }}/info/).

## E-mail

{% assign email = site.data.authors[site.author].email %}
{% if email %}
You can reach me at {% include snippets/email.html address=email %} where you can send attachments, images, etc. In case you just want to send me a quick message or want to stay anonymous, feel free to use the form below.
{% endif %}

<p><iframe src="https://docs.google.com/forms/d/1cG89BafxKwdxv9kzS-C_MjZfte0Ldlz37vr0m2U77jA/viewform?embedded=true"
           width="100%" height="715" frameborder="0" marginwidth="0" marginheight="0" scrolling="no">Loading...</iframe></p>

## Social contacts

You can also find me on various social sites, check them out at the [bottom of the page](#subfooter).

## Options
I should be online on most of the social services, if my Android phone has an internet connection, so I'll receive a notification about most of them.

 * If you want to send me a message use the above form.
 * If you want a reply supply your email address.
 * If you want a live conversation, either:
   * Go to my Google+ profile and click the little Hangout/Message button below my picture
   * Go to my Facebook profile and send a message  
     (sadly, [it'll go to my Other folder](https://www.facebook.com/help/398578543552207) so I won't necessarily notice it)
   * Chat me up on Skype
 * If I don't respond you can always send me an email requesting to be online on one of the above