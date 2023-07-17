---
title: Sabbatical
type: Personal
role: multitalented software engineer
maintech: Gradle, Android, GitHub
sector: technology
location: London
dates:
  from: 2022-10-14
  to: 2023-06-01
employer:
  onsite: true
---

After being slightly overworked in my last job, I took a short break for a few months.
This break was very similar to my [previous sabbatical]({{ site.baseurl }}/work/2014-sabbatical/).
I wanted to learn a few new things, maintain my hobby projects.
Most of the work I've done involved Android, Gradle, GitHub Actions, Notion, and many open-source projects on GitHub.

Technologies I up-skilled on:
 * Gradle
 * Android SDK
 * AndroidX libraries
 * Unified Test Platform
 * AGP 7 & 8 APIs
 * GitHub Actions
 * GitHub API
 * Copilot
 * Notion & API
 * GraphQL
 * JQ
 * IntelliJ IDEA & Android Studio plugin development
 * D3.js

Most notable projects completed over these few months:

 * **[Open Source contributions]({{ site.baseurl }}/project/contributions/)** are too many to count,
   but based on some rough math, on average I dealt with 2 issues and 2 PRs a day during my sabbatical.
 * **Notion**: I started using Notion as Life management tool.
   This involved learning how to set up everything in Notion, from scratch.
   I also learned how to script Notion via its API, because I had some data points I wanted to import to Databases.
   I already had a few tasks in GitHub Projects (v2),
   so I [migrated those by using API integrations](https://github.com/TWiStErRob/TWiStErRob-env/tree/ddc1b6f6ca6cf09ba245e59b3f99273cabca74e6/scripts/notion/import-data/github-projectv2).
 * **Open Sourcing [my Projects]({{ site.baseurl }}/project/)**, I finally got a round tuit!
   I split out my major projects [from my private SVN monorepo](https://github.com/TWiStErRob/TWiStErRob-env/tree/main/scripts/special/svn2git-migration) and published them on GitHub.
   Most of the repositories already existed, but they were used for issue tracking only.
   Sadly this doesn't make them automatically better, most of the code is still many years old.
 * **[GitHub Actions](https://github.com/search?q=owner%3ATWiStErRob+path%3A.github%2Fworkflows+-is%3Aarchived+-is%3Afork&type=code)**,
   after getting my code published on GitHub, I was able to use GitHub Actions for Continuous Integration.
   These range from
   a [few-line `gradlew build` job](https://github.com/TWiStErRob/glide-support/blob/0ecc1b9a927d9622454bd5c1dc68de9c6e10efb2/.github/workflows/CI.yml#L40-L49)
   to [running Android UI Tests](https://github.com/TWiStErRob/net.twisterrob.colorfilters/blob/76570c607e7f0bf9c9e51f4f451ef5bf3d931ee5/.github/workflows/CI.yml#L143)
   to [a huge compatibility matrix](https://github.com/TWiStErRob/net.twisterrob.gradle/blob/main/.github/workflows/CI.yml#L389).
 * **[Renovate](https://github.com/TWiStErRob/renovate-config)**
   was integrated to my repositories to automatically keep them up to date as things are released.
   If the GitHub Actions workflow passes, it's good to go!
   This helps me stay on top of latest dependencies and only occasionally need to step in to fix/migrate breaking changes.
   This also enables me to use some bleeding edge versions and discover/report issues early.
 * **Development Environment** I work in has finally started to become version controlled.
   This means I can easily set up a new machine, or just find and share things that will be helpful in some contexts.
   I still have ways to go, but it's been long-overdue.
 * **Gradle** learnings and contrbutions
    * Learned more about Included builds, Version management (Version Catalogs, Platforms, Dependency Constraints), Precompiled Script Plugins, Settings Plugins, Init Scripts
   * [I helped](https://newsletter.gradle.org/2023/03#:~:text=Big%20thanks%20to%20R%C3%B3bert%20Papp%20(TWiStErRob)%20from%20the%20Gradle%20community%20for%20giving%20feedback%20that%20helped%20develop%20the%20training%20material) the Gradle Training team to develop training material for Android. 
   * **[Android Gradle plugin]({{ site.baseurl }}/project/gradle/)**  
     is being maintained, I've fixed a few bugs, and fully migrated to new AGP 7-8 APIs.
   * **[Gradle Build graph visualization]({{ site.baseurl }}/project/gradle-graph/)**  
     was revived, I upgraded legacy code from Gradle 2 to 8, and D3.js 3 to 7.
 * **[Detekt](https://detekt.dev/)**
   * Based on my contributions the team added me as a [Maintainer](https://github.com/search?q=repo%3Adetekt%2Fdetekt+involves%3Atwisterrob).
   * I started writing some [custom rules](https://github.com/TWiStErRob/net.twisterrob.detekt) for fun to learn about the internals of Detekt.
 * **British Citizenship** I've finally went through to process to become an official Briton, after 11 years of living in the UK.
 * **[Paparazzi](https://cashapp.github.io/paparazzi/)** is a screenshot testing library that I contribute to regularly.
 * **[Razer Chroma]({{ site.baseurl }}/project/chroma/)**:
   I got a new keyboard, with RGB LEDs, that's no news, but I also played around programming those lights. See the project for more details.

*During these projects I reported numerous bugs and issues at the appropriate places and contributed some PRs as well.*

**Most notable technologies**: Gradle, Android, Kotlin, Detekt, JavaScript, D3.js, SVG, GitHub&nbsp;Actions, Renovate.

**Most used tools**: IntelliJ IDEA, Android Studio, git, Android Gradle Plugin, Notion
