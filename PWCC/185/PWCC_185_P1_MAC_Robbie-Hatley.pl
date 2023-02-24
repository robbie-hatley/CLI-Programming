#! /usr/bin/perl

# PWCC_185_P1_MAC_Robbie-Hatley.pl

=pod

Task 1: MAC Address
Submitted by: Mohammad S Anwar

You are given MAC address in the form i.e. hhhh.hhhh.hhhh.

Write a script to convert the address in the form hh:hh:hh:hh:hh:hh.
Example 1

Input:  1ac2.34f0.b1c2
Output: 1a:c2:34:f0:b1:c2

Example 2

Input:  abc1.20f1.345a
Output: ab:c1:20:f1:34:5a

=cut

use v5.36;
die if 1 != @ARGV;
my $H = qr([0-9a-f]);
die if $ARGV[0] !~ m/^[0-9a-f]{4}\.[0-9a-f]{4}\.[0-9a-f]{4}$/;
$ARGV[0] =~ s/\.//g;
$ARGV[0] =~ s/([0-9a-f])([0-9a-f])(?=[0-9a-f])/$1$2:/g;
say $ARGV[0];
