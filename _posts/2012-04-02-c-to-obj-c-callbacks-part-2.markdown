---
layout: post
status: publish
published: true
title: C++ to Obj-C callbacks. Part 2
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 251
wordpress_url: http://alex.tapmania.org/?p=251
date: '2012-04-02 22:21:29 +0100'
date_gmt: '2012-04-02 22:21:29 +0100'
categories:
- Development
tags:
- C++
- boost
- Obj-C
- metaprogramming
- preprocessor
---
Do you remember my post on [c++ to obj-c callbacks]({{ site.url }}/development/c-to-objective-c-callbacks/)?  
Recently I realized that the pattern for every callback is pretty much repeating
and I could employ the preprocessor to generate code instead of writing it myself.  
Because we are already using boost for **boost::function** I decided to look if
any useful libraries for preprocessing are available from boost and, of course,
found the **[Boost.Preprocessor](http://www.boost.org/doc/libs/1_49_0/libs/preprocessor/doc/index.html)** library.  
There are a couple of things we need to solve in order to generate the template code:

- Define the maximum argument count for our callback
- Write a 'template' for generation
- Generate some code :)

The first objective is easy:

{% highlight cpp linenos %}
#ifndef CALLBACK_arg_max
#define CALLBACK_arg_max 10
#endif
{% endhighlight %}

The second is the most interesting part. Here is the code. Explanation follows:

{% highlight cpp linenos %}
#define CALLBACK_generator(z, n, unused)                \
template <BOOST_PP_ENUM_PARAMS(n, typename T)>          \
static                                                  \
boost::function<void(                                   \
    BOOST_PP_ENUM_PARAMS(n, T)                          \
)>                                                      \
objc_callback_##n(SEL sel, id obj)                      \
{                                                       \
    typedef void (*func)(                               \
        id, SEL,                                        \
        BOOST_PP_ENUM_PARAMS(n, T)                      \
    );                                                  \
    func impl = (func)[obj methodForSelector:sel];      \
    return boost::bind(impl, obj, sel,                  \
        BOOST_PP_ENUM_SHIFTED_PARAMS(BOOST_PP_INC(n), _)\
    );                                                  \
}
{% endhighlight %}

So what is happening here? We define a **macro** called **CALLBACK_generator**.  
We will use this macro as a template for code generation.

The following parameters are defined for this macro:

1. z - Not used
2. n - Argument count
3. unused - Not used

The **BOOST_PP_ENUM_PARAMS(n, typename T)** and **BOOST_PP_ENUM_PARAMS(n, T)** calls
both generate a list of textual values separated by a comma.  
The text found in second argument (in my case 'typename T' and 'T') is glued with the number found
in the first argument (in both cases it's the current value of _n_).  
For _n = 3_ it expands to _'typename T0, typename T1, typename T2'_ and _'T0, T1, T2'_ respectively.  
**objc_callback\_\#\#n** generates a name for our callback function. **\#\#n** basically means
'glue the current value of _n_ to the text in front'.
The result for _n = 3_ will therefore be *objc_callback_3*.
**BOOST_PP_ENUM_SHIFTED_PARAMS(n, \_)** is the same as **BOOST_PP_ENUM_PARAMS(n, \_)** but shifted.  
So instead of *'_0, _1, _2'* it expands to *'_1, _2'*. However this is not exactly what we want.
We need to get *'_1, _2, _3'* for _n = 3_.  
Fortunately this can be easily solved by adding **BOOST_PP_INC(n)** which just increments
_n_ before passing it to **BOOST_PP_ENUM_SHIFTED_PARAMS**.

The rest is pretty straightforward.  
Now the last bit. We have to generate some code using our 'template':

{% highlight cpp linenos %}
#define BOOST_PP_LOCAL_MACRO(n)   CALLBACK_generator(~, n, ~)
#define BOOST_PP_LOCAL_LIMITS     (1, CALLBACK_arg_max)

#include BOOST_PP_LOCAL_ITERATE()
#undef CALLBACK_generator
#undef CALLBACK_arg_max
{% endhighlight %}

Here we employ the **BOOST_PP_LOCAL_ITERATE** inclusion-macro which is configured
using the two definitions above the _#include_ statement.

The first configuration line defines the local generator macro which in our case
just passes control to the **CALLBACK_generator**.  
The second line defines the limits. We tell **BOOST_PP_LOCAL_ITERATE** to iterate
from 1 to 10 and invoke the **CALLBACK_generator** on each value.  
Why _'~'_ is used for the _unused_ arguments to **CALLBACK_generator** is left
for you to find out in the docs ;)

The last thing to do is to get rid of the local macros we defined for the generation.  
We have to _#undef_ them to make sure they don't interfere with other code we might
include the callback header into.

In **Part 3** I will (some day) describe how to generate callbacks with a more pleasant syntax:

{% highlight objc linenos %}
auto cb = objc_callback<void(int, float)>
  (@selector(myCallbackWithInt:andFloat:), self);
{% endhighlight %}

Cheers!
