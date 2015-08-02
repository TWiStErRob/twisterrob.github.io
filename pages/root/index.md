---
#
# Use the widgets beneath and the content will be
# inserted automagically in the webpage. To make
# this work, you have to use › layout: frontpage
#
permalink: /index.html
layout: frontpage
header:
 image_fullwidth: header.jpg
widget1:
  title: "Professional Experience"
  url: /work/
  image: widget-1_canary-wharf.jpg
  text: "Find out what I've been doing when I was sitting in front of the computer in the last 10+ years."
widget2:
  title: "Portfolio"
  url: /project/
  image: widget-2_code.png
  text: "Check out my projects and contributions: what technologies did I use and what's the motivation behind each."
widget3:
  title: "Blog"
  url: /blog/
  image: widget-3_keyboard.jpg
  text: "Read my articles about software development, the problems I encountered and solutions I came up with."
---

{% comment %}
video: '<a href="#" data-reveal-id="videoModal"><img src="...-302x182.jpg" width="100%" alt=""></a>'
<div id="videoModal" class="reveal-modal large" data-reveal="">
  <div class="flex-video widescreen vimeo" style="display: block;">
    <iframe width="1280" height="720" src="https://www.youtube.com/embed/3b5zCFSmVvU" frameborder="0" allowfullscreen></iframe>
  </div>
  <a class="close-reveal-modal">&#215;</a>
</div>
{% endcomment %}
