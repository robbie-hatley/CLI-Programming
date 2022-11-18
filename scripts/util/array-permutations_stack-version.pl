#! /usr/bin/env perl
#  array-permutations_stack-version.pl
use v5.36;
$,=' ';
sub permutations (@array)
{
   my @permutations;             # Our output will go in here.
   my @stack = ([[@array],[]]);  # A 3D array!!! OMG, WTF???
   while (@stack)
   {
      my $pair = shift @stack;
      my $raw_size = scalar(@{${$pair}[0]});
      if ( 0 == $raw_size )
      {
         push @permutations, [@{${$pair}[1]}];
      }
      else
      {
         for ( my $idx = 0 ; $idx < $raw_size ; ++$idx )
         {
            my $new = [[@{${$pair}[0]}],[@{${$pair}[1]}]];
            my $cut = splice @{${$new}[0]}, $idx, 1;
            push @{${$new}[1]}, $cut;
            push @stack, $new;
         }
      }
   }
   return @permutations;
}
my @array = (@ARGV);
say "array = (@array)";
my @permutations = permutations(@array);
say "number of permutations = ", scalar(@permutations);
say @$_ for @permutations;
