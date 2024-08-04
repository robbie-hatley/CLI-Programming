#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# cleanup-facebook-friends-list-from-source.pl
#
# Cleans-up Facebook friends-list "page source" files. (Copy-Paste from regular browser presentation of FB
# home page no-longer works due to recent drastic changes by FB in how Friends Lists are presented.)
#
# Written by Robbie Hatley on Thursday November 30, 2023.
#
# Edit history:
# Thu Nov 30, 2023: Wrote it.
# Fri Aug 02, 2024: Got rid of "use strict", "use warnings", and "use Sys::Binmode".
##############################################################################################################

use v5.36;
use utf8;

my @unsorted;
my @sorted;

# Input and process text, reject some lines, clean and store others:
while (<>) {
   s/^\x{FEFF}//         ; # Get rid of leading  BOM (if any).
   s/^\s+//              ; # Get rid of leading  horizontal whitespace.
   s/\s+$//              ; # Get rid of trailing horizontal whitespace.
   s/\v//g               ; # Get rid of   all    vertical   whitespace.

   # Save all names found to array "@names":
   s/\"__isProfile\":\"User\",\"name\":\"([^\"]+)\"/push @unsorted, $1/ge;
}

# Sort and dedup names:
@sorted = sort @unsorted;

# Print result:
say for @sorted;
