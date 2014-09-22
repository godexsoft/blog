#!/bin/perl

while(<>) {
  $_ =~ s/&#47;/\//g;
  $_ =~ s/<br \/>/\n/g;
  $_ =~ s/<\/p>//g;
  $_ =~ s/<p>//g;
  $_ =~ s/<\/p>//g;

  $_ =~ s/<pre lang="(.+)" class="1">/\n{% highlight $1 linenos %}/g;
  $_ =~ s/<pre lang="(.+)">/\n{% highlight $1 linenos %}/g;
  $_ =~ s/<pre>/\n{% highlight cpp linenos %}/g;

  $_ =~ s/<\/pre>/{% endhighlight %}\n/g;

  $_ =~ s/<strong>/**/g;
  $_ =~ s/<\/strong>/**/g;

  $_ =~ s/<em>/_/g;
  $_ =~ s/<\/em>/_/g;

  $_ =~ s/<ul>//g;
  $_ =~ s/<\/ul>//g;
  $_ =~ s/<li>/- /g;
  $_ =~ s/<\/li>//g;

  print;
}
