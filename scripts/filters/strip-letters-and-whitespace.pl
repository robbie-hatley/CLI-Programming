#!/usr/bin/perl
# strip-letters-and-whitespace.pl
use v5.36;
for (<>)
{
   s/\pL|\s//g; # Get rid of letters & whitespace.
   say;         # Print remainder on its own line.
}
