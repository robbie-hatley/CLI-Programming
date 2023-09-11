#!/usr/bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# words.pl
# Prints a sorted list of the unique words in a file.
# Edit history:
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Refactored. Now using subroutines "clean" and "help".
# Wed Dec 08, 2021: Reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use List::Util 'uniq';

sub clean;
sub help;

my @line_words = ();
my @words      = ();

{ # begin main
   for (@ARGV)
   {
      if (/^-/)
      {
         if ('-h' eq $_ || '--help' eq $_ ) {help;}
      }
   }

   # Collect words in STDIN :
   while (<STDIN>)
   {
      s/\s+$//;                        # Chomp line.
      @line_words = clean(split);      # Get and clean words from line.
      foreach my $word (@line_words)   # For each word on line:
      {
         push @words, $word;           # Collect word.
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
   "words.pl" prints a case-folded, sorted list of the unique words in a file.
   Input is via STDIN and output is via STDOUT.
   Standard pipes and redirects will also work as expected.
   END_OF_HELP
   exit 0;
}
