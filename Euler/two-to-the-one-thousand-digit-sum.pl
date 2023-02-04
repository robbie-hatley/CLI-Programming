#!/usr/bin/perl

# This is an 78-character-wide ASCII-encoded Perl source-code text file.
# =======|=========|=========|=========|=========|=========|=========|========

##############################################################################
# /rhe/scripts/math/two-to-the-one-thousand-digit-sum.perl                   #
# Calculates the sum of the decimal digits of 2**1000.                       #
# Author: Robbie Hatley.                                                     #
# Edit history:                                                              #
#    Fri Feb 19, 2016 - Wrote it.                                            #
##############################################################################

use v5.022;
use strict;
use warnings;
use bigint;

my $string = 2**1000;
my @array = split //, $string;
my $sum = 0;
$sum += $_ for @array;
say $sum;
