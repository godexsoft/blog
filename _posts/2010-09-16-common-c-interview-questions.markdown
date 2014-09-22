---
layout: post
status: publish
published: true
title: Common C++ interview questions
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 28
wordpress_url: http://alex.tapmania.org/?p=28
date: '2010-09-16 13:04:19 +0100'
date_gmt: '2010-09-16 13:04:19 +0100'
categories:
- Development
- Lifestyle
tags:
- C++
- stl
- interview
comments: []
---
Just a little list of questions I like to ask people I interview.

- _**A\*a=new A;**_ --- Is this C++? Why not?
- What is auto_ptr?
- What about vector<auto_ptr<...> >?
  Provided: _**int a[] = {3,2,5,2,6,9,45,6,33};**_ --- Calculate total (3+2+5+...). STL way, perhaps?  
- Why can C's standard sort routine be slower than C++'s **std::sort**?

Provided:

{% highlight cpp linenos %}
class c
{
private:
   int foo, bar, baz;

public:
   c(int n)
   : foo(n++), baz(++n) bar(++n)
   { };
};
{% endhighlight %}

  What are the values after construction if:

{% highlight cpp linenos %}
c obj(10);
{% endhighlight %}

- What will happen if foo, bar and baz were pointers and one of them would throw
  exception on construction? How to solve the problem?
- **_template< template<class, int> T, T foo >_** --- How do you read this and is that valid C++?

Cheers.
