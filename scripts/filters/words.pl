#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# words.pl
# Prints a sorted list of the unique words in a file.
# Edit history:
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Refactored. Now using subroutines "clean" and "help".
# Wed Dec 08, 2021: Reformatted titlecard.
# Sat Aug 03, 2024: Reduced width from 120 to 110; upgraded from "v5.32" to "v5.36"; added "use utf8";
#                   switched from "sort" to Unicode collation.
##############################################################################################################

use v5.36;
use utf8;

use Unicode::Collate;
use List::Util 'uniq';

sub clean :prototype(@) ;
sub help  :prototype()  ;

{ # begin main
   # Process arguments:
   for (@ARGV) {
      if (/^-/) {
         if ('-h' eq $_ || '--help' eq $_ ) {
            help;
            exit(777);
         }
      }
   }

   # Collect words from STDIN :
   my @words = ();
   while (<STDIN>) {
      # Chomp leading and trailing white space:
      s/^\s+//; s/\s+$//;
      # Split line to words, clean them, and push them to "@words":
      push @words, clean(split);
   }
   # Say sorted list of unique words:
   say for uniq Unicode::Collate->new->sort(@words);
   # We're done, so exit program, returning success code "0" to caller:
   exit(0);
} # end main

# Clean leading and trailing white space and punctuation from words, and case-fold all letters:
sub clean :prototype(@) (@substrings) {
   return map {s/^\s+//; s/\s+$//; s/^\pP+//; s/\pP+$//; fc;} @substrings
}

# If user asks for help, give help:
sub help :prototype() () {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   "words.pl" prints a case-folded, sorted list of the unique words in a file.
   Input is via STDIN and output is via STDOUT.
   Standard pipes and redirects will also work as expected.
   END_OF_HELP
}
