#!/usr/bin/env perl

=pod

The Weekly Challenge 006-2, "Ramanujan’s constant".
Solution in Perl written by Robbie Hatley on Fri Aug 30, 2024.

=cut

use v5.16; # To get "say".
use bignum 'a'=>50, 'lib'=>'GMP', 'bexp', 'bpi';
say substr bexp(bpi(50)*sqrt(163), 50), 0, 40;
