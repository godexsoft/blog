---
layout: post
status: publish
published: true
title: Android NDK and Xcode
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 24
wordpress_url: http://alex.tapmania.org/?p=24
date: '2010-09-16 07:24:12 +0100'
date_gmt: '2010-09-16 07:24:12 +0100'
categories:
- Development
tags:
- Android
- C++
- ndk
- Xcode
---
I'm a big fan of Xcode. I'm also a fan of Android since short.
How great would it be to produce, compile and even run Android code right from Xcode?
In this article I will explain how to use Xcode together with Android's NDK.
First thing you will need is Xcode. I assume you already have it but just in case:
<a href="http://developer.apple.com/technologies/tools/xcode.html" target="_blank">grab it here</a>

You will also need both, Android SDK and NDK.
If you don't have them yet: <a href="http://developer.android.com/sdk/index.html">grab them here</a>

Follow the installation steps on the corresponding site.  
Now, when you are all set, lets get straight to the details.
I assume you already have an Android project with some NDK code.

##Create Xcode project##

- In Xcode - **File -> New Project**
- Select **External Build System**
- Navigate to your Android project's **PARENT** directory and create new Xcode project with the same name.
- Hit **Replace** --- don't worry. It will not ruine any existing code.
- Add files to your project using **Add -> Existing files** and configure groups as you like

##Configure the build system##

- Go to **Targets -> [_your project name_]** and double-click to open
- Change **Build Tool** to **[_path to NDK_]/ndk-build** or just **ndk-build**
  if NDK is listed in the PATH variable
- Leave **Arguments** as-is (should be **$(ACTION)**) --- this will allow us to
  pass 'build' and 'clean' to ndk-build
- Set **Directory** to **[_project path_]/jni**

Now you can build using ⌘B. You can **Build -> Clean** too.

Android NDK is basically a gcc xcompiler so it produces errors and warnings in
the same fashion Xcode's gcc does.  
While using Xcode with ndk-build together we can benefit from that --- the errors
and warnings are all landing back in Xcode's **Bulid Results** window just as if
you were working on some iPhone app.

Cheers.
