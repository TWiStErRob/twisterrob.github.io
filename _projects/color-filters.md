---
title: "Android Color Filters"
subheadline: "Colorize Everything!"
teaser: "Test out Android's ColorFilter classes with a live preview."
type: app
images:
  icon: projects/color-filters/icon-512.png
  icon_small: projects/color-filters/icon-mdpi.png
  screenshots:
    - url: 'projects/color-filters/Phone %233.jpg'
      title: Lighting Color Filter
    - url: 'projects/color-filters/Phone %235.jpg'
      title: Color Matrix Color Filter with custom keyboard
    - url: 'projects/color-filters/Tablet 7 %231.jpg'
      title: Color Matrix Color Filter with sliders on a tablet
    - url: 'projects/color-filters/Tablet 10 %231.jpg'
      title: Porter-Duff Color Filter on a tablet
links:
  googleplay: net.twisterrob.colorfilters
---

## Inception
There are some good and fast image manipulation tools in Android, but the documentation is not enough. One has to know the math behind. I'm a visual mind and I like to see how something behaves once I change it. The problem is that calibrating Colors means changing the color and re-building and re-deploying the app on a device which takes a long time to do. So I decided to make an app where I can change the parameters to some methods and see the result immediately.

## Implementation

### Swatches
There's no built-in way in Android to pick a color so I rolled my own based on a development sample app. I made it extremely extensible so it's easy to create new types of swatches. I also looked up some color spaces and created swatches for those.

### Keyboards
The built-in input methods take up too much spaces so I decided to try to implement my own on-screen Keyboard with actions specific to the screen. The biggest challenge was to be able to replace the user's keyboard with the one that's bundled into the app.

### Palette
After Lollipop came out the Android libraries were updated and they added support for Palette. I decided to work it into the app because it's similarly visual and the it fit right into the architecture.


## History

### 2.0.0#2722 (2019-02-07)
{: #v20002722}
 * [Fix](https://github.com/TWiStErRob/net.twisterrob.colorfilters/issues/9): Permissions update (request when needed) and remove write storage

### 2.0.0#2710 (2018-10-21)
{: #v20002710}
 * _unreleased_
 * [Feature]({{site.baseurl}}/blog/2016/09/android-xml-colors.html): font resource investigation (only in debug)
 * [Enhancement](https://github.com/TWiStErRob/net.twisterrob.colorfilters/issues/6): update all versions, target Pie
 * [Enhancement](https://github.com/TWiStErRob/net.twisterrob.colorfilters/issues/5): Kotlin, latest build system
 * [Fix](https://github.com/TWiStErRob/net.twisterrob.colorfilters/issues/7): Colored UI elements were black on Marshmallow and above
 * [Fix](https://github.com/TWiStErRob/net.twisterrob.colorfilters/issues/8): Truncated text on Lollipop and above
 * [Fix](https://github.com/TWiStErRob/net.twisterrob.colorfilters/issues/4): drag and drop crash

### 1.2.0#2463 (2017-12-21)
{: #v11102463}
 * _unreleased_
 * Enhancement: modularization
 * Enhancement: basic tests

### 1.1.0#1636 (2015-06-02)
{: #v11001636}
 * Feature: Added Palette support
 * Enhancement: Ability to hide images to gain space
 * Fix: Better number format support for non-latin locales  
   Use programmer number format everywhere
 * Fix: rotation and other lifecycle fixes
 * Fix: jumpy labels when sliders change

### 1.0.0#1339 (2014-10-28)
{: #v10001339}
 * Initial release with 3 Color Filters
 * Build with Lollipop

### 1.0.0#1324 (2014-10-25)
{: #v10001324}
 * Initial release preparation
