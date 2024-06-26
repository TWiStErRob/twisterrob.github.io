---
title: "Magic Home Inventory"
subheadline: "Remember and find your stuff"
teaser: "Categorized and hierarchical inventory with advanced search and visualization."
type: app
images:
  icon: projects/inventory/icon-512.png
  icon_small: projects/inventory/icon-mdpi.png
  inline:
    typos: projects/inventory/Phone %235 Category aid.jpg
  screenshots:
    - url: projects/inventory/Phone %231 Home Screen.jpg
      title: "Home Screen with shortcuts to belongings"
    - url: projects/inventory/Phone %232 Items.jpg
      title: "Item listing"
    - url: projects/inventory/Phone %233 Categories.jpg
      title: "Category browser showing main categories"
    - url: projects/inventory/Phone %234 Sunburst.jpg
      title: "Sunburst diagram of a small sample inventory"
    - url: projects/inventory/Phone %235 Category aid.jpg
      title: "Category suggestions showing ability to match typos in names"
    - url: projects/inventory/Phone %236 Subcategories.jpg
      title: "Subcategory drill-down with item count in each category"
    - url: projects/inventory/Phone %237 Selection.jpg
      title: "Multi-selection capabilities for items"
    - url: projects/inventory/Phone %238 Move.jpg
      title: "Move dialog for relocating items"
links:
  googleplay: net.twisterrob.inventory
---

{% include toc.md %}

## Inception

### Motivation
The idea to create an inventory app came to me when I moved home to my parents in Hungary for a long vacation. Up until then I was living in London, UK where I left some stuff in storage. As some weeks and months passed I totally forgot what stuff I have in London and where it is. I also experienced the same when I moved to the town I attended university and when I moved to London. Whatever if left behind becomes forgotten. I sometimes even buy the same thing because it is hidden in the depth of a drawer.

### Kickoff
So when I moved home I set out to inventory all my belongings in my room and in the shed, so next time I need something I can just simply look it up. This also includes when my mother asks: "Where did you put your X/Y item?".

I started looking at inventory apps in the Play Store. I found a few of them, but they were mostly for legal reasons, so you have the item's value in case of a sale or insurance claim I guess. They also lacked features important to me, one was able to put items into categories and the other was able to create hierarchies of items. The user interfaces didn't meet my expectations and some felt like it was done as a homework.

### Goals
I set my goals to include the features deemed most important to me:

 * free hierarchy
 * categories
 * record pictures for the items
 * searchable
 * fast entry, navigation and edit

... and left some features to the future:

 * import/export from/to other apps (though there's still ability to backup and share the full inventory)
 * multiple images per item
 * specialized fields (color, brand, price, ...)

I'm curious to see which of these pop up in reviews.

## Implementation

### Model
I started implementing the app with a basic, but flexible database schema:

{% assign url = "https://yuml.me/diagram/plain;dir:LR/class/[Property%7Bbg:green%7D],%20[Room%7Bbg:green%7D],%20[Item%7Bbg:green%7D],%20[PropertyType%7Bbg:orange%7D],%20[RoomType%7Bbg:orange%7D],%20[Category%7Bbg:orange%7D],%20[Room]++--%3E[Item],%20[Item]%3C%3E---%3E[Item],%20[Property]++--%3E[Room],%20[Property]-.-%3C%3E[PropertyType],%20[Room]-.-%3C%3E[RoomType],%20[Item]-.-%3C%3E[Category],%20[Category]++---%3E[Category].png" %}
[![Database schema]({{ url }}){: .light-bg}]({{ url }}){: .no-adorn }

... and it turned out to be the really good so far, because I didn't have to change the core ever since.

### Categories
The types of stuff are dynamically "hardcoded" and managed on the developer side. I chose this path because this way users don't have to worry about creating their own categories. This resulted in months of research to have a "Categorize Everything!" list of things.

#### Research
The method I used was the following: list generic words that represent physical objects and then use logic and sometimes common sense to group them together. If the group grew two big I looked for common properties between objects and split it up. If there was an item that didn't fit, I tried hardest to find out why: by researching its origin, use, and etymology. Sometimes even that didn't help, so it goes to the closest subcategory.

Another method that came up involved: going to the local supermarket, scanning all the aisles, and listing every item. This may sound tedious, but if you think about how many different brands and types of shampoos and soaps are there, you can quickly see that those two words cover almost a full aisle. It still took a week to finish though as I double-checked the name of everything on the Wikipedia, online shops, the dictionary, and sometimes with my British girlfriend --- remember, I was in Hungary, so the labels didn't have the right words... my vocabulary grew quite a bit.

The categories evolved a lot during these months and the final result is a multi-tiered categorization which means that the user can choose how deep they want to assign the categories.

#### Suggestions
The research turned out to be so deep that --- as a side effect --- a new feature arose: automatic category suggestions. This means that whenever a new item is created, the category can quite possibly be predicted. I used a trie data structure to store all the keywords and a clever matching algorithm to allow for character mismatches in during lookup. A reasonable implementation is to allow at most any 2 of the following mismatches: insert character, delete character, change character, swap two consecutive characters. This allows to match wild typos as can be seen on [one of the screenshots]({{site.urlimg}}{{page.images.inline.typos}}){:onclick="$('.clearing-thumbs li img[src="{{site.urlimg}}{{page.images.inline.typos}}"]').click(); return false;"}. Based on these matches a list of possible categories can be presented for the user to choose from.

### Validation
As a proof that the model is feasible and the categories are a fit for a "normal" home (I guess I live in one, but who knows ;) I started a full inventory of everything I own resulting in more than 1600 entries.

### Other features
During the development I had some ideas I wanted to see, so I tried to add them as I went. This deviated from the original goals, but still fit in with the spirit of the app.

#### Moving
This was the first extra. I soon found out that stuff can be reorganized during spring-cleaning or similar event; though most of the stuff is usually kept together. So the result is: any item (multiple selection possible) on any level can be moved around freely with all the contents. This greatly mimics the real life equivalent of moving a box :)

#### Recents
I remember having many occasions where I had to check my browsing history because I wanted to re-visit a website. This is similar. You browse your inventory looking for something. You found it 6-7 levels deep at the bottom of a cupboard inside 3 boxes, but say you're interrupted by a chat message. You leave and forget about it. The next time you open the app, you can see what you were looking at in the past and just quickly continue where you left off.

#### Lists
I realized that even if most of the stuff has its place in certain rooms, there's use for another way of looking at things: lists. A list consists of items that relate to a certain use case. For example, it may be worth creating the following lists, to never forget anything ever again:

 * Travel
 * Hiking
 * Skiing
 * Camping
 * Lent

The lists are quite simple things and can be extended at any time. So suppose you created a travel list, you used it to prepare next time you went traveling. It was quite good, but you forget this one thing. You can quickly hit up the app (because you probably didn't forget your phone), search for the item and add it to the list. There's no "I'll add it later", because it's so simple.

This type of list is better than a generic list, because it's made of YOUR stuff creating a personalized aspect. It's also really easy to look up where a certain item on the list is located in your home. This helps a lot because there may have been a full year passed since the last event of the same type.

#### Sunburst diagram
I really liked to browse some apps where I could see what's on my phone's internal memory, what's occupying space. The inventory applies a similar hierarchical concept than those of files and folders, so I set out try to visualize how my stuff looks like. The results are flashy :)

## User Guide
You can find most of the relevant usage information inside the app: tap <mark>☰</mark> and select <mark>About & Help</mark>.

### Working with exports

The export the app makes is made to work with the app. Since XML is a generic human-readable text file format, it's easy to convert it to anything.
I've included an HTML and a CSV file for human consumption to cover the most basic cases: sharing the export with others, browse the export on the computer, do some statistics (Excel) on the inventory.

It's easy to convert the exported data to any format necessary, though this mostly requires some kind of programming, for example writing an XSLT stylesheet.
The HTML conversion XSLT file can be found in each exported ZIP file, so based on that it should be simple to create any kind of output. The CSV conversion XSLT file is only available in the APK file.

## Privacy Policy

The _Magic Home Inventory_ app (the app) allows the user (You) to enter information about personal belongings.

### Camera permission
{: .no_toc }
This permission authorizes the app to take photos using Your device's camera(s).
The captured images are used as visual identification of Your belongings.

### Storage of user data
{: .no_toc }
The information You input is stored on the device\'s local storage mechanisms, as opposed to Cloud Storage.
However, it is possible through various ways to directly or indirectly export Your data and make it available for external parties.
From the moment Your data leaves the app via Backup, Export, or Share functionalities, the app has no control over that data, and hence third party terms and policies will apply.

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

### [1.2.0#1279-8eca619](https://github.com/TWiStErRob/net.twisterrob.inventory/releases/tag/v1.2.0) (2023-08-30)
{: #v12001279}
* Feature: Android 9, 10, 11, 12, 13 (API 28-33) compatibility.
* Feature: Android KitKat (4.4 / API 19) support is dropped, Android Lollipop (5.0 / API 21) is the minimum now.
* Feature: New, simpler Backup screen to accommodate new Android "Scoped Storage" practices.
* Feature: Internally re-written Manage Space screen.
* [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/pull/265): Editing an item always starts clean, so when there are no changes it doesn't ask to discard.
* [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/286): Hide "Flatten subcategories" button when it's not relevant.
* [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/296): SnackBar (delete/move confirmation) overlapping the system navigation bar (back button, home button).
* [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/196): Selection is now tracked correctly when a new item is added/removed.
* [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/191): Allow clicking the category icon to change category, previously it was opening the camera/image.
* Experimental: Reviewed Google Drive hacks, it's still broken, use Export/Import whenever possible.
* [Known issue](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/269): on API 23 deselecting text in About screen crashes the app, not fixing it as it's not a critical interaction.
* [Feature](https://github.com/TWiStErRob/net.twisterrob.inventory/tree/main/.github/workflows): Continuous Integration on GitHub

### [1.1.3#3191](https://github.com/TWiStErRob/net.twisterrob.inventory/releases/tag/v1.1.3) (2020-11-01)
{: #v11303191}
 * Feature: Support Android 9 (API 28), while keeping Gingerbread (2.3.7 API 10) compatibility.
   * [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/169): Permissions issues in Camera.
   * [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/159): Permissions issues in Backup.
   * Fix: ongoing notification for Backup and add notification channel support
 * [Feature](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/147): Warning for users on old devices.
   * App version 1.1.3 (this) will stay active and work down to Gingerbread (2.3.7 API 10) just like before, but will receive no more updates.
   * App version 1.2.0 (next) will drop support for version below Lollipop (5.0 API 21).
 * [Feature](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/143): Navigate to home screen from any depth via long press on top left "up" button.
 * [Enhancement](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/125): XSD schema for backup XML format is now included in the app / backup ZIP  
   Validating output based on this schema before finishing backup to be sure it's valid.
 * [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/101): Widen landscape move dialog to be useful. _(Thanks Barry L for the report!)_
 * [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/77): Flash not working after rotation.
 * [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/148): Cannot pick images from Gallery on Android 10. _(Thanks for the numerous reports!)_
 * [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/149): GMail integration when sending feedback (e.g. missing subject).
 * Small improvements here and there.
   * Feature: Jump to any folder in backup (tappable header).
   * Enhancement: Tiny improvements to some icons.
   * Enhancement: 28 keyword improvements for better suggestions.  
   * Enhancement: Better handling of Settings screen actions.
   * [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/87): Document what "Recents" is about
   * [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/129): Forget previous image in Camera to prevent weird behaviors.
   * [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/132): Cannot pick images from Gallery when process is killed.  
     _(Thanks Alberto P for the very detailed report!)_
   * [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/124): Fix generating invalid backup when a list references an item with name containing `--`.
   * Fix: Improved some error messages to show instead of SQL errors.  
     _(If you see a techie SQL error, please send me a screenshot. Thanks Dave S. for doing so already!)_
   * Fix: crashes reported via Crash reporting in Android (e.g. 
       [#161](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/161),
       [#162](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/162)
     )
   * Fix: camera crash for devices without flash
 * Lots of internal technical changes
   * Use newer build tools (AGP 3.4.2, Gradle 5.6.4).
   * Use a more modern internal structure for build scripts.
   * Use included builds instead of substitution hack.
   * Update some libraries to get better support for new Android versions.
   * Clean up new lint warnings.
   * Strict compilation checks.
   * Improved code documentation.
   * [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/163): Fix/suppress some StrictMode warnings on API 28+.
   * Use new SVG library and have an easy upgrade validation path.
   * Better architectural and code patterns.
   * Fix AAPT2 breaking changes (`$` in name and resource merging).
   * Android app is now split up into feature modules (a rough start).
   * Helper libraries exploded into many small libraries.
 * Improved self-tests (not visible to users) to prevent breaking app functionality. (100+ things)
   * Improve tests around selection, images, Backup, external export, Settings.
   * Fix permission issues in tests.
   * Better waiting between interactions (Glide, activities).
   * Better packaging of tests.
   * Fixed a lot of randomly failing flaky tests. (e.g.
       [#140](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/140),
       [#150](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/150),
       [#151](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/151),
       [#152](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/152),
       [#153](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/153),
       [#154](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/154),
       [#155](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/155),
       [#157](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/157)
     )
   * Fixed most version-related failures in tests.
   * Better failures if something goes wrong.
   * Updated test libraries to latest compatible versions  
     (Mockito 3.2.4, Robolectric 4.3.1, PowerMock 2.0.4, JUnit 4.13, Espresso 3.0.1)

### [1.1.2#2292](https://github.com/TWiStErRob/net.twisterrob.inventory/releases/tag/v1.1.2) (2017-07-28)
{: #v11202292-2}
 * Fix: Forgot bump staged rollout to 100%, so only half the users got the release.  
   _Thanks to Michael L. for alerting me! (Excellent example of useful feedback.)_

### [1.1.2#2292](https://github.com/TWiStErRob/net.twisterrob.inventory/releases/tag/v1.1.2) (2017-03-13)
{: #v11202292}
 * Known issues:
   * Cannot import image from gallery on Android 10, fixed in [1.1.3](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/148)
 * Feature: Add Privacy Policy in accordance with Google Play Store requirements.
 * Feature: Added a lot of self-tests (not visible to users), to prevent breaking app functionality.
 * Enhancement: ~30 keywords improvements for better suggestions.
 * [Enhancement](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/76): Rotate camera buttons more naturally.
 * [Enhancement](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/84): Better camera behavior on low-end devices.
 * Fix: Re-added missing attribution and licences section in About.
 * Fix: Improved error messages for Samsung Marshmallow+ devices.
 * Fix: Crash when displaying image in non-compliant Gallery apps (e.g. on Alcatel Pixi 4)
 * [Fix](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/83): Prevent crash when sharing with low resources.
 * Fix: Other very minor fixes, and internal improvements

### [1.1.1#2203](https://github.com/TWiStErRob/net.twisterrob.inventory/releases/tag/v1.1.0) (2016-09-20)
{: #v11102203}
 * Fix: Property images were associated with the wrong belonging when importing a local ZIP file from device.
 * Fix: Remove colors from texts to prevent crashes on exotic Android versions.
 * Enhancement: Use material design error for editing a belonging's name.

### [1.1.0#2193](https://github.com/TWiStErRob/net.twisterrob.inventory/releases/tag/v1.1.0) (2016-09-19)
{: #v11002193}
 * [Feature](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/37): Ability to import/export from/to any external source (incl. Drive, Dropbox).
 * Feature: Proper background import/export with notifications and all.
 * Feature: Add human-readable HTML (web page) and CSV (Excel) files to backup ZIPs.
 * Feature: Show details page automatically when opening a search result (most likely looking for location).
 * Feature: Added a lot of tests to cover the functionality and prevent breaking changes.
 * [Enhancement](https://github.com/TWiStErRob/net.twisterrob.inventory/issues/42): Show which lists the items are on in details view.
 * Enhancement: Use ▶ instead of > to signify containment.
 * Fix: Few suggestion improvements.
 * Fix: Minor additions and fixes to help (Navigation, Backup, Tips).
 * Fix: some images were not removed when some belongings were deleted: some space may free up after upgrade.
 * Fix: that single crash reported about HTC One M8 not knowing what "gray" is.  
   _(Please send the error reports if it pops up. The app doesn't have Internet permission, so I can't send automatic crash reports.)_
 * Fix: Lessen probability of technical messages showing up.
 * Fix: don't include any logging classes, more aggressive ProGuard

### [1.0.0#1934](https://github.com/TWiStErRob/net.twisterrob.inventory/releases/tag/v1.0.0) (2016-07-05)
{: #v10001934}
 * Enhancement: Lots of category research & rework
 * Enhancement: Typo-safe category suggestions
 * Enhancement: Much better quality image from camera
 * Enhancement: Added Help and fixed usability issues
 * Fix: Lots of other improvements

### [1.0.0#1627](https://github.com/TWiStErRob/net.twisterrob.inventory/releases/tag/v1.0.0-rc) (2015-05-31)
{: #v10001627}
 * Feature: Category suggestions
 * Enhancement: Lots of category research 
