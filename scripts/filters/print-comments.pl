#!/usr/bin/env -S perl -CSDA

# print-comments.pl

use v5.38;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';
use List::Util 'uniq';

say for map {s/^.*?#\s*//r} grep {/#/} map {chomp,$_} <>;
