---
layout: post
status: publish
published: true
title: Handy value holder templates
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 332
wordpress_url: http://alex.tapmania.org/?p=332
date: '2013-04-09 12:47:45 +0100'
date_gmt: '2013-04-09 12:47:45 +0100'
categories:
- Development
tags:
- C++
- boost
- x2d
- boost.random
- templates
comments: []
---
Often in applications we develop we need random values.  
We need random floats, we need random integers, sometimes we even need
random items from a predefined list.

However, we also want the ability to easily swap between random values
and a static value and vice versa.  
But wouldn't it be handy to treat random values and static values in the same way?

In my open source game engine, x2d, I faced this exact problem.  
I wanted to give the game developer the ability to generate a random value of
any type, anytime, anywhere in code as well as thru configuration (separate story).  
The "randomness", however, should be completely hidden from the end user - why would
he need to bother with these low-level details?

The foundation for the randomness is kindly provided by Boost.Random.  
That is because boost is already used in x2d anyways, so why not?  
It should be easy enough to rewrite the template with any other implementation though.

Consider the following code for usage examples:

{% highlight cpp linenos %}
value<int> v100(100);
value<int> vrand(0, 100);
value<float> frand(0.0f, 1.0f);
value<bool> brand;
list_value<std::string> lsv({"foo", "bar", "baz", "last"});
list_value<int> liv({1, 3, 10, 15, 4});

std::cout << "v100 always returns " << v100() << std::endl;

for(int i=0; i<5; ++i)
{
  std::cout << "[pass " << i+1 << "]"
    <<  " vrand returns " << vrand() << std::endl;
}

for(int i=0; i<5; ++i)
{
  std::cout << "[pass " << i+1 << "]"
    <<  " frand returns " << frand() << std::endl;
}

for(int i=0; i<5; ++i)
{
  std::cout << "[pass " << i+1 << "]"
    <<  " brand returns " << std::boolalpha
      << brand() << std::endl;
}

for(int i=0; i<5; ++i)
{
  std::cout << "[pass " << i+1 << "]"
    <<  " lsv returns '" << lsv() << "'\n";
}

for(int i=0; i<5; ++i)
{
  std::cout << "[pass " << i+1 << "]"
    <<  " liv returns '" << liv() << "'\n";
}
{% endhighlight %}

When compiled and executed, this code produces something like:

{% highlight bash %}
v100 always returns 100
[pass 1] vrand returns 6
[pass 2] vrand returns 29
[pass 3] vrand returns 43
[pass 4] vrand returns 6
[pass 5] vrand returns 71
[pass 1] frand returns 0.872364
[pass 2] frand returns 0.43368
[pass 3] frand returns 0.586899
[pass 4] frand returns 0.228958
[pass 5] frand returns 0.284605
[pass 1] brand returns false
[pass 2] brand returns true
[pass 3] brand returns true
[pass 4] brand returns false
[pass 5] brand returns false
[pass 1] lsv returns 'foo'
[pass 2] lsv returns 'baz'
[pass 3] lsv returns 'foo'
[pass 4] lsv returns 'last'
[pass 5] lsv returns 'last'
[pass 1] liv returns '4'
[pass 2] liv returns '15'
[pass 3] liv returns '1'
[pass 4] liv returns '1'
{% endhighlight %}

The implementation:
{% highlight cpp linenos %}
/**
 * Holds a value in range. Will return random values from the range on request.
 * If constructed with one argument will hold that single value and always
 * return it on request.
 */
template<typename T>
class value
{
public:
    /**
     * Constructor from single cached value.
     * @param[in] v Value to store
     */
    value(const T& v = T())
    : value_(v)
    , is_rand_(false)
    {
    }

    /**
     * Constructor from two values. Will produce random value in range.
     * @param[in] from Minimum value to generate
     * @param[in] to Maximum value to generate
     */
    value(const T& from, const T& to)
    : from_(from>to?to:from)
    , to_(from<to?to:from)
    , dist_(from_, to_)
    , is_rand_(true)
    {
        // If random ends up with same value everytime - cache it
        if(to == from)
        {
            is_rand_ = false;
            value_ = to;
        }
    }
    /**
     * Get a value.
     * @return Value of the type specified at template instantiation
     */
    T get() const
    {
        if(is_rand_)
        {
            return dist_(sevenbit::GENERATOR);
        }
        else
        {
            return value_;
        }
    }
    /**
     * Convenience access operator.
     */
    T operator ()() const
    {
        return get();
    }
    T min() const
    {
        if(is_rand_)
        {
            return from_;
        }
        return value_;
    }
    T max() const
    {
        if(is_rand_)
        {
            return to_;
        }
        return value_;
    }
private:
    T value_;
    T from_;
    T to_;
    wrapped_distribution<T> dist_;
    bool is_rand_;
};
{% endhighlight %}

Now this is a basic template, it works for all types
for which wrapped_distribution is defined.  
The wrapped_distribution had to be implemented because of the annoying
difference of int vs real distribution in Boost.Random:

{% highlight cpp linenos %}
// Shared global generator for all randomness
// NOTE: time(NULL) is not cross-platform, should use a wrapper instead
static boost::random::mt19937 GENERATOR = boost::random::mt19937( time(NULL) );

// Wrappers for boost.random to get rid of the annoying difference
// between int and real distributions
template<typename T>
struct wrapped_distribution;

template<>
struct wrapped_distribution<float>
: public boost::random::uniform_real_distribution<float>
{
  wrapped_distribution(const float& min, const float& max)
  : boost::random::uniform_real_distribution<float>(min, max) {}

  wrapped_distribution() {}
};

template<>
struct wrapped_distribution<int>
: public boost::random::uniform_int_distribution<int>
{
    wrapped_distribution(const int& min, const int& max)
    : boost::random::uniform_int_distribution<int>(min, max) {}

    wrapped_distribution() {}
};

// ...
// and so on for all types you want to support. like double, uint16_t and what not.
{% endhighlight %}

Note the static GENERATOR. That is the random generator used by all value<> instances in your app.
Because this is hidden in the library code, the user doesn't have to care about it at all.
Alright. So we have a value template for floats, doubles, ints, longs, etc.
What about boolean? We will need a special implementation for boolean:

{% highlight cpp linenos %}
/**
 * Special version for bool
 */
template<>
class value<bool>
{
public:
    /**
     * Default constructor. Assumes that we want random bool value.
     */
    value()
    : value_(0.0f, 1.0f)
    {
    }

    /**
     * Constructor from single cached value.
     * @param[in] v Value to store
     */
    value(const bool& v)
    : value_(v?1.0f:0.0f)
    {
    }

    /**
     * Constructor from two values. Will produce random value in range.
     * @param[in] from Minimum value to generate
     * @param[in] to Maximum value to generate
     */
    value(const bool& from, const bool& to)
    : value_(from?1.0f:0.0f, to?1.0f:0.0f)
    {
    }

    /**
     * Get a value.
     * @return Boolean value
     */
    bool get() const
    {
        return bool(value_() > 0.5f);
    }

    /**
     * Convenience access operator.
     */
    bool operator ()() const
    {
        return get();
    }
private:
    value<float> value_;
};
{% endhighlight %}

Now we support value<bool>.  
The default constructor just assumes that we actually want random boolean value.
Last thing to implement is the handy list_value<> template.  
Obviously, we will base it on the value template. Because now we can:

{% highlight cpp linenos %}
/**
 * @brief This template provides random selected values from a list.
 *
 * Note: makes a copy of the passed vector.
 */
template<typename T>
class list_value
{
public:
    list_value(const std::vector<T>& lst, int from=0, int to=-1)
    : lst_(lst)
    , rnd_(from, to == -1 ? lst_.size()-1 : to)
    {
        if(to == -1)
        {
            to = lst_.empty() ? 0 : lst_.size()-1;
        }

        if(from < 0 || from > lst_.size()-1)
        {
            throw std::runtime_error(
              "list_value - 'from' value can't be smaller than 0 "
              "or larger than the size of the passed vector.");
        }

        if(to < 0 || to > lst_.size()-1)
        {
            throw std::runtime_error(
              "list_value - 'to' value can't be smaller than 0 "
              "or larger than the size of the passed vector.");
        }
    }

    /**
     * Get a random picked value.
     * @return Value of the type specified at template instantiation
     */
    T get() const
    {
        if(lst_.empty())
        {
            throw std::runtime_error(
              "list_value::get() - get invoked on empty vector."
              " no random value to return.");
        }

        return lst_.at(rnd_());
    }

    /**
     * Get a copy of the whole list.
     * @return A copy of the vector
     */
    std::vector<T> get_list() const
    {
        return lst_;
    }

    /**
     * Convenience access operator.
     */
    T operator ()() const
    {
        return get();
    }
private:
    std::vector<T> lst_;
    value<int> rnd_;
};
{% endhighlight %}

Simple isn't it?  
For a more complete implementation as well as some more handy value-holders  
(cached_value<> and optional_value<>) refer to
[x2d source code](https://github.com/godexsoft/x2d/blob/master/x2d/src/base/value.h).

Cheers.
