#!/usr/bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks (\x{0A}).
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# "essay.pl"
########################################################################################################################

use v5.38;
use utf8;

use RH::Dir;
use RH::Util;

my $fh;
open($fh, '<', '/d/rhe/scripts/humor/Words-En.txt')
or die "Couldn't open words file.\n$!\n";
my @Words = map {$_ =~ s/\p{Cc}+$//r} <$fh>;
close($fh);
my $NumWords = scalar(@Words);

my $Rows =  5; $Rows = int shift if @ARGV;
my $Cols = 50; $Cols = int shift if @ARGV;

for my $Row (0..$Rows-1)
{
   for my $Col (0..$Cols-1)
   {
      my $Word = $Words[rand_int(0,$NumWords-1)];
      if (0 == $Col%20) {$Word =~ s/^(\pL)/\u$1/;}
      print "$Word ";
      if ( 4 == $Col% 5 && $Col > 0 && $Col < $Cols-4) {print "\x{8}, ";}
      if ( 9 == $Col%10 && $Col > 0 && $Col < $Cols-4) {print "\x{8}\x{8}; ";}
      if (19 == $Col%20 && $Col > 0 && $Col < $Cols-4) {print "\x{8}\x{8}. ";}
   }
   print "\x{8}. \n\n";
}
