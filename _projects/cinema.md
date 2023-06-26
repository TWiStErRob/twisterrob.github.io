---
title: "Cinema Planner"
subheadline: "Get the most of Cineworld Unlimited"
teaser: "Planning cinema visits based on available screenings."
type: app
images:
  icon: projects/cinema/logo.png
  icon_small: projects/cinema/fav.png
  screenshots:
    - url: 'projects/cinema/planner.png'
      title: Shows all available viewing plans.
    - url: 'projects/cinema/planner-mobile.png'
      title: Responsive, changing layout on mobile.
links:
  view: https://cinema.twisterrob.net/planner
  sources: https://github.com/TWiStErRob/net.twisterrob.cinema
deprecation: 'For now, the app shows fake data due to Cineworld''s discontinued screening feed. If you know where to find structured Cineworld screening data, please [contact me]({{ site.baseurl }}/contact)!'
---

{% include toc.md %}

## Inception
I like watching movies and I have a Cineworld Unlimited card
(watch as many movies as you want for about 2 ticket prices per month, it's [really worth it!](https://www.facebook.com/TWiStErRob/posts/pfbid07nf8TCtMzN4FdK1bfKsMRUyCrZwGHZjsyj6BaxvDYxUv4iCWiGLA4jmhBYdm5HNbl)).
With this, the price of going to the cinema is the _time and money spent on public transport_.
So batching screenings together helped me save.

I was hand-planning double-bills initially, but it got tedious and wanted to have some fun coding and learning, so I tried many alternatives.

## Implementation
Initially I was trying to make a mobile app, then an AJAX-only page,
but then soon realized I need a server to do the heavy lifting, so I also tried AppEngine.
In the end I ended up with an Angular.js webapp with a Node.js backend with a Neo4J OGM database.
Later, I migrated the backend to Kotlin/ktor.

For more history, see [the project repository](https://github.com/TWiStErRob/net.twisterrob.cinema/blob/main/README.md).

### Usage
The way it works is that you select which cinemas you're willing to go to.
Then select which movies you're interested in.
Then it'll give you a table of screenings and some plans to watch as many movies as possible in one batch.

### Filter
Going to the cinema is limited by external factors, for example working day, so I built in some filters to help with that.

### Optimizations
Cineworld plays a lot of advertisements, 15-25 minutes before each movie.
I wasn't really interested in watching the same ads over and over again, so I calculated a bit of delay to account for this.
Still, with this, I've seen Kevin Bacon's EE ads way too many times 😵.

### Sharing
The URL changes as the inputs change, this means that it's easy to share the current view with others.
