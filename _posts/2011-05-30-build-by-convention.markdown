---
layout: post
status: publish
published: true
title: Build by convention
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 142
wordpress_url: http://alex.tapmania.org/?p=142
date: '2011-05-30 22:15:35 +0100'
date_gmt: '2011-05-30 22:15:35 +0100'
categories:
- Development
tags:
- C++
- build
- boost
- just-build
comments: []
---
Building software from source --- not a simple task, even for a developer.  
Sometimes it takes hours to figure out what is missing and/or how to build a particular project.  
A good example are boost libraries --- they are easy for the bigger part when they work
as templates and you can simply include the code into your own.. however, when you need
anything what requires building and linking a boost library.. whoooa.. things go
crazy complicated on some systems.

Me and Greg Buteyko were thinking how wonderful it would be if you could just type "build"
and a complicated project (such as boost) would be built for your current system without having
to configure, specify library paths, dependencies and all that crap.  
Also, from a developer's point of view it would be much easier if you wont have to
write dozens of auxiliary files in order to "explain" a build system how to build your code.  
This post is my attempt to write down some thoughts on build systems and put some open
questions in hope that you might have a bright idea on solving them.  
What's wrong with traditional build systems (automake is a good example):

- I don't want to write Makefiles. No. Please.
- I don't want to specify dependencies (libraries, files) in separate files.
- I don't really like to run more than one command in order to build a project even though that's not hard to remember.

Solving these issues:

- Have a build system understand that any filesystem directory with the prefix "lib_" is a library. So anything inside "lib_foo" should be built into libfoo.a and libfoo.so respectively.
- Same with applications - anything with the prefix "app_" will be built as executables.
- Specify "local" library dependencies either by putting the corresponding "lib_" directory <b>inside</b> the app folder or by putting a symlink to that instead.
- Specify system library dependencies directly in code. Just like you can do with Microsoft's visual studio.

{% highlight cpp linenos %}
#pragma comment(lib, "libfoo")
{% endhighlight %}

but do this in a better way:

{% highlight cpp linenos %}
#pragma comment(lib, "libfoo >=1.0")
#pragma comment(lib, "libbar 1.1.0, 1.1.1")
#pragma comment(lib, "libbaz >1.0, <1.2")

// Set (#define) OMG_ITS_FOUND to 1 if dependency is met
#pragma comment(lib, "libMyMissingLib >1.0", "OMG_ITS_FOUND")
{% endhighlight %}

- Put resources to be bundled within the root of your application into "resources" folder
- Have the build system to know where to look for the system libraries you specified and how to check their version numbers (oops.)

Tweaking can be done by keywords. Keywords are written right after the build command and should be self-speaking:

{% highlight bash %}
# give the build system a hint
just-build gcc linux 64
{% endhighlight %}

Building only static libraries and all in debug mode? That would be as simple as adding command line arguments to the build command:

{% highlight bash %}
just-build debug static
{% endhighlight %}

Of course, sometimes, you would want to have a way to build using custom flags, with/without some components or even use a custom toolchain (android ndk anyone?):

{% highlight bash %}
just-build toolchain=/path/to/toolchain debug static
{% endhighlight %}

However, this kind of "tweaking" is already available with, say, Boost.Build.
Open questions

- How do I have the build system to know about all installed libraries and their versions?
- Would it be better to provide an interactive mode so that the user could answer simple questions like:

{% highlight bash %}
Component XXX will not be built due to missing library libiconv.
Do you want to build without this feature?: Yes/No
{% endhighlight %}

Conclusion
Would programming get easier?
No. However, building should be easier than it is. Writing dozens of files is just not the way I want to spend my time. Of course, IDEs make it easier nowadays but again, projects like boost are not intended to be built by IDEs.. almost 100% of opensource software comes without IDE project files and even if it does, chances are you don't want to install yet another IDE to build the project the easy way.
