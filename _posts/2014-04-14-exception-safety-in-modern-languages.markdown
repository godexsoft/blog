---
layout: post
status: publish
published: true
title: Exception safety in modern languages
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 321
wordpress_url: http://alex.tapmania.org/?p=321
date: '2014-04-14 09:33:06 +0100'
date_gmt: '2014-04-14 09:33:06 +0100'
categories:
- Development
tags:
- C++
- java
- D
- exception safety
comments: []
---
This was meant to be a post with lots of text. But as it was started over a year ago and never finished, I'm just posting a quick summary below:

####C++ try/catch:####  
- Cons/Pros - no _finally_... but also no real need for it as we will see later with RAII
- Pros - can catch exceptions on different levels
- Pros - can catch different exceptions at same level  
  and revert to ALL if needed (catch(...) )
- Cons - when catching ALL (...) the actual type of the exception is lost
- Cons - no standard way to get a stacktrace (call-chain, backtrace)

####C++ RAII:####  
- Cons - a lot of extra code (same class code. template won't help because the class is minimal anyway)
- Cons - has a stupid, poor-describing name
- Pros - flat structure, no hierarchy like with try/catch blocks
- Pros - the exception safety code is in the library/functions, not on the user-code side

####Java try/catch:####  
Can't rely on finalize (java destructor). finalize() will be called before object is garbage collected but no one guarantees the exact time.  

- Cons - if you have more than one level of nested try/catch it will become an unreadable mess soon
- Pros - has a finally block which allows for less code duplication
- Pros - can catch different types of errors on different levels
- [Read this from Egor's blog](http://binarybuffer.com/2012/03/things-you-need-to-remember-when-using-finally-in-java)
- Cons - exceptions are not chained if thrown from finally. finally always overrides everything (hidden exception)
- Pros - stacktrace is builtin

####D try/catch/finally:####  
- Pros (compared to java) - return statements cannot be in finally
- Pros - exception thrown first will be primary, the rest will be on the chain.  
  including exceptions thrown from finally (no hiding of exceptions)
- Other cons/pros are same as for Java

####D scopes:####  
Scope doesn't catch exceptions. It merely reacts to exceptions instead  

- Cons - moves exception handling onto the user of the functions/library. not the library itself as with raii
- Pros - flat structure. no hierarchy of scopes
- Pros - can define scopes for different types: exit (finally),  
  failure (catch) and success (!catch)

Cheers.
