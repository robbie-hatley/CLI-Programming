#!/usr/bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# character-info.pl
#
# Edit history:
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use Unicode::Normalize 'NFD';

use RH::Dir;

my ($line, $char, $j, $i, $rep, $ord, $type);

$j = 0;
foreach $line (<>)
{
   ++$j;
   say "Line #$i:\n$line";
   my @chars = split '',$line;
   $i = 0;
   foreach $char (@chars)
   {
      ++$i;

      # Decide representation:
      if    ($char =~ m/\pC/)                          {$rep = "\x{2423}"             ;}
      elsif ($char =~ m/\p{White_Space}/)              {$rep = "\x{2422}"             ;}
      else                                             {$rep = $char                  ;}

      # Get ordinal:
      $ord  = ord $char;

      # Generate type string:
      $type = '';
      if ($char =~ m/\p{White_Space}/)                 {$type .= ' Whitespace'        ;}
      if ($char =~ m/\pC/)                             {$type .= ' Control Character' ;}
      if ($char =~ m/\p{L}/)
      {
                                                        $type .= ' Letter'            ;
         if ($char =~ m/\p{Ll}/)                       {$type .= ', lower-case'       ;}
         elsif ($char =~ m/\p{Lu}/)                    {$type .= ', upper-case'       ;}
         else                                          {$type .= ', unkwn-case'       ;}
         my $decomposed = NFD $char;
         my $stripped = $decomposed =~ s/\p{M}//rg;
         my $folded = fc $stripped;
         if    ($folded =~ m/[aeiou]/)                 {$type .= ' (vowel    )'       ;}
         elsif ($folded =~ m/[bcdfghjklmnpqrstvwxyz]/) {$type .= ' (consonant)'       ;}
         else                                          {$type .= ' (unknown  )'       ;}
      }
      if ($char =~ m/\pZ/)                             {$type .= ' Separator'         ;}
      if ($char =~ m/\pN/)                             {$type .= ' Numeral'           ;}
      if ($char =~ m/\pM/)                             {$type .= ' Combining Mark'    ;}
      if ($char =~ m/\p{Block: Hangul_Jamo}/)          {$type .= ' Hangul Jamo'       ;}
      if ($char =~ m/\p{Block: Hangul}/)               {$type .= ' Hangul Character'  ;}
      if ($char =~ m/\p{Block: CJK_Strokes}/)          {$type .= ' CJK Stroke'        ;}
      if ($char =~ m/\p{Block: CJK_Symbols}/)          {$type .= ' CJK Symbol'        ;}
      if ($char =~ m/\p{Block: CJK}/)                  {$type .= ' CJK Character'     ;}
      if ($char =~ m/\pS/)                             {$type .= ' Symbol'            ;}
      if ($char =~ m/\pP/)                             {$type .= ' Punctuation'       ;}
      printf("line# %3d char# %2d char = %s\tord = %7d(dec) = %5X(hex)%s\n", $j, $i, $rep, $ord, $ord, $type);
   } # end for each character
}
exit 0;
__END__
