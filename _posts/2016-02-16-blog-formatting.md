---
title: "Formatting used in this blog"
subheadline: "Cheat sheet for formatting tags"
teaser: "All-in-one visual medley of most formatting options I use in markdown on this website."
category: web
tags:
- blog
- jekyll
- liquid
- collection
- efficiency
---

I created this blog more than half a year ago and a lot of convetion I tried to introduce was lost in memory. This document will help to remember what's possible and how it will look like.

<!--more-->

It should also help to quickly test if formatting would break with any future updates of the site.

## TL;DR
{: .no_toc }
*[TL;DR]: Too Long; Didn't Read

This heading is not part of the [TOC](#toc). All headings can be linked via their short name: [this heading](#tldr).


{% include toc.md %}

## Formatting
*[abbr]: abbreviation

 * Belonging words should have `&nbsp;` between to prevent wrapping: Papp&nbsp;Róbert.
 * Long list of alternatives should have `<wbr>` between them to allow wrapping: this&nbsp;one<wbr>/that&nbsp;one<wbr>/other&nbsp;thing
 * Use `<samp>` for sample output: <samp>Exit code: 1</samp>.
 * Use `<samp>` for math: <samp>4&nbsp;people &times; 5&nbsp;days = 20&nbsp;man hours</samp>.
 * Use `<var>` for something representing a number: <var>your age</var> times.
 * Use `<mark>` for callout <mark>Grammar&nbsp;Nazis</mark>
 * Use `<mark>` for UI elements: Press <mark>Next</mark> to proceed.
 * Use `<abbr>` to show an abbreviation: <abbr title="shortended text">shot</abbr>, but it's not necessary if the abbr is defined in markdown
 * Custom colors when referencing something highlighted on an image: <span style="color:cyan">Save button</span>.


## Code

 * File extensions with `<code>`: `.css`, `.js`, `.html`
 * Paths and file names with `<samp>`: <samp>lib/code/path/file.name</samp>
 * Liquid-like code may need some escaping: {%raw%}`{{tag}}`{%endraw%}
 * Fencing code blocks' ticks can be output like this: ````<code>```</code>```` &rarr; <code>```</code>.
 * Don't be lazy with `alternative`/`code`/`formatting`.


### Normal code block

```java
/** Comment */
public void method();
```

*Some extra explanation to help understand the code.*


### Code block with title

```java
/** Comment */
public void method();
```
{: title="Short description of the code block"}


### Code block with Liquid code

```liquid{% raw %}
{% for tag in site.data.tags %}<li>{{ tag.name }}{% unless forloop.last %}, {% endunless %}</li>{% endfor %}
```{% endraw %}
{: title="Liquid code, that's not executed"}
{% comment %}Outputting `endraw` in code block requires some trickery: http://blog.slaks.net/2013-06-10/jekyll-endraw-in-code/{% endcomment %}

### Code block for shell

```shell
me@laptop$ command args "more args"
output text from command
though output may be highlighted weirdly
```

## Quotes

Here's a <q>short quotation</q> which is in the middle of a sentence.

> This is a long quotation by someone, normal markdown formatting rules apply:  
  **strong**, *em*, _em_, ***strong em***, <b>html bold</b>, `code`, <kbd>kbd</kbd>, <samp>samp</samp>, <ins>ins</ins>, <del>del</del>
  <cite>TWiStErRob</cite>

> <samp>Program output text</samp> <cite>output from [file.name](http://sources.com/path/to/file.name#line=123) in [library](http://library.com/)</cite>


## Alerts
All `alert`s support markdown and their names are all lowercase, because they're used as CSS classes, for example TODO is `alert todo=`. The <q>TODO:</q> prefix is not automatically inserted, it's for name calling only here.
{% include alert alert='Alert:  
    This is like any normal markdown, even when used from non-markdown context:  
    **strong**, *em*, _em_, ***strong em***, <b>html bold</b>, `code`, <kbd>kbd</kbd>, <samp>samp</samp>, <ins>ins</ins>, <del>del</del>.' %}

{% include alert warning='Warning: call out a caveat that\'s easy to trigger  
    This is like any normal markdown, even when used from non-markdown context:  
    **strong**, *em*, _em_, ***strong em***, <b>html bold</b>, `code`, <kbd>kbd</kbd>, <samp>samp</samp>, <ins>ins</ins>, <del>del</del>.' %}

{% include alert info='Info: supplementary information, for example links to further reading or documentation.  
    This is like any normal markdown, even when used from non-markdown context:  
    **strong**, *em*, _em_, ***strong em***, <b>html bold</b>, `code`, <kbd>kbd</kbd>, <samp>samp</samp>, <ins>ins</ins>, <del>del</del>.' %}

{% include alert success='Success:  
    This is like any normal markdown, even when used from non-markdown context:  
    **strong**, *em*, _em_, ***strong em***, <b>html bold</b>, `code`, <kbd>kbd</kbd>, <samp>samp</samp>, <ins>ins</ins>, <del>del</del>.' %}

{% include alert text='Text:  
    This is like any normal markdown, even when used from non-markdown context:  
    **strong**, *em*, _em_, ***strong em***, <b>html bold</b>, `code`, <kbd>kbd</kbd>, <samp>samp</samp>, <ins>ins</ins>, <del>del</del>.' %}

{% include alert todo='TODO: reminder to myself that something needs to be done here  
    This is like any normal markdown, even when used from non-markdown context:  
    **strong**, *em*, _em_, ***strong em***, <b>html bold</b>, `code`, <kbd>kbd</kbd>, <samp>samp</samp>, <ins>ins</ins>, <del>del</del>.' %}

{% include alert terminal='Terminal:<br/>
    This is like any normal markdown, even when used from non-markdown context:  
    **strong**, *em*, _em_, ***strong em***, <b>html bold</b>, `code`, <kbd>kbd</kbd>, <samp>samp</samp>, <ins>ins</ins>, <del>del</del>.' %}

