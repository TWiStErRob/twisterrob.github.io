---
title: "Chroma Keys"
subheadline: "What was that shortcut?"
teaser: "See available shortcuts in IntelliJ IDEA and Android Studio."
type: poc
images:
  icon: projects/chroma/logo.jpg
  icon_small: projects/chroma/keys.jpg
  screenshots:
    - url: 'projects/chroma/keyboard-shortcuts.jpg'
      title: Visualizing shortcuts on the keyboard.
    - url: 'projects/chroma/keyboard-regions.jpg'
      title: Visualizing gaming regions on the keyboard.
    - url: 'projects/chroma/keyboard-snake.jpg'
      title: Playing around with Snake on the keyboard.
  videos:
    - youtube: 'ADC9suV2v4U'
links:
  sources: https://github.com/TWiStErRob/net.twisterrob.chroma
---

{% include toc.md %}

## Inception
I've always wanted to code something with LEDs.
Recently the need came to buy a quieter keyboard, so I ended up buying one with laser switches...
and of course the nowadays "mandatory" RGB LEDs.

## Implementation
I set up the [Razer Chroma SDK](https://developer.razer.com/works-with-chroma/),
wrote a Kotlin wrapper, and integrated it in an IntelliJ IDEA Plugin.

## Features
Sadly the enthusiasm faded when I started interacting with [IntelliJ IDEA Extension points](https://plugins.jetbrains.com/docs/intellij/extension-point-list.html),
trying to find the one or two functions I need to find the currently focused view.
I found all the keyboard shortcuts, but need to filter by view to make sense of it.
The framework is there, I'm just missing the key glue to make it work.

## History
See [releases on GitHub](https://github.com/TWiStErRob/net.twisterrob.chroma/releases),
where there are currently none as the project is not fully functional.
