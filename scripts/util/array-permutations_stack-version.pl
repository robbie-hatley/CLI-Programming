#! /bin/env perl
#  array-permutations_stack-version.pl
use v5.36;
use Time::HiRes 'time';
$,=' ';
sub permutations (@array)
{
   my @permutations;             # Our output will go in here.
   my @stack = ([[@array],[]]);  # A 3D array!!! OMG, WTF???
   while (@stack)
   {
      my $old_pair = shift @stack;
      my $raw_size = scalar(@{$old_pair->[0]});
      if ( 0 == $raw_size )
      {
         push @permutations, $old_pair->[1];
      }
      else
      {
         for ( my $idx = 0 ; $idx < $raw_size ; ++$idx )
         {
            my $new_pair = [[@{$old_pair->[0]}],[@{$old_pair->[1]}]];
            my $cut = splice @{$new_pair->[0]}, $idx, 1;
            push @{$new_pair->[1]}, $cut;
            push @stack, $new_pair;
         }
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
