---
layout: post
status: publish
published: true
title: C++ to Obj-C callbacks. Part 4
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 309
wordpress_url: http://alex.tapmania.org/?p=309
date: '2012-04-18 22:22:07 +0100'
date_gmt: '2012-04-18 22:22:07 +0100'
categories:
- Development
tags:
- C++
- Obj-C
- C++11
- variadic templates
---
Really?! Part 4?

I have been looking at C++'s new standard a little..
there is a neat feature called __Variadic templates__ in C++11.

I thought it would be a good candidate to rewrite my callbacks _"lib"_
(now it sounds even funnier than before) in a much better, readable and preprocessor-independent way.  
The end result is __SO__ small that I actually embed it all in this post:

{% highlight objc++ linenos %}
template<typename Signature> class objc_callback;

template<typename R, typename... Ts>
class objc_callback<R(Ts...)>
{
public:
    typedef R (*func)(id, SEL, Ts...);

    objc_callback(SEL sel, id obj)
    : sel_(sel)
    , obj_(obj)
    , fun_((func)[obj methodForSelector:sel])
    {
    }

    inline R operator ()(Ts... vs)
    {
        return fun_(obj_, sel_, vs...);
    }

private:
    SEL sel_;
    id obj_;
    func fun_;
};
{% endhighlight %}

That's all! Now you can do all the cool stuff:

{% highlight objc++ linenos %}
// use boost::function
boost::function<void()> fn =
  objc_callback<void()>(@selector(simpleCallback), self);

// or boost::signals
boost::signal<void()> sig;
sig.connect(
  objc_callback<void()>(@selector(signalCallback), self) );

// or use auto
auto upd =
  objc_callback<void(float)>(@selector(update:), self);

// just invoke the callbacks
fn();
upd(now() - last_update);

// and signal
sig();
{% endhighlight %}

Cheers.
