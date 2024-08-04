#!/usr/bin/env -S perl -CSDA
use v5.36;
use utf8;
for (<>) {
   s/\pL|\s//g; # Get rid of letters & whitespace.
   say;         # Print remainder.
}
