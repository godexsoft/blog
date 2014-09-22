---
layout: post
status: publish
published: true
title: Blood on MacOS X
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 120
wordpress_url: http://alex.tapmania.org/?p=120
date: '2011-01-04 13:27:49 +0000'
date_gmt: '2011-01-04 13:27:49 +0000'
categories:
- Lifestyle
tags:
- MacOSX
- blood
- gaming
- boxer
- DOS
comments:
- id: 42
  author: myltik
  author_email: myltik@gmail.com
  author_url: http://chupakabr.ru
  date: '2011-01-09 13:13:26 +0000'
  date_gmt: '2011-01-09 13:13:26 +0000'
  content: very nice , just installed boxer, looking for some games...
- id: 8022
  author: Towing in Sun Valley
  author_email: kenneth_ring@gmail.com
  author_url: http://towingstudiocity.net/
  date: '2013-06-20 16:38:39 +0100'
  date_gmt: '2013-06-20 16:38:39 +0100'
  content: "Thanks for sharing your thoughts on compensation insurance.\r\nRegards"
- id: 9423
  author: Carmen
  author_email: carmenantonieff@care2.com
  author_url: http://www.themotorettes.com/forum/profile.php?mode=viewprofile&amp;u=528743
  date: '2013-10-11 18:31:34 +0100'
  date_gmt: '2013-10-11 18:31:34 +0100'
  content: "Tech companies including Apple regularly ignore propellerheads for instance
    myself for your incredibly $imple rea$on of funds: \r\nEven though vocal, we're
    just not that big of the industry, and stuff that makes us satisfied \r\nisn't
    going to necessarily translate to \r\nmass sales. For that reason, these of us
    who wanted to upgrade and use it on, say, T-Mobile, are acceptable \r\ncollateral
    damage. I do suspect that they've \r\nunderestimated how peevish persons are gonna
    be in the poor previous activation hassle,\r\nalthough. Fingers crossed for your
    resumption \r\nof sanity, mainly because there's one particular factor that I'm
    totally certain of: The iPhone 3G will \r\nget hacked anyway. Persons like this
    may make it take place, so \r\nwhy play King Canute?"
- id: 9462
  author: Dyan
  author_email: dyanjulia@inbox.com
  author_url: http://www.gentebmw.com/profile.php?mode=viewprofile&amp;u=83040
  date: '2013-10-15 16:36:51 +0100'
  date_gmt: '2013-10-15 16:36:51 +0100'
  content: "Dear sir i would like to make 1 10leds and one more 16 leds of 8mm,\r\n0.5
    watts 100ma leds what exactly are the adjustments \r\nis requir, please enable
    me."
- id: 10460
  author: Marissa
  author_email: marissasessums@bigstring.com
  author_url: http://brownoykz.kazeo.com/florida-nursing-student-uses-msn-training-to-create-veteran-s-patient-education-programs,a4051762.html
  date: '2014-03-09 07:29:17 +0000'
  date_gmt: '2014-03-09 07:29:17 +0000'
  content: "It's enormous that you are getting thoughts from this piece of writing
    \r\nas well as from our dialogue made here."
- id: 11481
  author: herbal wash
  author_email: emanueldolling@gmail.com
  author_url: http://wikipedia.com
  date: '2014-06-29 06:02:48 +0100'
  date_gmt: '2014-06-29 06:02:48 +0100'
  content: "Hi! Do youu know if they make any plugins to safeguard against hackers?\r\n\r\nI'm
    kinda paranoid about losing everything I've worked \r\nhard on. Any suggestions?\r\n\r\nLook
    at my blog ... <a href=\"http://wikipedia.com\" rel=\"nofollow\">herbal
    wash</a>"
---
Happy New Year folks!

Hope you are enjoying your holidays just like I do enjoy them :-)
For a long time now I was wondering whether it was possible to play one of my favorite FPS games - Blood by Monolith productions (1997) on my MacBookPro without installing Windows via Bootcamp or Parallels..

I decided to make this small post to help others who might want to run that excellent title on their Mac.
You will need:
- Original Blood CD or an ISO dump of that
- Boxer 0.87
- nrg2iso for MacOS X - only if you download Blood's CD dump as NRG archive (Nero format)
First of all do yourself a favor and install <a href="http://boxerapp.com/download/0.87">Boxer</a>. Boxer is a Mac-style wrapper on top of DOSBox which is a great and lightweight DOS emulator for *NIX.
Now lets assume that you don't have the original CD and you downloaded a torrent containing Blood_(ISO)-39.rar which in turn extracts to Blood121.nrg or similar. What you need in this case is the great <a href="http://download.cnet.com/nrg2iso/3000-2248_4-76952.html">nrg2iso</a> software.
Now just start nrg2iso.app and browse to your Blood.nrg file.. set an output folder and let it convert (hit Extract). You should end up with a Blood121.ISO file in the specified output folder.
Next step is to install Blood on your DOSBox installation.

First thing to do is to mount the Blood.ISO file by double clicking it. You will see a new mountpoint on your Desktop. It should be called Blood121 or similar.

Open the DOS Games folder created by Boxer in your home directory. There is a "Drop games here to install them" item there. Just drag and drop Blood's INSTALL.exe file which can be found inside the Blood121 mountpoint into that item and Boxer will do the magic.
If all goes well you will get a DOS prompt with the installation of Blood. From here you need to complete the installation and later run SETUP to configure your sound card etc. For sound/music card select Sound blaster and put maximum values for everything. Don't forget to set the highest possible resolution - 800x600.
When all is done you will just need to type BLOOD in the command prompt to run Blood.
Happy gaming!

Cheers.
