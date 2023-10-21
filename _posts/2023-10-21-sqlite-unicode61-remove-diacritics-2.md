---
title: "Android SQLite FTS4 tokenize=unicode61 remove_diacritics=2"
subheadline: "requires minSdk API 30"
teaser: "It was too good to be true to begin with!"
category: android
tags:
- investigation
---

_Android developer_ wants to create a quick full text search for an international audience with case-insensitivity.<!--more-->

## TL;DR

See the [Summary](#summary) section below.

{% include toc.md %}

## The High of Feasibility

_Android developer_ searches a bit and finds SQLite, FTS4 and `unicode61` as potential solution.

The [FTS4 documentation](https://www.sqlite.org/fts3.html) reads as follows:

> FTS4 is an enhancement to FTS3.  
> FTS3 has been available since SQLite version 3.5.0 (2007-09-04)  
> The enhancements for FTS4 were added with SQLite version 3.7.4 (2010-12-07).  
> \[…]  
> The "unicode61" tokenizer is available beginning with SQLite version 3.7.13 (2012-06-11).

Quick check of [Android SQLite versions](https://developer.android.com/reference/android/database/sqlite/package-summary) reveals the following table:

| Android API | SQLite Version | Comment                                                  |
|-------------|----------------|----------------------------------------------------------|
| API 1       | 3.4            |
| API 3       | 3.5            | FTS3 from this point onwards.                            |
| API 8       | 3.6            |
| API 11      | 3.7            | FTS4 was added somewhere here.                           |
| API 21      | 3.8            | FTS4 and `unicode61` definitely from this point onwards. |
| API 24      | 3.9            |
| API 26      | 3.18           |
| API 27      | 3.19           |
| API 28      | 3.22           |
| API 30      | 3.28           |
| API 31      | 3.32           |

Let's say that the app under development has an "old" `minSdk = 21` which covers 99.34% of the market in 2023[^1]. This is great, this means we can use FTS4 for the app, no restrictions. Quick further check of [StackOverflow: Version of SQLite used in Android?](https://stackoverflow.com/a/4377116/253468) reveals the exact version we could expect from API 21 is 3.8.6. Further check of the [release notes](https://www.sqlite.org/releaselog/3_8_6.html) shows:

> The unicode61 tokenizer is now included in FTS4 by default.

Such, great, news! Feasibility confirmed, let continue [reading the docs](https://www.sqlite.org/fts3.html) and find the option to remove diacritics (e.g. accents, which makes the search a little bit more dynamic in ways I won't go into detail here.):

> The remove_diacritics option may be set to "0", "1" or "2". The default value is "1". \[…]  
> This is technically a bug \[…]  
> If this option is set to "2", then diacritics are correctly removed from all Latin characters.

OK, so the default behavior is bugged in some cases[^2], let's just set the option to `2` to ensure the best behavior for an international audience.

## Testing a Proof of Concept

So, now equipped with a very simple SQL statement based on all the above documentation:
```sql
CREATE VIRTUAL TABLE Search USING FTS4 (
	tokenize=unicode61 'remove_diacritics=2',
	content
);
```
let's try this out. I was using the latest emulator API 34, and it was working fine. Then I tried API 21 and got greeted with
```
android.database.sqlite.SQLiteException: unknown tokenizer (code 1)
	at android.database.sqlite.SQLiteConnection.nativeExecuteForChangedRowCount(Native Method)
	at android.database.sqlite.SQLiteConnection.executeForChangedRowCount(SQLiteConnection.java:734)
	at android.database.sqlite.SQLiteSession.executeForChangedRowCount(SQLiteSession.java:754)
	at android.database.sqlite.SQLiteStatement.executeUpdateDelete(SQLiteStatement.java:64)
	at android.database.sqlite.SQLiteDatabase.executeSql(SQLiteDatabase.java:1676)
	at android.database.sqlite.SQLiteDatabase.execSQL(SQLiteDatabase.java:1605)
```
Uhm, OK, this shouldn't happen according to the version checks I did earlier, right? `unicode61` was available much earlier, and is now included by default too. What's going on?

## Compassion

Failing to make it work, I turned to our big G friend to find some answers.

My first try to search for the error message `SQLiteException: unknown tokenizer (code 1)` pretty much failed, as I only found false positives which were a similar error showing me how "icu" and "unicode61" tokenizers were not found. These seemed like proper errors where the tokenizer was simply not available.

On to more direct search based on what I knew `fts4 unicode61 remove_diacritics` also gave me no usable results, so I went back to try an exact search `"SQLiteException: unknown tokenizer (code 1)"` which yielded a Bingo! result at [Unknown tokenizer - TOKENIZER_UNICODE61](https://stackoverflow.com/q/72807615/253468) which was exactly the same problem. I was glad to find some info, but there were no answers, just guessing.

I also tried `android "unicode61" "remove_diacritics"` which lead me to find [Uwe's issue](https://github.com/UweTrottmann/SeriesGuide/issues/673) where he apparently also had a similar issue at first, but in the end he just went with `remove_diacritics=0`.

I wasn't satisfied with finding only questions, without knowing why it's not possible. Luckily the above references gave me some ideas, so I started researching deeper.

## Reproducer

At this point I knew I needed more info: what is failing exactly and where? So I went on to create a small standalone project and see what's possible.

I tested variations of `FTS3`/`FTS4`/`FTS5` with `tokenize=simple|porter|icu|unicode61` and all possible `remove_diacritics=*` values and executed this on all relevant API levels (21-34).

The results (see [project for test and CI code](https://github.com/TWiStErRob/repros/tree/main/android/sqlite-tokenizer-availability)):
 * FTS5 is not supported on Android at all.
 * Almost everything in FTS3 and FTS4 works on all versions,
   except the `tokenize=unicode61 'remove_diacritics=2'` combination I wanted,
   which throws up on API 21-29:
   ```
   android.database.sqlite.SQLiteException: unknown tokenizer (code 1 SQLITE_ERROR)
   ```
   and works from 30 onwards.

I would like to call out a few things here:
 1. `tokenize=unicode61 'remove_diacritics=0'` and `tokenize=unicode61 'remove_diacritics=1'` works, but `tokenize=unicode61 'remove_diacritics=2'` doesn't.
 2. The same problem occurs with `FTS3` and `FTS4`.
 3. API level 30 and onwards works, so there must be something with that version. [^3]

## In Depth Research

I wanted to answer the question: why does `tokenize=unicode61 'remove_diacritics=2'` only work on API 30 and above, if `FTS4` and `unicode61` already works from API 21. [^4]

Let's start with what we already know from [Android's SQLite package](https://developer.android.com/reference/android/database/sqlite/package-summary):

| Android API | SQLite Version | Status |
|-------------|----------------|--------|
| API 21      | 3.8            | fails  |
| …           | …              | fails  |
| API 28      | 3.22           | fails  |
| API 29      | 3.22           | fails  |
| API 30      | 3.28           | works  |

From here I've reviewed all the SQLite release notes between 3.22 and 3.28 looking for `FTS`/tokenizer/`unicode61` keywords.
There were 3 release notes that contained these, but the big reveal was in [3.27.0](https://sqlite.org/releaselog/3_27_0.html):

> Added the `remove_diacritics=2` option to FTS3 and FTS5.

So this confirms why it started to work in API 30.

To double-check this finding, I looked at the FTS3 documentation
[before](https://web.archive.org/web/20190206145549/https://www.sqlite.org/fts3.html#tokenizer:~:text=By%20default%2C%20%22unicode61,unicode61%20%22remove_diacritics%3D0%22)
and
[after](https://web.archive.org/web/20190324224724/https://www.sqlite.org/fts3.html#tokenizer:~:text=By%20default%2C%20%22unicode61,all%20Latin%20characters.)
that release, and found that the sentence about `remove_diacritics=2` was added after 7th February 2019 which is exactly the release date of SQLite `3.27.0`.

## Summary [^5]

Android API 30 (including SQLite `3.28`) is the first one that supports `remove_diacritics=2`, which was added in SQLite `3.27.0`.

| Date       | What happened? |
|------------|----------------|
| 2007-09-04 | [SQLite 3.5.0](https://sqlite.org/releaselog/3_5_0.html) was released with FTS3 (no mention in release notes, but in documentation). |
| 2010-12-07 | [SQLite 3.7.4](https://sqlite.org/releaselog/3_7_4.html) was released with FTS4. |
| 2012-06-11 | [SQLite 3.7.13](https://sqlite.org/releaselog/3_7_13.html) was released with the `unicode61` tokenizer. |
| 2014-08-15 | [SQLite 3.8.6](https://sqlite.org/releaselog/3_8_6.html) was released where the `unicode61` tokenizer is included in FTS4 by default. |
| 2014-11    | [Android 5 / L / API 21](https://developer.android.com/reference/kotlin/android/os/Build.VERSION_CODES#lollipop) was released [including SQLite 3.8](https://developer.android.com/reference/android/database/sqlite/package-summary)[.6](https://stackoverflow.com/a/4377116/253468). |
| 2018-01-22 | [SQLite 3.22.0](https://sqlite.org/releaselog/3_22_0.html) was released. |
| 2018-08    | [Android 9 / P / API 28](https://developer.android.com/reference/kotlin/android/os/Build.VERSION_CODES#p) was released [including SQLite 3.22](https://developer.android.com/reference/android/database/sqlite/package-summary). |
| 2019-02-06 | [archive.org](https://archive.org/) took a snapshot [before](https://web.archive.org/web/20190206145549/https://www.sqlite.org/fts3.html#tokenizer:~:text=By%20default%2C%20%22unicode61,unicode61%20%22remove_diacritics%3D0%22) the release. |
| 2019-02-07 | [SQLite 3.27.0](https://sqlite.org/releaselog/3_27_0.html) was released including support for `remove_diacritics=2` |
| 2019-03-24 | [archive.org](https://archive.org/) took a snapshot of the [FTS3 documentation including `remove_diacritics=2` mention](https://web.archive.org/web/20190324224724/https://www.sqlite.org/fts3.html#tokenizer:~:text=By%20default%2C%20%22unicode61,all%20Latin%20characters.). |
| 2019-04-16 | [SQLite 3.28.0](https://sqlite.org/releaselog/3_28_0.html) was released. |
| 2020-09    | [Android 11 / R / API 30](https://developer.android.com/reference/kotlin/android/os/Build.VERSION_CODES#r) was released [including SQLite 3.28](https://developer.android.com/reference/android/database/sqlite/package-summary). |
| 2023-…     | Android developers are reading the [latest version of the FTS documentation](https://www.sqlite.org/fts3.html). |

## Conclusion

 1. When it comes to Android, we need to be more aware of versioning and history.  
    After 10 years I'm still not used to this, as showcased by this above story.
    SQLite team is wonderful at keeping a version history, [archive.org](https://archive.org/) is a godsend when it comes to time travel.
 2. Read the error message, and write good error messages!  
    Think about how much difference it had made if the error was:
    ```
    SQLiteException: unknown tokenizer option value 2 for remove_diacritics
    ```
 3. Test assumptions if possible.  
    Luckily I tested on my `minSdk` version before releasing this time and found the problem early.

[^1]: You can substitute many versions here for a few coming years. According to [apilevels.com](https://apilevels.com/) which sources data from [GlobalStats](https://gs.statcounter.com/android-version-market-share/mobile-tablet/worldwide).
[^2]: Foreshadowing: At this point something was fishy to me: using the first SQLite version where FTS4 was available had "historical reasons" already. But I dismissed feeling on account of the high of the great feasibility news.
[^3]: I set out to find and document the exact problem here, the end result is what you're reading right now.
[^4]: In hindsight the answer is very simple, but finding it wasn't that trivial.
[^5]: Research based on [Android Release dates](https://developer.android.com/reference/kotlin/android/os/Build.VERSION_CODES), [Android embedded SQLite versions](https://developer.android.com/reference/android/database/sqlite/package-summary), [SQLite FTS3 and FTS4 documentation](https://www.sqlite.org/fts3.html) and its [historical snapshots on archive.org](https://web.archive.org/web/20190207000000*/https://www.sqlite.org/fts3.html), [SQLite release dates](https://sqlite.org/chronology.html) and [release notes](https://sqlite.org/changes.html).
