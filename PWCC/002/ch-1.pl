#!/usr/bin/env perl

# TITLE AND ATTRIBUTION:
# Solutions in Perl for The Weekly Challenge 002-1,
# written by Robbie Hatley on Sat Aug 24, 2024.

# PROBLEM DESCRIPTION:
# Task 002-1:
# Write a script or one-liner to remove leading zeros from positive numbers.

# PROBLEM NOTES:
# s/^0+//g

# IO NOTES:
# Input is via @ARGV. Output is to STDOUT and is each element of @ARGV with
# any leading zeros removed.

use v5.10; $"=", "; my @s = map {$_ =~ s/^0+//gr} @ARGV; say "@s"
