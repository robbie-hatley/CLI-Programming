#! /bin/perl -CSDA

# This is a 110-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# file-size-stats.pl
# Prints the distribution of file sizes in the current directory (and all subdirs if a -r or --recurse option
# is used).
#
# Author: Robbie Hatley
# Creation date: Sun Apr 17, 2016
#
# Edit history:
# Sun Apr 17, 2016: Wrote first draft.
# Thu Dec 21, 2017: Converted to logarithmic and reduced bins to 13.
# Tue Dec 26, 2017: Improved anti-log(0) code.
# Wed Feb 17, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory
#                   as its first argument, target as second, and regexp (instead of wildcard) as third.
# Sat Feb 20, 2021: Got rid of "Settings" hash. All subs now have prototypes.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Thu Aug 03, 2023: Upgraded from "use v5.32;" to "use v5.36;". Got rid of prototypes and started using
#                   signatures instead. Renamed from "file-size-statistics.pl" to "file-size-stats.pl".
#                   Got ride of "common::sense" (antiquated).
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;

use Sys::Binmode;
use Cwd;

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ;
sub curdire ;
sub logsize ;
sub stats   ;
sub error   ;
sub help    ;

# ======= VARIABLES: ===================================================================================================

# Debug?
my $db = 0;

# Settings:                      Meaning of setting:        Possible values:    Meaning of default:
my $Recurse   = 0            ; # Recurse subdirectories?    bool                Don't recurse.
my $RegExp    = qr/^.+$/o    ; # Regular expression.        regexp              Process all file names.

# Counters:
my $direcount = 0            ; # Count of directories navigated.
my $filecount = 0            ; # Count of files matching $RegExp.

# Make array of 13 size bins. $size_bins[i] represents number of files
# with int(floor(log(size)) = i.
my @size_bins;
foreach (0..12) {$size_bins[$_] = 0};

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   argv;
   say STDERR "\$Recurse   = $Recurse";
   say STDERR "\$RegExp    = $RegExp";
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub argv {
   # Get options and arguments:
   my @opts;
   my @args;
   for ( @ARGV ) {
      if (/^-\pL*$|^--[\pL\pM\pN\pP\pS]*$/) {push @opts, $_}
      else                                  {push @args, $_}
   }

   # Process options:
   for ( @opts ) {
      /^-\pL*h|^--help$/     and help and exit 777 ;
      /^-\pL*r|^--recurse$/  and $Recurse =  1     ;
   }

   # Process arguments:
   my $NA = scalar(@args);
      if ( 0 == $NA ) {                            ; } # Do nothing.
   elsif ( 1 == $NA ) { $RegExp    = qr/$args[0]/o ; } # Set $RegExp.
   else               { error($NA); help; exit 666 ; } # Something evil happened.

   # Return success code 1 to caller:
   return 1;
} # end sub argv

# Return int(log10(file size)) with knife-edge rounding-error protection
# (ie, protect against int(0.99999973) vs int(1.0000142):
sub logsize ($file) {
   if ($db) {say "In logsize; file name = \"$file->{Name}\".";}
   my $size_bin;
   $size_bin = $file->{Size} < 10 ? 0 : int(log($file->{Size}+0.1)/log(10));
   return $size_bin;
} # end sub logsize ($file)

sub curdire {
   ++$direcount;

   # Get current working directory:
   my $curdir = d getcwd;

   # Get list of entries in current directory matching $RegExp:
   my $curdirfiles = GetFiles($curdir, 'F', $RegExp);

   # Iterate through all entries in current directory which match $RegExp,
   # incrementing appropriate size_bin counter for each file which also matches $Predicate:
   foreach my $file (@{$curdirfiles}) {
      ++$filecount;
      ++$size_bins[logsize($file)];
   }

   # Return success code 1 to caller:
   return 1;
} # end sub curdire

sub stats
{
   say STDERR "File-size statistics for this tree:";
   say STDERR "Navigated $direcount directories.";
   say STDERR "Found $filecount regular files matching RegExp \"$RegExp\".";
   for (0..12)
   {
      printf
      ("Number of files with size 10^%2d bytes = %6d\n", $_, $size_bins[$_]);
   }
   return 1;
} # end sub stats

sub error ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: You typed $NA arguments, but this program takes 0 or 1 arguments.
   Help follows:
   END_OF_ERROR
} # end sub error ($NA)

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to "file-size-stats.pl". This program prints file-size stats for all
   regular files in the current directory (and all subdirectories if a -r or
   --recurse option is used).

   Command lines:
   file-size-stats.pl [-h|--help]         (to print this help and exit)
   file-size-stats.pl [options] [Arg1]    (to print file-size stats)

   -------------------------------------------------------------------------------
   Description of options:

   Option:                  Meaning:
   -h or --help             Print help and exit.
   -r or --recurse          Recurse subdirectories.
   Any other options will be ignored.

   -------------------------------------------------------------------------------
   Description of arguments:

   In addition to options, this program can take 1 optional argument, which, if
   present, must be a Perl-Compliant Regular Expression specifying which files to
   print size stats for. To specify multiple patterns, use the | alternation
   operator. To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to print size stats for items with names containing
   "cat", "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   If the number of arguments is not 0 or 1, this program will print an error
   message and abort.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
