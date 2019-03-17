---
title: "\"My <em>Pricy</em> Orders\" in Google Play store"
subheadline: "Hide purchases you didn't pay for"
category: productivity
tags:
- bookmarklet
- Google
script:
  foot: bookmarklet.js
---

Google Play is providing a <a href="https://play.google.com/store/account" target="_blank">nice list of Orders</a>, 
however I couldn't care less about *Free* books app installations as <mark>My Orders</mark>.
This little script loads the whole list and then removes all "Free" items, leaving you only the pricy ones: 
<a class="bookmarklet" href="#GooglePlay-RemoveFreeOrders">Google Play: Remove free Orders</a>.
<!--more-->
[^1]

```javascript
var sort = true;

function clean() {
	$('.my-account-purchase-row')
		.filter(function(i, x) {
			var price = $(x).find(".my-account-purchase-price").text().trim();
			return /Free|[^\d]+0([.,]?0*)$|^0[.,]?0*[^\d]+/.test(price);
		})
		.remove()
	;
}

function compareByPrice(a, b) {
	var aPrice = $(a).find('.my-account-purchase-price').text().replace(/[^0-9,.;]/g, "");
	var bPrice = $(b).find('.my-account-purchase-price').text().replace(/[^0-9,.;]/g, "");
	return bPrice - aPrice;
}

function check() {
	var more = $("#show-more-button:visible");
	if (more.length) {
		more.click();
		window.scrollBy(0, 1000000);
		setTimeout(check, 3000);
	} else {
		clean();
		if (sort) {
			console.debug("Done, sorting.");
			$(".my-account-list-table tbody").replaceWith(
				$('.my-account-purchase-row').sort(compareByPrice)
			);
		}
		window.scrollTo(0, 0);
	}
}

check();
```
{: #GooglePlay-RemoveFreeOrders}

[^1]: {% include snippets/bookmarklet.html %}
