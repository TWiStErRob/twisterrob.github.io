---
title: "How to be effective at work?"
subheadline: "Generic rules and examples"
teaser: "Tips and tricks to be fast and effective in a software engineering job."
category: dev
tags:
- collection
- efficiency
---

I was leaving a team at my job and when I was handing over my work to my replacement I wrote him some tips to be more effective. I apply a lot of these at work, and I feel that some of them should be used more.

<!--more-->

## TL;DR
{: .no_toc }
If something slows you down take time to make it faster; and communicate with others.

{% include toc.md %}

## Make a sacrifice, it'll pay off!
> &mdash; Doctor, doctor, it hurts when I do this.  
  &mdash; Then don't do that!
  <cite>common joke</cite>

If something takes 1 hour every single day or slows you down by 20%, then once take an hour and spend it to make it only a few minutes long, that is automate it or re-structure it, examples:

 * **short** (1-2 letter) build **commands**
 * **bookmarklets** to navigate on web-pages, **deeplinks**  
   create scripts for stuff that's available through changing an URL, with defaults for most used values
 * use **Stylish** addon to re-style third-party pages  
   e.g. hide unused features to reduce clutter, or emphasize important things
 * **configure** the product you're working on  
   e.g. disable or set defaults for stuff that's irrelevant to you
 * create **email rules**  
   filter what's not relevant to you, e.g. <q>other team's environment down</q>;  
   if it's really important your collegaues will tell you anyway
 * **keyboard shortcuts**  
   you just have to learn them once, you'll forget what you don't use anyway)
 * **preferences/settings/menus**
   it's worth going through IDE settings/menus to learn what's available, anything may come in handy later


## Take shortcuts! aka. It works, doesn't it?
If you can skip a task then **do** skip it. Don't give in to paranoid urban legends, like <q>you must always clean before build</q>. A clean build usually takes 10 times more time.

When modifying static content (`.css`, `.js`, `.html`) it's usually not required to restart the webserver, just refresh the page.

When you're naughty and don't apply yourself to do TDD and write your tests at the end of the development you can save a lot of time by not compiling the test classes, meaning the compation time is halved. You can also skip running unit tests when you're just manually testing the product.

Of course the above is true here too, you can make a sacrafice and learn what the system is tolerant of, where can hack around a little to save time. The only problematic thing is when the system changes without your knowledge and some often practiced method just fails. When that happens you may have some trouble and you need to sacrifice again to adjust your method, but it's usually incomparable to the daily amount you saved prior and in the future.


## Help others to help yourself!
Write more comments and JavaDoc at sensitive places, it'll pay of in the long run: many times it helps a lot interpreting your own code.
Additionally don't go writing
{% highlight java %}
/** Gets the name. */
public void getName();
{% endhighlight %} style comments, the lack of that comment saves time for anyone reading the code by not having a <q>Thank you Captain&nbsp;Obvious!</q> moment.

Fill in the description or message field with a meaningful declaration of what you did; this applies to version control commit, wiki edit, file upload, etc.

Small things count: with a well-named variable, that no-one asks about in an in-person code review, you saved <var>team members</var> man-minutes for the team, and it took you only 10&nbsp;seconds to come up with. It also helps a great deal for anyone trying to understand that code, saving minutes again. Code is read by many and written by few. Look out for spelling mistakes to not confuse others and also prevent others spending time correcting it, because it's already correct --- looking at you <mark>Grammar&nbsp;Nazis</mark> ;).


## Emphasize the essence!
I'm pretty sure you're really good at reading monochrome logs, but if you're staring at / grepping logs a lot during the day it's worth setting up some [highlighting](https://consolehighlighter.codeplex.com/). It's worth setting up logging and highlighting in a way that only relevant log lines are shown and the important parts are higlighted.

When writing something:

 * it's worth emphasizing some words in the text
 * you can safely assume that people are busy/lazy so a [TL;DR](#tldr) section will brigthen their day
 * it's worth formatting even the emails you write, for example:  
   again, more people read your email so it may worth investing that 1 minute extra effort to make it easily comprehensible.
   * copy-paste highlighted code from <abbr>IDE</abbr>
   * or at least set font to a monospace one for code, classnames and method names
   * I usually color-code related things
     e.g. when I refer to a blue circle on a picture encompassing a button labeled <mark>Save</mark> I write: <q>the <span style="color:cyan">Save button</span> is misplaced</q>.


## Learn from mistakes of others!
If someone had a problem in your team or nearby and they don't share the solution, make them share it and remember if you run into similar situation.
If someone has a problem, help them a little, this will resolve their problem and you'll also remember once faced with the same/similar issue again, you'll also gain repuation as a bonus :)
If you don't remember the exact solution to a problem, only who had that problem before, you'll probably come out on top if you ask them as they'll feel important; of course only if they remember.


## The Debugger is your friend, you just don't know it yet
In many cases you can develop a whole feature while debugging without restarting the app.
Create a method that's triggered by an external event. You can change the code inside while debugging and the IDE will hot replace the code in memory and you don't need to slowly recompile/restart. After it's complete you can start refactoring and extracting classes/methods to avoid monoliths.
You can also test different outcomes in the Immediate View.
If you made a mistake and it's as simple as <q>what happens if I put an extra character in that <code>String</code>?</q>, then restart current method with <mark>Drop to frame</mark> and modify the local variables/objects in the Variables view (or call methods in Immediate View); then if it worked, modify the source, so next time it's compiled.


## Ask questions!
I see it a lot that people spend hours trying to make something work, ask your collegaues maybe they know some key information how to solve the problem. Even when they don't, they may know where to look it up. In the worst case you get an <q>I don't know</q>.


## There may be more...
If something is not clear, use this joker tip:

All these look insignificant improvements and waste of time, but if all of these tips save you only 10 minutes a day, then you already saved an hour that you can spend on working on something else. To be honest in many of these you're actually saving time for others, but you're part of team. If everyone follows some of these tips you may end up saving a lot of time in the long run, for example: <samp>4&nbsp;people &times; 5&nbsp;days &times; 1&nbsp;hour = 20&nbsp;hours</samp> in just a week.

*[TDD]: Test Driven Development
*[IDE]: Integrated Development Environment
*[TL;DR]: Too Long; Didn't Read
