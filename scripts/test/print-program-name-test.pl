#!/bin/perl
# print-program-name-test.pl
use v5.36;
say [split /\//, $0]->[-1];
say @{[split /\//, $0]}[-1];
say pop @{[split /\//, $0]};
say substr $0,1+rindex $0,'/';
say splice @{[split /\//, $0]}, -1;
say shift @{[reverse split /\//, $0]};
