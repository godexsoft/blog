---
layout: post
status: publish
published: true
title: Persistent timers on iOS
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 288
wordpress_url: http://alex.tapmania.org/?p=288
date: '2012-04-16 11:18:16 +0100'
date_gmt: '2012-04-16 11:18:16 +0100'
categories:
- Development
tags:
- C++
- boost
- iOS
- persistence
- asio
---
Today I want to share another knowhow.
This time I had __boost::asio__ timers in my iOS application but as we all know
the application can be killed by the OS at any time or it can crash due to a bug
in our code. Usually it's not a big deal as you can setup your timers at startup
and probably nothing bad will happen if some timer wont fire once..
however in some cases you want to guarantee that your timer will fire no matter what.

Perhaps it will fire with a delay or at application launch one day later than
you expected but at least you can guarantee that once it was scheduled it will
definitely fire at some point even if your app crashed or was killed by the OS or user.

Originally we have a deadline timer from __boost::asio__:

{% highlight cpp linenos %}
boost::asio::deadline_timer my_fancy_timer_;

// setup timer with runloop (io_service) in c-tor
app(boost::asio::io_service& io)
: my_fancy_timer_(io)
{
}

// ...
// somewhere later - schedule the timer
my_fancy_timer_.expires_from_now(
  boost::posix_time::seconds( 25 ) );

my_fancy_timer_.async_wait(
  boost::bind(&app::handle_timer, this, _1) );
{% endhighlight %}

This code is great but it wont automatically resume/reschedule your timer if
your app restarts. Instead it will just put it on the io_service and that's all.

One possible solution is to implement a wrapper on top of __boost::asio::deadline_timer__:

{% highlight cpp linenos %}
//
// header
//
class timer
{
public:
  typedef
    boost::function<void(const boost::system::error_code&)>
      handler_type;

  timer(boost::asio::io_service& io_service,
        const std::string& name,
        const handler_type& handler);
  ~timer() {}

  void cancel();
  void schedule(const uint64_t& ts);
  uint64_t firetime() const;

private:
    void process(const boost::system::error_code& e);

    boost::asio::io_service&    io_service_;
    const std::string           storage_;
    handler_type                handler_;
    boost::asio::deadline_timer timer_;
};

//
// in cpp file:
//
timer::timer(boost::asio::io_service& io_service,
             const std::string& name,
             const handler_type& handler)
: io_service_(io_service)
, storage_("timer_" + name)
, handler_(handler)
, timer_(io_service_)
{
  uint64_t ts = firetime();

  if( ts != 0 )
  {
    boost::posix_time::ptime t =
      boost::posix_time::from_time_t(ts);
    timer_.expires_at( t );
    timer_.async_wait(boost::bind(&timer::process, this, _1));
  }
}

void timer::cancel()
{
  platform::save_value<uint64_t>(storage_, 0);
  timer_.cancel(); // will notify that the timer was aborted
}

void timer::schedule(const uint64_t& ts)
{
  platform::save_value<uint64_t>(storage_, ts);
  boost::posix_time::ptime t =
    boost::posix_time::from_time_t(ts);
  timer_.expires_at( t );
  timer_.async_wait(boost::bind(&timer::process, this, _1));
}

uint64_t timer::firetime() const
{
  return platform::get_value<uint64_t>(storage_, 0);
}

void timer::process(const boost::system::error_code& e)
{
  platform::save_value<uint64_t>(storage_, 0); // clear
  handler_( e );
}
{% endhighlight %}

Usage is pretty straight-forward.  
The first snippet becomes:

{% highlight cpp linenos %}
timer my_fancy_timer_;

// setup timer with runloop (io_service) in c-tor
app(boost::asio::io_service& io)
: my_fancy_timer_(io, "fancy",
  boost::bind(&app::handle_timer, this, _1))
{
}

// ...
// somewhere later - cancel or schedule the timer
// note that time is given in milliseconds
my_fancy_timer_.cancel();
my_fancy_timer_.schedule(
  platform::current_time() + 25*1000 );
{% endhighlight %}

Don't worry about the __platform__ functions - I will add the code for them below.
The interesting part is that the callback is moved to the constructor.
That is because now the timer could be scheduled before construction as it's a persistent timer, remember?

Each timer now has a name too.
that's how we know if it was scheduled and what the fire-time is from the persistent store.  
The persistent store can be anything you like but on the iOS it makes sense
to use the __NSUserDefaults__ for that:

{% highlight objc++ linenos %}
// platform header:
namespace platform
{
  const uint64_t current_time();

  template<typename R>
  void save_value(const std::string& key, const R& value);

  template<typename R>
  R get_value(const std::string& key, const R& def=R());
}

// impl:
namespace platform
{
  const uint64_t current_time()
  {
    return static_cast<uint64_t>(std::time(0));
  }

  template<>
  void save_value(const std::string& key, const uint64_t& value)
  {
    [[NSUserDefaults standardUserDefaults]
      setObject:[NSNumber numberWithUnsignedLongLong:value]
         forKey:[NSString stringWithUTF8String:key.c_str()]];
  }

  template<>
  uint64_t get_value(const std::string& key, const uint64_t& def)
  {
    NSNumber* v = (NSNumber*)[[NSUserDefaults standardUserDefaults]
      objectForKey:[NSString stringWithUTF8String:key.c_str()]];

    if(v == nil)
    {
      return def;
    }

    return [v unsignedLongLongValue];
  }
}
{% endhighlight %}

Cheers.
