#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# words-starting-with.pl
# Prints a sorted list of the unique words in a file beginning with one of the given clusters of characters.
# Edit history:
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Refactored. Now using subroutines "clean" and "help".
# Wed Dec 08, 2021: Reformatted titlecard.
# Sun Aug 04, 2024: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.36". Added "use utf8".
#                   Got rid of "common::sense" and "Sys::Binmode".
##############################################################################################################

use v5.36;
use utf8;

use List::Util 'uniq';

sub clean;
sub help;

my @line_words = ();
my @words      = ();
my @starts     = ();

{ # begin main
   # First, collect starting clusters:
   for (@ARGV)
   {
      if (/^-/)
      {
         if ('-h' eq $_ || '--help' eq $_ ) {help;}
      }
      else
      {
         push @starts, $_;
      }
   }

   # Clean-up starting clusters:
   @starts = clean(@starts);

   # Collect words in STDIN starting with strings in @starts :
   while (<STDIN>)
   {
      s/\s+$//;                        # Chomp line.
      @line_words = clean(split);      # Get and clean words from line.
      foreach my $word (@line_words)   # For each word on line:
      {
         foreach my $start (@starts)   # For each start:
         {
            if ($word =~ m/^$start/)   # If word starts with start,
            {
               push(@words, $word);    # collect word.
            }
         }
      }
   }
   say for uniq sort @words;           # Say sorted list of unique words.
   exit 0;
} # end main

sub clean
{
   return map {s/\pP+$//; s/^\pP+//; fc;} @_ ;
}

sub help
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   "words-starting-with.pl" prints a case-folded, sorted list of the unique words
   in a file which start with one of the letters or letter clusters given as
   command-line arguments. (If no arguments are given, no words will be printed.)
   Input is via STDIN and output is via STDOUT.
   Standard pipes and redirects will also work as expected.
   END_OF_HELP
   exit 0;
}
