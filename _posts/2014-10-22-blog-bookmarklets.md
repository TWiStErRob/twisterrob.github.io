---
title: "Prettified bookmarklet code on Blogger"
subheadline: "DRY principle in blogging"
category: web
tags:
- blog
- bookmarklet
- tutorial
script:
  foot: bookmarklet.js
---

I wanted to share bookmarklets without duplicating the code to display and the code in `href`.
I also wanted that a <q>bookmarklet name</q> link can be dragged to the bookmarks bar and then just work.
This post describes how I included prettified and easily copiable bookmarklet code to my <a href="http://www.blogger.com/" target="_blank">Blogger</a> blog.
<!--more-->


## Example
Short summary of
<a class="bookmarklet" href="#ID-of-code">bookmarklet name</a>[^1]
(grab "bookmarklet name" to your bookmarks bar).

```javascript
/* display an alert */
alert("Bookmarklet");
```
{: #ID-of-code }


## Template Changes
For this to work the following modification need to be made at <mark>Blogger Dashboard > Template > Edit HTML</mark>.


### Into `<head>`
```html
<!-- TWiStErRob global customization -->
<style type='text/css'>/* Pretty printing styles. Used with prettify.js. */
/* string */        pre .str, code .str { color: #FF8000; }
/* keyword */       pre .kwd, code .kwd { color: #B0B0FF; font-weight: bold; }
/* comment */       pre .com, code .com { color: #B3CECD; }
/* type */          pre .typ, code .typ { color: #FFFFED; }
/* literal */       pre .lit, code .lit { color: #FF00FF; }
/* punctuation */   pre .pun, code .pun { color: #E1FFBF; }
/* plaintext */     pre .pln, code .pln { color: #FFFFFF; }
/* xml tag */       pre .tag, code .tag { color: #B0B0FF; font-weight: bold; }
/* xml attr name */ pre .atn, code .atn { color: #00FF85; }
/* xml attr value */pre .atv, code .atv { color: #FF8000; }
/* decimal */       pre .dec, code .dec { color: #FF00FF; }

pre.prettyprint, code.prettyprint {
    background-color: #000;
    -moz-border-radius: 8px;
    -webkit-border-radius: 8px;
    -o-border-radius: 8px;
    -ms-border-radius: 8px;
    -khtml-border-radius: 8px;
    border-radius: 8px;
    font-family: Menlo, DejaVu Sans Mono, Consolas, monospace;
}

pre.prettyprint {
    line-height: 1;
    overflow: auto;
    max-height: 600px;
    padding: 1em;
    word-wrap: normal;
}

/* Specify class=linenums on a pre to get line numbering */
ol.linenums { margin-top: 0; margin-bottom: 0; color: #888888; }
li.L0,li.L1,li.L2,li.L3,li.L4,li.L5,li.L6,li.L7,li.L8,li.L9 { list-style-type: decimal; }
li.L4,li.L9 { font-weight: bold; }
/* Alternate shading for lines */
li.L1,li.L3,li.L5,li.L7,li.L9 { background: inherit; }

@media print {
    pre .str, code .str { color: #060; }
    pre .kwd, code .kwd { color: #006; font-weight: bold; }
    pre .com, code .com { color: #600; font-style: italic; }
    pre .typ, code .typ { color: #404; font-weight: bold; }
    pre .lit, code .lit { color: #044; }
    pre .pun, code .pun { color: #440; }
    pre .pln, code .pln { color: #000; }
    pre .tag, code .tag { color: #006; font-weight: bold; }
    pre .atn, code .atn { color: #404; }
    pre .atv, code .atv { color: #060; }
    pre.prettyprint { word-wrap: break-word; max-height: initial; background-color: #fff; }
}
</style>
<!-- end of TWiStErRob global customization -->
```


### Before `</html>`
```html
<!-- TWiStErRob global customization -->
<script type="text/javascript">
//<![CDATA[
(function() {
    // update bookmarklet from source code
    var bookmarkletLinks = document.getElementsByClassName('bookmarklet');
    for (var linkIndex = 0; linkIndex < bookmarkletLinks.length; ++linkIndex) {
        var link = bookmarkletLinks[linkIndex];
        var codeID = link.href.substring(link.href.indexOf('#') + 1);
        var code = document.getElementById(codeID);
        if (code) {
            link.href = 'javascript:' + code.innerText;
        }
    }
})();
//]]>
</script>
<script src="https://google-code-prettify.googlecode.com/svn/loader/run_prettify.js?autoload=true"></script>
<!-- end of TWiStErRob global customization -->
```


## Example Code
This way when I create a new post with the following content will turn into what you can see at the [Example section](#example):

```html
Short summary of <a class="bookmarklet" href="#ID-of-code">bookmarklet name</a>
(grab "bookmarklet name" to your bookmarks bar).
<pre id="ID-of-code" class="bookmarklet-code prettyprint linenums"><code class="lang-js">
/* display an alert */
alert("Bookmarklet");
</code></pre>
```


## Other blogging platforms
You can use the same technique on any blogging platform given that you have control over the styles and scripts of the pages.

[^1]: {% include snippets/bookmarklet.html %}
