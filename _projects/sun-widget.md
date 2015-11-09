---
title: "Sun Position Widget"
subheadline: "Where's the sun?"
teaser: "Learn and predict the Sun's altitude wherever you are."
images:
  icon: projects/sun-widget/icon-512.png
  icon_small: projects/sun-widget/icon-mdpi.png
  screenshots:
    - url: 'projects/sun-widget/Phone %231.jpg'
      title: Daytime with last update time (if enough space)
    - url: 'projects/sun-widget/Tablet 7 %231.jpg'
      title: Civil dusk with no space for last update time
    - url: 'projects/sun-widget/Tablet 10 %231.jpg'
      title: Sunset with no space for time of day nor last update time
urls:
  googleplay: net.twisterrob.sun
---

{% include toc.md %}


## Inception
Summer was coming to London and my girlfriend has heard about UV/B benefits, so she wanted to know when the Sun is above 50° over the horizon to exploit the [health benefits](#read-more).


## Implementation
I spent two weekends on developing a quick prototype, one for the algorithm to calculate the Sun's angle and one to create an Android widget around the algorithm.


### Calculating the angle
I thought it was a simple calculation, but there's really complex mathematics behind it. Luckily I found [some](http://www.susdesign.com/sunangle/) [good](http://www.pveducation.org/pvcdrom/properties-of-sunlight/elevation-angle) [articles](https://en.wikipedia.org/wiki/Solar_zenith_angle) and a [credible source](http://aa.usno.navy.mil/data/docs/AltAz.php) to double check my calculations.


### The App
I spend another two weeks to make it work on more Android devices and planned to publish it as my first ever Google Play store app together with [Android Color Filters]({{ site.baseurl }}/project/color-filters), both as a preparation for a bigger release of [Magic Home Inventory]({{ site.baseurl }}/project/inventory).

There were quite a few challenges with home screen widgets and the publishing process. The biggest one was the layout: I want to display information based on the available size, but because of the architecture it's not possible to know how big it'll be. So in the end I left to the user to switch parts of the widget on/off.


## Features
Other than the initial "show when above 50°" I crammed a few more features into app that I wanted to have:

 * Tap to refresh/configure
 * Display altitude angle
 * Display part of the day
 * Set [thresholds](#thresholds)
 * Personalize to your needs
 * Beautiful widget backgrounds
 * Follows you wherever you are
 * Auto-updates every 30 minutes


### Thresholds
Ever wanted to know at an easy glance when the sunset will be today or when will it get dark? You're in the right place; you can easily set up a threshold to see when the sun will transition to a given angle range, here are a few examples:

 * sunrise and sunset (default)
 * start/end of twilights (presets)
 * [UV/B benefits](#read-more) (preset)
 * Any custom angle

If you want more of these, just put more widgets, they are don't occupy much home screen space.


### Parts of the day
The widget will display the following part of the day, each with a corresponding background image:

 * sunrise, sunset at 0°: short period of time when the Sun transitions over the horizon
 * day-time, night: longer parts of the day when the Sun is farthest from the horizon
 * civil twilight, dawn/dusk at -6°: the sky is dull blue, lighting conditions are suitable for every-day activities, but there are no shadows
 * nautical twilight, dawn/dusk at -12°: the sky is very dark blue, some stars become visible, the horizon is still visible
 * astronomical twilight, dawn/dusk at -18°: the sky is already black, stars become apparently visible


## Read more
 * [about Twilights](http://en.wikipedia.org/wiki/Twilight) (not the movies) 
 * [the Math](#calculating-the-angle)
 * [Light Pollution ☹](http://www.mensjournal.com/magazine/where-did-all-the-stars-go-20131115?page=2)
 * [UV/B and Vitamin D benefits](http://articles.mercola.com/sites/articles/archive/2012/09/29/sun-exposure-vitamin-d-production-benefits.aspx), [also here](http://articles.mercola.com/sites/articles/archive/2012/03/26/maximizing-vitamin-d-exposure.aspx)
