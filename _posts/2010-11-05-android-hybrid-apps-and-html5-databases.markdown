---
layout: post
status: publish
published: true
title: Android, Hybrid apps and HTML5 databases
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 97
wordpress_url: http://alex.tapmania.org/?p=97
date: '2010-11-05 15:12:07 +0000'
date_gmt: '2010-11-05 15:12:07 +0000'
categories:
- Development
tags:
- Android
- java
- HTML5
- hybrid
---
If you use HTML5, most likely you are developing some web app which is supposed
to support offline mode and most likely uses a local database.  
Usually you create your HTML5 app for a browser and it works great as long as you
run it in a real browser. But once you want a hybrid app things can really get painful.

A WebView is typically the heart of any hybrid app.. you have all of your HTML5 running
in there but the really fancy or just platform dependent stuff can be done on the native side.
Communication between Javascript and Native (Java on Android) is likely to be
implemented using a bridge API or a local HTTP server which you will query using AJAX.

Android features a bridge API called JavascriptInterface which you can simply
attach to a WebView and all the methods of the class you passed to it will be
available in javascript under 'window.$NAME.$method(...)' where $NAME is the
JavascriptInterface name you specified in your WebView setup code and $method
is the Java method you can now simply call from JavaScript. Neat huh?

However, back to databases.

A very straightforward setup scenario with Javascript and Databases in mind:

{% highlight java linenos %}
WebView webView = new WebView(this);

// Out of scope. Just bare in mind that you wont be able
// to use your WebView without this
// as any request (intent) will be driven through Android system
// and will be opened in the default browser
// instead of your WebView.

webView.setWebViewClient( new MyWebViewClient() );
webView.getSettings().setJavaScriptEnabled(true);

webView.getSettings().setDatabaseEnabled(true);
{% endhighlight %}

This will fail to enable Database usage.  
To make it all work together you will definitely need to enable DOM storage:

{% highlight java linenos %}
webView.getSettings().setDomStorageEnabled(true);
{% endhighlight %}

You also will need to specify the file of the DB..:

{% highlight java linenos %}
webView.getSettings().setDatabasePath("/data/data/org.tapmania.alex.myapp/database");
{% endhighlight %}

But even that is not enough.  
You will need to tell Android that your quota for the database is at least twice
as big as it is once it's expired... now don't ask me what that means but just
stare at this code until fully satisfied:

{% highlight java linenos %}
webView.setWebChromeClient(new WebChromeClient() {
   @Override
   public void onExceededDatabaseQuota(String url,
        String databaseIdentifier,
        long currentQuota,
        long estimatedSize,
        long totalUsedQuota,
        WebStorage.QuotaUpdater quotaUpdater)
   {
       quotaUpdater.updateQuota(estimatedSize * 2);
   }
});
{% endhighlight %}

In fact, this code will automatically update the quota and thus allow us to
actually write a database file to disk and thus make the database work at all.

Cheers.
