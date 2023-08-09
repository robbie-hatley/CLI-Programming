#! /usr/bin/perl

###############################################################################
# /rhe/Euler/Euler-031_English-Coin-Sums.perl                                 #
# Counts ways of making 200 pence using English coins.                        #
# Author: Robbie Hatley                                                       #
# Edit history:                                                               #
#    Mon Jan 15, 2018: Wrote it.                                              #
###############################################################################

=pod

===============================================================================
Problem Statement:

Project Euler, Problem 31: English Coin Sums

In England the currency is made up of pound, £, and pence, p, 
and there are eight coins in general circulation:

    1p, 2p, 5p, 10p, 20p, 50p, £1 (100p) and £2 (200p).

It is possible to make £2 in the following way:

    1×£1 + 1×50p + 2×20p + 1×5p + 1×2p + 3×1p

How many different ways can £2 be made using any number of coins?

===============================================================================
Problem Analysis:

Perhaps start with the largest denomination and work down, filling the gaps?
7 levels of for() loops with number of p1 equal to deficit at the center?

===============================================================================
Problem Solution:

=cut

use 5.026_001;
use strict;
use warnings;
my $p200;
my $p100;
my $p050;
my $p020;
my $p010;
my $p005;
my $p002;
my $p001;
my $l100='int((200-$p200*200)/100)';
my $l050='int((200-$p200*200-$p100*100)/50)';
my $l020='int((200-$p200*200-$p100*100-$p050*50)/20)';
my $l010='int((200-$p200*200-$p100*100-$p050*50-$p020*20)/10)';
my $l005='int((200-$p200*200-$p100*100-$p050*50-$p020*20-$p010*10)/5)';
my $l002='int((200-$p200*200-$p100*100-$p050*50-$p020*20-$p010*10-$p005*5)/2)';
my $ways;
for ( $p200 = 0 ; $p200 <= 1          ; ++$p200 ) {
for ( $p100 = 0 ; $p100 <= eval $l100 ; ++$p100 ) {
for ( $p050 = 0 ; $p050 <= eval $l050 ; ++$p050 ) {
for ( $p020 = 0 ; $p020 <= eval $l020 ; ++$p020 ) {
for ( $p010 = 0 ; $p010 <= eval $l010 ; ++$p010 ) {
for ( $p005 = 0 ; $p005 <= eval $l005 ; ++$p005 ) {
for ( $p002 = 0 ; $p002 <= eval $l002 ; ++$p002 ) {
++$ways; # Only 1 way to fill in the gap with 0-200 pennies.
}}}}}}}
say "Number of ways = $ways";
