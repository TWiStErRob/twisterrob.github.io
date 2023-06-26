---
title: "Contributions"
subheadline: "Give back to the community"
teaser: "Report/fix bugs, provide support, improve projects."
type: app
images:
  icon: projects/contributions/github.png
  icon_small: projects/contributions/github-icon.png
links:
  sources: https://github.com/TWiStErRob/repros
---

{% include toc.md %}

## Inception
I now have the habit of reporting issues I find in the tools I use.
Actually don't remember how it came about...
I think it might come from my first job where I was doing manual testing and had to report everything I found.

### Motivation
I want to make the world better by improving the tools we use.
If there's something wrong, I try to report it so that the owner can make a decision what to do.

## Implementation
This means I'm reporting bugs, missing features, and I'm also trying to fix them where applicable.

Over the years I realized that juggling ZIP files around is not the most effective way to share code,
so I created a [repo of repros](https://github.com/TWiStErRob/repros) where I collect all the projects for the issues I filed.

This forces me to make a minimal independent reproducer, so that maintainers can more easily asses the problem.
From my experience on [Glide]({{ site.baseurl }}/work/2014-glide/ ) I found that
oftentimes it's enough to just be able to browse the repro files to find the problem, this is why I think a GitHub repo works.

## Investigations
Many times I can also contribute by spending a deep debugging session sleuthing for a root cause and reporting a bug with full details.

Note: examples in this section are really heavily detailed and deeply technical and messy in some cases.
They might be slightly out of date as well, since they record the state of the environment at the time of the investigation.
They're still interesting reads if you're curious about how to approach complex problems.


### [Bad quality when saving Bitmaps as JPEG on Android](https://stackoverflow.com/a/36560663/253468)
This is one of the most complex ones, it involves all levels of Android, from Java to native code and back.
It all started when I noticed that all my pictures of my desk had some banding on them, and they looked like the GIFs did in the 90s.

<img src="https://i.stack.imgur.com/vIuH4.jpg" width="400" />

After asking a StackOverflow question where Android community support rejected that's a problem, and Google straight up closed the issue as "Obsolete",
I dug deep into where the Bitmap to JPEG compression happens and found that some constants were not set correctly, they had rounding errors.
On the way I learned a lot about how JPEG compression works.
I even got 2 lines of help from Irfan Skiljan, the author of [IrfanView](https://www.irfanview.com/), which nudged me in the right direction of discovery.

Luckily I had a friend at Google who was able to route the issue, now complete with an exact route cause and fix proposal, to the right team.
They landed a fix at https://codereview.chromium.org/1886183002/, which means Android and Chrome should have better quality pictures from then on.


### [Kotlin vs Android Gradle Plugin vs Gradle JVM Targets](https://stackoverflow.com/a/75158443/253468)
This is a short investigation of a problem which I think affects or will affect many of the Android community.
After finding the root cause, we reported the problem to JetBrains, and they provided a workaround.
This workaround does not fix the issue, but avoids it, by using newer approaches in Gradle tooling.


### [Obfuscating Android code with ProGuard while keeping code debuggable and readable](https://stackoverflow.com/q/29871644/253468)
I wanted to debug an obfuscated Android app, but I couldn't, because everything was called `a`, `b` or `c`, so I was totally lost.
I found a way to apply obfuscation, but define how the names are changed, but it was not easy.
This helped me fix my problem, and probably not in a usable form right now. Might come in handy at some point.


### [Truth vs Paparazzi vs Guava dependencies](https://github.com/cashapp/paparazzi/issues/906)
This was a short investigation of a Gradle dependency resolution issue.
It seems it has started to lead to a Google considering to improve bring Guava `-android` artifact closer to `-jre`.


### [Mockito Gradle warning cleanup](https://github.com/mockito/mockito/pull/2904)
This is a small contribution following a hours of investigation with full details of my process on how I approach Gradle build problems.


### [Kotlin Power Assert tech debt](https://github.com/bnorm/kotlin-power-assert/pull/87)
A Kotlin Power Assert contributor become [blocked](https://github.com/bnorm/kotlin-power-assert/pull/86#issuecomment-1494350875)
while trying to bump a small dependency version, and got entangled in a major Gradle 8 upgrade.
I helped upgrade Gradle 8, so they can continue the contribution.

There was a little surprise undocumented breaking change by the Gradle Plugin Portal plugin, but luckily for the better.


### [Kotlin scripting failures](https://github.com/Kotlin/kotlin-script-examples/issues/21#issuecomment-1302593643)
On one of my watched repositories there came a request for help, and I dug deep into why their code was failing.
I showed my working and left some hints, hopefully they learned from it, I definitely did.

> WOW... thanks so much... your sleuthing is beyond my Kotlin skills...


### [Glide progress bar](https://github.com/bumptech/glide/issues/232#issuecomment-172625621)
One day at Glide a support request came in, and it was an interesting problem.
I hacked together a proof of concept that I shared in the issue. Hopefully it helped others.


### [Dialog crash on Android Emulator](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/157)
This was a failure that was bugging me a lot, and I wanted to find out what's going on.
Had to dig deep into native code again, and reason I found surprised me.
Reported to Google, and they picked it up years later and by that time it seems it was already fixed.
