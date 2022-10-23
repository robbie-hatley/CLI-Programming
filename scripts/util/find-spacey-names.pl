#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# find-spacey-names.pl
# Finds directory entries with names containing spaces.
#
# Author: Robbie Hatley.
#
# Edit history:
# Unknown date    : Wrote it.
# Wed Feb 17, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory as its first
#                   argument, target as second, and regexp (instead of wildcard) as third.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Sat Nov 27, 2021: Shortened sub names. Tested: Works.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ()  ; # Process @ARGV.
sub curdire ()  ; # Process current directory.
sub curfile ($) ; # Process current file.
sub stats   ()  ; # Print statistics.
sub error   ($) ; # Handle errors.
sub help    ()  ; # Print help and exit.

# ======= VARIABLES: ===================================================================================================

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

#Program Settings:             Meaning:                 Range:     Default:
my $Recurse   = 0          ; # Recurse subdirectories?  (bool)     0
my $Target    = 'A'        ; # Target                   (F|D|B|A)  'A'
my $Regexp    = qr/^.+$/   ; # Regular expression.      (regexp)   qr/^.+$/
my $Verbose   = 0          ; # Be verbose?              (bool)     0

# Counters:
my $direcount = 0; # Count of directories processed by curdire().
my $filecount = 0; # Count of    files    processed by curfile().
my $spaccount = 0; # Count of spacey directory names found.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   print
   (
      STDERR
      "\n"
    . "Now entering program \"" . get_name_from_path($0) . "\".\n"
    . "Recurse = $Recurse\n"
    . "Target  = $Target\n"
    . "Regexp  = $Regexp\n"
    . "\n"
   );
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $t1 = time; my $te = $t1 - $t0;
   print
   (
      STDERR
      "\n"
    . "Now exiting program \"" . get_name_from_path($0) . "\";\n"
    . "execution time was $te seconds.\n"
    . "\n"
   );
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
            if ( $_ eq '-h' || $_ eq '--help'         ) {help; exit 777;}
         elsif ( $_ eq '-r' || $_ eq '--recurse'      ) {$Recurse =  1 ;}
         elsif ( $_ eq '-f' || $_ eq '--target=files' ) {$Target  = 'F';}
         elsif ( $_ eq '-d' || $_ eq '--target=dirs'  ) {$Target  = 'D';}
         elsif ( $_ eq '-b' || $_ eq '--target=both'  ) {$Target  = 'B';}
         elsif ( $_ eq '-a' || $_ eq '--target=all'   ) {$Target  = 'A';}
         elsif ( $_ eq '-v' || $_ eq '--verbose'      ) {$Verbose =  1 ;}

         # Remove option from @ARGV:
         splice @ARGV, $i, 1;

         # Move the index 1-left, so that the "++$i" above
         # moves the index back to the current @ARGV element,
         # but with the new content which slid-in from the right
         # due to deletion of previous element contents:
         --$i;
      }
   }
   my $NA = scalar(@ARGV);
   given ($NA)
   {
      when (0)
      {
         ; # Do nothing.
      }
      when (1)
      {
         $Regexp = shift(@ARGV);
      }
      default
      {
         error($NA);
      }
   }
   return 1;
} # end sub argv ()

sub curdire ()
{
   ++$direcount;
   my $curdir = cwd_utf8;
   if ($Verbose)
   {
      print
      (
         STDOUT
         "\n"
       . "Dir # $direcount: $curdir\n"
       . "\n"
      );
   }
   my $curdirfiles = GetFiles($curdir, $Target, $Regexp);
   foreach my $file (@{$curdirfiles}) 
   {
      curfile($file);
   }
   return 1;
} # end sub curdire ()

sub curfile ($) 
{
   ++$filecount;
   my $file = shift;
   if ($file->{Name} =~ m/\s/)
   {
      ++$spaccount;
      print
      (
         STDOUT
         "$file->{Path}\n"
      );
   }
   return 1;
} # end sub curfile ($) 

sub stats ()
{
   print
   (
      STDERR
      "\n"
    . "Navigated $direcount directories.\n"
    . "Examined $filecount directory entries.\n"
    . "Found $spaccount spacey names.\n"
    . "\n"
   );
   return 1;
} # end sub stats ()

sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $NA arguments, but \"find-spacey-names.pl\" takes
   at most 1 argument, which, if present, must be a regular expression
   specifying which directory entries to process. (Did you forget to put
   your regexp in 'single quotes'?) Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end sub error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "find-spacey-names.pl". This program finds entries in the current
   directory (and all subdirectories if a -r or --recurse option is used) which
   have names containing white space.

   Command line:
   find-spacey-names.pl [options] [argument]

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-r" or "--recurse"          Recurse subdirectories.
   "-f" or "--target=files"     Target files only.
   "-d" or "--target=dirs"      Target directories only.
   "-b" or "--target=both"      Target both files and directories.
   "-a" or "--target=all"       Target ALL directory entries. (DEFAULT)
   "-v" or "--verbose"          Print directory headings, stats, etc.

   Description of arguments:
   In addition to options, this program can take one optional argument which, if
   present, must be a Perl-Compliant Regular Expression specifying which items to
   process. To specify multiple patterns, use the | alternation operator.
   To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to search for items with names containing "cat",
   "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead. 

   If the number of arguments is not 0 or 1, this program will print an
   error message and abort.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
