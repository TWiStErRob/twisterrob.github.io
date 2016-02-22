---
title: "Magic Home Inventory"
subheadline: "Remember and find your stuff"
teaser: "Categorized and hierarchical inventory with advanced search and visualization."
type: app
images:
  icon: projects/inventory/icon-512.png
  icon_small: projects/inventory/icon-mdpi.png
#  screenshots:
#    - url: 'projects/inventory/....jpg'
#      title: ...
links:
  googleplay: net.twisterrob.inventory
---

{% include alert alert='This app is not publicly released *yet*.' %}

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
The research turned out to be so deep that --- as a side effect --- a new feature arose: automatic category suggestions. This means that whenever a new item is created the category can quite possibly be predicted.

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
