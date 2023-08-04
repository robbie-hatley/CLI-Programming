#! /bin/perl -CSDA

# This is a 110-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# file-extension-stats.pl
# Prints how many files of each name-extension ("*.jpg", "*.avi", etc) exist in directories.
# Written by Robbie Hatley.
#
# Edit history:
# Sun Feb 21, 2021: Wrote it. Later that day, fine-tuned it a bit.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Thu Aug 03, 2023: Upgraded from "use v5.32;" to "use v5.36;". Changed name from "file-type-statistics.pl"
#                   to "file-extension-stats.pl". Got rid of "use common::sense;" (antiquated). Reduced
#                   width from 120 to 110 for github. Shortened sub names. Got rid of prototypes and started
#                   using signatures instead. Improved help.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;

use Sys::Binmode;
use Cwd;

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ;
sub curdire ;
sub curfile ;
sub stats   ;
sub help    ;

# ======= VARIABLES: =========================================================================================

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

#Program Settings:
#  Setting:           Meaning:                  Range:   Default:
my $Recurse = 0 ;   # Recurse subdirectories?   (bool)   0
my $Number  = 0 ;   # Sort by number of files?  (bool)   0

# Counters:
my $direcount = 0; # Count of directories processed by process_current_directory().
my $filecount = 0; # Count of    files    processed by process_current_file().

# File types counter hash (how many files have we seen of each type?):
my %file_types;

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   argv;
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

sub argv {
   foreach (@ARGV)
   {
      if ($_ eq '-h' || $_ eq '--help'   ) {help; exit 777 ; }
      if ($_ eq '-r' || $_ eq '--recurse') {$Recurse = 1   ; }
      if ($_ eq '-n' || $_ eq '--number' ) {$Number  = 1   ; }
   }
   return 1;
} # end sub process_argv ()

sub curdire {
   ++$direcount;
   my $curdir = d getcwd;
   my @curdirpaths = glob_regexp_utf8($curdir, 'F');
   foreach my $path (@curdirpaths) {curfile($path)}
   return 1;
} # end sub curdire

sub curfile ($path) {
   ++$filecount;
   my $name = get_name_from_path($path);
   if ($db) {say "In curfile. Current file name = \"$name\".";}
   my $suff = get_suffix($name);
   $suff =~ s/^\.htm$/.html/i;
   $suff =~ s/^\.tif$/.tiff/i;
   $suff =~ s/^\.jpeg$/.jpg/i;
   $suff =~ s/^\.mpeg$/.mpg/i;
   $suff = fc $suff;
   ++$file_types{$suff};
   return 1;
} # end sub curfile ($path)

sub stats {
   say "\nFile-extension statistics for this tree:\n";
   printf("Extension:  Count:\n");
   my @sorted_keys;
   if ($Number) {
      @sorted_keys = sort {$file_types{$b} <=> $file_types{$a}} keys %file_types;
   }
   else {
      @sorted_keys = sort keys %file_types;
   }
   printf("%-12s%6d\n", $_, $file_types{$_}) for @sorted_keys;
   return 1;
} # end sub stats

sub help
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "file-extension-stats.pl". This program prints how many files of
   each name-extension ("*.jpg", "*.avi", etc) exist in the current directory
   (and all subdirectories if a -r or --recurse option is used).

   -------------------------------------------------------------------------------
   Command lines:
   file-types-statistics.pl [-h|--help]   (to print this help and exit)
   file-types-statistics.pl [options]     (to print file-extension stats)

   -------------------------------------------------------------------------------
   Description Of Options:

   Option:               Meaning:
   "-h" or "--help"      Print this help and exit.
   "-r" or "--recurse"   Recurse subdirectories.
   "-n" or "--number"    Sort by number-of-files instead of by extension.

   Any options not listed above will be ignored.

   -------------------------------------------------------------------------------
   Description Of Arguments:

   Other than the options above, this program will ignore all arguments you type.
   But hey, type some anyway; it's good typing practice. :-)

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
} # end sub help
