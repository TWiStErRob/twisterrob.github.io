---
title: "Import a GIT repository to an SVN repository's subfolder preserving history"
subheadline: "Suprisingly simple steps in the right order"
teaser: "with full reproducible example"
category: dev
tags:
- git
- tutorial
---

I had an interview for which I created a GIT repo, but I wanted to import it into my personal monolyth SVN repo.<!--more--> After some Googling I found some examples, and this was the simplest solution. I decided to re-write from the original it in hopes that it'll be more discoverable.

## Intro

I'll be doing everything on Windows and using spaces in paths, because that's trickier, and to show that these things are not evil ;). Obviously, all these work on Unix systems as well, just convert the paths to use forward slashes and ignore the drive letters.

## Initial state

 * GIT repository with a project on a branch  
 (simple Gradle project shown, with 3 commits that created it)  

    ```
    + src
        + main
            + java
                - Test.java
    - build.gradle
    - README.md
    ```
    {: title="structure"}

    ```
    main: A --- B --- C
    ```
    {: title="branches & commits"}

 * SVN repository with projects in subfolders  
 (I have 4 projects in 2 groups, with 6 commits that created these)  

    ```
    + project group 1
         + project 1
         + project 2
    + project group 2
         + project 3
         + project 4
    ```
    {: title="structure"}

    ```
    svn: pg1 --- p1 --- p2 --- pg2 --- p3 --- p4
    ```
    {: title="branches & commits"}


## Goal
To grab the GIT repository contents into <samp>project group 2/project 5</samp> subfolder of the SVN repository.

```
+ project group 1
     + project 1
     + project 2
+ project group 2
     + project 3
     + project 4
     + project 5
        + src
            + main
                + java
                    - Test.java
        - build.gradle
        - README.md
```
{: title="structure"}

```
svn: pg1 --- p1 --- p2 --- pg2 --- p3 --- p4 --- A --- B --- C
```
{: title="branches & commits"}


## Set-up
I'll be using local repositories to do everything; meaning there's no network requests going on. It should be easy to generalize this to remote repositories.

The GIT repository is located in: <samp>P:\temp\git repo</samp>
```shell
git init "git repo"
cd "git repo"
echo "Test repo" > README.md
git add --all && git commit --message "Init repo"
echo "apply plugin: java" > build.gradle
git add --all && git commit --message "Init project"
mkdir src\main\java
echo "public class Test { public static void main(String... args) { System.out.println(""Hello""); } }" > src\main\java\Test.java
git add --all && git commit --message "Add code"
```
{: title="setup steps executed starting in P:\temp if you want to follow along"}

The SVN repository is located in: <samp>P:\temp\svn repo</samp> (Note: original repository, not the checked-out files)
```shell
svnadmin create "svn repo"
svn mkdir "file://P:/temp/svn repo/project group 1" -m "add project group 1"
svn mkdir "file://P:/temp/svn repo/project group 1/project 1" -m "add project 1"
svn mkdir "file://P:/temp/svn repo/project group 1/project 2" -m "add project 2"
svn mkdir "file://P:/temp/svn repo/project group 2" -m "add project group 2"
svn mkdir "file://P:/temp/svn repo/project group 2/project 3" -m "add project 3"
svn mkdir "file://P:/temp/svn repo/project group 2/project 4" -m "add project 4"
svn checkout "file://P:/temp/svn repo" svn
```
{: title="setup steps executed starting in P:\temp if you want to follow along"}

{% include alert info='Sadly I couldn\'t find a way yet to clone the SVN repo via `git svn` with `file:///` url, so in the SVN repo you\'ll need to `svnserve -d --listen-port 1234 -r P:\temp\svn-repo` for it to be accessible on `svn://localhost:1234` (edit `P:\temp\svn-repo\conf\svn-serve.conf` to include `anon-access=write` in `[general]` block; or otherwise configure your access rights).' %}


## Steps

 * Prepare folder (`svn mkdir`)
 * Check out SVN via git (`git svn clone`)
 * Link GIT (`git remote add`)
 * Link commits (`git rebase`)
 * Send to SVN (`git merge --ff-only` & `git svn dcommit`)

### Create hosting folder in SVN repository
A folder needs to be created to host the project in SVN. This is required to be able to put the branch from GIT repo into a subfolder.
```shell
svn mkdir "svn://localhost:1234/project group 2/project 5" -m "prepare project 5"
```
at this point we've added an extra commit to SVN. It would be nice to skip this from the steps, but didn't find a way yet.
```
root
    + ...
    + project group 2
         + project 5
```
```
svn: pg1 --- p1 --- p2 --- pg2 --- p3 --- p4 --- prep
```
{: title="branches & commits"}

### Prepare bridge repo from SVN
We'll clone the actual project subfolder from the SVN repo, this is why it was required to exist beforehand.

```shell
git svn clone "svn://localhost:1234/project group 2/project 5" "svn via git"
```

### Link up the bridge repo with GIT
```shell
cd "svn via git"
git remote add bridge "P:\temp\git repo"
git fetch bridge
```
```
main: pg1 --- p1 --- p2 --- pg2 --- p3 --- p4 --- prep
bridge/main: A --- B --- C
```
{: title="branches & commits"}

{% include alert warning='It is really important to step into the bridge repo folder, otherwise you may get an error like this:
> fatal: Not a git repository (or any of the parent directories): .git' %}

### Prepare commits to be put on top of the SVN repo
Create working copy of the GIT repo (`bridge/main`) and put its history (`import`) on top of the SVN folder's history (`main`).
```shell
git checkout -b import bridge/main
git rebase -i main
```
```
main: pg1 --- p1 --- p2 --- pg2 --- p3 --- p4 --- prep
import: A --- B --- C
bridge/main: A --- B --- C
```
{: title="branches & commits after checkout"}
```
main: pg1 --- p1 --- p2 --- pg2 --- p3 --- p4 --- prep
                                                       \
import:                                                  A' --- B' --- C'
bridge/main: A --- B --- C
```
{: title="branches & commits after rebase"}

{% include alert info='This is the point where you can edit the history, filter the branch, reword commits, etc.. Just `rebase -i main` as much as you want.' %}

### Finalize the process
```shell
git checkout main
git merge --ff-only import
```
```
main: pg1 --- p1 --- p2 --- pg2 --- p3 --- p4 --- prep --- A' --- B' --- C'
                                                       \
import:                                                  A' --- B' --- C'
bridge/main: A --- B --- C
```
{: title="branches & commits"}

After checking that everything is correct `git log`, `gitk` and the like push the changes to the SVN repo via `git svn dcommit`.

## References

 * [StackOverflow question with tricky answers](https://stackoverflow.com/questions/661018/pushing-an-existing-git-repository-to-svn)
 * [Original idea and credit](https://chani.wordpress.com/2012/01/25/the-easy-way-to-import-from-git-into-svn/)
 * [`svn mkdir`](https://svnbook.red-bean.com/en/1.7/svn.ref.svn.c.mkdir.html)
 * [`git svn`](https://git-scm.com/docs/git-svn)
