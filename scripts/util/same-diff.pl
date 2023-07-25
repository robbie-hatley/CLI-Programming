#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# myprog.pl
# Finds substrings of a second string which are / aren't in a first string.
# Written by Robbie Hatley.
# Edit history:
# Wed Mar 09, 2022: Wrote it.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ()  ; # Process @ARGV.
sub help    ()  ; # Print help and exit.

# ======= VARIABLES: ===================================================================================================

# Settings:                    Meaning:                     Range:    Default:
my $db     = ''   ; # Debug (print diagnostics)?   bool      0 (don't print diagnostics)
my $refe   = ''   ; # Reference string.
my $test   = ''   ; # Test string.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   say "\nNow entering program \"same-diff.pl\".";

   say "Reference string = $refe";
   say "   Test   string = $test";

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

   say "\$same = $same";
   say "\$diff = $diff";

   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"same-diff.pl\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

# Process @ARGV :
sub argv ()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL]{1,}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         if ( $_ eq '-h' || $_ eq '--help' ) {help; exit 777;}
         splice @ARGV, $i, 1;
         --$i;
      }
   }
   my $NA = scalar(@ARGV);
   given ($NA)
   {
      when (2)
      {
         $refe = $ARGV[0];  # Reference string.
         $test = $ARGV[1];  # Test string.
      }
      default
      {
         error($NA);        # Print error and help messages then exit 666.
      }
   }
   return 1;
} # end sub argv ()

# Handle errors:
sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $NA arguments, but this program takes exactly 2 arguments.
   Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end sub error ($)

# Print help:
sub help ()
{
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
} # end sub help ()
