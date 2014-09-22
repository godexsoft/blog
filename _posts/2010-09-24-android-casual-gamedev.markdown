---
layout: post
status: publish
published: true
title: Android casual gamedev
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 36
wordpress_url: http://alex.tapmania.org/?p=36
date: '2010-09-24 10:19:26 +0100'
date_gmt: '2010-09-24 10:19:26 +0100'
categories:
- Development
tags:
- Android
- java
- gamedev
comments: []
---
I spent a little more than 3 days to write a simple Bubbles game for the Android
and this post should describe the steps I had to take and things I had to deal
with to complete this dumb game and publish it on the Android Market.

**Objective**

First of all.. why am I doing this anyway? The answer is simple - to get a free Nexus One.
I'm not going to explain how it's corelated with development of a simple puzzler.

**Decide to use Java**

I could try to use C++ and OpenGL but I thought I would never complete the game in 3 days.
The easier way is to just take Java and try to get up and running ASAP.

**LunarLander sample project**

The obvious place to start was the Samples directory bundled with the SDK.
Looking thru the samples I found the LunarLander example which I thought was doing a lot
of the "engine" part already so I took it as a base for my game.

**Strip the sample code**

The LunarLander code is small and very good documented through javadoc comments.
Basically, there are two files and that's it. Throw away everything useless as I'm only interested
in the "engine" part of the project. All the Lunar landing logic is thrown away and
a small and minimal engine is left over.

**Create some graphics**

The best place to look for graphics is google images :-)  
Google is awesome! Just as I thought - I found a great looking shiny ball in PSD
format in no time.  
[Here](http://www.psdgraphics.com/) is a link to the great site I found the ball psd on.

However, you can't expect to find all the graphics you might need anyway..
so the next obvious thing is opening photoshop and just doing the rest yourself.

**Write the code**

There are a couple of different components to code for this game:

#####Physics/Maths#####

I would like to thank Gleb Lutskov for helping me out with some of the hardest
calculations in this game.  
I'm not any good in maths of any level so I would really get stuck without his help.
The physics part was easy - we need to determine the direction of the ball
depending on the area we touch on the screen.
we need to calculate the vector of movement. we need to bounce off walls.
All that is pretty simple.

The calculation of the bubble-bubble collision is somewhat harder.
I will cover that in the next section.

#####Collision detection#####

So we know there is a collision.
We know that because every bubble has a center point (position on the screen)
and a radius for the bounding circle.
The radius is a bit smaller than the bubble self (the image) because we want
the bubble to fit through gaps between other bubbles, right?

So there is collision. The collision is never perfect - we never detect collision
when it really happens (when one edge hits another edge).  
Most of the times you will see that the collision is detected when the bubble
is halfway thru the other bubble :-)  
The first thing to do is to travel back in time to the location when the collision
just happend. This is done by jumping back by -N\*delta where N is the unit
vector of the bubble's traveling direction and 'delta' is the offset given by
bounding_circle.radius\*2-(bubble1.position-bubble2.position).

Now when we are on the right place we need to find the location where we hit.
We need to know that because we can only stick to 6 places - left, right, up-left,
up-right, bottom-left and bottom-right from the bubble we hit.
To calculate the zone the flying bubble hit we will need to use the atan2()
function and feed the x and y offsets to that function.  
The result is the angle in radians and if we shift it like this:

{% highlight cpp linenos %}
(radToDeg(angle) + 180.0f)%360.0f;
{% endhighlight %}

  we will be able to determine the zone of the hit in a pleasant way:

{% highlight cpp linenos %}
if(angle >= 180.0f && angle < 240.0f) {

   // Left-bottom

}  else if(angle >= 240.0f && angle < 300.0f) {

   // Left

}

// ...
{% endhighlight %}

#####Logic#####

  This is a lot easier than the rest. No real problems met underway.

**Add some animation!**

Most of the code is written.. Most of the logic is working..
but the bubbles just disappear when they hit a group.
That looks unnatural and unpleasant. Good time to remember about animation!

I thought that the easiest way to animate disappearing bubbles could be achieved
by maintaining a simple list of Animation objects.  
Every animation object just needs to know the position of the bubble it's animating,
the color of that bubble and current animation parameters such as the alpha and the size of the bubble.

Provided this simple system we now can create Animation objects for the disappearing
bubbles and push them into the list. The Animation object must implement
the update(delta) method and set a finished flag to true once the animation is completed.  
The engine then checks for completed animations and just remove the corresponding
Animation objects off the list. Simple.

**What about sound?**

When I had the game almost ready it just came to me.  
I completely forgot about sound effects - a very important thing for every game.

Again, the best place to look for free sounds is google.  
Well, actually the first place I jumped on is my Tapmania game which has some good sounds.
One sound from Tapmania seems to fit very well so I used it. For the other
two sounds - a bit of googling. Audacity. Tadaaa - Solved.

**Integrate the sounds**

That was very easy.  
Just read the docs [here](http://developer.android.com/guide/topics/media/index.html)
and did what they told me to do. Only one simple obstacle underway - .caf file
format is not supported so had to convert to .mp3 (Duuuh. of course Apple's format wont work).

**Create a developer profile and become a publisher**

Now when everything is ready and all my colleagues are beta-testing the game on
their Android phones it's time to publish the game.  
However, you will need a developer profile and a "license" to publish to the Android Market.
It will cost you US $25 to get one. Btw, note how $25 is less than Apple's $99.

Anyway, spent a couple of hours to get the budget for that in my company and purchase the license.

**Integrate flurry**

One thing I forgot about is - I want to collect some interesting stats about the market.
I want to know which devices and which firmwares are popular atm.
I want to know which countries play my game and which countries don't.  
All that is easy to achieve. Go to [flurry.com](http://flurry.com) and grab
the latest SDK for android. Integration takes like 5 minutes.
The only thing you really will NEED to remember is that to get it working you
MUST put this line into your AndroidManifest.xml:

{% highlight xml linenos %}
<uses-permission android:name="android.permission.INTERNET" />
{% endhighlight %}

**Publish to the market**

Publishing to the Android market is a piece of cake. It's nothing compared to Apple's upload process.  
I have completely filled the fields, uploaded the .apk and even created/edited/uploaded
the screenshots in less than 30 minutes.  
You really need to read [this](http://developer.android.com/guide/publishing/app-signing.html)
to know how to sign your application.  
Signing is a required step so you wont be able to skip it anyway.  
One thing worth mentioning is that you MUST specify the minimum SDK requirement
in your AndroidManifest.xml:

{% highlight xml linenos %}
<uses-sdk android:minSdkVersion="1" />
{% endhighlight %}

There is no approval or anything like that so once you hit "publish" it's UP and
users can start playing your game! Isn't this wonderful? :-)

**Results**

I think that this experience is very good to have because now I know much more
about the Java side of Android development and I see how to proceed with the C++
game engine I'm also working on.  
I have also learnt to publish apps to the market and to integrate Flurry into android applications.
The time is very well spent.

Cheers.
