#!/usr/bin/env -S perl -C63

=pod

The Weekly Challenge #285-1: "No Connection"
Submitted by: Mohammad Sajid Anwar
You are given a list of routes, @routes. Write a script to find
the destination with no further outgoing connection.

Example 1:
Input: @routes = (["B","C"], ["D","B"], ["C","A"])
Output: "A"
"D" -> "B" -> "C" -> "A".
"B" -> "C" -> "A".
"C" -> "A".
"A".

Example 2:
Input: @routes = (["A","Z"])
Output: "Z"

Solution in Perl written by Robbie Hatley on Fri Sep 06, 2024.

=cut

use v5.36;
use utf8;
$"=', ';





