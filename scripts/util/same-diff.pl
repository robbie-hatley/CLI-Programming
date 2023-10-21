#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# same-diff.pl
# Finds substrings of a second string which are / aren't in a first string.
# Written by Robbie Hatley.
# Edit history:
# Wed Mar 09, 2022: Wrote it.
# Wed Aug 09, 2023: Upgraded from "v5.32" to "v5.36". Got rid of "common::sense" (antiquated). Reduced width
#                   from 120 to 110. Added strict, warnings, etc, to boilerplate.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";
use Sys::Binmode;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv  ; # Process @ARGV.
sub error ; # Print error message.
sub help  ; # Print help and exit.

# ======= VARIABLES: =========================================================================================

# Settings:          Meaning of setting:          Range:    Meaning of default:
my $refe   = ''  ; # Reference string.            string    Empty string.
my $test   = ''  ; # Test string.                 string    Empty string.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   argv;
   say STDERR "refe = $refe";
   say STDERR "test = $test";
   my $tsz = length($test);
   my ($i, $j, $matches, $same, $diff, $substring);
   for ( $i = 0 ; $i < $tsz ; ++$i )
   {
      for ( $j = $tsz - $i ; $j > 0 ; --$j )
      {
         $substring = substr($test, $i, $j);
         $matches = ($refe =~ m/$substring/);
         if ($matches)
         {
            $same .= substr($test, $i, $j);
            $i += ($j - 1);
            last;
         }
      }
      if (!$matches)
      {
         $diff .= substr($test, $i, 1)
      }
   }
   say "same = $same";
   say "diff = $diff";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV :
sub argv ()
{
   # Get options and arguments:
   my @opts = ();
   my @args = ();
   my $end_of_options = 0;
   for ( @ARGV ) {
      /^--$/ and $end_of_options = 1 and next;
      !$end_of_options && /^-\pL*$|^--.+$/ and push @opts, $_ or push @args, $_;
   }

   # Process options:
   for ( @opts ) {
      /^-\pL*h|^--help$/   and help and exit 777;
   }

   # Count args:
   my $NA = scalar @args;

   # If the number of arguments is exactly two, set reference and test strings:
   if ($NA == 2) {
      $refe = $args[0]; # Set $refe
      $test = $args[1]; # Set $test
   }

   # Otherwise, abort execution:
   else {
      error($NA);       # Print error message.
      help;             # Provide help.
      exit 666;         # Return The Number Of The Beast.
   }

   # Return success code 1 to caller:
   return 1;
} # end sub argv ()

# Handle errors:
sub error ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $NA arguments, but this program takes exactly 2 arguments.
   Help follows:
   END_OF_ERROR
   help;
   exit 666;
} # end sub error

# Print help:
sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to "same-diff.pl". This program looks for maximum-size substrings
   of a "test string" which are also in a "reference string". All such substrings
   are concatenated to a "same" string, and all left-over characters which
   couldn't be matched are concatenated to a "diff" string, then the "same" and
   "diff" strings are printed.

   Command lines:
   program-name.pl -h | --help   (to print this help and exit)
   program-name.pl refe test     (to search for substrings of test in refe)

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.

   All other options are ignored.

   Description of arguments:
   This program takes exactly 2 non-option arguments. The first must be a
   reference string to look for patterns in, and the second must be a test string
   with patterns to search for.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
