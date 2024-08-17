#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# distribution.pl
# Dumps a set of numbers into 100 equal-subinterval bins, with the 100 bins spanning the interval from min to max,
# then prints how many of the numbers ended up in each bin. Numbers must be in a file (or piped or redirected) with one
# number per line.
# Edit history:
#    Tue Nov 09, 2021:
#       Refreshed colophon, title card, and boilerplate.
#       Also fixed some bugs. Now ignores garbage (non-number) lines, and now works even if some bins are empty.
########################################################################################################################

use v5.32;
use utf8;
use Sys::Binmode;
use experimental 'switch';
use strict;
use warnings;
use warnings FATAL => "utf8";

use Scalar::Util qw(looks_like_number);

my $db = 0;

# Pre-declare all variables we'll be using:
my @bins    = ();
my $idx     = 0;
my $min     = 0;
my $max     = 0;
my $range   = 0;
my $x       = 0;

# Get numbers from <>, sans space:
my @numbers = map {s/^\s+//;s/\s+$//r;} <>;

# Get rid of any "numbers" that don't look like numbers:
for ( $idx = 0 ; $idx < scalar(@numbers) ; ++$idx )
{
   if (!looks_like_number($numbers[$idx]))
   {
      warn "Not a number: $numbers[$idx]\n";
      splice(@numbers, $idx, 1);
      --$idx;
   }
   else
   {
      warn "Number: $numbers[$idx]\n" if $db;
   }
}

# Print the numbers to STDERR (NOT to STDIN!!!):
warn("Numbers = ", join(',', @numbers), "\n") if $db;

# Get min, max, and range:
$min   = $numbers[0];
$max   = $numbers[0];
$range = 0;
for $x (@numbers)
{
   $min = $x if $x < $min;
   $max = $x if $x > $max;
}
$range = $max-$min;
warn "min   = $min"   if $db;
warn "max   = $max"   if $db;
warn "range = $range" if $db;

# Fill @bins with 100 refs to empty anonymous arrays:
for ($idx = 0 ; $idx < 100 ; ++$idx)
{
   $bins[$idx]=[];
}

# Fill bins with numbers:
for $x (@numbers)
{
   $idx = int(100*($x-$min)/$range);
   if ($idx <  0) {$idx = 0;}
   if ($idx > 99) {$idx = 99;}
   push @{$bins[$idx]}, $x;
}

# Print results in Perl "hash" nomenclature (using "=>"):
for ( $idx = 0 ; $idx < 100 ; ++$idx )
{
   print $idx, ' => ', scalar(@{$bins[$idx]}), ",\n";
}
