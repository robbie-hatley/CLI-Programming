#! /bin/perl
# "random-wiki.pl"
use v5.20;

my @lines = ();
my $numlines = 0;
my $outline = 0;
my $filenum = 1;

while (<>)
{
   s|wiki\?|http\://www.c2.com/cgi/wiki\?|;
   $numlines = push @lines, $_;
}

while ($numlines>0)
{
   if (($outline%500)==0)
   {
      if ($filenum>1)
      {
         close OUT;
      }
      open OUT, ">wiki$filenum.htm";
      $filenum++;
   }
   if (($outline%100)==0)
   {
      print OUT "<HR>\n";
   }
   if (($outline%20)==0)
   {
      print OUT "\n\n$outline\n\n";
   }
   print OUT scalar(splice(@lines,(rand $numlines), 1));
   $outline++;
   $numlines--;
}

close OUT;
