---
layout: post
status: publish
published: true
title: C++ to Obj-C callbacks. Part 3
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 271
wordpress_url: http://alex.tapmania.org/?p=271
date: '2012-04-05 09:46:57 +0100'
date_gmt: '2012-04-05 09:46:57 +0100'
categories:
- Development
tags:
- C++
- boost
- Obj-C
- metaprogramming
- preprocessor
---
As promised in Part 2, I took the time to rewrite the callbacks lib to match _Boost.Function_ style.

{% highlight objc++ linenos %}
boost::function<void(float)> update_callback =
  objc_callback<void(float)>(
    @selector(updateCallback:), self);
{% endhighlight %}

As you can see the syntax changed since last post.  
It's now a proper class instead of a static function and there is a good reason for that.  
The reason is that the neat __void(float)__ syntax can only be implemented using the
__partial template specialization__ feature which simply doesn't exist for functions:

{% highlight objc++ linenos %}
template<typename T> spec_test_fn(T input);
template<typename T1, typename T2>
  spec_test_fn<T1 (T2)>(T1 input1, T2 input2); // Oops.

template<typename T>
class spec_test;

template<typename T1, typename T2>
class spec_test<T1 (T2)>
{
    // valid!
};

// fine:
spec_test<void(int)> tst1;

// error:
// implicit instantiation of undefined
// template 'spec_test<void ()>'
spec_test<void()> tst2;
{% endhighlight %}

I decided to mimic boost::function by generating _safe_ versions of callbacks first.
__objc_callback_*n*__:

{% highlight objc++ linenos %}
#define CALLBACK_operator_params(z, n, text) \
    BOOST_PP_COMMA_IF(n) \
    BOOST_PP_CAT(T,n) BOOST_PP_CAT(text,n)

#define CALLBACK_generator(z, n, unused)                \
template<typename R BOOST_PP_COMMA_IF(n)                \
    BOOST_PP_ENUM_PARAMS(n, typename T)>                \
class objc_callback_##n                                 \
{                                                       \
public:                                                 \
    typedef R (*func)(                                  \
        id, SEL BOOST_PP_COMMA_IF(n)                    \
        BOOST_PP_ENUM_PARAMS(n, T)                      \
    );                                                  \
    objc_callback_##n(SEL sel, id obj)                  \
        : sel_(sel)                                     \
        , obj_(obj)                                     \
        , fun_((func)[obj methodForSelector:sel])       \
    {}                                                  \
    inline R operator ()                                \
    (BOOST_PP_REPEAT_FROM_TO(                           \
        0, n, CALLBACK_operator_params, par))           \
    {                                                   \
        return fun_(obj_, sel_ BOOST_PP_COMMA_IF(n)     \
            BOOST_PP_ENUM_PARAMS(n, par));              \
    }                                                   \
private:                                                \
    SEL sel_;                                           \
    id obj_;                                            \
    func fun_;                                          \
};
{% endhighlight %}

As you may (or not) remember from my [last post]({{ site.url }}/development/c-to-obj-c-callbacks-part-2), 
a **CALLBACK_generator** macro is defined.
Not much changed here. The only difference is that now I use **BOOST_PP_COMMA_IF(n)**
whenever I need a comma which might be missing for non-args callback.
The **BOOST_PP_COMMA_IF(n)** expands to _','_ for _n != 0_ and to empty space for _n == 0_.

Another new feature of Boost.Preprocessor I started using is
**BOOST_PP_REPEAT_FROM_TO(from, to, callback, text)** which works together with our custom
**CALLBACK_operator_params** macro.

As you can see I'm using it as follows:

{% highlight objc++ linenos %}
#define CALLBACK_operator_params(z, n, text) \
    BOOST_PP_COMMA_IF(n) \
    BOOST_PP_CAT(T,n) BOOST_PP_CAT(text,n)

// This call to BOOST_PP_REPEAT_FROM_TO expands
// to (for n == 2) 'T0 par0, T1 par1'
// This means we copy.
// perhaps it should expand to T0& par0..
BOOST_PP_REPEAT_FROM_TO(0, n, CALLBACK_operator_params, par))
{% endhighlight %}

Now when we have our **objc_callback_0** to **objc_callback_9** we can start building
our "convenience wrapper" on top of it:

{% highlight objc++ linenos %}
template<typename Signature> class objc_callback;

#define CALLBACK_generator(z, n, unused)                        \
template<typename R BOOST_PP_COMMA_IF(n)                        \
    BOOST_PP_ENUM_PARAMS(n, typename T)>                        \
class objc_callback<R(                                          \
    BOOST_PP_ENUM_PARAMS(n, T)                                  \
)>                                                              \
    : public objc_callback_##n<R BOOST_PP_COMMA_IF(n)           \
        BOOST_PP_ENUM_PARAMS(n, T)>                             \
{                                                               \
public:                                                         \
    objc_callback(SEL sel, id obj)                              \
        : objc_callback_##n<                                    \
            R BOOST_PP_COMMA_IF(n)                              \
            BOOST_PP_ENUM_PARAMS(n, T)                          \
        >(sel, obj)                                             \
    {                                                           \
    }                                                           \
};

#define BOOST_PP_LOCAL_MACRO(n)   CALLBACK_generator(~, n, ~)
#define BOOST_PP_LOCAL_LIMITS     (0, CALLBACK_arg_max-1)
#include BOOST_PP_LOCAL_ITERATE()
{% endhighlight %}

First of all we forward-declare a template class called **objc_callback**.
The _Signature_ template parameter is used to specify the callback signature
in functional style: **void(int, float)** for example.

Next we define the new **CALLBACK_generator** which generates _partial template specializations_
for each **objc_callback_\_n_**.  
The idea is to generate something like this (for _n == 2_ in this case):

{% highlight objc++ linenos %}
template<typename R, typename T0, typename T1>
class objc_callback<R(T0, T1)>
    : public objc_callback_2<R, T0, T1>
{
public:
    objc_callback(SEL sel, id obj)
        : objc_callback_2<R, T0, T1>(sel, obj)
    {
    }
};
{% endhighlight %}

This is a very minimal wrapper.  
It just creates a specialization for the **R(T0, T1)** signature and delegates
all _dirty work_ to **objc_callback_2**.  
Because the **operator()** call is _inlined_ (I didn't had to specify that explicitly but I did),
the whole callback system does not add runtime overhead.  
That's it :-)

The one-file "library" is opensource and is now available
[on github](https://github.com/godexsoft/objc_callback).

Cheers!
