#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# find-cjk-file-names.pl
# Written by Robbie Hatley.
#
# Edit history:
# Mon Mar 15, 2021: Wrote it.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Thu Oct 03, 2024: Got rid of Sys::Binmode and common::sense; added "use utf8".
########################################################################################################################

use v5.32;
use utf8;

use Time::HiRes 'time';

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ()  ; # Process @ARGV.
sub curdire ()  ; # Process current directory.
sub curfile ($) ; # Process current file.
sub stats   ()  ; # Print statistics.
sub error   ($) ; # Handle errors.
sub help    ()  ; # Print help.

# ======= VARIABLES: ===================================================================================================

# Use debugging? (Ie, print extra diagnostics?)
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# Settings:                  Meaning:                  Range:    Default:
my $Recurse = 0          ; # Recurse subdirectories?   bool      0
my $Target  = 'A'        ; # Target                    F|D|B|A   'A'
my $Verbose = 0          ; # Verbose                   bool      0
my $RegExp  = qr/^.+$/o  ; # Regular Expression.       regexp    qr/^.+$/o (matches all strings)

# Counters:
my $direcount = 0; # Count of directories processed by curdire.
my $filecount = 0; # Count of    files    processed by curfile.
my $findcount = 0; # Count of dir entries matching regexps.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;

   if ($Verbose) {say "\nNow entering program \"" . get_name_from_path($0) . "\".";}
   if ($Verbose) {say "Verbose = $Verbose" ;}
   if ($Verbose) {say "Recurse = $Recurse" ;}
   if ($Verbose) {say "Target  = $Target"  ;}
   if ($Verbose) {say "RegExp  = $RegExp"  ;}

   $Recurse and RecurseDirs {curdire} or curdire;

   if ($Verbose) {stats;}

   my $t1 = time;
   my $te = $t1 - $t0;

   if ($Verbose) {say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";}

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
         splice @ARGV, $i, 1;
         --$i;
      }
   }
   my $NA = scalar(@ARGV);
   given ($NA)
   {
      when (0) {                       ;} # Do nothing.
      when (1) {$RegExp = qr/$ARGV[0]/o;} # Set $RegExp.
      default  {error($NA)             ;} # Print error and help messages then exit 666.
   }
   return 1;
} # end sub argv ()

sub curdire ()
{
   # Increment directory counter:
   ++$direcount;

   # Get and announce current working directory:
   my $cwd = cwd_utf8;
   say "\nDirectory # $direcount: $cwd\n";

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, $Target, $RegExp);

   # Iterate through $curdirfiles and send each file to curfile():
   foreach my $file (@{$curdirfiles})
   {
      curfile($file);
   }
   return 1;
} # end sub curdire ()

# Process current file:
sub curfile ($)
{
   my $file = shift;
   ++$filecount;
   # Print paths of all files with names containing at least one CJK (Chinese, Japanese, or Korean) character:
   if ( $file->{Name} =~ m/\p{Block: CJK}/ )
   {
      ++$findcount; # Count of all files which also match both regexps.
      say $file->{Path};
   }
   return 1;
} # end sub curfile ()

sub stats ()
{
   warn "Statistics for this directory tree:\n";
   warn "Navigated $direcount directories.\n";
   warn "Processed $filecount files.\n";
   warn "Found $findcount paths with names containing CJK ideographic characters.\n";
   return 1;
} # end sub stats ()

sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $NA arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which directory entries to process. Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end sub error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "find-cjk-file-names.pl". This program finds all files
   in the current directory (and all subdirectories if a -r or --recurse
   option is used) which have names containing Chinese, Japanese, or
   Korean ideographic characters belonging to the "CJK" Unicode block,
   and prints their fully-qualified paths.

   Command lines:
   find-cjk-file-names.pl -h | --help            (to print help)
   find-cjk-file-names.pl [options] [arguments]  (to find files)

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-r" or "--recurse"          Recurse subdirectories.
   "-f" or "--target=files"     Target files only.
   "-d" or "--target=dirs"      Target directories only.
   "-b" or "--target=both"      Target both files and directories.
   "-a" or "--target=all"       Target all (files, directories, symlinks, etc).
   "-v" or "--verbose"          Print lots of extra statistics.

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

   Happy CJK file finding!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
