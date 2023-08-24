#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# regexp-tester.pl
# Tests the regexp given by the first command-line argument by applying it to the text coming in on STDIN.
# Written by Robbie Hatley.
# Edit history:
# Fri Dec 03, 2021: Wrote it.
# Wed Aug 23, 2023: Upgraded from "v5.32" to "v5.36". Reduced width from 120 to 110. Got rid of CPAN module
#                   "common::sense" (antiquated). Got rid of all prototypes. Now using signatures.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

use Sys::Binmode;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;
use RH::RegTest;
use RH::WinChomp;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv  ; # Process @ARGV.
sub error ; # Handle errors.
sub help  ; # Print help and exit.

# ======= VARIABLES: =========================================================================================

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# Settings:                 Meaning of setting:           Range:   Meannig of default:
my $RegExp = qr/^.+$/o;   # Regular expression to test.   regexp   Expression which matches all strings.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   my $pname = get_name_from_path($0);
   say '';
   say "Now entering program \"$pname\".";
   my $tester = RH::RegTest->new($RegExp);

   $tester->match(winchomp($_)) while (<STDIN>);

   my $µs = 1000000 * (time - $t0);
   say '';
   say "Now exiting program \"$pname\".";
   printf "Execution time was %.0fµs.", $µs;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

sub argv {
   # Get options and arguments:
   my @opts = (); my @args = (); my $end_of_options = 0;
   for ( @ARGV ) {
      /^--$/ and $end_of_options = 1 and next;
      !$end_of_options && /^--?\w+$/ and push @opts, $_ or push @args, $_;
   }

   # Process options:
   for ( @opts ) {
      /^-h$|^--help$/ and help and exit 777;
   }

   # Process arguments:
   my $NA = scalar @args;
   if ( 1 == $NA ) { $RegExp = qr/$args[0]/o    ; } # Set $RegExp.
   else            { error($NA); help; exit 666 ; } # Wrong number of arguments.

   # Return success code 1 to caller:
   return 1;
} # end sub argv

sub error ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $NA arguments, but this program takes exactly 1 argument,
   which must be a valid Perl-Compliant Regular Expression. Help follows:
   END_OF_ERROR
} # end sub error ($)

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to "regexp-tester.pl". This program tests a regular expression
   (which must be given as this program's one-and-only command-line argument)
   by matching text coming in on STDIN to that regexp.

   Command lines:
   regexp-tester.pl -h | --help        (to print this help and exit)
   regexp-tester.pl RegExp < Input     (to test a regular expression)
   Input | regexp-tester.pl RegExp     (to test a regular expression)

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
} # end sub help
__END__
