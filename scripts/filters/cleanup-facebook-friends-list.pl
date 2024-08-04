#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# cleanup-facebook-friends-list.pl
# Cleans up a Facebook "Friends" list copy-pasted to a text file from Facebook's regular web-page "Friends
# list presentation (not from page source, which is limited to first 100 names).
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
# Sat Sep 23, 2023: Upgraded Perl version from "v5.32" to "v5.36". Reduced width from 120 to 110. Got rid of
#                   CPAN module common::sense (antiquated). Got rid of RH::Winchomp (unnecessary).
# Fri Aug 02, 2024: Got rid of "use strict", "use warnings", and "use Sys::Binmode".
# Sat Aug 03, 2024: Ditched "Unicode::Collate" in favor of "sort", as I want weird codepoints obvious.
#                   Also, refactored to handle Facebook's new presentation (not source).
##############################################################################################################

use v5.36;
use utf8;

my @unsorted;
my @sorted;

# Input and process text, reject some lines, clean and store others:
while (<>) {
   s/^\x{FEFF}//                                   ; # Trim leading      BOM     (if any).
   s/^\s+//                                        ; # Trim leading  white space (if any).
   s/\s+$//                                        ; # Trim trailing white space (if any).

   next if m/^\s+$/                                ; # Skip "white"         lines.
   next if m/^$/                                   ; # Skip "empty"         lines.

   next if m/mutual friend/                        ; # Skip "mutual friend" lines.

   next if m/ at /                                 ; # Skip "employment"    lines.
   next if m/Producer/                             ; # Skip "employment"    lines.
   next if m/Kenyan Bytes/                         ; # Skip "employment"    lines.

   next if m/School|College|University/            ; # Skip "education"     lines.
   next if m/ High$/                               ; # Skip "education"     lines.
   next if m/^Lycée /                              ; # Skip "education"     lines.
   next if m/^[A-Z]{4}/                            ; # Skip "education"     lines.
   next if m/Beroepsopleiding Iokai Shiatsu/       ; # Skip "education"     lines.
   next if m/Pima CC/                              ; # Skip "education"     lines.
   next if m/Frontier Central/                     ; # Skip "education"     lines.
   next if m/מכון/                                  ; # Skip "education"     lines.

   next if m/, /                                   ; # Skip "location"      lines.
   next if m/^Timbuktu$/                           ; # Skip "location"      lines.
   next if m/^Ilesa$/                              ; # Skip "location"      lines.

   # If we get to here, lets assume this line is a friend name
   # and push it onto the right end of our array of unsorted names:
   push @unsorted, $_;
}

# Sort names:
@sorted = sort @unsorted;

# Print result:
say for @sorted;
