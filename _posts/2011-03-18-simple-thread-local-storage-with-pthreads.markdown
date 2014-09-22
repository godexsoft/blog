---
layout: post
status: publish
published: true
title: Simple Thread Local Storage with pthreads
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 133
wordpress_url: http://alex.tapmania.org/?p=133
date: '2011-03-18 02:36:15 +0000'
date_gmt: '2011-03-18 02:36:15 +0000'
categories:
- Development
tags:
- C++
- MacOSX
- pthread
- tls
- threading
---
The story is simple.. say you want a thread local static variable in one of your classes.

With gcc on Linux you could easily do something like

{% highlight cpp linenos %}
static __thread Object tls_static_obj;
{% endhighlight %}

But on MacOSX the story is different.  
The _\_thread keyword is not supported at all. Neither in the llvm compiler nor in gcc.

Here is a fast workaround I came up with. It's based on pthread's 'key' and 'specific' stuff:

{% highlight cpp linenos %}
#pragma once
#ifndef __TLS_H__
#define __TLS_H__

#include
<pthread.h>

template<typename T>
class ThreadLocalStorage
{
private:
    pthread_key_t   key_;

public:
    ThreadLocalStorage()
    {
        pthread_key_create(&key_, NULL);
    }

    ~ThreadLocalStorage()
    {
        pthread_key_delete(key_);
    }

    ThreadLocalStorage& operator =(T* p)
    {
        pthread_setspecific(key_, p);
        return *this;
    }

    bool operator !()
    {
        return pthread_getspecific(key_)==NULL;
    }

    T* operator ->()
    {
        return static_cast<T*>(pthread_getspecific(key_));
    }

    T* get()
    {
        return static_cast<T*>(pthread_getspecific(key_));
    }
};
#endif // __TLS_H__
{% endhighlight %}

Now you can write something as simple as

{% highlight cpp linenos %}
class MyClass
{
private:
    static ThreadLocalStorage<Object> tls_static_obj;

    // ...
};

// Just get the linker happy
// (set tls_static_obj's internal data to NULL too)
ThreadLocalStorage<Object> tls_static_obj;
{% endhighlight %}

Now when you get to the point where you want to set it to something (remember, it was NULL by default) you just do

{% highlight cpp linenos %}
MyClass::tls_static_obj = &someObject;
{% endhighlight %}

And then you can use it like this:

{% highlight cpp linenos %}
MyClass::tls_static_obj->objMethod();
{% endhighlight %}

This will invoke objMethod on a thread local instance of Object.

Cheers.
