---
title: "Gradle Visualization"
subheadline: "Open a window to your build, literally."
teaser: "Ever wondered how the task graph looks like? Now you can interactively play with it."
type: poc
released: false
images:
  icon: projects/gradle-graph/gradle-graph-logo.png
  icon_small: projects/gradle-graph/gradle-graph-icon.png
  screenshots:
    - url: 'projects/gradle-graph/graph-demo.png'
      title: Demo of the visualization, using fake states.
    - url: 'projects/gradle-graph/graph-sample.png'
      title: Sample of the visualization, using real states of Android Gradle Plugin on a small 2-module project.
  videos:
    - youtube: 'RqNmRxywKM4'
links:
#  download: https://mvnrepository.com/artifact/net.twisterrob.gradle/twister-gradle-graph
  sources: https://github.com/TWiStErRob/net.twisterrob.gradle/tree/main/graph
---

{% include toc.md %}


## Inception
Many years ago I wanted to learn more about how the Android Gradle Plugin wired up internal tasks.
I was also curious about how the task graph looks like, so I started to write a plugin that visualizes the task graph.

## Implementation
Originally I used Gradle 2.x public APIs to gather enough information about the dependencies.
This is simple enough.
Interestingly Gradle runs on Java, which means we can open UI windows.
I used JavaFX to create a simple UI that shows the task graph and allows to interact with it.
But I didn't want to too deeply tie myself to any UI framework, and wanted fast iterations.
In the end I used an embedded browser to display a D3.js visualization.

## History
Not yet released, but can be built from source.
