---
layout: post
status: publish
published: true
title: HTML5 Cache, Android WebView
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 110
wordpress_url: http://alex.tapmania.org/?p=110
date: '2010-11-19 12:43:49 +0000'
date_gmt: '2010-11-19 12:43:49 +0000'
categories:
- Development
tags:
- Android
- java
- HTML5
- hybrid
- cache
---
So last post was about HTML5 and WebViews but it didn't cover offline usage and especially caching.

HTML5 is cool. It can work offline once cached by the browser.
The main mechanism for offline HTML5 is the so called Manifest.
Basically it's a file which lists entries (js files, pictures, css, etc.) to be cached by the browser.  
To enable cache in Android's WebView we must do at least the following:

{% highlight java linenos %}
webView.setWebChromeClient(new WebChromeClient() {
  @Override
  public void onReachedMaxAppCacheSize(long spaceNeeded, long totalUsedQuota,
               WebStorage.QuotaUpdater quotaUpdater)
  {
        quotaUpdater.updateQuota(spaceNeeded * 2);
  }
});

webView.getSettings().setDomStorageEnabled(true);

// Set cache size to 8 mb by default. should be more than enough
webView.getSettings().setAppCacheMaxSize(1024*1024*8);

// This next one is crazy. It's the DEFAULT location for your app's cache
// But it didn't work for me without this line.
// UPDATE: no hardcoded path. Thanks to Kevin Hawkins
String appCachePath = getApplicationContext().getCacheDir().getAbsolutePath();

webView.getSettings().setAppCachePath(appCachePath);
webView.getSettings().setAllowFileAccess(true);
webView.getSettings().setAppCacheEnabled(true);
{% endhighlight %}

This will work. Well, this will make your WebView support caching.. doesn't mean it will actually work.

You can tune cache policies using the following code, even though it's not required to make it work:

{% highlight java linenos %}
webView.getSettings().setCacheMode(WebSettings.LOAD_DEFAULT);
{% endhighlight %}

Now when all the cache is setup we would like to see our HTML5 site working in pure offline mode.. but we don't!

Why? well.. if it's not working for you it probably means that the site you load up with
the following call is actually redirecting you somewhere else:

{% highlight java linenos %}
webView.loadUrl("http://myHTML5app.com/app/");
{% endhighlight %}

If /app/ is resolving to a redirect --- you are in trouble, sir.

The Cache mechanism will cache the actual RESULT of the redirect and sure it will
map it to the url you are being REDIRECTED to, not the one you originally called.  
So once you are offline --- the cache has no clue about the /app/ url and thus you
are simply given the default android "can't open page" replacement.

There are at least two ways to solve this issue..

1. Get rid of the redirect on the server
2. Re-redirect on android side

The first option is bad because you typically don't want to mess with the working
HTML5 site which is working on pure Browsers (iPhone, desktop, etc.).

To implement the second option I used the following code in the WebViewClient implementation:

{% highlight java linenos %}
@Override
public void onReceivedError(WebView view, int errorCode,
    String description, String failingUrl)
{
  // The magic redirect
  if( "http://HTML5app.com/app/".equals(failingUrl) ) {
    // main.html is the place we are redirected to by the server if we are online
    mWebView.loadUrl("http://HTML5app.com/app/main.html");

    return;
  }
  else if( "http://HTML5app.com/app/main.html".equals(failingUrl) ) {
    // The cache failed - We don't have an offline version to show
    // This code removes the ugly android's "can't open page"
    // and simply shows a dialog stating we have no network
    view.loadData("", "text/html", "UTF-8");
    showDialog(DIALOG_NONETWORK);
  }
}
{% endhighlight %}

Good luck!
