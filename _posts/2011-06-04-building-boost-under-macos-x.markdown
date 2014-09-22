---
layout: post
status: publish
published: true
title: Building boost under MacOS X
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 157
wordpress_url: http://alex.tapmania.org/?p=157
date: '2011-06-04 10:23:03 +0100'
date_gmt: '2011-06-04 10:23:03 +0100'
categories:
- Development
tags:
- C++
- MacOSX
- Xcode
- boost
---
This is a small tutorial on building boost the proper way.  
I assume you already have a compiler installed on your system :)
If that's not the case your best bet is to grab Xcode4 with iPhone SDK or whatever
you need to get started. Installing Xcode will automatically give you everything (almost).  
Now back to boost.

First of all you will need to obtain the latest boost release at [boost.org](http://boost.org).

Unpack the archives:

{% highlight bash %}
$ tar xvjf boost_1_46_1.tar.bz2
$ cd boost_1_46_1
{% endhighlight %}

Bootstrap to create a build environment for boost:

{% highlight bash %}
$ sh bootstrap.sh
{% endhighlight %}

There is only one thing missing on stock MacOS X with Xcode4 installed --- ICU.

Grab ICU at [this site](http://site.icu-project.org/download).
ICU stands for "International Components for Unicode".  
Now when you have ICU4c, you will have to unpack, build and install it:

{% highlight bash %}
$ tar xvzf icu4c-4_8-src.tgz
$ cd icu4c-4_8
$ ./configure
$ make
$ sudo make install
{% endhighlight %}

After completing this step you are all set to compile boost libraries without any problems:

{% highlight bash %}
$ cd boost_1_46_1
$ ./bjam
$ sudo ./bjam install
{% endhighlight %}

That's it.  
Boost libraries and headers are installed onto the system in a convenient place: /usr/local/lib and /usr/local/include.

Cheers
