---
layout: post
status: publish
published: true
title: C++ try-catch syntax
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 42
wordpress_url: http://alex.tapmania.org/?p=42
date: '2010-09-27 11:25:00 +0100'
date_gmt: '2010-09-27 11:25:00 +0100'
categories:
- Development
tags:
- C++
comments:
- id: 3
  author: kenota
  author_email: unplaced@gmail.com
  author_url: ''
  date: '2010-10-05 14:15:30 +0100'
  date_gmt: '2010-10-05 14:15:30 +0100'
  content: what are you smoking? :)
---
Some C++ syntactic sugar shared by Mike Filimonov.
Using try-catch within initialization:

{% highlight cpp linenos %}
struct A {
private:
    std::string s;

public:
    A( int value )
    try : s( boost::lexical_cast<std::string>( value ) )
    {
      // do something
    }
    catch ( boost::bad_lexical_cast ) {
      // handle lexical_cast exception here
    }
};
{% endhighlight %}

Using try-catch block as a global wrapper:

{% highlight cpp linenos %}
int main() // No body-block opened here
try
{
   // ...
}
catch(...)
{
   // ...
};
{% endhighlight %}

Cheers.
