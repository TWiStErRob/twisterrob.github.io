---
title: "Android Color Filters"
subheadline: "Colorize Everything!"
teaser: "Test out Android's ColorFilter classes with a live preview."
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
urls:
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
