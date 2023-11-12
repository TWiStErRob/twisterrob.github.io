---
title: "ScreenJunkies Episode Guide"
subheadline: "Static episode listing"
teaser: "All ScreenJunkies episodes in one place."
type: bodge
images:
  icon: projects/screenjunkies/icon-512.png
  icon_small: projects/screenjunkies/icon-mdpi.png
  inline:
    sj: projects/screenjunkies/sj.jpg
    sjv: https://i.imgur.com/wAZnRCk.gif
    my: projects/screenjunkies/my.jpg
    myv: https://i.imgur.com/oP3Ykjg.gif
    titles: projects/screenjunkies/titles.jpg
  screenshots:
    - url: 'projects/screenjunkies/shows.jpg'
      title: List of shows in the Episode Guide
    - url: 'projects/screenjunkies/episodes.jpg'
      title: List of episodes in the Episode Guide
    - url: 'projects/screenjunkies/big-screen.jpg'
      title: Page view on a big screen
links:
  view: https://twisterrob-screenjunkies.herokuapp.com/
deprecation: 'This app was made redundant by the [termination of ScreenJunkies Plus](https://honest-trailers.fandom.com/wiki/Screen_Junkies_Plus#The_End_of_Plus).<br/>[ScreenJunkies website](https://www.screenjunkies.com) is no longer live.'
---

{% include toc.md %}

## Inception

### Motivation
I like to watch the content the awesome ScreenJunkies&nbsp;Team creates, but the [ScreenJunkies website](https://www.screenjunkies.com) has some usability and performance issues that are making me not want to use it. Let's look at an example use case:

> I already watched the latest <mark>Honest Trailer Commentaries</mark> yesterday, but prior to that I didn't watch the show for a few weeks. I want to watch the one episode before the latest that I missed.

Let's see what issues come up when trying to achieve that. (click the image to watch the screen recording[^large-gif]):
[![ScreenJunkies site]({{site.urlimg}}{{page.images.inline.sj}} "ScreenJunkies website - click for animation"){:onClick="this.src='{{page.images.inline.sjv}}'"}]({{page.images.inline.sjv}}){:onClick="return false;"}

Things to notice:

 * Hovering the <mark>Shows</mark> menu on top opens the listing delayed.
 * Taking the wrong route with the mouse (that is: diagonal) immediately hides the listing.  
  (It usually takes me two tries; this is because the hover goes to the <mark>Go [Plus]</mark> item.)
 * The show listing carousel lags when changing pages.
 * Not the whole show in the listing is clickable, only the <mark>Latest Episode</mark> button.
 * The video auto-plays.
 * The video cannot be paused while initially buffering.  
   (I thought I paused, but then I had to go back to pause it again.)
 * Using the lazy-loading carousel to step through 100+ items is boring and pointless.
 * If I wanted to watch the second from last episode of a show I have to scroll through each episode of that show.

I wanted to be able to get rid of these issues and I also wanted a better listing for the shows' episodes. Here's what I ended up with (click the image to watch the screen recording[^large-gif]):

[![Episode Guide page]({{site.urlimg}}{{page.images.inline.my}} "My take on ScreenJunkies' data - click for animation"){:onClick="this.src='{{page.images.inline.myv}}'"}]({{page.images.inline.myv}}){:onClick="return false;"}

[^large-gif]: I didn't wan't to include the original GIF here, because it's a few megabytes large. May take a while to load.

### Kickoff
I sent a few feedbacks to ScreenJunkies support, and they said <q>Thank you for writing, we appreciate your feedback.</q>. I guess they will take it into account, but it may take a long time as I'm guessing that the website is not maintained in-house. It's also possible I'm the only one who cares about ease of use, in which case they won't change the site, so after the last response I just decided to go ahead and brew something myself.

### Goals
These were my goals during implementation:

 * easily searchable, show all episodes at once  
 * simple, but flexible layout, support different screen sizes
 * easy on the eye, clean up redundant texts
 * fast loading
 * don't hammer their website with constant scraping

Possible future improvements, which are out of scope for now:

 * Show schedule calendar to visually show when each show has a new episode, like a desktop calendar.
 * Episode times to be able to display ["this week", "last week", "this month" type lists](https://www.youtube.com/feed/subscriptions).  
   (Sadly upload times are not public, but I could track differences between updates.)
 * watched episodes: need login, database, and dynamic pages
 * Ability to hide shows that the user never watches.
 * Ability to hide free content as that's available on [YouTube](https://www.youtube.com/user/screenjunkies) too.

#### Workarounds
The last three can be achieved by fairly trivial [userscripts](https://github.com/OpenUserJs/OpenUserJS.org/wiki/Userscript-beginners-HOWTO):  
*(Please note that I can't guarantee these will work in the future. Though it should be easy to fix them.)*

```javascript
$('.episode.sj').remove();
```
{:title="Remove free episodes"}

```javascript
var nonWatched = ['mundy-night-raw', 'knocking-dead', 'whats-in-the-box'];
for (var i = 0; i < nonWatched.length; ++i) {
	var dataid = '[data-slug=' + nonWatched[i] + ']';
	$('a' + dataid + ' + p + .episodes').remove(); // episode listing
	//$('a' + dataid + ' + p').remove();             // show description
	$('a' + dataid).remove();                      // show title
	//$('#shows li' + dataid).remove();              // show image on top
}
```
{:title="Remove unwatched shows (IDs from url when you click a show)"}

```javascript
// Warning: the order of the displayed episodes may change (unlikely) which can break this
var watched = { // showID: watchedCount
	'honest-trailer-commentaries': 50,
	'does-it-hold-up': 15
};
for (var id in watched) { if (Object.prototype.hasOwnProperty.call(watched, id)) {
	$('a[data-slug=' + id + '] + p + .episodes .episode:lt(' + watched[id] + ')').remove();
} }
```
{:title="Remove watched episodes (IDs from url when you click a show)"}

## Implementation

### Architecture
I decided to write a simple NodeJS application so I can host it on Heroku. I can schedule a background job to periodically scrape their website and load the latest episode listing. Since they release at most a few episodes each day, I figured a <samp>24h</samp> period would suffice. The scraped HTML is compiled into a JSON object with all the relevant information parsed out, then this intermediate representation is rendered with a JADE template into a single HTML page. This resulting page can be cached and served statically after this.

### Storage
A issue I wasn't anticipating was storing that rendered static HTML file to be served. In a normal environment one just saves the file and then stream the file as response when needed. The problem with this approach is that Heroku's dynos may be stopped<wbr>/started<wbr>/restarted<wbr>/put&nbsp;to&nbsp;sleep<wbr>/woke&nbsp;up at any time. The Hobby dynos may be reallocated to a different server meaning that the ephemeral file system they use will just lose all the cached data, so I needed an external storage system. I was contemplating using an RDBMS or Graph DB, but they both sounded like overkill for a simple file storage. The next idea was to use Amazon&nbsp;S3, but when the website asked for my credit card I gave up on it; free usage expire after 12 months anyway. Next I looked at the storage add-ons on Heroku and found Redis, which can outlive the Dynos and has a very simple get/set interface.

### Titles
Thinking about another potential use case:

> Let's see if they have an episode about &lt;title&gt; movie!  
> or  
> My friend came over and I want to show a joke in one of the episodes.

For this you need to be able to find the episode quickly, you can't just scroll through with the carousel looking at each episode, because it takes a lot of time and most of the time the titles are not even readable:

![{{titles.title}}]({{site.urlimg}}{{page.images.inline.titles}})

Unless you've seen the movies they made the Honest Trailer about and recognize the picture, it's hard to figure out which movie it is by a quick glance. To alleviate this I decided to clean up the titles by removing the show's title from the episode's title, because the heading or the thumbnail already tells which show I'm looking at.

#### Human generated data
Humans are inherently flawed and inconsistent most of the time, this reflected highly in the titles of the episodes. For example here are the different titles patterns that were used for the Honest&nbsp;Trailers show:

 * <samp>Honest Trailers - &lt;title&gt;</samp>[^dashes]
 * <samp>Honest Trailers – &lt;title&gt;</samp>[^dashes]
 * <samp>Honest Trailers — &lt;title&gt;</samp>[^dashes]
 * <samp>Honest Trailers - '&lt;title&gt;'</samp>
 * <samp>Honest Trailer: &lt;title&gt;</samp>
 * <samp>Honest Trailer: '&lt;title&gt;'</samp>
 * <samp>Honest Trailers: &lt;title&gt;</samp>
 * <samp>Honest Trailers: '&lt;title&gt;'</samp>
 * <samp>Honest Trailers &lt;title&gt;</samp>
 * <samp>&lt;title&gt; - Honest Trailers</samp>
 * <samp>&lt;title&gt;</samp>
 * ... and a few special titles
 
No wonder Google discards punctuation when indexing the web. I guess they are all equivalent uses, but the randomness feels disturbing to me. Probably the title depends on who uploaded it to YouTube and what mood they were in.

The most consistent show in this regard was Spencer's Does It Hold Up? where the titles are cleanly: <samp>Does &lt;title&gt; Hold Up? w/ &lt;guest&gt;</samp>. Interns of F.I.E.L.D., Movie Games, First & Worst, Mega Movie Get-Together and TV Fights come in second place with 1-2 unintentionally non-uniform titles.

[^dashes]: In case you're wondering what's the difference between these: notice the length of the dashes.  
           See [Dash on Wikipedia](https://en.wikipedia.org/wiki/Dash) for the differences in use of hyphen (-)/en-dash (&ndash;)/em-dash (&mdash;).

### Images
The ScreenJunkies website has 557 episodes to this date, rendering all that on a single page is nothing for a browser running on today's computers, but rendering all those with thumbnails makes a ton of separate requests for each image. If the browser fires all those requests during page load, you're left with a bad user experience and an overloaded server. For this reason I used lazy loading images with a thumbnail of the show showing as a placeholder. The images are loaded when the user actually sees them, as it would happen with ScreenJunkies's original carousel solution.
