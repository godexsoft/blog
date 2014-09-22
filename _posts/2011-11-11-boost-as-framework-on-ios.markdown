---
layout: post
status: publish
published: true
title: boost as framework on iOS
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 180
wordpress_url: http://alex.tapmania.org/?p=180
date: '2011-11-11 10:04:11 +0000'
date_gmt: '2011-11-11 10:04:11 +0000'
categories:
- Development
tags:
- C++
- Xcode
- boost
- iOS
---
Using boost libraries on iOS?
Tired of building the libraries by hand and including them into your project using CFLAGS?
You need to read [this NOW](http://goodliffe.blogspot.com/2010/09/building-boost-framework-for-ios-iphone.html).

So Pete Goodliffe made a great script which allows you to build boost as a all-in-one
shiny framework which you can just drag&drop into your project and start using
boosting right away! neat huh?

However there are small issues with his script:

- You can't build boost::test and possibly some other libraries using it.
- Wont work with iOS 5 and current Xcode out of the box.
- Uses old boost (1.44.0) by default and no easy way to use newer version.

I have fixed these problems and shared the corrected version of his amazing script [here](http://tapmania.org/files/boost.sh).

**Usage:**

- You can edit this line _': ${BOOST_LIBS:="thread signals filesystem regex program_options system test"}'_ to add different libraries into the resulting framework.
- You can edit the _': ${IPHONE_SDKVERSION:=5.0}'_ line to set a different SDK if you have to.
- You need to have **boost_1_47_0.tar.bz2** downloaded into the same directory where the script is
- Just run **boost.sh** from a terminal.

Cheers.
