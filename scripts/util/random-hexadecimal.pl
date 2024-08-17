#!/usr/bin/env -S perl -C63

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# random-hexadecimal.pl
# Generates and print a random hexadecimal number, 1-to-1,000,000 digits long, defaulting to 8 digits.
# Written by Robbie Hatley.
# Edit history:
# Sun Jan 28, 2024: Wrote it.
# Thu Aug 15, 2024: -C63; got rid of unnecessary "use" statements.
##############################################################################################################

use v5.36;
use utf8;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ; # Process @ARGV.
sub error   ; # Handle errors.
sub help    ; # Print help and exit.

# ======= LEXICAL VARIABLES: =================================================================================

my $digits = 8; # Number of digits. (1 to 1,000,000, defaulting to 8.)
my @hex = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   argv;
   for ( my $i = 1 ; $i <= $digits ; ++$i ) {
      print $hex[int rand 16];
      #0 == $i%64 and print "\n";
   }
   print "\n";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV :
sub argv {
   for ( @ARGV ) {
      /^-h$/ || /^--help$/    and help and exit 777;
      /^--digits=([1-9]\d*)$/ and $digits = int($1);
   }
   $digits < 1 || $digits > 1000000
   and say "Error: Number of digits must be 1-1,000,000 but you specified $digits"
   and exit 666;
   return 1;
} # end sub argv

# Print help:
sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "random-hexadecimal.pl". This program prints a random positive
   hexadecimal integer, 1-to-1,000,000 digits long, defaulting to 8 digits.

   -------------------------------------------------------------------------------
   Command lines:

   program-name.pl -h | --help       (to print this help and exit)
   program-name.pl [--digits=####]   (to print a hexadecimal integer)

   -------------------------------------------------------------------------------
   Description of options:

   Option:            Meaning:
   -h or --help       Print help and exit.
   --digits=####      Set number of digits to #### (must be 1 to 1000000)

   All options not listed above, and all non-option arguments, are ignored.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
__END__
