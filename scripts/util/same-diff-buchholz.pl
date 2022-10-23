#!/usr/bin/perl -w
use strict;
my $v1 = "un garde de la porte";
my $v2 = "de la p p";
my $l1 = length ($v1);
my $l2 = length ($v2);
my ($i1, $i2, $pos, $longmatch);
for ($pos = -1, $longmatch = $i1 = 0; $i1 <= $l1 && $longmatch < $l2 && ($i1 + $longmatch) < $l1; ++$i1)
{
   for ($i2 = 0; $i2 < $l2 && ($i1 + $i2) < $l1; ++$i2)
   {
      if (substr ($v1, $i1 + $i2, 1) ne substr ($v2, $i2, 1))
      {
         if ($i2 > $longmatch)
         {
            $pos = $i1;
            $longmatch = $i2;
         }
         last;
      }
   }
}
print "$pos, $longmatch\n";
