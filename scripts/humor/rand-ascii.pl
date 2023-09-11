#!/usr/bin/perl

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# /rhe/scripts/util/rand-ascii.pl
# Generates a specified number of rows of a specified number of columns of
# random ASCII text (letters and spaces only). Numbers of rows and columns
# are given by $ARGV[0] and $ARGV[1] respectively.
# Edit history:
#    Sat Jan 10, 2015: Wrote it.
#    Fri Jul 17, 2015: Minor cleanup (comments, etc).
#    Sun Nov 11, 2018: Added numbers and symbols, debugging, and argument
#                      processing.
########################################################################################################################

use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

no warnings 'experimental::smartmatch';

our $db = 0; # 1 for debug, 0 for no-debug.
our $rows = 20;
our $cols = 70;
our @Arguments;
sub process_argv;

# int main (@ARGV)
{
   process_argv;
   my $chars =
   "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
   "abcdefghijklmnopqrstuvwxyz".
   "abcdefghijklmnopqrstuvwxyz".
   "abcdefghijklmnopqrstuvwxyz".
   "012345678901234567890123456789".
   '`~!@#$%^&*()-_=+[{]};:\'",<.>/?|\\'.
   "                          ";
   my $numchars = length($chars);
   say "Number of chars = $numchars" if $db;
   for ( my $i = 0 ; $i < $rows ; ++$i )
   {
      for ( my $j = 0 ; $j < $cols ; ++$j )
      {
         my $nextchar = substr($chars, int(rand($numchars)), 1);
         print("$nextchar");
      }
      print("\n");
   }
   exit 0;
}

sub process_argv
{
   my $s;
   while (defined ($s = shift @ARGV))
   {
      if ('--db' eq $s) {$db = 1;}
      else              {push @Arguments, $s;}
   }
   given (scalar(@Arguments))
   {
      when (0)
      {
         ; # Do nothing.
      }
      when (1)
      {
         $rows = $Arguments[0];
      }
      when (2)
      {
         $rows = $Arguments[0];
         $cols = $Arguments[1];
      }
      when ($_ > 2)
      {
         $rows = $Arguments[0];
         $cols = $Arguments[1];
         say 'Extra arguments.';
      }
      when ($_ < 0)
      {
         say 'We\'re through the looking glass here, people.';
      }
   }
}
