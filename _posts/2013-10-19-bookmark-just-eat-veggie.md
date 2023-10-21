---
title: "Just-Eat vegetarian food"
subheadline: "Hide meals you'll never order"
teaser: "Tired of the meat-driven world? Order your kind of food with a click."
category: productivity
tags:
- bookmarklet
script:
  foot: bookmarklet.js
---

I got bored with searching through <q>Grilled&nbsp;Chicken&nbsp;Wings</q> and <q>Lamb&nbsp;Shish&nbsp;Kebab</q> and so on when ordering from&nbsp;<a href="http://www.just-eat.co.uk/" target="_blank">Just-Eat.co.uk</a>, so I came up with this script which removes all food containing known meat ingredients:
<a class="bookmarklet" href="#JustEat-GoGreen">Just-Eat: Go green</a>.
<!--more-->
[^1]
This bookmarklet is designed for the *Just-Eat menu pages* (updated for 2015 design). Open your favourite takeaway's menu and then execute the script:

 1. Install the bookmarklet [^1]
 2. Open [Indian Greedy Cow's menu](http://www.just-eat.co.uk/restaurants-indiangreedycowe2/menu){:target="_blank"}
 3. Click the bookmarklet, wait a little and observe:
     * how the whole <mark>Healthy Food Dishes</mark> category disappears  
       (I would've thought they have some **(V)** food there...)
     * that only the <mark>Vegetable</mark> options remain in the <mark>Traditional Curries</mark> category

The removed dishes are logged to the Console in the browser's Developer Tools.

```javascript
$.expr[':']['non-veggie'] = function(elem, i, match) {
	var text = (elem.textContent || elem.innerText || $(elem).text() || "");
	return new RegExp(match[3], 'i').test(text) && /* prevent removing "vegetarian lamb" */
		  !new RegExp('vegetarian[^,;.:*/\\(\\[\\{\\}\\]\\)\\\\]+' + match[3], 'i').test(text);
};

/* polyfill logging methods */
console.group = console.group || console.log;
console.groupCollapsed = console.groupCollapsed || console.log;
console.groupEnd = console.groupEnd || console.log;
console.debug = console.debug || console.log;
function removeLog(type, group, item) {
	group = group? group.text().trim() + (item && item.length? " > " : "") : "";
	item  = item ? item.text().trim() : "";
	console.debug("Removing " + type + ": " + group + item);
}

function removeEmptyTitles() {
	$('li.productSynonymListContainer')
		.has('ul.item-synonyms:not(:has(*))')
		.each(function() { removeLog("empty synonym list", $(this).parents('.menu-category').find('.category-header'), $('.itemName', this)); })
		.remove()
	;
	$('section.menu-category')
		.has('ul.menu-category-products:not(:has(*))')
		.each(function() {
			var href = $('a[href$="#' + $('>a', this).attr('id') + '"]'); /* category on the left */
			removeLog("empty category", href);
			href.parent().remove();
		})
		.remove()
	;
}

function removeItem(text) {
	var nonVeggieSections = $('.menu-category').not(':has(.category-header-link:non-veggie("vegetarian"))');
	var nonVeggieItems = '.item-name:non-veggie("' + text + '"), .item-description:non-veggie("' + text + '")';
	nonVeggieSections
		.find('ul.menu-category-products > li.addItemButton:has(' + nonVeggieItems + ')')
		.each(function() { removeLog("item", $('.item-name', this), $('.item-description', this)); })
		.remove()
	;
	var nonVeggieItems = '.itemName:non-veggie("' + text + '"), .item-description:non-veggie("' + text + '")';
	nonVeggieSections
		.find('ul.menu-category-products > li.productSynonymListContainer:has(' + nonVeggieItems + ')')
		.each(function() { removeLog("synonym list", $('.itemName', this), $('.item-description', this)); })
		.remove()
	;
	var nonVeggieItems = '.synonymName:non-veggie("' + text + '")';
	nonVeggieSections
		.find('ul.item-synonyms > li.addItemButton:has(' + nonVeggieItems + ')')
		.each(function() { removeLog("synonym list item", $(this).parents('.productSynonymListContainer').find('.itemName'), $('.synonymName', this)); })
		.remove()
	;
}


var nonVeg = [
	/*poultry*/ "wings", "chicken", "duck",
	/*cattle*/ "meat", "lamb", "pork", "beef", "goat", "oxtail", "cow", "mutton",
	/*products*/ "steak", "ham", "bacon", "rib", "ribs", "salami", "pepperoni", "meatball", "meatballs", "kebab", 
	/*fish*/ "fish", "saltfish", "tuna", "cod", "salmon", "brass", "seabass",
	/*seafood*/ "prawn", "prawns", "squid", "crab", "shrimp", "shrimps", "oyster"
];
for(var idx = 0; idx < nonVeg.length; ++idx) {
	console.group("Removing " + nonVeg[idx]);
	removeItem('\\b' + nonVeg[idx] + '\\b');
	console.groupEnd();
}
removeEmptyTitles();
$('#menu-navigation .current-menu-item > a').text("Menu, filtered: (V)")
```
{: #JustEat-GoGreen}

This is a best effort implementation which only works in English menus and I take no responsibility if the script breaks the page or leaves some non-vegetarian dishes on the menu. Please report any omissions and other issues with the script.

[^1]: {% include snippets/bookmarklet.html %}
