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
# Fri Jul 28, 2023: Reduced width from 120 to 110 for Github. Got rid of "common::sense" (antiquated).
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
#                   Added file-type counts back in and made $Verbose trinary.
# Tue Aug 01, 2023: Took file-type counts back OUT and reverted $Verbose back to binary. Just not necessary.
#                   Corrected "count of files matching predicate is NOT reported by stats" bug.
#                   Corrected error in help in which the order of Arg1 and Arg2 was presented backwards.
# Thu Aug 03, 2023: Improved help. Re-instated "$Target". Re-instated "--local" and "--quiet".
#                   Now using "$pname" for program name to clean-up main body of program.
# Tue Aug 15, 2023: Disabled "Filesys::Type": slow, buggy, and unnecessary.
# Mon Aug 21, 2023: An "option" is now "one or two hyphens followed by 1-or-more word characters".
#                   Reformatted debug printing of opts and args to ("word1", "word2", "word3") style.
#                   Inserted text into help explaining the use of "--" as "end of options" marker.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;

use Sys::Binmode;
use Cwd;
#use Filesys::Type 'fstype';
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

# Setting:      Default Value:   Meaning of Setting:         Range:     Meaning of Default:
   $"         = ', '         ; # Quoted-array formatting.    string     Separate elements with comma space.
my $db        = 0            ; # Debug?                      bool       Don't debug.
my $Verbose   = 0            ; # Be wordy?                   bool       Be quiet.
my $Recurse   = 0            ; # Recurse subdirectories?     bool       Be local.
my $RegExp    = qr/^.+$/o    ; # Regular expression.         regexp     Process all file names.
my $Target    = 'A'          ; # Files, dirs, both, all?     F|D|B|A    Process all file types.
my $Predicate = 1            ; # Boolean predicate.          bool       Process all file types.

# Counters:
my $direcount = 0 ; # Count of directories processed by curdire().
my $filecount = 0 ; # Count of files found which match file-name regexp.
my $findcount = 0 ; # Count of files found which also match file-type predicate.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   my $pname = get_name_from_path($0);
   argv;
   if ( $Verbose >= 1 ) {
      say STDERR '';
      say STDERR "Now entering program \"$pname\". ";
      say STDERR "Verbose   = $Verbose             ";
      say STDERR "Recurse   = $Recurse             ";
      say STDERR "RegExp    = $RegExp              ";
      say STDERR "Target    = $Target              ";
      say STDERR "Predicate = $Predicate           ";
   }
   if ( $db ) {exit 555}

   $Recurse and RecurseDirs {curdire} or curdire;

   stats;
   my $ms = 1000 * (time - $t0);
   if ( $Verbose >= 1 ) {
      printf STDERR "\nNow exiting program \"%s\". Execution time was %.3fms.\n", $pname, $ms;
   }
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV:
sub argv {
   # Get options and arguments:
   my @opts = (); my @args = (); my $end_of_options = 0;
   for ( @ARGV ) {
      /^--$/ and $end_of_options = 1 and next;
      !$end_of_options && /^--?\w+$/ and push @opts, $_ or push @args, $_;
   }

   # Process options:
   for ( @opts ) {
      /^-\w*h|^--help$/     and help and exit 777 ;
      /^-\w*e|^--debug$/    and $db      =  1     ;
      /^-\w*q|^--quiet$/    and $Verbose =  0     ;
      /^-\w*t|^--terse$/    and $Verbose =  1     ;
      /^-\w*v|^--verbose$/  and $Verbose =  2     ;
      /^-\w*l|^--local$/    and $Recurse =  0     ;
      /^-\w*r|^--recurse$/  and $Recurse =  1     ;
      /^-\w*f|^--files$/    and $Target  = 'F'    ;
      /^-\w*d|^--dirs$/     and $Target  = 'D'    ;
      /^-\w*b|^--both$/     and $Target  = 'B'    ;
      /^-\w*a|^--all$/      and $Target  = 'A'    ;
   }
   if ( $db ) {
      say   STDERR '';
      print STDERR "opts = ("; print STDERR map {'"'.$_.'"'} @opts; say STDERR ')';
      print STDERR "args = ("; print STDERR map {'"'.$_.'"'} @args; say STDERR ')';
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

#  # Get file-system type:
#  my $fst = fstype("'$curdir'");

   # Announce $curdir if being verbose:
   if ( $Verbose >= 1 ) {
      say STDERR "\nDir # $direcount: $curdir";
#     say STDERR "File-system type: $fst\n";
   }

   # Get ref to array of file-info packets for all files in current directory matching 'A' and $RegExp:
   my $curdirfiles = GetFiles($curdir, $Target, $RegExp);

   # Process each path that matches $RegExp, $Target, and $Predicate:
   foreach my $file (@{$curdirfiles}) {
      ++$filecount;
      local $_ = e $file->{Path};
      if (eval($Predicate)) {
         ++$findcount;
         say STDOUT "$file->{Path}";
      }
   }

   # Return success code 1 to caller:
   return 1;
} # end sub curdire

# Print stats, if being verbose:
sub stats {
   if ( $Verbose >= 1 ) {
      say    STDERR '';
      say    STDERR 'Statistics for this directory tree:';
      say    STDERR "Navigated $direcount directories.";
      say    STDERR "Found $filecount files matching regexp \"$RegExp\" and target \"$Target\".";
      say    STDERR "Found $findcount files which also match predicate \"$Predicate\".";
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

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "find-files.pl", Robbie Hatley's excellent file-finding utility!
   This program finds directory entries in the current directory (and all
   subdirectories if a -r or --recurse option is used) which match a given
   file-name regular expression (defaulting to '^.+$' meaning "all files") and/or
   a given file-type predicate  (defaulting to '1'    meaning "all files"),
   and prints their full paths.

   If no predicate, no regexps, and no options are specified, this program prints
   the paths of all entries in the current directory, which probably isn't what
   you want, so I suggest using options and arguments to specify what you're
   looking for.

   -------------------------------------------------------------------------------
   Command lines:

   find-files-by-type.pl [-h|--help]              (to print help)
   find-files-by-type.pl [options] [Arg1] [Arg2]  (to find files)

   -------------------------------------------------------------------------------
   Description of options:

   Option:            Meaning:
   -h or --help       Print help and exit.
   -e or --debug      Print diagnostics and exit.
   -q or --quiet      Be quiet.                       (DEFAULT)
   -t or --terse      Be terse.
   -v or --verbose    Be verbose.
   -l or --local      Don't recurse subdirectories.   (DEFAULT)
   -r or --recurse    Do    recurse subdirectories.
   -f or --files      Target Files.
   -d or --dirs       Target Directories.
   -b or --both       Target Both.
   -a or --all        Target All.                     (DEFAULT)
         --           End of options (all further CL items are arguments).

   Multiple single-letter options may be piled-up after a single hyphen.
   For example, use -vr to verbosely and recursively process items.

   If multiple conflicting separate options are given, later overrides earlier.
   If multiple conflicting single-letter options are piled after a single colon,
   the result is determined by this descending order of precedence: heabdfrlvtq.

   If you want to use an argument that looks like an option (say, you want to
   search for files which contain "--recurse" as part of their name), use a "--"
   option; that will force all command-line entries to its right to be considered
   "arguments" rather than "options".

   All options not listed above are ignored.

   -------------------------------------------------------------------------------
   Description of arguments:

   "find-files-by-type.pl" takes 0, 1, or 2 arguments.

   Providing no arguments will result in this program returning the paths of all
   entries in the current directory, which is probably not what you want.

   Arg1 (OPTIONAL), if present, must be a Perl-Compliant Regular Expression
   specifying which file names to look for. To specify multiple patterns, use the
   | alternation operator. To apply pattern modifier letters, use an Extended
   RegExp Sequence. For example, if you want to search for items with names
   containing "cat", "dog", or "horse", title-cased or not, you could use this
   regexp: '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   Arg2 (OPTIONAL), if present, must be a boolean expression using Perl
   file-test operators. The expression must be enclosed in parentheses (else
   this program will confuse your file-test operators for options), and then
   enclosed in single quotes (else the shell won't pass your expression to this
   program intact). Here are some examples of valid and invalid second arguments:

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

   Arguments and options may be freely mixed, but the arguments must appear in
   the order Arg1, Arg2 (RegExp first, then File-Type Predicate); if you get them
   backwards, they won't do what you want, as most predicates aren't valid regexps
   and vice-versa.

   If the number of arguments is not 0, 1, or 2, this program will print an
   error message and abort.

   -------------------------------------------------------------------------------
   Description of Operation:

   "find-files.pl" will first obtain a list of file records for all files
   matching the regex in Arg1 (or '^.+$' if no regex is given) in the current
   directory, and the target given by a "--files", "--dirs", "--both", or "--all"
   option (or "A" if no target is specified).

   Then for each file record matching the regex and target, the boolean expression
   given by Arg2 (or 1 if no predicate is given) is then evaluated; if it is true,
   the file's path is printed; otherwise, the file is skipped. If recursing, this
   procedure is also followed for each subdirectory of the the current directory;
   otherwise, only the current directory is searched.

   For one example, the following would look for all sockets with names containing
   "pig" or "Pig", in all subdirectories of the current directory, and also print
   relevant statistics:
   find-files.pl -rv '(?i:p)ig' '(-S)'

   For another example, the following would find all block-special and
   character-special files in the current directory with names containing '435',
   and would print just the paths, not any statistics:
   find-files.pl '435' '(-b || -c)'

   Happy file finding!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end help
