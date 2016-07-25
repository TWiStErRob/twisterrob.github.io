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

I started looking at inventory apps in the Play Store. I found a few of them, but they were mostly for legal reasons so you have the item's value in case of a sale or insurance claim I guess. They also lacked features important to me, one was able to put items into categories and the other was able to create hierarchies of items. The user interfaces didn't meet my expectations and some felt like it was done as a homework.

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

{% assign url = "http://yuml.me/diagram/plain;dir:LR/class/[Property%7Bbg:green%7D],%20[Room%7Bbg:green%7D],%20[Item%7Bbg:green%7D],%20[PropertyType%7Bbg:orange%7D],%20[RoomType%7Bbg:orange%7D],%20[Category%7Bbg:orange%7D],%20[Room]++--%3E[Item],%20[Item]%3C%3E---%3E[Item],%20[Property]++--%3E[Room],%20[Property]-.-%3C%3E[PropertyType],%20[Room]-.-%3C%3E[RoomType],%20[Item]-.-%3C%3E[Category],%20[Category]++---%3E[Category].png" %}
[![Database schema]({{ url }}){: .light-bg}]({{ url }}){: .no-adorn }

... and it turned out to be the really good so far, because I didn't have to change the core ever since.

### Categories
The types of stuff are dynamically "hardcoded" and managed on the developer side. I chose this path because this way users don't have to worry about creating their own categories. This resulted in months of research to have a "Categorize Everything!" list of things.

#### Research
The method I used was the following: list generic words that represent physical objects and then use logic and sometimes common sense to group them together. If the group grew two big I looked for common properties between objects and split it up. If there was an item that didn't fit, I tried hardest to find out why: by researching its origin, use, and etymology. Sometimes even that didn't help so it goes to the closest subcategory.

Another method that came up involved: going to the local supermarket, scanning all the aisles, and listing every item. This may sound tedious, but if you think about how many different brands and types of shampoos and soaps are there, you can quickly see that those two words cover almost a full aisle. It still took a week to finish though as I double-checked the name of everything on the Wikipedia, online shops, the dictionary, and sometimes with my British girlfriend --- remember, I was in Hungary, so the labels didn't have the right words... my vocabulary grew quite a bit.

The categories evolved a lot during these months and the final result is a multi-tiered categorization which means that the user can chose how deep they want to assign the categories.

#### Suggestions
The research turned out to be so deep that --- as a side effect --- a new feature arose: automatic category suggestions. This means that whenever a new item is created, the category can quite possibly be predicted. I used a trie data structure to store all the keywords and a clever matching algorithm to allow for character mismatches in during lookup. A reasonable implementation is to allow at most 2 of any of the following mismatches: insert character, delete character, change character, swap two consecutive characters. This allows to match wild typos as can be seen on [one of the screenshots]({{site.urlimg}}{{page.images.inline.typos}}){:onclick="$('.clearing-thumbs li img[src="{{site.urlimg}}{{page.images.inline.typos}}"]').click(); return false;"}. Based on these matches a list of possible categories can be presented for the user to choose from.

### Validation
As a proof that the model is feasible and the categories are a fit for a "normal" home (I guess I live in one, but who knows ;) I started a full inventory of everything I own resulting in more than 1600 entries.

### Other features
During the development I had some ideas I wanted to see so I tried to add them as I went. This deviated from the original goals, but still fit in with the spirit of the app.

#### Moving
This was the first extra. I soon found out that stuff can be reorganized during spring cleaning or similar event; though most of the stuff is usually kept together. So the result is: any item (multiple selection possible) on any level can be moved around freely with all the contents. This greatly mimics the real life equivalent of moving a box :)

#### Recents
I remember having many occasions where I had to check my browsing history because I wanted to re-visit a website. This is similar. You browse your inventory looking for something. You found it 6-7 levels deep at the bottom of a cupboard inside 3 boxes, but say you're interrupted by a chat message. You leave and forget about it. The next time you open the app, you can see what you were looking at in the past and just quickly continue where you left off.

#### Lists
I realized that even if most of the stuff has its place in certain rooms, there's use for another way of looking at things: lists. A list consists of items that relate to a certain use case. For example it may worth create the following lists, to never forget anything ever again:

 * Travel
 * Hiking
 * Skiing
 * Camping
 * Lent

The lists are quite simple things and can be extended at any time. So suppose you created a travel list, you used it to prepare next time you went traveling. It was quite good, but you forget this one thing. You can quickly hit up the app (because you probably didn't forget your phone), search for the item and add it to the list. There's no "I'll add it later", because it's so simple.

This type of list is better than a generic list, because it's made of YOUR stuff creating a personalized aspect. It's also really easy to look up where a certain item on the list is located in your home. This helps a lot because there may've been a full year passed since the last event of the same type.

#### Sunburst diagram
I really liked to browse some apps where I could see what's on my phone's internal memory, what's occupying space. The inventory applies a similar hierarchical concept than those of files and folders, so I set out try to visualize how my stuff looks like. The results are flashy :)

## Working with exports

The export the app makes is made to work with the app, but since XML is a generic human readable format, it's easy to convert it to anything.
Though this mostly requires some kind of programming.
In the future I plan to create some transformations to make it easier to consume an export.

### Convert XML to CSV (Excel)
In the meantime here's a quick and dirty workaround.

 1. Extract data.xml from an export.zip on your computer.
 1. Open data.xml in a text editor that fully supports Regular Expressions:
  * [Sublime Text](https://www.sublimetext.com/)
  * [Nodepad++](https://notepad-plus-plus.org/)
  * Windows Notepad has no support at all
  * Notepad2 deems it too complex and doesn't work
 1. Press <kbd>CTRL+H</kbd> to start replacing text
  * Sublime Text: <mark>Find > Replace...</mark>
  * Notepad++: <mark>Search menu > Replace...</mark>
 1. Copy the below monstrosity to <mark>Find what</mark>:

    ```regexp
    ^(?:\s*<item id="(\d+)" name=(?:"([^"]+)"|'([^']+)') type="([^"]+)"(?: image="([^"]+)")? ?/?>.*?(?:\s*<description>([^<]*)</description>)?(?:\s*</item>)?|\s*</item>)$
    ```
 1. Copy the below to <mark>Replace with</mark>:

    ```regex
    "\1","\2\3","\4","\5","\6"
    ```
 1. Make sure to remove any leading or trailing whitespace resulting from copy-paste in <mark>Find what</mark> and <mark>Replace with</mark> fields.
 1. Enable <strong>Regular Expressions</strong> (`.*` icon in Sublime Text) and click the "Replace All" button
  * Sublime Text:  
    ![Replace dialog in Sublime Text](data:image/png;base64,
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
RK5CYII=
    )
  * Notepad++:  
    ![Replace dialog in Notepad++](data:image/png;base64,
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
)
 1. <mark>File menu > Save As ... ></mark> enter file name `data.csv` and save
 1. Staying in the text editor, modify the encoding to UTF-8 so Excel recognizes any special characters:
  * Notepad++: <mark>Encoding menu > Encode in UTF-8-BOM</mark>, then <mark>File menu > Save</mark>
  * Sublime Text: <mark>File menu > Save with Encoding > UTF-8 with BOM</mark>
 1. Open just-saved `data.csv` in Excel and clean up: adjust column widths and delete unnecessary XML remains.
    To remove empty lines you can sort the table and the empty lines will move to the end.
    Alternatively before you open in Excel you can search `"","","","",""\n` and replace with nothing (leave <mark>Replace with</mark> empty), don't forget to save the changes.
    {%include alert warning='Warning: the cells may be misaligned if your names or descriptions contain straight quotation marks (`"`), make sure you remove them!' %}

