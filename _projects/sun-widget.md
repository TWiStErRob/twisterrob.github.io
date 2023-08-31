---
title: "Sun Position Widget"
subheadline: "Where's the sun?"
teaser: "Learn and predict the Sun's altitude wherever you are."
type: app
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
links:
  googleplay: net.twisterrob.sun
  sources: https://github.com/TWiStErRob/net.twisterrob.sun
---

{% include toc.md %}


## Inception
Summer was coming to London and my girlfriend has heard about UV/B benefits, so she wanted to know when the Sun is above 50° over the horizon to exploit the [health benefits](#read-more).


## Implementation
I spent two weekends on developing a quick prototype, one for the algorithm to calculate the Sun's angle and one to create an Android widget around the algorithm.


### Calculating the angle
I thought it was a simple calculation, but there's really complex mathematics behind it. Luckily I found [some](http://www.susdesign.com/sunangle/) [good](http://www.pveducation.org/pvcdrom/properties-of-sunlight/elevation-angle) [articles](https://en.wikipedia.org/wiki/Solar_zenith_angle) and a [credible source](http://aa.usno.navy.mil/data/docs/AltAz.php) to double check my calculations.


### The App
I spend another two weeks to make it work on more Android devices and planned to publish it as my first ever Google Play store app together with [Android Color Filters]({{ site.baseurl }}/project/color-filters/), both as a preparation for a bigger release of [Magic Home Inventory]({{ site.baseurl }}/project/inventory/).

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

## Privacy Policy

The Sun Position Widget (the app) allows the user (You) to check an estimation of the Sun's position in the sky.

### Location permission
{: .no_toc }
This permission authorizes the app to know where Your device is located in order to calculate the angle of the Sun. This is necessary because the Sun's apparent position is different from different vantage points on Earth.

### Storage of user data
{: .no_toc }
The captured location data stays in the runtime memory of the app and is only used for astronomical calculations.

### Third-party services
{: .no_toc }
Currently there are no third party integrations (including analytics and ads) that allow data to leave the app without user action.
This may change in the future, in which case:

* there will be an update available for the app
* this Privacy Policy will be updated

### Future Changes
{: .no_toc }
If I decide to change this Privacy Policy, I will post those changes on this page.

### Contact
{: .no_toc }
If there are still unanswered questions, or You want to chat about privacy of Your data, feel free to [contact&nbsp;me]({{site.baseurl}}/contact).

## History
See [releases on GitHub](https://github.com/TWiStErRob/net.twisterrob.sun/releases) for more details.

### [1.2.2#302-7ceb0e8](https://github.com/TWiStErRob/net.twisterrob.sun/releases/tag/v1.2.2) (2023-08-31)
{: #v12200302}
 * Feature: Android 13 compatibility
 * Enhancement: tons of dependency updates

### [1.2.1#fa87837](https://github.com/TWiStErRob/net.twisterrob.sun/releases/tag/v1.2.1) (2022-02-28)
{: #v12100086}
 * Enhancement: allow resizing of widget
 * Fix: more compliant way to refresh

### [1.2.0#7d706b5](https://github.com/TWiStErRob/net.twisterrob.sun/releases/tag/v1.2.0) (2022-02-05)
{: #v12000077}
 * Fix: Widget not refreshing ("No location available")
 * Enhancement: small UI improvements
 * Enhancement: internal technical changes to get the technology up to speed with 2021.

### [1.1.0#b02a853](https://github.com/TWiStErRob/net.twisterrob.sun/releases/tag/v1.1.0) (2022-01-03)
{: #v11000069}
 * Code is now open source in https://github.com/TWiStErRob/net.twisterrob.sun
 * Feature: Support Android 12 while keeping Ice Cream Sandwich (4.0) compatibility
 * Enhancement: internal technical changes to get the technology up to speed with 2021.

### [1.0.0#1339](https://github.com/TWiStErRob/net.twisterrob.sun/releases/tag/v1.0.0) (2014-10-18)
{: #v10001339}
 * Initial release
 * Feature: Multiple widgets
 * Feature: show-hide timing and name
 * Feature: manually select threshold
