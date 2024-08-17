#!/usr/bin/env -S perl -C63

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# regexp-tester.pl
# Tests the regexps given by command-line arguments by applying them to the text coming in on STDIN.
# Written by Robbie Hatley.
# Edit history:
# Fri Dec 03, 2021: Wrote it.
# Wed Aug 23, 2023: Upgraded from "v5.32" to "v5.36". Reduced width from 120 to 110. Got rid of CPAN module
#                   "common::sense" (antiquated). Got rid of all prototypes. Now using signatures.
# Mon Aug 28, 2023: Improved argv. Got rid of "/o" on all instances of qr().
# Tue Aug 29, 2023: Changed all "$Db" to "$Db". Argument processing now set's $RegExp even if many args.
# Wed Aug 30, 2023: Got rid of a couple extra "say '';" (too many blank lines in output).
# Fri Oct 20, 2023: Got rid of "$RegExp". Instead, now using "@args" to contain multiple regexps to be tested.
#                   Input text is still via STDIN (redirect from file or pipe from echo).
# Mon Apr 22, 2024: Corrected errors in comments and help which erroneously stated that only one RegExp can be
#                   specified (actually, this program can now test many RegExps at once). Also got rid of
#                   subroutine "error()" as it's no-longer needed. (If no args, program simply does nothing.)
# Thu Aug 15, 2024: -C63; got rid of unnecessary "use" statements.
##############################################################################################################

use v5.36;
use utf8;
use Time::HiRes 'time';
use RH::Util;
use RH::Dir;
use RH::RegTest;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv  ; # Process @ARGV.
sub help  ; # Print help and exit.

# ======= VARIABLES: =========================================================================================

# Turn on debugging?
my $Db = 0; # Set to 1 for debugging, 0 for no debugging.

# Options and arguments:
my @opts = (); # options
my @args = (); # arguments

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   my $pname = get_name_from_path($0);
   say '';
   say "Now entering program \"$pname\".";

   my @input_lines = <STDIN>;
   for my $RE ( @args ) {
      my $tester = RH::RegTest->new($RE);
      for my $line ( @input_lines ) {
         $tester->match($line);
      }
   }

   say '';
   say "Now exiting program \"$pname\".";
   printf "Execution time was %.0fµs.\n", 1000000 * (time - $t0);
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

sub argv {
   # Get options and arguments:
   my $end = 0;               # end-of-options flag
   my $s = '[a-zA-Z0-9]';     # single-hyphen allowable chars (English letters, numbers)
   my $d = '[a-zA-Z0-9=.-]';  # double-hyphen allowable chars (English letters, numbers, equal, dot, hyphen)
   for ( @ARGV ) {
      /^--$/                  # "--" = end-of-options marker = construe all further CL items as arguments,
      and $end = 1            # so if we see that, then set the "end-of-options" flag
      and next;               # and skip to next element of @ARGV.
      !$end                   # If we haven't yet reached end-of-options,
      && ( /^-(?!-)$s+$/      # and if we get a valid short option
      ||   /^--(?!-)$d+$/ )   # or a valid long option,
      and push @opts, $_      # then push item to @opts
      or  push @args, $_;     # else push item to @args.
   }

   # Process options:
   for ( @opts ) {
      /^-$s*h/ || /^--help$/  # If user wants help,
      and help                # give help,
      and exit 777;           # then exit, returning 777 to invoker of this script.
   }

   # Process arguments:
   ;                          # Do nothing. (Arguments are in "@args" and main body processes them.)

   # If we get to here, return success code 1 to caller of this subroutine:
   return 1;
} # end sub argv

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to "regexp-tester.pl". This program tests a list of regular expressions
   given as command-line arguments by matching text coming in on STDIN to those
   regexps.

   Command lines:
   regexp-tester.pl -h | --help          (to print this help and exit)
   regexp-tester.pl RegExp(s) < Input    (to test a regular expression)
   Input | regexp-tester.pl RegExp(s)    (to test a regular expression)

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   (All other options are ignored.)

   Description of arguments:
   Arguments to this program should be valid Perl-Compliant Regular Expressions.
   This program will then test each of those regular expressions against each
   line of text coming in on STDIN. If no arguments are given, this program will
   do nothing.

   Description of input:
   Input is via STDIN. The two easiest ways of providing input are:
   1. By pipe from echo:
      echo "This is some input text!" | regexp-tester.pl '^\pL{4}\d{4}$'
   2. By redirect from file:
      regexp-tester.pl '^\pL{4}\d{4}$' < input_text.txt


   Happy regular-expression testing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
__END__
