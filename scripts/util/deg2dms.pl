#! /bin/perl

# deg2dms.pl

use v5.36;
use strict;
use warnings;

my $deg_dec = $ARGV[0];
my $deg_int = int $deg_dec;
my $deg_frc = $deg_dec - $deg_int;

my $min_dec = 60 * $deg_frc;
my $min_int = int $min_dec;
my $min_frc = $min_dec - $min_int;

my $sec_dec = 60 * $min_frc;
my $sec_int = int $sec_dec;
my $sec_frc = $sec_dec - $sec_int;

# We could continue this as far as we want:
# 1 minute  = 1/60 degree
# 1 second  = 1/60 minute
# 1 argblu  = 1/60 second
# 1 senska  = 1/60 argblu
# Etc, etc, etc. Sexagesimal is fun! :-)

say(qq($deg_int° $min_int' $sec_int"));
