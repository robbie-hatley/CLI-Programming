#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# find-files.pl
# Finds directory entries in current directory (and all subdirectories if a -r or --recurse option is used)
# by providing a Perl-Compliant Regular Expression (PCRE) describing file names and/or by providing a boolean
# expression based on Perl file-test operators so that one can specify "regular files", "directories",
# "symbolic links to directories", "block special files", "sockets", etc, or any combination of those.
#
# This file used to be called "find-files-by-type.pl", but I realized that it also subsumes everything that
# my "find-files-by-name.pl" program does, so I'm retiring THAT program and renaming THIS one "find-files.pl".
#
# Written by Robbie Hatley.
#
# Edit history:
# Thu May 07, 2015: Wrote first draft.
# Mon May 11, 2015: Tidied some things up a bit, including using a
#                   "here" document to clean-up Help().
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Sun Dec 24, 2017: Splice options from @ARGV to @Options;
#                   added file type counters for use if being verbose.
# Tue Sep 22, 2020: Improved Help().
# Wed Feb 17, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory as
#                   its first argument, target as second, and regexp (instead of wildcard) as third.
# Tue Nov 16, 2021: Got rid of most boilerplate; now using "use common::sense" instead.
# Wed Nov 17, 2021: Now using "use Sys::Binmode". Also, fixed hidden bug which was causing program to fail to
#                   find any files with names using non-English letters. This was the "sending unencoded
#                   names to shell under Sys::Binmode" bug, which was previously hidden due to a compensating
#                   bug in Perl itself, which is removed by "Sys::Binmode". I fixed this by setting
#                   "local $_ = e file->{Path}" in sub "curfile".
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate, and now using "common::sense".
# Sat Nov 27, 2021: Shortened sub names. Tested: Works.
# Mon Feb 20, 2023: Upgraded to "v5.36". Got rid of prototypes. Put signatures on "curfile" and "error".
#                   Fixed the "$Quiet" vs "$Verbose" variable conflict. Improved "argv". Improved "help".
#                   Put 'use feature "signatures";' after 'use common::sense;" to fix conflict between
#                   common::sense and signatures.
# Fri Jul 28, 2023: Reduced width from to 110 with Github in-mind. Got rid of "common::sense" (antiquated).
#                   Multiple single-letter options can now be piled-up after a single hyphen.
# Sat Jul 29, 2023: Got rid of print-out of stats for directory entries encountered per-directory or per-tree,
#                   as that info isn't relevant to finding specific files. Set defaults to local and quiet.
# Mon Jul 31, 2023: Renamed this file from "find-files-by-type.pl" to "find-files.pl". Retired program
#                   "find-files-by-name.pl". Moved file-name regexp to first argument and moved file-type
#                   predicate to second argument. Corrected bug in regexps in argv() which was failing to
#                   correctly discern number of hyphens on left end of each element of @ARGV (I fixed that bug
#                   by specifying that single-hyphen options may contain letters only whereas double-hyphen
#                   options may contain letters, numbers, punctuations, and symbols). Cleaned-up formatting
#                   and comments. Fixed bug in which $, was being set instead of $" .
#                   Got rid of "--target=xxxx" options in favor of just "--xxxx".
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;

use Sys::Binmode;
use Cwd;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv      ; # Process @ARGV.
sub curdire   ; # Process current directory.
sub curfile   ; # Process current file.
sub dir_stats ; # Print statistics for current directory.
sub stats     ; # Print statistics for entire tree.
sub error     ; # Handle errors.
sub help      ; # Print help and exit.

# ======= VARIABLES: =========================================================================================

# Setting:      Default Val:     Meaning of Setting:         Range:     Meaning of Default:
   $"         = ', '         ; # Quoted-array formatting.    string     Separate elements with comma space.
my $db        = 0            ; # Debug?                      bool       Don't debug.
my $Verbose   = 0            ; # Be wordy?                   bool       Be quiet.
my $Recurse   = 0            ; # Recurse subdirectories?     bool       Be local.
my $RegExp    = qr/^.+$/o    ; # Regular expression.         regexp     Process all file names.
my $Predicate = 1            ; # File-type boolean.          bool       Process all file types.

# Counters:
my $direcount = 0 ; # Count of directories processed by curdire().
my $filecount = 0 ; # Count of files found which match file-name regexp.
my $findcount = 0 ; # Count of files found which also match file-type predicate.

# Accumulations of counters from RH::Dir :
my $totfcount = 0 ; # Count of all targeted directory entries matching regexp.
my $noexcount = 0 ; # Count of all nonexistent files encountered.
my $ottycount = 0 ; # Count of all tty files.
my $cspccount = 0 ; # Count of all character special files.
my $bspccount = 0 ; # Count of all block special files.
my $sockcount = 0 ; # Count of all sockets.
my $pipecount = 0 ; # Count of all pipes.
my $brkncount = 0 ; # Count of all symbolic links to nowhere.
my $slkdcount = 0 ; # Count of all symbolic links to directories.
my $linkcount = 0 ; # Count of all symbolic links to files.
my $weircount = 0 ; # Count of all symbolic links to weirdness.
my $sdircount = 0 ; # Count of all directories.
my $hlnkcount = 0 ; # Count of all regular files with multiple hard links.
my $regfcount = 0 ; # Count of all regular files.
my $unkncount = 0 ; # Count of all unknown files.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   if ( $Verbose >= 1 ) {
      print STDERR
         "\nNow entering program \"" . get_name_from_path($0) . "\".\n".
         "Verbose   = $Verbose\n".
         "Recurse   = $Recurse\n".
         "RegExp    = $RegExp\n".
         "Predicate = $Predicate\n";
   }
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $ms = 1000 * (time - $t0);
   if ( $Verbose >= 1 ) {
      print  STDERR "\nNow exiting program \"" . get_name_from_path($0) . "\".\n";
      printf STDERR "Execution time was %.3fms.\n", $ms;
   }
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV:
sub argv {
   # Get options and arguments:
   my @opts;
   my @args;
   for ( @ARGV ) {
      # Single-hyphen options may contain letters only. (That way, "-5" is an argument, not an option.)
      # Double-hyphen options may contain letters, combining marks, numbers, punctuation, and symbols.
      if (/^-\pL*$|^--[\pL\pM\pN\pP\pS]*$/) {push @opts, $_}
      else                                  {push @args, $_}
   }
   if ( $db ) {
      say STDERR "options   = (@opts)";
      say STDERR 'num opts  = ', scalar(@opts);
      say STDERR "arguments = (@args)";
      say STDERR 'num args  = ', scalar(@args);
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
   }

   # Process arguments:
   my $NA = scalar(@args);
   if    ( 0 == $NA ) {                                                ; } # Use default settings.
   elsif ( 1 == $NA ) { $RegExp = qr/$args[0]/o                        ; } # Set $RegExp.
   elsif ( 2 == $NA ) { $RegExp = qr/$args[0]/o; $Predicate = $args[1] ; } # Set $RegExp and $Predicate.
   else               { error($NA); help(); exit 666                   ; } # Something evil happened.

   # Return success code 1 to caller:
   return 1;
} # end sub argv

# Process current directory:
sub curdire {
   # Increment directory counter:
   ++$direcount;

   # Get current working directory:
   my $curdir = d getcwd;

   # Announce $curdir if being at-least-somewhat-verbose:
   if ( $Verbose >= 1 ) {
      print STDERR "\nDir # $direcount: $curdir\n\n";
   }

   # Get ref to array of file-info packets for all files in current directory matching 'A' and $RegExp:
   my $curdirfiles = GetFiles($curdir, 'A', $RegExp);

   # If being at-least-somewhat-verbose, append total-files and nonexistant-files to accumulators:
   if ($Verbose >= 1)
   {
      $totfcount += $RH::Dir::totfcount; # Total files.
      $noexcount += $RH::Dir::noexcount; # Nonexistent files.
   }

   # If being VERY-verbose, also append all remaining RH::Dir counters to accumulators:
   if ($Verbose >= 2)
   {
      $ottycount += $RH::Dir::ottycount; # tty files
      $cspccount += $RH::Dir::cspccount; # character special files
      $bspccount += $RH::Dir::bspccount; # block special files
      $sockcount += $RH::Dir::sockcount; # sockets
      $pipecount += $RH::Dir::pipecount; # pipes
      $brkncount += $RH::Dir::brkncount; # symbolic links to nowhere
      $slkdcount += $RH::Dir::slkdcount; # symbolic links to directories
      $linkcount += $RH::Dir::linkcount; # symbolic links to files
      $weircount += $RH::Dir::weircount; # symbolic links to weirdness
      $sdircount += $RH::Dir::sdircount; # directories
      $hlnkcount += $RH::Dir::hlnkcount; # regular files with multiple hard links
      $regfcount += $RH::Dir::regfcount; # regular files
      $unkncount += $RH::Dir::unkncount; # unknown files
   }

   # Print each path that matches both $RegExp and $Predicate:
   foreach my $file (@{$curdirfiles}) {
      ++$filecount;
      local $_ = e $file->{Path};
      if (eval($Predicate)) {
         ++$findcount;
         say STDOUT "$file->{Path}";
      }
   }

   # Print stats for this directory:
   dir_stats($curdir);

   # Return success code 1 to caller:
   return 1;
} # end sub curdire

# Print stats for current directory:
sub dir_stats ($curdir) {
   if ( $Verbose >= 1 ) {
      say STDERR "\nStatistics for directory \"$curdir\":";
      say STDERR "Found ${RH::Dir::totfcount} files matching given target and regexp.";
      say STDERR "Found ${RH::Dir::noexcount} nonexistent directory entries.";
   }
   if ( $Verbose >= 2 ) {
      say    STDERR "\nDirectory entries encountered in this directory included:";
      printf STDERR "%7u tty files\n",                              $RH::Dir::ottycount;
      printf STDERR "%7u character special files\n",                $RH::Dir::cspccount;
      printf STDERR "%7u block special files\n",                    $RH::Dir::bspccount;
      printf STDERR "%7u sockets\n",                                $RH::Dir::sockcount;
      printf STDERR "%7u pipes\n",                                  $RH::Dir::pipecount;
      printf STDERR "%7u symbolic links to nowhere\n",              $RH::Dir::brkncount;
      printf STDERR "%7u symbolic links to directories\n",          $RH::Dir::slkdcount;
      printf STDERR "%7u symbolic links to files\n",                $RH::Dir::linkcount;
      printf STDERR "%7u symbolic links to weirdness\n",            $RH::Dir::weircount;
      printf STDERR "%7u directories\n",                            $RH::Dir::sdircount;
      printf STDERR "%7u regular files with multiple hard links\n", $RH::Dir::hlnkcount;
      printf STDERR "%7u regular files\n",                          $RH::Dir::regfcount;
      printf STDERR "%7u files of unknown type\n",                  $RH::Dir::unkncount;
   }
   return 1;
} # end sub dir_stats ($curdir)

# Print stats for entire tree:
sub stats {
   if ( $Verbose >= 1 ) {
      say STDERR "\nStatistics for this tree:";
      say STDERR "Navigated $direcount directories.";
      say STDERR "Processed $filecount files.";
      say STDERR "Found $totfcount files matching given target and regexp.";
      say STDERR "Found $noexcount nonexistent directory entries.";
   }
   if ( $Verbose >= 2 ) {
      say    STDERR "\nDirectory entries encountered in this tree included:";
      printf STDERR "%7u tty files\n",                              $ottycount;
      printf STDERR "%7u character special files\n",                $cspccount;
      printf STDERR "%7u block special files\n",                    $bspccount;
      printf STDERR "%7u sockets\n",                                $sockcount;
      printf STDERR "%7u pipes\n",                                  $pipecount;
      printf STDERR "%7u symbolic links to nowhere\n",              $brkncount;
      printf STDERR "%7u symbolic links to directories\n",          $slkdcount;
      printf STDERR "%7u symbolic links to files\n",                $linkcount;
      printf STDERR "%7u symbolic links to weirdness\n",            $weircount;
      printf STDERR "%7u directories\n",                            $sdircount;
      printf STDERR "%7u regular files with multiple hard links\n", $hlnkcount;
      printf STDERR "%7u regular files\n",                          $regfcount;
      printf STDERR "%7u files of unknown type\n",                  $unkncount;
   }
   return 1;
} # end sub stats

# Print error and help messages and exit 666:
sub error ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $NA arguments, but \"find-files-by-type.pl\"
   requires 0, 1, or 2 arguments. Help follows:
   END_OF_ERROR
} # end error ($NA)

# Print help message:
sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to "find-files.pl", Robbie Hatley's excellent file-finding utility!
   This program finds directory entries in the current directory (and all
   subdirectories if a -r or --recurse option is used) which match a given
   file-name regular expression (defaulting to '.+' meaning "all files") and/or
   a given file-type predicate  (defaulting to '1'  meaning "all files"), and
   prints their full paths.

   If no predicate, no regexps, and no options are specified, this program prints
   all entries in the current directory, which probably isn't what you want,
   so I suggest using options and arguments to specify what you're looking for.

   Command lines:
   find-files-by-type.pl [-h|--help]              (to print help)
   find-files-by-type.pl [options] [arg1] [arg2]  (to find files)

   -------------------------------------------------------------------------------
   Description of options:

   Option:             Meaning:
   -h or --help        Print help and exit.
   -q or --quiet       Be quiet.                       (DEFAULT)
   -t or --terse       Be terse.
   -v or --verbose     Be verbose.
   -l or --local       Don't recurse subdirectories.   (DEFAULT)
   -r or --recurse     Do    recurse subdirectories.

   Multiple single-letter options may be piled-up after a single hyphen.
   For example, use -vr to verbosely and recursively search for files.

   If multiple conflicting options are given, later overrides earlier.

   If multiple conflicting letters are piled after a single colon, the result is
   determined by this descending order of precedence: hrlvq.

   All options  not listed above are ignored.

   (Note that a "target" option is NOT provided, as that would conflict with the
   whole idea of this program, which is to specify what types of files to look for
   by using Perl file-test boolean expressions.)

   -------------------------------------------------------------------------------
   Description of arguments:

   "find-files-by-type.pl" takes 0, 1, or 2 arguments.

   Providing no arguments will result in this program returning the paths of all
   regular files and directories, which probably not what you want.

   Argument 1 (optional), if present, must be a boolean expression using Perl
   file-test operators. The expression must be enclosed in parentheses (else
   this program will confuse your file-test operators for options), and then
   enclosed in single quotes (else the shell won't pass your expression to this
   program intact). Here are some examples of valid and invalid first arguments:

   '(-d && -l)'  # VALID:   Finds symbolic links to directories
   '(-l && !-d)' # VALID:   Finds symbolic links to non-directories
   '(-b)'        # VALID:   Finds block special files
   '(-c)'        # VALID:   Finds character special files
   '(-S || -p)'  # VALID:   Finds sockets and pipes.  (S must be CAPITAL S!  )

    '-d && -l'   # INVALID: missing parentheses       (confuses program      )
    (-d && -l)   # INVALID: missing quotes            (confuses shell        )
     -d && -l    # INVALID: missing parens AND quotes (confuses prgrm & shell)

   (Exception: Technically, you can use an integer as a boolean, and it doesn't
   need quotes or parentheses; but if you use an integer, any non-zero integer
   will print all paths and 0 will print no paths, so this isn't very useful.)

   Argument 2 (optional), if present, must be a Perl-Compliant Regular Expression
   specifying which file names to look for. To specify multiple patterns, use the
   | alternation operator. To apply pattern modifier letters, use an Extended
   RegExp Sequence. For example, if you want to search for items with names
   containing "cat", "dog", or "horse", title-cased or not, you could use this
   regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   If the number of arguments is not 0, 1, or 2, this program will print an
   error message and abort.

   (A number of arguments less than 0 will likely rupture our spacetime manifold
   and destroy everything. But if you DO somehow manage to use a negative number
   of arguments without destroying the universe, please send me an email at
   "Hatley.Software@gmail.com", because I'd like to know how you did that!)

   (But if you somehow manage to use a number of arguments which is an irrational
   or complex number, please keep THAT to yourself. Some things would be better
   for my sanity for me not to know. I don't want to find myself enthralled to
   Cthulhu.)

   -------------------------------------------------------------------------------
   Description of Operation:

   "find-files-by-type.pl" will first obtain a list of file records for all
   files matching the regex in Argument 2 (or qr/^.+$/ if no regex is given)
   in the current directory (and all subdirectories if a -r or --recurse option
   is used). Then for each file record matching the regex, the boolean expression
   given by Argument 1 (or '(-f || -d)' if no predicate is given) is then
   evaluated; if it is true, the file's path is printed; otherwise, the file is
   skipped.

   Happy file finding!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end help
