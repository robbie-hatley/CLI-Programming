#! /bin/env perl
#  array-permutations.pl
use v5.36;
use Time::HiRes 'time';
$,=' ';
sub permutations (@array)
{
   my @permutations;
   my $size = scalar(@array);
   if (0 == $size)
   {
      @permutations = ([]);
   }
   else
   {
      for ( my $idx = 0 ; $idx <= $#array ; ++$idx )
      {
         my @temp = @array;
         my @removed = splice @temp, $idx, 1;
         my @partials = permutations(@temp);
         unshift @$_, @removed for @partials;
         push @permutations, @partials;
      }
   }
   return @permutations;
}

{ # begin main
   my $t0 = time;
   my @array = (@ARGV);
   say "array = (@array)";
   my @permutations = permutations(@array);
   say "number of permutations = ", scalar(@permutations);
   #say @$_ for @permutations;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nExecution time was $te seconds.";
   exit 0;
} # end main
