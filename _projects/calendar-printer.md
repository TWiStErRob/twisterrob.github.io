---
title: "Google&nbsp;Calendar Printer"
subheadline: "Lean, compact layout"
teaser: "Prints your chosen calendar with picked range and time zone."
type: bodge
images:
  screenshots:
    - url: 'projects/calendar-printer/india_google.png'
      title: Most compact printing possible in Google Calendar
    - url: 'projects/calendar-printer/india_twisterrob.png'
      title: My take on printing the same data
links:
  view: http://twisterrob.net/dev/google-calendar
---

## Inception
One day we wanted to print an agenda for a week for events held at a venue. Google Calendar's print feature didn't make the cut, so I made a different one.

## Goals

 * make a week's schedule fit a page with 1-5 events / day
 * make it easy to reproduce a certain view of the calendar
 * make it readable from afar

## Features

 * display a public calendar of choice
 * authenticate to show private calendars
 * bookmarkable url
 * compact layout
 * printable
 * supports whole day/multi-day events
 * date range setting
 * by default it shows next 3 weeks of your primary calendar

## Examples
{% assign year = site.time | date: '%Y' | times: 1 %}
 * [Days]({{ page.links.download }}#!&calendar=%23daynum%40group.v.calendar.google.com)
 * [Next Moon phases]({{ page.links.download }}#!&calendar=ht3jlfaac5lfd6263ulfh4tql8%40group.calendar.google.com&lang=en)
 * [Upcoming Namedays (Hungary)]({{ page.links.download }}#!&calendar=03g7gm39atboogh5lgedpd8ntc@group.calendar.google.com&lang=hu)
 * [Holidays in {{year}} (HU)]({{ page.links.download }}#!&calendar=hu.hungarian%23holiday%40group.v.calendar.google.com&from={{year}}-01-01&to={{year}}-12-31&lang=hu)
 * [Holidays in {{year}} (UK)]({{ page.links.download }}#!&calendar=en.uk%23holiday%40group.v.calendar.google.com&from={{year}}-01-01&to={{year}}-12-31&lang=en_GB)
 * [Holidays in {{year}} (US)]({{ page.links.download }}#!&calendar=en.usa%23holiday%40group.v.calendar.google.com&from={{year}}-01-01&to={{year}}-12-31&lang=en_US)
 * [Sun (Szeged)]({{ page.links.download }}#!&calendar=i_91.120.28.2%23sunrise%40group.v.calendar.google.com&lang=hu)
 * [Sun (London)]({{ page.links.download }}#!&calendar=i_109.68.196.188%23sunrise%40group.v.calendar.google.com&lang=en_GB)
 * [Google Dev calendar]({{ page.links.download }}#!&calendar=developer-calendar%40google.com&from=2013-01-01&to={{year}}-12-31)

{% comment %}
## Used
 * http://momentjs.com/docs/#/manipulating/start-of/
 * http://underscorejs.org/#sortBy
 * https://developers.google.com/google-apps/calendar/v3/reference/events/list
## Future plans
 * validation http://ajax.aspnetcdn.com/ajax/jQuery.Validate/1.6/jQuery.Validate.pack.js
{% endcomment %}
