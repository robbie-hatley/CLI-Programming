#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# file-size-statistics.pl
# Prints the distribution of file sizes in the current directory (and all subdirs if a -r or --recurse option is used).
# Author: Robbie Hatley
# Creation date: Sun Apr 17, 2016
#
# Edit history:
# Sun Apr 17, 2016: Wrote first draft.
# Thu Dec 21, 2017: Converted to logarithmic and reduced bins to 13.
# Tue Dec 26, 2017: Improved anti-log(0) code.
# Wed Feb 17, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory as its first
#                   argument, target as second, and regexp (instead of wildcard) as third.
# Sat Feb 20, 2021: Got rid of "Settings" hash. All subs now have prototypes.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv        ()  ;
sub curdire     ()  ;
sub log_of_size ($) ;
sub stats       ()  ;
sub error       ($) ;
sub help        ()  ;

# ======= VARIABLES: ===================================================================================================

# Debug?
my $db = 0;

# Settings:                   Meaning of setting:        Possible values:  Default:
my $Recurse   = 0         ; # Recurse subdirectories?    (bool)            0
my $Regexp    = qr/^.+$/o ; # Regular expression.        (regexp)          '.+'

# Counters:
my $direcount = 0         ; # Count of directories processed.
my $filecount = 0         ; # Count of    files    processed.

# Make array of 13 size bins. $size_bins[i] represents number of files
# with int(floor(log(size)) = i.
my @size_bins;
foreach (0..12) {$size_bins[$_] = 0};

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   argv;
   $Recurse ? RecurseDirs {curdire} : curdire;
   stats;
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
            if (/^-h$/ || /^--help$/        ) {help; exit 777;}
         elsif (/^-r$/ || /^--recurse$/     ) {$Recurse =  1 ;}
         splice @ARGV, $i, 1;
         --$i;
      }
   }
   my $NA = scalar @ARGV;
   given ($NA)
   {
      when (0) {                       ;}
      when (1) {$Regexp = qr/$ARGV[0]/o;}
      default  {error($NA)             ;}
   }
   return 1;
} # end sub argv ()

sub curdire ()
{
   ++$direcount;

   # Get current working directory:
   my $curdir = cwd_utf8;

   # Get list of targeted files in current directory:
   my $curdirfiles = GetFiles($curdir, 'F', $Regexp);

   # Iterate through all files in current directory, 
   # incrementing appropriate size_bin counter for each file:
   foreach my $file (@{$curdirfiles}) 
   {
      ++$filecount;
      ++$size_bins[log_of_size($file)];
   }
   return 1;
} # end sub curdire ()

# Return int(log10(file size)) with knife-edge rounding-error protection
# (ie, protect against int(0.99999973) vs int(1.0000142):
sub log_of_size ($)
{
   my $file = shift;
   if ($db) {say "In log_of_size; file name = \"$file->{Name}\".";}
   my $size_bin;
   $size_bin = $file->{Size} < 10 ? 0 : int(log($file->{Size}+0.1)/log(10));
   return $size_bin;
} # end sub log_of_size ($)

sub stats ()
{
   printf ( "Navigated %6u directories.\n", $direcount );
   printf ( "Examined  %6u files.\n",       $filecount );
   for (0..12)
   {
      printf
      ("Number of files with size 10^%2d bytes = %6d\n", $_, $size_bins[$_]);
   }
   return 1;
} # end sub stats ()

sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: You typed $NA arguments, but this program takes at most 1 argument
   which, if present, must be a regular expression specifying which directories
   and/or files to process. Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end sub error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "file-size-statistics.pl". This program prints file-size stats for
   all files in the current directory (and all subdirectories if a -r or --recurse
   option is used).

   Command line:
   file-size-statistics.pl [-h|--help] [-r|--recurse] [Arg1]

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-r" or "--recurse"          Recurse subdirectories (but not links).

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

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
