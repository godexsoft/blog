---
layout: post
status: publish
published: true
title: Checking whether a configuration profile is installed on iOS
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 162
wordpress_url: http://alex.tapmania.org/?p=162
date: '2011-09-07 17:32:46 +0100'
date_gmt: '2011-09-07 17:32:46 +0100'
categories:
- Development
tags:
- MacOSX
- Xcode
- iOS
- SSL
- Obj-C
---
Configuration profiles are XML (plist) files which control the iOS device's settings in one or another way.

Imagine that some iOS project depends on a configuration profile.
Moreover it's a requirement that the application wont allow certain actions unless
the device has the correct configuration profile installed.

Now to the fun part. There is no official API to check whether a profile is installed
or not ( :) ).. however, there is a very clever workaround which I found somewhere
on the internet and I'm glad to share.

The idea is to create a CA Root certificate and a second certificate which will
be signed by that CA Root. In order to verify and validate the second certificate
one would need to install the Root certificate into the system.  
We can bundle Certificates with our configuration profile and they will get installed
on the iOS device so that's how we get the CA Root certificate on board.

The second part is a bit trickier and requires some programming effort.
First of all, bundle the second certificate with your application --- drag&drop
to Resources folder in Xcode.
And now you can use the following code to validate the target certificate and
thus know whether your configuration profile is already installed or not:

{% highlight objc linenos %}
NSString * certPath = [[NSBundle mainBundle]
  pathForResource:@"target" ofType:@"cer"];

NSData * certData = [NSData dataWithContentsOfFile:certPath];

SecCertificateRef cert = SecCertificateCreateWithData(
  NULL, (CFDataRef) certData);

SecPolicyRef policy = SecPolicyCreateBasicX509();

OSStatus err = SecTrustCreateWithCertificates(
  (CFArrayRef) [NSArray arrayWithObject:(id)cert],
    policy, &trust);

SecTrustRef trust;
SecTrustResultType  trustResult = -1;

err = SecTrustEvaluate(trust, &trustResult);

CFRelease(trust);
CFRelease(policy);
CFRelease(cert);

if(trustResult == 4)
{
  // Profile is installed
}
else
{
  // Profile not installed
}
{% endhighlight %}

Cheers.
