---
title: "How to do a PR?"
subheadline: "Work around the quirks"
teaser: "Full process of how I go through a pull request for a GitHub fork."
category: dev
tags:
- git
- github
- tutorial
---

Many times when you ask for a feature in a GitHub issue, you're welcomed with:

> Can you create a PR please?

... even if it's a one-character typo. Here's how I create a PR.

<!--more-->

## What is a PR?
A <dfn>Pull&nbsp;Request</dfn> is request created on GitHub to merge code from one fork of the repository to another. Usually there's a feature/bug branch in the fork and the PR is made against the `master` branch &mdash;, or wherever their `HEAD` commit is &mdash; in the base repository.

## GitHub setup

As easy as pressing ![Fork button on GitHub](data:image/png;base64,
	iVBORw0KGgoAAAANSUhEUgAAAF0AAAAaCAMAAADi8qAlAAAABGdBTUEAALGPC/xhBQAAAAFzUkdC
	AK7OHOkAAABCUExURfPz8/Hx8fX19d3d3fr6+v////j4+Pz8/NXV1e/v719fX3R0dOTk5Orq6ktL
	SzMzM8fHx7q6us/Pzz4+PqWlpY2NjfCuymIAAAGWSURBVEjHtZaJsoMgDEVZbGUJART//1dfQqti
	++zuzQyZkMkBIy6iB/Ol9J5CLwBE139j5rSjDoIwqvtOu/TTWQvTHUY/HU4/L0qIqfWv6UV68MPg
	w+q7OdE1dj/xIf0cXGRtryM4bz/Z+11n7kAs+JQOzsHWv0PvyoiZx3E6N3Q1GziskUGi15hAnIGJ
	SoBi53GgyTIWtVTN9ITGOD2Mg8G00tUiOUUHiiBxkhwz/eoBvANeXVKQx0v+opmenbUuGyT68B9d
	BR+ZE31QFyrfVG9zzErRQODAFzhe81s67V3j1JcYS7/ShVqN8Qy/RLx39iUmJVIsNeYl0TQ1Td+d
	mwZeo+mMaMW1DpaA1iHRtutQY2p+xsmuJc2ZkT7X/kw7dGEQjbihk9e69r3SfShjuqdTuwfUtT95
	j86n8ZYudD0zYqHrOdHSuTOpnsjSnEi5ET9J8i09fpqkFFcjAb8FQC4TS2KWuA5isWf0RuBTYvrv
	9m5by4h5O/PMHtPtRtK+q3fo9sf0cBidvtqgw0F0/uM49G/pDxDMOtB3YFf6AAAAAElFTkSuQmCC
).

## Checkout

Click the [HTTPS](javascript:;) link below the clone URL box and then copy the ***HTTPS** clone URL* which can be then used to clone a repo:

{% highlight console %}
me@laptop$ git clone https://github.com/me/repo-name.git .
Cloning into '.'...
{% endhighlight %}

Immediately after this I go back to the original repository (where I forked from) and repeat the [HTTPS](#) link copying and add the remote:
{% highlight console %}
me@laptop$ git remote add -f mint https://github.com/stranger/repo-name.git # -f == immediate fetch
Updating mint
me@laptop$ git remote set-url --push mint DISALLOWED
{% endhighlight %}
This is useful if the original repo is active and you want to keep up to date. I call it `mint` (after the adjective in "mint&nbsp;condition"), because the normal clone operation creates an `origin` remote, also mint suggests to keep it clean.

{% highlight console %}
me@laptop$ git remote -v # == git remote --verbose show
mint    https://github.com/stranger/repo-name.git (fetch)
mint    DISALLOWED (push)
origin  https://github.com/me/repo-name.git (fetch)
origin  https://github.com/me/repo-name.git (push)
{% endhighlight %}

## Update remote

`stranger-head-branch` is usually the `master` branch and `my-pr-branch`'s name is highly correlated with what your PR is representing.

{% highlight console %}
me@laptop$ git checkout stranger-head-branch
Switched to branch 'stranger-head-branch'

me@laptop$ git merge mint/stranger-head-branch
Updating abc1230..abc123f
Fast-forward
...

me@laptop$ git checkout my-pr-branch
Switched to branch 'my-pr-branch'

me@laptop$ git rebase stranger-head-branch
First, rewinding head to replay your work on top of it...
Applying: Commit message 1
Applying: Commit message 2
...
{% endhighlight %}

## Create PR
{% highlight console %}
me@laptop$ git push --all
{% endhighlight %}

Upon success just go to the original repo or your fork on GitHub and you should see a <mark>Your recently pushed branches:</mark> tip with a <mark>Compare & pull request<mark> button.

Review changes, fill in description and you're good to go.

## Future of a PR
If the repository owners like what you did and it adheres to rules usually defined in `CONTRIBUTING.md` they'll merge your PR and you'll see a <mark>Pull request successfully merged and closed</mark> message with a <mark>Delete branch</mark> button next to it. That helps to keep your fork's working branches to a minimum. Once it's merged the commits are copied to their repository so it's safe to delete your branch.

There's of course the possibility that something goes wrong, like the CI build fails or there's some modification needed in the PR. In that case make some more commits to your fork, or even rebase or squash commits; then push it to the working branch and the PR will be updated automatically.

*[PR]: Pull Request
