#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# catpod.pl
#
# Written by Robbie Hatley (date unknown).
#
# Edit history:
# ??? ??? ??, ????: Wrote it.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

my $inpod = 0;
while (<>)
{
   if ($inpod)
   {
      if (/^=cut/)
      {
         $inpod = 0;
      }
      else
      {
         print;
      }
   }
   else
   {
      if (/^=/)
      {
         $inpod = 1;
      }
      else
      {
         ; # Do nothing.
      }
   }
}

=pod

This really is a pretty ridiculous program.
It's about as useful to a human as a bicycle is to a fish.

=cut

