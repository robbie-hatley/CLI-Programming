#!/usr/bin/env perl

=pod

--------------------------------------------------------------------------------------------------------------
TITLE AND ATTRIBUTION:

Solution in Perl for The Weekly Challenge 017-1,
written by Robbie Hatley on Fri Oct 09, 2026.

--------------------------------------------------------------------------------------------------------------
PROBLEM DESCRIPTION:

Task 017-1: Ackermann function
Create a script to demonstrate Ackermann function. The Ackermann
function is defined as below, m and n are positive number:
          A(m, n) = n + 1                  if m = 0
          A(m, n) = A(m - 1, 1)            if m > 0 and n = 0
          A(m, n) = A(m - 1, A(m, n - 1))  if m > 0 and n > 0

--------------------------------------------------------------------------------------------------------------
PROBLEM NOTES:

I tried simply calculating A(m, n) exactly as described above, but it was too slow, so I created a hash to
keep track of all A(m, n) calculated so-far, so we don't have to calculate them again.

--------------------------------------------------------------------------------------------------------------
IO NOTES:

Input is via either default data or @ARGV. If using @ARGV, provide one-or-more space-separated single-quoted
arguments. Each argument must be a comma-separated pair of decimal representations of non-negative integers.
For example:

./ch-1.pl '0,7' '1,7' '2,7' '3,7' '4,0' '4,1' '4,2' '4,3'

Output is to STDOUT and will be each input followed by the corresponding output.

=cut

# ------------------------------------------------------------------------------------------------------------
# PRAGMAS AND MODULES:

use v5.40;
no warnings 'recursion';
use Math::BigInt 'lib' => 'GMP';

# ------------------------------------------------------------------------------------------------------------
# VARIABLES:

$" = ', ';
my $fh = undef;                      # File Handle.
my %avs;                             # Hash of Ackermann values found.

# ------------------------------------------------------------------------------------------------------------
# SUBROUTINES:

# Return Ackermann function of arguments:
sub Ackermann ( $m , $n ) {
   my $result;
   if ( exists $avs{"$m,$n"} ) {
      $result = $avs{"$m,$n"};
   }
   else {
         if ( 0 == $m ) {
         $result = Math::BigInt->new($n + 1);
      }
      elsif ( 1 == $m ) {
         $result = Math::BigInt->new($n + 2);
      }
      elsif ( 2 == $m ) {
         $result = Math::BigInt->new(2*$n + 3);
      }
      elsif ( 3 == $m ) {
         $result = Math::BigInt->new(2)->bpow($n+3)->bsub(3);
      }
      elsif ( 4 == $m ) {
         $result = Math::BigInt->new(2);
         $result->buparrow(2,$n+3)->bsub(3);
      }
      elsif ( $m > 0 && 0 == $n ) {
         $result = Math::BigInt->new(Ackermann($m-1, 1));
      }
      else {
         $result = Math::BigInt->new(Ackermann($m-1, Ackermann($m, $n-1)));
      }
      $avs{"$m,$n"} = $result->copy();
   }
   $result;
}

# Is a given argument valid?
sub is_valid ( $aref ) {
   return 0 if 'ARRAY' ne reftype $aref;
   return 0 if 2 != scalar @$aref;
   return 0 if $aref->[0] !~ m/^0$|^[1-9]\d*$/;
   return 0 if $aref->[1] !~ m/^0$|^[1-9]\d*$/;
   return 1;
}

# Parse lists of strings:
sub parse_argv_1 ( @bash_args ) {
   my @args = ();
   foreach my $bash_arg (@bash_args) {
      push @args, [map {trim $_} split /,/, $bash_arg, -1];
   }
   return @args;
}

# ------------------------------------------------------------------------------------------------------------
# INPUTS:

my @arrays = @ARGV ? parse_argv_1(@ARGV) :
([0,3], [1,5], [2,7], [3,5], [3,18], [4,0], [4,1], [4,2], [4,3], [5,0], [5,1], [1745,9243]);

# ------------------------------------------------------------------------------------------------------------
# MAIN BODY OF PROGRAM:

for my $aref (@arrays) {
   say '';
   say "Argument = (@$aref)";
   if (!is_valid($aref)) {
      warn "Error: Argument (@$aref) is not a comma-separated pair of non-negative integers.\n";
      next;
   }
   my ($m,$n) = @$aref;
   if ( 4 == $m ) {
      if ( $n > 2 ) {
         warn "Error: Cannot compute Ackermann(4,n) for values of n greater than 2.\n";
         next;
      }
   }
   if ( 5 == $m ) {
      if ( $n > 0 ) {
         warn "Error: Cannot compute Ackermann(5,n) for values of n greater than 0.\n";
         next;
      }
   }
   if ( $m > 5 ) {
      warn "Are you out of your mind??? This is blasphemy!!! This is madness!!!\n";
      next;
   }
   my $av = Ackermann($m, $n);
   say     "Ackermann($m, $n) = $av";
}
