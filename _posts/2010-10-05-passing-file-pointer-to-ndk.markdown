---
layout: post
status: publish
published: true
title: Passing file pointer to NDK
author:
  display_name: godexsoft
  login: godexsoft
  email: godexsoft@gmail.com
  url: ''
author_login: godexsoft
author_email: godexsoft@gmail.com
wordpress_id: 68
wordpress_url: http://alex.tapmania.org/?p=68
date: '2010-10-05 09:39:32 +0100'
date_gmt: '2010-10-05 09:39:32 +0100'
categories:
- Development
tags:
- Android
- C++
- ndk
comments: []
---
I can't take credits for this as I found this after googling a while.
However, I think this task is a tough one and it's good to have this info in yet another place.

Sometimes it's useful to open the R.raw.* resources in the NDK.  
The resources are actually bundled within your .apk file and you can't access
them on the filesystem as they are not being unpacked or at least you will
never know the location they are unpacked to.  
You can, however, get a file descriptor of the resource and pass that through the JNI to C++.

Java code:

{% highlight java linenos %}
AssetFileDescriptor desc =
   getResources().openRawResourceFd(R.raw.assets);

if (desc != null) {
   FileDescriptor fd = desc.getFileDescriptor();
   long off = desc.getStartOffset();
   long len = desc.getLength();
   PASS_TO_NATIVE(fd, off, len);
}
{% endhighlight %}

NDK code:

{% highlight cpp linenos %}
JNIEXPORT void JNICALL Java_com_yourLib_OpenFile
   (JNIEnv * env, jclass envClass, jstring name,
    jobject fd_sys, jlong off, jlong len)
{
   jclass fdClass = env->FindClass("java/io/FileDescriptor");
   if (fdClass != NULL)
   {
      jfieldID fdClassDescriptorFieldID =
        env->GetFieldID(fdClass, "descriptor", "I");

      if (fdClassDescriptorFieldID != NULL && fd_sys != NULL) {
         jint fd = env->GetIntField(fd_sys, fdClassDescriptorFieldID);

         int myfd = dup(fd);

         FILE* myFile = fdopen(myfd, "rb");
         if (myFile)
         {
            const char * str = env->GetStringUTFChars(name, NULL);

            if (str == NULL) {

               // Oops. Handle error

            }

            USE_FILE_IN_CPP(myFile, len, off);

            env->ReleaseStringUTFChars(name, str);
         }
      }
   }
}
{% endhighlight %}

Cheers.
