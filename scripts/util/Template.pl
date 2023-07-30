#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# Template.pl
# "Template" serves as a template for making new file and directory maintenance scripts.
#
# Edit history:
# Mon May 04, 2015: Wrote first draft.
# Wed May 13, 2015: Updated and changed Help to "Here Document" format.
# Thu Jun 11, 2015: Corrected a few minor issues.
# Tue Jul 07, 2015: Now fully utf8 compliant.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Sun Dec 24, 2017: Now splicing options from @ARGV.
# Thu Jul 11, 2019: Combined getting & processing options and arguments.
# Fri Jul 19, 2019: Renamed "get_and_options_and_arguments" to "argv" and got rid of arrays @CLOptions and
#                   @CLArguments.
# Sun Feb 23, 2020: Added entry and exit announcements, and refactored statistics.
# Sat Jan 02, 2021: Got rid of all "our" variables; all subs return 1; and all Here documents are now
#                   indented 3 spaces.
# Fri Jan 29, 2021: Corrected minor comment and formatting errors, and changed erasure of Here-document
#                   indents from "s/^ +//gmr" to "s/^   //gmr".
# Mon Feb 08, 2021: Got rid of "help" function (now using "__DATA__"). Renamed "error" to "error".
# Sat Feb 13, 2021: Reinstituted "help()". "error()" now exits program. Created "dire_stats()".
# Wed Feb 17, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory as
#                   its first argument, target as second, and regexp (instead of wildcard) as third.
# Mon Mar 15, 2021: Now using time stamping.
# Sat Nov 13, 2021: Refreshed colophon, title card, and boilerplate.
# Mon Nov 15, 2021: Changed regexps to qr/YourRegexpHere/, and instructed user to use "extended regexp
#                   sequences" in order to use pattern modifiers such as "i".
# Tue Nov 16, 2021: Now using common::sense, and now using extended regexp sequences instead of regexp
#                   delimiters.
# Wed Nov 17, 2021: Now using raw regexps instead of qr//. Also, fixed bug in which some files were being
#                   reported twice because they matched more than one regexp. (I inverted the order of the
#                   regexp and file loops.)
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Fri Dec 03, 2021: Now using just 1 regexp. (Use alternation instead of multiple regexps.)
# Sat Dec 04, 2021: Improved formatting in some places.
# Sun Mar 05, 2023: Updated to v5.36. Got rid of "common::sense" (antiquated). Got rid of "given" (obsolete).
#                   Changed all prototypes to conform to v5.36 standards:
#                   "sub mysub :prototype($) {my $x=shift;}"
# Sat Mar 18, 2023: Added missing "use utf8" (necessary due to removal of common::sense). Got rid of all
#                   prototypes. Converted &curfile and &error to signatures. Made &error a "do one thing only"
#                   subroutine. Added "quiet", "verbose", "local", and "recurse" options.
# Tue Jul 25, 2023: Decreased width to 110 (with github in mind). Made single-letter options stackable.
##############################################################################################################

##############################################################################################################
# myprog.pl
# "MyProg" is a program which [insert description here].
# Written by Robbie Hatley.
# Edit history:
# Sat Jun 05, 2021: Wrote it.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;

use Sys::Binmode;
use Time::HiRes 'time';
use charnames qw( :full :short );
use Unicode::Normalize qw( NFD NFC );
use Unicode::Collate;
use MIME::QuotedPrint;
use Scalar::Util qw( looks_like_number reftype );
use List::AllUtils;
use Hash::Util;
use Regexp::Common;

use RH::Dir;
use RH::Math;
use RH::RegTest;
use RH::Util;
use RH::WinChomp;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ; # Process @ARGV.
sub curdire ; # Process current directory.
sub curfile ; # Process current file.
sub stats   ; # Print statistics.
sub error   ; # Handle errors.
sub help    ; # Print help and exit.

# ======= VARIABLES: =========================================================================================

# Settings:                    Meaning:                     Range:    Default:
$,            = ', '       ; # Array formatting.
my $db        = 0          ; # Debug (print diagnostics)?   bool      0 (Don't print diagnostics.)
my $Verbose   = 1          ; # Be wordy?                    bool      1 (Blab.)
my $Recurse   = 1          ; # Recurse subdirectories?      bool      1 (Recurse.)
my $Target    = 'A'        ; # Files, dirs, both, all?      F|D|B|A   A (All.)
my $RegExp    = qr/^.+$/o  ; # Regular Expression.          regexp    qr/^.+$/o (matches all strings)

# Counters:
my $direcount = 0          ; # Count of directories processed by curdire().
my $filecount = 0          ; # Count of dir entries processed by curfile().

# Accumulations of counters from RH::Dir::GetFiles():
my $totfcount = 0          ; # Count of all directory entries matching target & regexp & verified by GetFiles.
my $noexcount = 0          ; # Count of all nonexistent files encountered.
my $ottycount = 0          ; # Count of all tty files.
my $cspccount = 0          ; # Count of all character special files.
my $bspccount = 0          ; # Count of all block special files.
my $sockcount = 0          ; # Count of all sockets.
my $pipecount = 0          ; # Count of all pipes.
my $brkncount = 0          ; # Count of all symbolic links to nowhere
my $slkdcount = 0          ; # Count of all symbolic links to directories.
my $linkcount = 0          ; # Count of all symbolic links to regular files.
my $weircount = 0          ; # Count of all symbolic links to weirdness (things other than files or dirs).
my $sdircount = 0          ; # Count of all directories.
my $hlnkcount = 0          ; # Count of all regular files with multiple hard links.
my $regfcount = 0          ; # Count of all regular files.
my $unkncount = 0          ; # Count of all unknown files.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   say '';
   say "Now entering program \"" . get_name_from_path($0) . "\".";
   say "Target  = $Target";
   say "RegExp  = $RegExp";
   say "Recurse = $Recurse";
   say "Verbose = $Verbose";
   say '';
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $µs = 1000000 * (time - $t0);
   printf("\nNow exiting program \"%s\". Execution time was %.3fµs.\n", get_name_from_path($0), $µs);
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV :
sub argv
{
   my @options;
   my @arguments;
   for (@ARGV) {
     #if (/^-[\pL]{1,}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/) {push @options  , $_}
      if (/^-[^-]+$/ || /^--[^-]+$/) {push @options  , $_}
      else                           {push @arguments, $_}
   }
   if ($db) {
      say "options   = (@options)";
      say "arguments = (@arguments)";
   }
   for (@options) {
      if ( $_ =~ m/^-[^-]*h/ || $_ eq '--help'         ) {help; exit 777;}
      if ( $_ =~ m/^-[^-]*q/ || $_ eq '--quiet'        ) {$Verbose =  0 ;}
      if ( $_ =~ m/^-[^-]*v/ || $_ eq '--verbose'      ) {$Verbose =  1 ;} # DEFAULT
      if ( $_ =~ m/^-[^-]*l/ || $_ eq '--local'        ) {$Recurse =  0 ;}
      if ( $_ =~ m/^-[^-]*r/ || $_ eq '--recurse'      ) {$Recurse =  1 ;} # DEFAULT
      if ( $_ =~ m/^-[^-]*f/ || $_ eq '--target=files' ) {$Target  = 'F';}
      if ( $_ =~ m/^-[^-]*d/ || $_ eq '--target=dirs'  ) {$Target  = 'D';}
      if ( $_ =~ m/^-[^-]*b/ || $_ eq '--target=both'  ) {$Target  = 'B';}
      if ( $_ =~ m/^-[^-]*a/ || $_ eq '--target=all'   ) {$Target  = 'A';} # DEFAULT
   }
   my $NA = scalar(@arguments);
   if    ( 0 == $NA ) {                                  } # Do nothing.
   elsif ( 1 == $NA ) {$RegExp = qr/$arguments[0]/o      } # Set $RegExp.
   else               {error($NA); say ''; help; exit 666} # Print error and help messages and exit 666.
   return 1;
} # end sub argv

# Process current directory:
sub curdire
{
   # Increment directory counter:
   ++$direcount;

   # Get and announce current working directory:
   my $cwd = cwd_utf8;
   say "\nDirectory # $direcount: $cwd\n";

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, $Target, $RegExp);

   # If being verbose, also accumulate all counters from RH::Dir:: to main:
   if ($Verbose)
   {
      $totfcount += $RH::Dir::totfcount; # all directory entries found
      $noexcount += $RH::Dir::noexcount; # nonexistent files
      $ottycount += $RH::Dir::ottycount; # tty files
      $cspccount += $RH::Dir::cspccount; # character special files
      $bspccount += $RH::Dir::bspccount; # block special files
      $sockcount += $RH::Dir::sockcount; # sockets
      $pipecount += $RH::Dir::pipecount; # pipes
      $brkncount += $RH::Dir::slkdcount; # symbolic links to nowhere
      $slkdcount += $RH::Dir::slkdcount; # symbolic links to directories
      $linkcount += $RH::Dir::linkcount; # symbolic links to regular files
      $weircount += $RH::Dir::multcount; # symbolic links to weirdness
      $sdircount += $RH::Dir::sdircount; # directories
      $hlnkcount += $RH::Dir::hlnkcount; # regular files with multiple hard links
      $regfcount += $RH::Dir::regfcount; # regular files
      $unkncount += $RH::Dir::unkncount; # unknown files
   }

   # Iterate through $curdirfiles and send each file to curfile():
   foreach my $file (@{$curdirfiles})
   {
      curfile($file);
   }
   return 1;
} # end sub curdire

# Process current file:
sub curfile ($file)
{
   # Increment file counter:
   ++$filecount;

   # Get path from file:
   my $path = $file->{Path};

   # Announce path:
   say $path;

   # We're done, so scram:
   return 1;
} # end sub curfile

# Print statistics for this program run:
sub stats
{
   say '';
   say 'Statistics for this directory tree:';
   say "Navigated $direcount directories.";
   say "Found $filecount paths matching given target and regexp.";

   if ($Verbose)
   {
      say '';
      say 'Directory entries encountered in this tree included:';
      printf("%7u total files\n",                            $totfcount);
      printf("%7u nonexistent files\n",                      $noexcount);
      printf("%7u tty files\n",                              $ottycount);
      printf("%7u character special files\n",                $cspccount);
      printf("%7u block special files\n",                    $bspccount);
      printf("%7u sockets\n",                                $sockcount);
      printf("%7u pipes\n",                                  $pipecount);
      printf("%7u symbolic links to nowhere\n",              $brkncount);
      printf("%7u symbolic links to directories\n",          $slkdcount);
      printf("%7u symbolic links to non-directories\n",      $linkcount);
      printf("%7u symbolic links to weirdness\n",            $weircount);
      printf("%7u directories\n",                            $sdircount);
      printf("%7u regular files with multiple hard links\n", $hlnkcount);
      printf("%7u regular files\n",                          $regfcount);
      printf("%7u files of unknown type\n",                  $unkncount);
   }
   return 1;
} # end sub stats

# Handle errors:
sub error ($err_msg)
{
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $err_msg arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which directory entries to process.
   END_OF_ERROR
   return 1;
} # end sub error

# Print help:
sub help
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "[insert Program Name here]". This program does blah blah blah
   to all files in the current directory (and all subdirectories if a -r or
   --recurse option is used).

   Command lines:
   program-name.pl -h | --help            (to print help and exit)
   program-name.pl [options] [arguments]  (to [perform funciton] )

   Description of options:
   Option:                     Meaning:
   "-h" or "--help"            Print help and exit.
   "-q" or "--quiet"           Don't be verbose.
   "-v" or "--verbose"         Do    be Verbose.    (DEFAULT)
   "-l" or "--local"           Don't recurse.
   "-r" or "--recurse"         Do    recurse.       (DEFAULT)
   "-f" or "--target=files"    Target Files.
   "-d" or "--target=dirs"     Target Directories.
   "-b" or "--target=both"     Target Both.
   "-a" or "--target=all"      Target All.          (DEFAULT)
   All single-letter options are stackable (eg: "-qlf").
   All options other than those shown above are ignored.

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

   Happy item processing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
