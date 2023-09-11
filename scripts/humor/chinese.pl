#!/usr/bin/perl -CSDA

# This is an 78-character-wide UTF-8-encoded Perl source-code text file.
# ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|========

# "chinese.pl"

use v5.32;
use strict;
use warnings;
use warnings FATAL => "utf8";
use utf8;

sub RandomHanzi
{
   return 0x4E00 + int(rand(0x51A6));  # 4E00 through 9FA5
}

my $Rows = 15; $Rows = shift if @ARGV;
my $Cols = 24; $Cols = shift if @ARGV;

for (1..$Rows)
{
   for (1..$Cols)
   {
      print chr RandomHanzi;
   }
   print "\n";
}
