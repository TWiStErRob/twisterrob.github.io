---
title: "Battle Camp: Trading Revamp"
subheadline: "New level of trading"
teaser: "Revamp for the quick and dirty trading interface PennyPop gave us."
images:
  icon: projects/bc-trade/bc-trade-logo.png
  icon_small: projects/bc-trade/bc-icon.png
  screenshots:
    - url: 'projects/bc-trade/bc-trade-big.jpg'
      title: 'Bigger example'
    - url: 'projects/bc-trade/bc-trade-before.jpg'
      title: 'Before applying this script'
    - url: 'projects/bc-trade/bc-trade-after.jpg'
      title: 'After applying this script'
urls:
  download: http://twisterrob.net/dev/bc/bc-trade.user.js
---

{% include toc.md %}

## Reason for existence
In short: they moved the Facebook Trading App to their Support site, but it was in a hurry and it's unfinished/unpolished. Here's a detailed breakdown:

 * **before April 2015**: Battle Camp Trading has been a [Facebook App](https://apps.facebook.com/battlecampapp) for long.
 * **April**: Facebook disabled the App <q>due to an issue with its third-party developer</q>, it's been "temporarily unavailable" since then.
 * **mid-April**: After PennyPop acknowledged the issue, they tried to [reinstate it](https://www.facebook.com/BattleCampApp/photos/a.207360366076774.69481.207322356080575/713998605412945/), but without luck, so they went with Plan B:
 * **18th April**: PennyPop [published](https://www.facebook.com/BattleCampApp/photos/a.207360366076774.69481.207322356080575/716224051857067/) an extremely minimalistic quick and dirty solution to get people back on trading again at [support.pennypop.com](http://support.pennypop.com/player/trading).
 * **31st May**: After weeks of trading and waiting for them to finish the app, I decided to re-style the monster selection on the trading pages.

## Installation

 0. Open a modern browser on the computer/laptop (no tablet/mobile sadly)
 0. Install either of the following browser plugins:
	* <a href="https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo?hl=en">TamperMonkey</a> from Chrome Web Store
	* <a href="https://addons.mozilla.org/en-us/firefox/addon/greasemonkey/">GreaseMonkey</a> from Mozilla Add-ons
	* <a href="https://addons.opera.com/en/extensions/details/violent-monkey/">Violent Monkey</a> from Opera add-ons
 0. Add <a href="bc-trade.user.js">Battle Camp trading userscript</a>
 0. Enjoy a new level of trading

## Disclaimer
This is a one-day hack having my best efforts put into it, it may break any time in the future as Battle Camp changes the trading process. I claim no responsibility to any potential damage caused.

Feel free to <a href="{{ site.baseurl }}/contact">contact me</a> with any questions or suggestions.

<small>THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.</small>
