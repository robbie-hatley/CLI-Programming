#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# cleanup-facebook-friends-list-new.pl
#
# Cleans up "page source" Facebook friends-list files. (Copy-Paste no-longer works due to recent drastic
# changes by FB in how Friends Lists are presented.)
#
# Written by Robbie Hatley on Thursday November 30, 2023.
#
# Edit history:
# Thu Nov 30, 2023: Wrote it.
# Wed Aug 02, 2024: Got rid of "use strict", "use warnings", and "use Sys::Binmode".
##############################################################################################################

use v5.36;
use utf8;

use Unicode::Collate;
use List::Util 'uniq';

my @names;
my @sorted;
my @unique;

# Input and process text, reject some lines, clean and store others:
while (<>) {
   s/^\x{FEFF}//         ; # Get rid of leading  BOM (if any).
   s/^\s+//              ; # Get rid of leading  horizontal whitespace.
   s/\s+$//              ; # Get rid of trailing horizontal whitespace.
   s/\v//g               ; # Get rid of   all    vertical   whitespace.

   # Save all names found to array "@names":
   s/\"__isProfile\":\"User\",\"name\":\"([^\"]+)\"/push @names, $1/ge;
}

# Make collator:
my $collator = Unicode::Collate->new();

# Sort names array:
@sorted = $collator->sort(@names);

# Erase duplicates:
@unique = uniq @sorted;

# Print result:
say "Found ${\scalar(@unique)} names:";
say for @unique;
