---
title: "Xalan Java Extensions on Android"
subheadline: "Spoiler alert: not available out of the box"
teaser: "A saga of finding out, that I can't use them without external dependencies."
category: android
tags:
- debug
- workaround
- xml
---

I wanted to do a simple check to see whether Xalan's extension functions are available. This would've helped speeding up an XML-to-CSV transformation a bit.

<!--more-->

```xml
<xsl:stylesheet xmlns:str="xalan://java.lang.String">
...
<xsl:variable name="quote">&quot;</xsl:variable>
<xsl:variable name="double-quote">&quot;&quot;</xsl:variable>
<xsl:choose>
    <xsl:when test="function-available('str:replaceAll')">
        <!-- Happy days, fast replacement! -->
        <xsl:value-of select="str:replaceAll(string($text), $quote, $double-quote)" />
    </xsl:when>
    <xsl:otherwise>
        <!-- Oh well, we have this nice XSLT 1.0-compatbile implementation -->
        <xsl:variable name="escaped">
            <!-- @see http://stackoverflow.com/a/10528912/253468 -->
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="$text" />
                <xsl:with-param name="replace" select="$quote" />
                <xsl:with-param name="with" select="$double-quote" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$escaped" />
    </xsl:otherwise>
</xsl:choose>
```

After running it on my Android phone it just kept spewing `NullPointerException`s at me:

> W/System.err: SystemId Unknown; Line #98; Column #3; Attempt to invoke virtual method 'boolean org.apache.xalan.extensions.ExtensionsTable.functionAvailable(java.lang.String, java.lang.String)' on a null object reference

Everything was still working, but I don't like warnings, so I started looking for the root cause.

## Debugging and breakpoints

The source code is not available in the Android SDK. This means that it's nearly impossible to comperehend what's going on and use the stepping facilities of the IDE. I didn't even know where the exception is coming from, because there's no stack trace.

So I set out to figure out which version of Xalan is running on the device, so I can get the sources. I found that calling `org.apache.xml.serializer.Version.main(new String[0])` would give me the answer. It's not possible to call this from code, not even from an Evaluate while debugging, but the problem was only that it wasn't know to IDEA, so this worked:

```java
Class
    .forName("org.apache.xml.serializer.Version")
    .getDeclaredMethod("main", String[].class)
    .invoke(null, new Object[] { new String[0] });
```

The answer was: <q>Serializer Java 2.7.1</q> on both a 2.3.7 and a 5.0.0 device. So I tried to reproduce the issue on my desktop, but the `function-available` call worked real good when using `xalan:xalan:2.7.1`. **The problem was only reproducible on the phone.** So now, I knew the version of Xalan, and added it to my source path so the IDE can handle debugging. As usual with Android source code, there are some problems with line alignment. I still couldn't set meaningful breakpoints, but it was possible to set method breakpoints, however slow.

## Finding the source

So the official Xalan release is not the one I needed. A quick Google search for `TransformerImpl.java` revealed that it was once available as `/luni/src/main/java/...` in the AOSP [platform/libcore](https://android.googlesource.com/platform/libcore) repository. I tried to get the latest by simply jumping to the `master` branch, but it wasn't there. Quick cloning and `git log -- luni/...` showed me that the whole `org.apache.xalan` package was moved to `/apache-xml` in [f029395](https://android.googlesource.com/platform/libcore/+/f029395dff382fc4dcba0689fd948ec06644e1f0). That one still wasn't on the `master` branch, so another `git log` revelated that it was deleted and moved to an <q>external</q> repository in [e590b9c](https://android.googlesource.com/platform/libcore/+/e590b9c7ecbe9b35c33fd2d101b1abc6bd7d1489). At first I was puzzled by what that means, but after a quick look at the [repository listing](https://android.googlesource.com/?format=HTML) I found [platform/external/apache-xml](https://android.googlesource.com/platform/external/apache-xml/). Finally this one contained up-to-date code for [Lollipop](https://android.googlesource.com/platform/external/apache-xml/+/refs/heads/lollipop-release).

## Finally Debugging

Adding the above sources to the IDE source path I was able to browse and debug. I found out the full stack trace:

```
java.lang.NullPointerException: Attempt to invoke virtual method 'boolean org.apache.xalan.extensions.ExtensionsTable.functionAvailable(java.lang.String, java.lang.String)' on a null object reference
    at org.apache.xalan.transformer.TransformerImpl.functionAvailable(TransformerImpl.java:396)
    at org.apache.xpath.functions.FuncExtFunctionAvailable.execute(FuncExtFunctionAvailable.java:89)
    at org.apache.xpath.Expression.bool(Expression.java:186)
    at org.apache.xpath.XPath.bool(XPath.java:412)
    at org.apache.xalan.templates.ElemChoose.execute(ElemChoose.java:103)
    at org.apache.xalan.transformer.TransformerImpl.executeChildTemplates(TransformerImpl.java:2223)
    at org.apache.xalan.templates.ElemTemplate.execute(ElemTemplate.java:389)
    at org.apache.xalan.templates.ElemCallTemplate.execute(ElemCallTemplate.java:241)
    at org.apache.xalan.transformer.TransformerImpl.executeChildTemplates(TransformerImpl.java:2223)
    at org.apache.xalan.transformer.TransformerImpl.transformToRTF(TransformerImpl.java:1830)
    at org.apache.xalan.transformer.TransformerImpl.transformToRTF(TransformerImpl.java:1752)
    at org.apache.xalan.templates.ElemVariable.getValue(ElemVariable.java:302)
    at org.apache.xalan.templates.ElemVariable.execute(ElemVariable.java:245)
    at org.apache.xalan.transformer.TransformerImpl.executeChildTemplates(TransformerImpl.java:2223)
    at org.apache.xalan.templates.ElemTemplate.execute(ElemTemplate.java:389)
    at org.apache.xalan.templates.ElemCallTemplate.execute(ElemCallTemplate.java:241)
    at org.apache.xalan.templates.ElemApplyTemplates.transformSelectedNodes(ElemApplyTemplates.java:370)
    at org.apache.xalan.templates.ElemApplyTemplates.execute(ElemApplyTemplates.java:175)
    at org.apache.xalan.templates.ElemApplyTemplates.transformSelectedNodes(ElemApplyTemplates.java:370)
    at org.apache.xalan.templates.ElemApplyTemplates.execute(ElemApplyTemplates.java:175)
    at org.apache.xalan.transformer.TransformerImpl.executeChildTemplates(TransformerImpl.java:2223)
    at org.apache.xalan.transformer.TransformerImpl.applyTemplateToNode(TransformerImpl.java:2096)
    at org.apache.xalan.transformer.TransformerImpl.transformNode(TransformerImpl.java:1228)
    at org.apache.xalan.transformer.TransformerImpl.transform(TransformerImpl.java:614)
    at org.apache.xalan.transformer.TransformerImpl.transform(TransformerImpl.java:1145)
    at org.apache.xalan.transformer.TransformerImpl.transform(TransformerImpl.java:1123)
```

The reason it worked even with the error is because `XPath#bool` catches the exception and just returns `false` after logging.

So the question now is: <q>Why is the `ExtensionsTable` `null`?</q>. It is only set in one place:

```java
void setExtensionsTable(StylesheetRoot sroot)
		throws javax.xml.transform.TransformerException {
	try {
		if (sroot.getExtensions() != null)
			m_extensionsTable = new ExtensionsTable(sroot);
	} catch (javax.xml.transform.TransformerException te) {
		te.printStackTrace();
	}
```

The extensions are correctly recognized, I saw earlier during debug that `sroot.getExtensions()` is a non-null `Vector` containing one element. After a debug session, it turns out that an exception was thrown, however that `printStackTrace` had no effect and it wasn't visible. Don't fret, just use `printStackTrace(PrintWriter(StringWriter))` to get the trace:

```
javax.xml.transform.TransformerException: java.lang.ClassNotFoundException: org.apache.xalan.extensions.ExtensionHandlerJavaClass
    at org.apache.xalan.extensions.ExtensionNamespaceSupport.launch(ExtensionNamespaceSupport.java:101)
    at org.apache.xalan.extensions.ExtensionsTable.<init>(ExtensionsTable.java:66)
    at org.apache.xalan.transformer.TransformerImpl.setExtensionsTable(TransformerImpl.java:385)
    at org.apache.xalan.transformer.TransformerImpl.transformNode(TransformerImpl.java:1184)
    at org.apache.xalan.transformer.TransformerImpl.transform(TransformerImpl.java:614)
    at org.apache.xalan.transformer.TransformerImpl.transform(TransformerImpl.java:1145)
    at org.apache.xalan.transformer.TransformerImpl.transform(TransformerImpl.java:1123)
Caused by: java.lang.ClassNotFoundException: org.apache.xalan.extensions.ExtensionHandlerJavaClass
    at java.lang.Class.classForName(Native Method)
    at java.lang.BootClassLoader.findClass(ClassLoader.java:781)
    at java.lang.BootClassLoader.loadClass(ClassLoader.java:841)
    at java.lang.ClassLoader.loadClass(ClassLoader.java:469)
    at org.apache.xalan.extensions.ObjectFactory.findProviderClass(ObjectFactory.java:100)
    at org.apache.xalan.extensions.ExtensionHandler.getClassForName(ExtensionHandler.java:65)
    at org.apache.xalan.extensions.ExtensionNamespaceSupport.launch(ExtensionNamespaceSupport.java:76)
    ... 22 more
Caused by: java.lang.NoClassDefFoundError: Class not found using the boot class loader; no stack available
```

Surprise, surprise, there's a class missing. I diffed the Android Xalan and Xalan 2.7.1 sources and indeed, the whole XSLTC and most of the extension classes are not included in Android. This exception causes `m_extensionsTable` to be `null` and that's a problem in `functionAvailable`. So I went ahead tried to ensure that it's non-null:

```java
// transformer created by factory.newTransformer(...)
TransformerImpl xalanTransformer = (TransformerImpl)transformer;
StylesheetRoot sroot = new StylesheetRoot((ErrorListener)null);
// creates an empty Vector to be returned from getExtensions()
sroot.getExtensionNamespacesManager();
// make sure the workaround works in Marsmallow too
sroot.setSecureProcessing(false);
// sets up an empty ExtensionTable, so functionAvailable works without NPE
xalanTransformer.setExtensionsTable(sroot); // default visibility
```

It's worth noting that this code cannot be executed as is, because the compile classpath doesn't have these classes. However, it's a trivial conversion to reflective calls.

## Summary
This indeed fixed the problem, however it is not a good solution, even if you accept reflective hacks. The problem being that even though the XSLT ran, and there was no error, the `test="function-available"` check still evaluated to `false` and the `<xsl:template>` version was used. I now think it's pointless to do the hack to ensure an extension table, because the only place where `replaceAll` could have benefit, it doesn't work. In the end I just removed the Xalan Java Extension and swallowed the XSLT 1.0-compatible workaround.
