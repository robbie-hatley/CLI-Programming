#! /bin/perl

use v5.32;
use strict;
use warnings;

LOOP: {
   state $Variable = 0;
   ++$Variable;
   say $Variable;
   next LOOP if ($Variable >= 10);
   last LOOP;
}
