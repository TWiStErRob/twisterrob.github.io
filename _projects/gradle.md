---
title: "Gradle Plugins"
subheadline: "The D.R.Y. of builds"
teaser: "Aggregate reports, visualize tasks, share common build logic."
type: app
images:
  icon: projects/gradle/gradle-white-primary-plugins.png
  icon_small: projects/gradle/gradle-plugins-icon.png
links:
  download: https://mvnrepository.com/artifact/net.twisterrob.gradle
  sources: https://github.com/TWiStErRob/net.twisterrob.gradle
---

{% include toc.md %}


## Inception
This project has been long-running.
Initially it was just some quality plugins for multi-module development,
now it has grown to many Gradle utilities I use in my projects and accumulates my Gradle knowledge in some form. 

The Android Lint report in AGP works on individual modules,
but at work we used TeamCity which was able to show a single HTML file in a "Report Tab".
I wanted to ease the pain of developers by providing a single HTML file that contains all the reports from all the modules.
This is how the `net.twisterrob.gradle.quality` plugin was born.

I also needed a way to share configuration between my projects,
so I don't have to repeat complex Gradle scripts and can improve and fix bugs centrally.
This was called "private" plugin and was recently migrated to the same repository as the quality plugins with the name "convention" plugins.
Along with this the experimental [Gradle Task Graph visualization]({{ site.baseurl }}/project/gradle-graph/) was also moved and published.

### Motivation
This project is my testbed of discovering and learning new Gradle APIs and features.
I also learned to polyfill/hack internals to bend the build system to my needs.

## Implementation
I wanted everything to be tested from the get-go,
so I set up a very complex Gradle / AGP / Java testing [matrix](https://github.com/TWiStErRob/net.twisterrob.gradle/blob/57bd2ee98eba35ed97f17251ba76d054fb1ac875/README.md#compatibility) to test for compatibility issues.
This is still live, but I recently had to stop supporting older versions, because the maintenance was becoming unwieldy.
Also since I started "Renovate"-ing all my projects, older version support is no longer an issue.

## History
See [releases on GitHub](https://github.com/TWiStErRob/net.twisterrob.gradle/releases) for details.
