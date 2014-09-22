---
layout: post
status: publish
published: true
title: WebOS supported
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 88
wordpress_url: http://alex.tapmania.org/?p=88
date: '2010-10-06 15:30:12 +0100'
date_gmt: '2010-10-06 15:30:12 +0100'
categories:
- Development
tags:
- C++
- PDK
- WebOS
- Chupengine
comments: []
---
Took me one day to make WebOS hit the supported platforms list of Chupengine.

The PDK (WebOS's analogue to Androids' NDK) is nice. It has exceptions, RTTI and STL out of the box. It's a pleasure to work with. Really.

However, I was disappointed to know that the simulator is not able to run PDK code yet. There is no OpenGL support in the simulator they said.. Currently, we must build targeting our host architecture to run as a native app on the host platform (MacOSX in my case).
Cheers.
