#!/usr/bin/env -S perl -C63

=pod

The Weekly Challenge #011-1: "Fahrenheit Celsius Equal Point"
Task: Find the temperature at which Fahrenheit and Celsius are equal.
Solution in Perl written by Robbie Hatley on Mon Sep 02, 2024.

F = C*(180/100)+32
So, F = C implies:
C*(180/100)+32 = C
C*(180/100 - 1) = -32
C*(9/5 - 5/5) = -32
C*(4/5) = -32
C = -32*(5/4)
C = -40
Hence -40°F = -40°C
The whole thing is thus solved in POD, so there's nothing left
for the actual code of this script to do except print the result.

=cut

use utf8;
print '-40°F = -40°C';
