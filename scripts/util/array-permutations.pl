#! /usr/bin/env perl
#  array-permutations.pl
use v5.36;
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
my @array = (@ARGV);
say "array = (@array)";
my @permutations = permutations(@array);
say "number of permutations = ", scalar(@permutations);
say @$_ for @permutations;
