#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# list-by-last-name.pl
# Converts lists of names from "list by first" to "list by last".
#
# Written by Robbie Hatley on Saturday January 10, 2015.
#
# Edit history:
# Sat Jan 10, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
# Fri Aug 02, 2024: Upgraded to "v5.36"; got rid of "common::sense"; got rid of "Sys::Binmode".
########################################################################################################################

use v5.32;

use Unicode::Collate;

our @lfm_names = ();

while (<>) {
   s/\s+$//;
   my @fml = split(" ", $_);
   my @lfm = ();
   $lfm[0] = $fml[@fml - 1].",";
   for ( my $i = 1 ; $i < @fml ; ++$i ) {
      $lfm[$i] = $fml[$i-1];
   }
   push(@lfm_names, join(" ", @lfm));
}
say for Unicode::Collate->new->sort( @lfm_names );
