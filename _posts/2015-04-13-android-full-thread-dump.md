---
title: "Getting a full Thread Dump on Android"
subheadline: "Detailed walkthrough"
category: android
tags:
- investigation
- workaround
---

The Android operating system does a thread dump whenever it receives `SIGQUIT` signal. 
However you need an unlocked device to send that signal. 
Fear not, there's a workaround to get the exact same thread dump with a little more effort on a production device with a debuggable application.
<!--more-->

## Background
There are a few sources on the Internet on how to make a thread dump in Android, but most of them don't work or are lacking the intrinsic locking information, here's an example:

> If you have a developer / rooted device, you can ask the Dalvik VM to dump thread stacks by sending a `SIGQUIT` to the app process you're interested in.
<cite>[How to make Java Thread Dump in Android?](http://stackoverflow.com/a/13592951/253468)</cite>

If you try to send a signal on a non-rooted/non-dev device you'll get:

```shell
me@laptop$ adb shell "ps | grep twister"
USER     PID   PPID  VSIZE  RSS     WCHAN    PC         NAME
u0_a504   10904 278   914108 23164 ffffffff 00000000 S net.twisterrob.app

me@laptop$ adb shell kill -s SIGQUIT 10904
/system/bin/sh: kill: 10904: Operation not permitted
```

[An answer](http://stackoverflow.com/a/17737101/253468) to [How to stop an android application from adb without force-stop or root?](http://stackoverflow.com/q/17736188/253468) suggests to use `run-as`:

```shell
me@laptop$ adb shell run-as net.twisterrob.app kill -3 10904
run-as: Package 'net.twisterrob.app' is unknown
```

while the OP states that `force-stop` and `am kill` is ruled out, we could use them here:

```shell
me@laptop$ adb shell am force-stop net.twisterrob.app
me@laptop$ adb shell am kill --user all net.twisterrob.app
```
...the first really kills the app, and the second does nothing, in any case there's no thread dump.


## Solution
A solution for the above issues follows, based on the fact that you have control over your own Android process from the app's code.


### Step 0: Fake a UI lock-down
To have something to validate that we have the right information I suggest to lock on a known object. So later we'll see who/where and when locked. I put the following into my main Activity's `onCreate`:

```java
// we want to see what "this" is in a thread dump
synchronized (this) {
	try {
		wait();
	} catch (InterruptedException e) {
		e.printStackTrace();
	}
}
```

### Step 1: Always available debugger break entry point
If you want a thread dump you probably have a deadlock in your code in which case it might not be trivial to know when and where to stop the code execution. You'll need to start a background thread in your app so that you can stop the execution any time and be able to mess around in immediate mode too.

There's a <mark>Pause Program</mark> action available in IntelliJ IDEA's Debug view:  
!["Pause Program" action in IDEA's Debug View](data:image/png;base64,
	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
)  
but you can't execute any code in that mode:

> Target VM is not paused by breakpoint request. Evaluation of methods is not possible in this mode

So to have a live breakable point, put the following snippet somewhere in your app:

```java
new Thread("Debug-Breaker") {
	@Override public void run() {
		while (true) {
			try {
				Thread.sleep(1); // breakpoint here
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}
}.start();
```

Anywhere is ok that you know will surely execute before you need the thread dump.
Even an button's event handler will work.
I choose to put mine in:

```java
public class App extends Application {
	@Override public void onCreate() {
```

*Don't forget to register it in your manifest: `<application android:name=".App"`.*

Compile and run your app. If you did step 0 as I did, your app will be plain black/white and do nothing at this point, because `wait()` blocked the UI thread.


### Step 2: Create thread dump
Go to your IDE and do <mark>Run > Attach debugger</mark> to Android process  
![Choose Process dialog](data:image/png;base64,
	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
	TkSuQmCC
)  
and select your app's process and then go to the place where you have `Thread.sleep(1);` and put a breakpoint on it:  
![Breakpoint on line `Thread.sleep`](data:image/png;base64,
	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
	IH75H0nGqlhgzt4HAAAAAElFTkSuQmCC
)  
The breakpoint should be hit immediately:  
![app pause at breakpoint](data:image/png;base64,
	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
	YII=
)

Now there's a context you can execute code in, go to <mark>Run > Evaluate Expression...</mark> and enter:

```java
android.os.Process.sendSignal(android.os.Process.myPid(), android.os.Process.SIGNAL_QUIT)
```

In the Android LogCat view you'll see the following information printed:

```text
04-13 16:36:21.971  10904-10954/net.twisterrob.app I/Process﹕ Sending signal. PID: 10904 SIG: 3
04-13 16:36:21.971  10904-10909/net.twisterrob.app I/dalvikvm﹕ threadid=3: reacting to signal 3
04-13 16:36:22.061  10904-10909/net.twisterrob.app I/dalvikvm﹕ Wrote stack traces to '/data/anr/traces.txt'
```
The app may be still running at this point, but it doesn't matter any more. Feel free to detach debugger and/or stop it on the phone.


### Step 3: Acquire thread dump
Now it should be a simple `pull` from your device like this, but hey it's not that simple...

```shell
me@laptop$ adb pull /data/anr/traces.txt
failed to copy '/data/anr/traces.txt' to './traces.txt': Permission denied
```

for some reason I wasn't able to copy the file, but I can read it... so it's simple after all:

```shell
me@laptop$ adb shell "cat /data/anr/traces.txt" > traces.txt
```


### Step 4: Read thread dump
Now if you open <samp>traces.txt</samp> on you machine and scroll from the bottom you should find your app:

```text
----- pid 10904 at 2015-04-13 17:16:40 -----
Cmd line: net.twisterrob.app

... lots of stack traces of threads ...

----- end 10904 -----
```

Here's the UI thread's state, remember in [Step 0](#step-0-fake-a-ui-lock-down) I synchronized on `this`, see line #6 (starting with "waiting on"):

```text
"main" prio=5 tid=1 WAIT
    | group="main" sCount=1 dsCount=0 obj=0x418ccea0 self=0x417c7388
    | sysTid=13183 nice=-11 sched=0/0 cgrp=apps handle=1074684244
    | state=S schedstat=( 0 0 0 ) utm=7 stm=5 core=3
    at java.lang.Object.wait(Native Method)
    - waiting on <0x42aeb7a8> (a net.twisterrob.app.MainActivity)
    at java.lang.Object.wait(Object.java:364)
    at net.twisterrob.app.MainActivity.onCreate(MainActivity.java:45)
    at android.app.Activity.performCreate(Activity.java:5426)
    ...
```



## Summary
The above steps should give you access to thread dumps for any application you develop from your real device. The full thread dumps contain locking information like the <samp>waiting on</samp> line above which helps to diagnose deadlocks and synchronization issues. If you just want to see where your app is at the current time I suggest you use the Threads view of the SDK's DDMS `monitor`, or `Thread.getAllStackTraces()` programmatically or while debugging.
