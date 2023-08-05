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
# Mon Jul 31, 2023: Cleaned up formatting and comments. Fine-tuned definitions of "option" and "argument".
#                   Fixed bug in which $, was being set instead of $" .
#                   Got rid of "--target=xxxx" options in favor of just "--xxxx".
# Sat Aug 05, 2023: Command-line item "--" now means "all further items are arguments, not options".
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

# Setting:      Default Value:   Meaning of Setting:         Range:     Meaning of Default:
   $"         = ', '         ; # Quoted-array formatting.    string     Separate elements with comma space.
my $db        = 0            ; # Debug?                      bool       Don't debug.
my $Verbose   = 0            ; # Be wordy?                   0,1,2      Be quiet.
my $Recurse   = 0            ; # Recurse subdirectories?     bool       Be local.
my $RegExp    = qr/^.+$/o    ; # Regular Expression.         regexp     Process all file names.
my $Target    = 'A'          ; # Files, dirs, both, all?     F|D|B|A    Process all file types.

# Counters:
my $direcount = 0 ; # Count of directories processed by curdire().
my $filecount = 0 ; # Count of dir entries processed by curfile().

# Accumulations of counters from RH::Dir::GetFiles():
my $totfcount = 0 ; # Count of all directory entries matching regexp & target.
my $noexcount = 0 ; # Count of all nonexistent files encountered.
my $ottycount = 0 ; # Count of all tty files.
my $cspccount = 0 ; # Count of all character special files.
my $bspccount = 0 ; # Count of all block special files.
my $sockcount = 0 ; # Count of all sockets.
my $pipecount = 0 ; # Count of all pipes.
my $brkncount = 0 ; # Count of all symbolic links to nowhere
my $slkdcount = 0 ; # Count of all symbolic links to directories.
my $linkcount = 0 ; # Count of all symbolic links to regular files.
my $weircount = 0 ; # Count of all symbolic links to weirdness (things other than files or dirs).
my $sdircount = 0 ; # Count of all directories.
my $hlnkcount = 0 ; # Count of all regular files with multiple hard links.
my $regfcount = 0 ; # Count of all regular files.
my $unkncount = 0 ; # Count of all unknown files.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   if ( $Verbose >= 1 ) {
      say STDERR '';
      say STDERR "Now entering program \"" . get_name_from_path($0) . "\".";
      say STDERR "Verbose = $Verbose";
      say STDERR "Recurse = $Recurse";
      say STDERR "RegExp  = $RegExp";
      say STDERR "Target  = $Target";
   }
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $ms = 1000 * (time - $t0);
   if ( $Verbose >= 1 ) {
      printf STDERR "\nNow exiting program \"%s\". Execution time was %.3fms.\n", get_name_from_path($0), $ms;
   }
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV :
sub argv {
   # Get options and arguments:
   my @opts; my @args; my $nomo = 0;
   for ( @ARGV ) {
      /^-\pL*e|^--debug$/ and $db = 1;
      /^--$/ and $nomo = 1 and next;
      if ( !$nomo && /^-\pL*$|^--.+$/) {push @opts, $_}
      else                             {push @args, $_}
   }
   if ($db) {
      say STDERR "opts = (@opts)";
      say STDERR "args = (@args)";
      exit 555;
   }

   # Process options:
   for ( @opts ) {
      /^-\pL*h|^--help$/     and help and exit 777 ;
      /^-\pL*q|^--quiet$/    and $Verbose =  0     ;
      /^-\pL*t|^--terse$/    and $Verbose =  1     ;
      /^-\pL*v|^--verbose$/  and $Verbose =  2     ;
      /^-\pL*l|^--local$/    and $Recurse =  0     ;
      /^-\pL*r|^--recurse$/  and $Recurse =  1     ;
      /^-\pL*f|^--files$/    and $Target  = 'F'    ;
      /^-\pL*d|^--dirs$/     and $Target  = 'D'    ;
      /^-\pL*b|^--both$/     and $Target  = 'B'    ;
      /^-\pL*a|^--all$/      and $Target  = 'A'    ;
   }

   # Process arguments:
   my $NA = scalar(@args);
   if    ( 0 == $NA ) {                                  } # Use default settings.
   elsif ( 1 == $NA ) { $RegExp = qr/$args[0]/o          } # Set $RegExp.
   else               { error($NA) and help and exit 666 } # Something evil happened.

   # Return success code 1 to caller:
   return 1;
} # end sub argv

# Process current directory:
sub curdire
{
   # Increment directory counter:
   ++$direcount;

   # Get current working directory:
   my $cwd = cwd_utf8;

   # Announce current working directory if being at-least-somewhat-verbose:
   if ( $Verbose >= 1) {
      say "\nDirectory # $direcount: $cwd\n";
   }

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, $Target, $RegExp);

   # If being very-verbose, also accumulate all counters from RH::Dir:: to main:
   if ( $Verbose >= 2 ) {
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
      $weircount += $RH::Dir::weircount; # symbolic links to weirdness
      $sdircount += $RH::Dir::sdircount; # directories
      $hlnkcount += $RH::Dir::hlnkcount; # regular files with multiple hard links
      $regfcount += $RH::Dir::regfcount; # regular files
      $unkncount += $RH::Dir::unkncount; # unknown files
   }

   # Iterate through $curdirfiles and send each file to curfile():
   foreach my $file (@{$curdirfiles}) {
      curfile($file);
   }
   return 1;
} # end sub curdire

# Process current file:
sub curfile ($file)
{
   # Increment file counter:
   ++$filecount;

   # Announce path:
   say STDOUT $file->{Path};

   # Return success code 1 to caller:
   return 1;
} # end sub curfile

# Print statistics for this program run:
sub stats
{
   if ( $Verbose >= 1 ) {
      say    STDERR '';
      say    STDERR 'Statistics for this directory tree:';
      say    STDERR "Navigated $direcount directories.";
      say    STDERR "Found $filecount paths matching given target and regexp.";
   }

   if ( $Verbose >= 2) {
      say    STDERR '';
      say    STDERR 'Directory entries encountered in this tree included:';
      printf STDERR "%7u total files\n",                            $totfcount;
      printf STDERR "%7u nonexistent files\n",                      $noexcount;
      printf STDERR "%7u tty files\n",                              $ottycount;
      printf STDERR "%7u character special files\n",                $cspccount;
      printf STDERR "%7u block special files\n",                    $bspccount;
      printf STDERR "%7u sockets\n",                                $sockcount;
      printf STDERR "%7u pipes\n",                                  $pipecount;
      printf STDERR "%7u symbolic links to nowhere\n",              $brkncount;
      printf STDERR "%7u symbolic links to directories\n",          $slkdcount;
      printf STDERR "%7u symbolic links to non-directories\n",      $linkcount;
      printf STDERR "%7u symbolic links to weirdness\n",            $weircount;
      printf STDERR "%7u directories\n",                            $sdircount;
      printf STDERR "%7u regular files with multiple hard links\n", $hlnkcount;
      printf STDERR "%7u regular files\n",                          $regfcount;
      printf STDERR "%7u files of unknown type\n",                  $unkncount;
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

   -------------------------------------------------------------------------------
   Description of options:

   Option:             Meaning:
   -h or --help        Print help and exit.
   -q or --quiet       Be quiet.                       (DEFAULT)
   -t or --terse       Be terse.
   -v or --verbose     Be verbose.
   -l or --local       Don't recurse subdirectories.   (DEFAULT)
   -r or --recurse     Do    recurse subdirectories.
   -f or --files       Target Files.
   -d or --dirs        Target Directories.
   -b or --both        Target Both.
   -a or --all         Target All.                     (DEFAULT)

   All single-letter options are stackable (eg: "-qlf").
   All options other than those shown above are ignored.

   -------------------------------------------------------------------------------
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
