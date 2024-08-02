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
# Wed Jan 01, 2020: I probably wrote this in 2020, but I made no record, so I'm not sure.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
# Fri Aug 02, 2024: Upgraded to "v5.36"; got rid of "common::sense" and "Sys::Binmode"; deleted pod comment.
########################################################################################################################

use v5.36;

my $inpod = 0;
while (<>) {
   if ($inpod) {
      if (/^=cut/) {
         $inpod = 0;
      }
      else {
         print;
      }
   }
   else {
      if (/^=/) {
         $inpod = 1;
      }
      else {
         ; # Do nothing.
      }
   }
}
