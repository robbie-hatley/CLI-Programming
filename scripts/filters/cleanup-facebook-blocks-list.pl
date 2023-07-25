#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# cleanup-facebook-blocks-list.pl
# Cleans up raw Facebook blocks-list files.
#
# Written by Robbie Hatley on Monday April 14, 2015.
#
# Edit history:
# Mon Apr 14, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Thu Mar 10, 2016: Cleaned up a few things.
# Sat Apr 16, 2016: Now using -CSDA.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Unicode::Collate;
use RH::WinChomp;

# main
{
   my @unsorted;
   my @sorted;

   LINE: while (<>)
   {
      remove_bom;                 # Get rid of BOM (if any).
      winchomp;                   # Chomp-off newlines.
      s/\v//g;                    # Get rid of all vertical whitespace.
      s/Unblock$//;               # Get rid of trailing "Unblock".
      s/^\s+//;                   # Get rid of leading  whitespace.
      s/\s+$//;                   # Get rid of trailing whitespace.
      next LINE if $_ eq '';      # Skip this line if it's empty.
      next LINE if m/^\s+$/;      # Skip this line if it's whitespace-only.
      push @unsorted, $_;         # Push line onto end of @unsorted.
   }

   # Make collator:
   my $collator = Unicode::Collate->new();

   # Sort array:
   @sorted = $collator->sort(@unsorted);

   # Print result:
   say for @sorted;

   # We be done, so scram:
   exit 0;
} # end main
