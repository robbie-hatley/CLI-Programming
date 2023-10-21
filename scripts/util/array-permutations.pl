#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# array-permutations.pl
# This program places all of its non-option arguments in an array, then prints both the original array and
# all possible permutations thereof.
# Written by Robbie Hatley.
# Edit history:
# Sat Jun 05, 2021: Wrote it.
# Sat Sep 09, 2023: Brought formatting up to my current standards.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

use Sys::Binmode;
use Time::HiRes 'time';

sub permutations ( @array ) {
   my @permutations;
   my $size = scalar(@array);
   if ( 0 == $size ) {
      @permutations = ([]);
   }
   else {
      for ( my $idx = 0 ; $idx <= $#array ; ++$idx ) {
         my @temp = @array;
         my $removed = splice @temp, $idx, 1;
         my @partials = permutations(@temp);
         unshift @$_, $removed for @partials;
         push @permutations, @partials;
      }
   }
   return @permutations;
}

{ # begin main
   my $t0 = time;
   my @array = (@ARGV);
   say "Array = " . "(" . join(', ', map {"\"$_\""} @array) . ")";
   my @permutations = permutations(@array);
   say "Number of permutations = ", scalar(@permutations);
   #say "Permutations:";
   #for my $aref ( @permutations ) {
   #   say "(", join(', ', map {"\"$_\""} @$aref), ")";
   #}
   my $t1 = time; my $te = $t1 - $t0;
   say "\nExecution time was $te seconds.";
   exit 0;
} # end main
__END__
