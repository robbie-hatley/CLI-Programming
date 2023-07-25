#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# vowel-count.pl
#
# Edit history:
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Thu Nov 25, 2021: Now also printing the "decomposed" version of each string.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use Unicode::Normalize 'NFC', 'NFD';

my $vcount;
while (<>)
{
   $_ =~ s/[\r\n]+$//;
   my $decomposed   = NFD $_;
   my $stripped     = ($decomposed =~ s/\pM//gr);
   my $folded       = fc $stripped;
   my @base_letters = split //, $stripped;
   $vcount = 0;
   /[aeiou]/ and ++$vcount for @base_letters;
   say '';
   say " Original  string: $_";
   say "Decomposed string: $decomposed";
   say " Stripped  string: $stripped";
   say "Casefolded string: $folded";
   say " Number of vowels: $vcount";
}
