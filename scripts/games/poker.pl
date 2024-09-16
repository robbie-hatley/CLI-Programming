#!/usr/bin/env perl
# poker.pl
use v5.36;
use bigint "lib" => "GMP";

# x!:
sub fact ($x) {
   my $f = 1;
   for my $i (2..$x) {$f *= $i}
   $f
}

# Unordered combinations of x things taken y-at-a-time:
sub comb ($x, $y) {
   fact($x)/fact($x-$y)/fact($y);
}

my $RF = 1 * 4;               # TJQKA in each of 4 suits.                                                    4
my $SF = 9 * 4;               # A-5, 2-6, 3-7, 4-8, 5-9, 6-T, 7-J, 8-Q, 9-K in each of 4 suits.             36
my $FK = 13                   # 13 poss vals  for quartet
       * 1                    # 1  poss suit  combos for quartet (namely one-each of the 4 suits)
       * 12                   # 12 poss vals  for 5th card
       * 4;                   # 4  poss suits for 5th card                                                 624
my $FH = 13                   # 13 poss vals  for trio
       * comb(4,3)            # 4c3=4 poss suit combos for trio
       * 12                   # 12 poss vals  for pair
       * comb(4,2);           # 4c2=6 poss suit combos for pair                                           3744
my $FL = (comb(13,5)-10)*4;   # (13c5-10=1277) val combos for each of 4 suits                             5108
my $ST = 10*(4**5-4);         # 10 poss val combos for each of (4**5-4) suit combos                     10_200
my $TK = 13                   # 13 poss vals for trio
       * comb(4,3)            # 4c3=4 poss suit combos for trio
       * comb(12,2)           # 12c2=66 poss val combos for 4th and 5th cards
       * 4                    # 4 poss 4th-card suits
       * 4;                   # 4 poss 5th-card suits                                                   54_910
my $TP = comb(13,2)           # 13c2=78 poss pairs of pair values
       * comb(4,2)            # 4c2=6 first pair suit combos
       * comb(4,2)            # 4c2=6 secnd pair suit combos
       * 11                   # 11 poss vals  for 5th card
       * 4;                   # 4  poss suits for 5th card                                             123_552
my $OP = 13                   # 13 poss pair values
       * comb(4,2)            # 4c2=6 suit combos for pair
       * comb(12,3)           # 12c3=220 val combos for 3rd, 4th, 5th cards
       * 4                    # 4c1 poss 3rd-card suits
       * 4                    # 4c1 poss 4th-card suits
       * 4;                   # 4c1 poss 5th-card suits                                              1_098_240
my $ZP = (comb(13,5)-10)      # (13c5 poss  val combos, minus 10 for straights) = 1277
       * (4**5 - 4);          # (4**5 poss suit combos, minu   4 for flushes  ) = 1020               1_302_540

printf "Number of Poker Hands      = %7d\n", comb(52,5);
printf "Number of Royal    Flushes = %7d\n", $RF;
printf "Number of Straight Flushes = %7d\n", $SF;
printf "Number of Four-Of-A-Kinds  = %7d\n", $FK;
printf "Number of Full Houses      = %7d\n", $FH;
printf "Number of Flushes          = %7d\n", $FL;
printf "Number of Straights        = %7d\n", $ST;
printf "Number of Three-Of-A-Kinds = %7d\n", $TK;
printf "Number of Two-Pairs        = %7d\n", $TP;
printf "Number of One-Pairs        = %7d\n", $OP;
printf "Number of No-Pairs         = %7d\n", $ZP;
printf "Sum    of Poker Ranks      = %7d\n", $RF+$SF+$FK+$FH+$FL+$ST+$TK+$TP+$OP+$ZP;
