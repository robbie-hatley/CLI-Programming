#! /bin/perl

# This is a 120-character-wide ASCII Perl source-code text file.
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# /rhe/scripts/util/Twelve-Days.pl
# Prints lyrics to song "The Twelve Days Of Christmas".
# Edit history:
#    Sun Dec 23, 2012 - Wrote it. (Date is very-loose approximation.)
#    Sun Apr 17, 2016 - Minor code cleanups (no change to functionality).
########################################################################################################################

use v5.32;
use strict;
use warnings;

our @ordinals = 
(
   "first",    "second",   "third",    "fourth",   
   "fifth",    "sixth",    "seventh",  "eighth",
   "ninth",    "tenth",    "eleventh", "twelfth"
);

our @gifts = 
(
   "a partridge in a pear tree.\n\n",
   "two turtle doves,\nand ",
   "three French hens, ",
   "four calling birds, ",
   "five golden rings,\n",
   "six geese a-laying, ",
   "seven swans a-swimming,\n",
   "eight maids a-milking, ",
   "nine ladies dancing, ",
   "ten lords a leaping,\n",
   "eleven pipers piping, ",
   "twelve drummers drumming, ",
);

for my $day (1..12)
{
   print "On the $ordinals[$day-1] day of Christmas my true love gave to me\n";
   for my $gift (reverse 1..$day) {print($gifts[$gift-1]);}
}

say "Merry Christmas!";
say "Robbie Hatley";
say "Midway City, CA, USA";
say "\154o\156e\167o\154f\100w\145ll\56c\157m";
say "https\x3A\x2F\x2Fwww\x2Efacebook\x2Ecom\x2Frobbie\x2Ehatley";
