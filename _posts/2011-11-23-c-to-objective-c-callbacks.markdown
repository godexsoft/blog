---
layout: post
status: publish
published: true
title: C++ to Objective-C callbacks
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 186
wordpress_url: http://alex.tapmania.org/?p=186
date: '2011-11-23 14:58:32 +0000'
date_gmt: '2011-11-23 14:58:32 +0000'
categories:
- Development
tags:
- C++
- boost
- iOS
- Obj-C
- bridge
- boost::bind
---
Developing for iOS?
That does not mean you have to do everything in Objective-C right? :-)

If you like to keep your business logic cross-platform or you just prefer C++
--- you are free to use C++ for most of your stuff.. just a little bit of glue code will be required to keep iOS happy.  
The big problem, however, is when one needs to update the UI (Obj-C only).
Now how do you update the UI from a C++ class where you don't have Obj-C's _self_?
And even worse - if you don't even compile that C++ part using Obj-C++ (.mm file or compiler setting)?

Recently I ran into this problem and found a nice way to deal with it. Time to share :-)

**Compile this as Objective-C++**:

{% highlight objc++ linenos %}
static boost::function<void()> objc_callback(SEL sel, id obj)
{
  typedef void (*func)(id, SEL);
  func impl = (func)[obj methodForSelector:sel];
  return boost::bind(impl, obj, sel);
}
{% endhighlight %}

**Define a callback in a pure C++ class**:

{% highlight cpp linenos %}
// ...

private:
    boost::function<void()> my_callback;

// ...
{% endhighlight %}

**Use our small bridge in your Objective-C code**:

{% highlight objc++ linenos %}
@interface ViewController (Callbacks)
- (void) onSomeCallback;
@end

@implementation ViewController
- (void) onSomeCallback
{
    // You have an Objective-C self here. Can update GUI
}

- (void)viewDidLoad
{
    // This is the trick:
    main_app::instance().set_my_callback(
        objc_callback(@selector(onSomeCallback), self) );

    [super viewDidLoad];
}
@end
{% endhighlight %}

**Now when you 'notify' in your C++ code**:

{% highlight cpp linenos %}
// ...

    my_callback();

// ...
{% endhighlight %}

Your Objective-C ViewController instance will receive the correct message and
you can safely update the UI from there.

**If you need to pass data thru your callback**:

{% highlight objc linenos %}
template<typename T>
static boost::function<void(T)> objc_callback_1(SEL sel, id obj)
{
    typedef void (*func)(id, SEL, T);
    func impl = (func)[obj methodForSelector:sel];

    return boost::bind(impl, obj, sel, _1);
}

template<typename T1, typename T2>
static boost::function<void(T1,T2)> objc_callback_2(SEL sel, id obj)
{
    typedef void (*func)(id, SEL, T1, T2);
    func impl = (func)[obj methodForSelector:sel];

    return boost::bind(impl, obj, sel, _1, _2);
}
{% endhighlight %}

Cheers.
