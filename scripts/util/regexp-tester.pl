#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# regexp-tester.pl
# Tests the regexp given by the first command-line argument by applying it to the text coming in on STDIN.
# Written by Robbie Hatley.
# Edit history:
# Fri Dec 03, 2021: Wrote it.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';
use RH::Dir;
use RH::RegTest;
use RH::WinChomp;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ()  ; # Process @ARGV.
sub error   ($) ; # Handle errors.
sub help    ()  ; # Print help and exit.


# ======= VARIABLES: ===================================================================================================

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# Settings:               Meaning:             Range:     Default:
my $Regexp = qr/^.+$/o; # Regular expression.  (regexp)   qr/^.+$/o;

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   my $tester = RH::RegTest->new($ARGV[0]);
   while (<STDIN>)
   {
      $tester->match(winchomp($_));
   }
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

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
   if ( 1 != $NA ) {error($NA);}
   # If we get to here, RegExp is in $ARGV[0]. Just use that.
   return 1;
} # end sub argv ()

sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $NA arguments, but this program takes exactly 1 argument,
   which must be a valid Perl-Compliant Regular Expression. Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end sub error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "regexp-tester.pl". This program tests a regular expression
   (which must be given as this program's one-and-only command-line argument)
   by matching text coming in on STDIN to that regexp.

   Command lines:
   program-name.pl -h | --help        (to print this help and exit)
   program-name.pl RegExp < Input     (to test a regular expression)

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   (All other options are ignored.)

   Description of arguments:

   This program must have exactly one command-line argument, which must be a valid
   Perl-Compliant Regular Expression. This regular expression will be tested by
   matching text coming in on STDIN against it.

   Happy regular-expression testing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
