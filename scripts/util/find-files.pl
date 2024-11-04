#!/usr/bin/env -S perl -C63

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
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
# Thu Aug 31, 2023: Clarified sub argv().
#                   Got rid of "/...|.../" in favor of "/.../ || /.../" (speeds-up program).
#                   Simplified way in which options and arguments are printed if debugging.
#                   Removed "$" = ', '" and "$, = ', '". Got rid of "/o" from all instances of qr().
#                   Changed all "$db" to $Db". Debugging now simulates renames instead of exiting in main.
#                   Removed "no debug" option as that's already default in all of my programs.
#                   $Verbose now means "print directories". Everything else is now printed regardless.
#                   STDERR = "stats and serious errors". STDOUT = "files found, and dirs if being verbose".
# Fri Sep 01, 2023: Got rid of $Db and -e and --debug (not necessary).
# Tue Sep 05, 2023: That was stupid. Added $Db, -e, --debug back in. Improved help. Changed default target
#                   from 'F' to 'A' so as not to conflict with predicates. Entry/stats/exit messages are
#                   now printed to STDERR only if $Verbose >= 1. Directory headings are printed to STDOUT
#                   only if $Verbose >= 2. Found paths are printed to STDOUT regardless of verbosity level.
# Wed Sep 06, 2023: Set default target back to 'F', and set predicate to override target and force it to 'A'.
# Mon Jul 22, 2024: Fixed minor typos in error() and help() functions.
# Thu Aug 15, 2024: -C63; got rid of unnecessary "use" statements.
##############################################################################################################

use v5.36;
use utf8;
use Cwd 'getcwd';
use Time::HiRes 'time';
use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ; # Process @ARGV.
sub curdire ; # Process current directory.
sub curfile ; # Process current file.
sub stats   ; # Print statistics.
sub error   ; # Handle errors.
sub help    ; # Print help and exit.

# ======= VARIABLES: =========================================================================================

# Setting:      Default Value:   Meaning of Setting:         Range:     Meaning of Default:
my $Db        = 0            ; # Print diagnostics?          bool       Don't print diagnostics.
my $Verbose   = 1            ; # Quiet, terse, or verbose?   0,1,2      Be terse.
my $Recurse   = 0            ; # Recurse subdirectories?     bool       Be local.
my $Target    = 'F'          ; # Files, dirs, both, all?     F|D|B|A    Find all directory entries.
my $RegExp    = qr/^.+$/     ; # Regular expression.         regexp     Find all file names.
my $Predicate = 1            ; # Boolean predicate.          bool       Find all file-type combos.

# Counters:
my $direcount = 0 ; # Count of directories processed by curdire().
my $filecount = 0 ; # Count of files found which match $RegExp and $Target.
my $predcount = 0 ; # Count of files found which also match $Predicate.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   # Set time and program variables:
   my $t0 = time;
   my $pname = substr $0, 1 + rindex $0, '/';

   # Process @ARGV:
   argv;

   # Print entry message if being at least somewhat verbose:
   if ( $Verbose >= 1 ) {
      say    STDERR '';
      say    STDERR "Now entering program \"$pname\"." ;
      say    STDERR "\$Db        = $Db"        ;
      say    STDERR "\$Verbose   = $Verbose"   ;
      say    STDERR "\$Recurse   = $Recurse"   ;
      say    STDERR "\$Target    = $Target"    ;
      say    STDERR "\$RegExp    = $RegExp"    ;
      say    STDERR "\$Predicate = $Predicate" ;
   }

   # Process current directory (and all subdirectories if recursing):
   $Recurse and RecurseDirs {curdire} or curdire;

   # Print stats:
   stats;

   # Print exit message if being at least somewhat verbose:
   if ( $Verbose >= 1 ) {
      say    STDERR '';
      say    STDERR "Now exiting program \"$pname\".";
      printf STDERR "Execution time was %.3f seconds.", time - $t0;
   }

   # Exit program, returning success code "0" to caller:
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV:
sub argv {
   # Get options and arguments:
   my @opts = ();             # options
   my @args = ();             # arguments
   my $end = 0;               # end-of-options flag
   my $s = '[a-zA-Z0-9]';     # single-hyphen allowable chars (English letters, numbers)
   my $d = '[a-zA-Z0-9=.-]';  # double-hyphen allowable chars (English letters, numbers, equal, dot, hyphen)
   for ( @ARGV ) {
      /^--$/                  # "--" = end-of-options marker = construe all further CL items as arguments,
      and $end = 1            # so if we see that, then set the "end-of-options" flag
      and next;               # and skip to next element of @ARGV.
      !$end                   # If we haven't yet reached end-of-options,
      && ( /^-(?!-)$s+$/      # and if we get a valid short option
      ||   /^--(?!-)$d+$/ )   # or a valid long option,
      and push @opts, $_      # then push item to @opts
      or  push @args, $_;     # else push item to @args.
   }

   # Process options:
   for ( @opts ) {
      /^-$s*h/ || /^--help$/    and help and exit 777 ;
      /^-$s*e/ || /^--debug$/   and $Db      =  1     ;
      /^-$s*q/ || /^--quiet$/   and $Verbose =  0     ;
      /^-$s*t/ || /^--terse$/   and $Verbose =  1     ; # DEFAULT
      /^-$s*v/ || /^--verbose$/ and $Verbose =  2     ;
      /^-$s*l/ || /^--local$/   and $Recurse =  0     ; # DEFAULT
      /^-$s*r/ || /^--recurse$/ and $Recurse =  1     ;
      /^-$s*f/ || /^--files$/   and $Target  = 'F'    ; # DEFAULT
      /^-$s*d/ || /^--dirs$/    and $Target  = 'D'    ;
      /^-$s*b/ || /^--both$/    and $Target  = 'B'    ;
      /^-$s*a/ || /^--all$/     and $Target  = 'A'    ;
   }
   if ( $Db ) {
      say STDERR '';
      say STDERR "\$opts = (", join(', ', map {"\"$_\""} @opts), ')';
      say STDERR "\$args = (", join(', ', map {"\"$_\""} @args), ')';
   }

   # Process arguments:
   my $NA = scalar(@args);     # Get number of arguments.
   if ( $NA >= 1 ) {           # If number of arguments >= 1,
      $RegExp = qr/$args[0]/;  # set $RegExp to $args[0].
   }
   if ( $NA >= 2 ) {           # If number of arguments >= 2,
      $Predicate = $args[1];   # set $Predicate to $args[1]
      $Target = 'A';           # and set $Target to 'A' to avoid conflicts with $Predicate.
   }
   if ( $NA >= 3 && !$Db ) {   # If number of arguments >= 3 and we're not debugging,
      error($NA);              # print error message,
      help;                    # and print help message,
      exit 666;                # and exit, returning The Number Of The Beast.
   }

   # Return success code 1 to caller:
   return 1;
} # end sub argv

# Process current directory:
sub curdire {
   # Increment directory counter:
   ++$direcount;

   # Get current working directory:
   my $curdir = d getcwd;

   # Announce $curdir if being VERY verbose:
   if ( $Verbose >= 2 ) {
      say STDOUT '';
      say STDOUT "Dir # $direcount: $curdir";
      say STDOUT '';
   }

   # Get ref to array of file-info hashes for all files in $curdir matching $Target and $RegExp:
   my $curdirfiles = GetFiles($curdir, $Target, $RegExp);

   # Process each path that matches $RegExp, $Target, and $Predicate:
   foreach my $file (@{$curdirfiles}) {
      ++$filecount;
      local $_ = e $file->{Path};
      if (eval($Predicate)) {
         ++$predcount;
         say STDOUT "$file->{Path}";
      }
   }

   # Return success code 1 to caller:
   return 1;
} # end sub curdire

# Print stats, if being terse or verbose:
sub stats {
   if ( $Verbose >= 1 ) {
      say STDERR '';
      say STDERR 'Statistics for this directory tree:';
      say STDERR "Navigated $direcount directories.";
      say STDERR "Found $filecount files matching regexp \"$RegExp\" and target \"$Target\".";
      say STDERR "Found $predcount files which also match predicate \"$Predicate\".";
   }
   return 1;
} # end sub stats

# Print error and help messages and exit 666:
sub error ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $NA arguments, but \"find-files.pl\"
   requires 0, 1, or 2 arguments. Help follows:
   END_OF_ERROR
} # end error

# Print help message:
sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "find-files.pl", Robbie Hatley's excellent file-finding utility!
   By default, this program finds all directory entries in the current working
   directory which match a given file-name regular expression
   (defaulting to '^.+$' meaning "all files") and file-type predicate
   (defaulting to '1'    meaning "all files"), and prints their full paths.

   Item types may be restricted to "regular files", "directories", or "both"
   by using appropriate options (see "Options" section below) or by using a
   file-type predicate (see "Arguments" section below).

   All subdirectories of the current working directory my be searched by using a
   "-r" or "--recurse" option.

   If no options, no regexp, and no predicate are specified, this program prints
   the paths of all regular files in the current working directory, which probably
   isn't what you want ("ls" is better for that), so I suggest using options and
   arguments to specify which items you're looking for.

   -------------------------------------------------------------------------------
   Command lines:

   find-files.pl [-h|--help]               (to print help)
   find-files.pl [options] [Arg1] [Arg2]   (to find files)

   -------------------------------------------------------------------------------
   Description of options:

   Option:            Meaning:
   -h or --help       Print help and exit.
   -e or --debug      Print diagnostics.
   -q or --quiet      Don't print stats or directories.
   -t or --terse      Print stats but  not directories.   (DEFAULT)
   -v or --verbose    Print both stats AND directories.
   -l or --local      Don't recurse subdirectories.       (DEFAULT)
   -r or --recurse    Do    recurse subdirectories.
   -f or --files      Target Files.
   -d or --dirs       Target Directories.
   -b or --both       Target Both.
   -a or --all        Target All.                         (DEFAULT)
         --           End of options (all further CL items are arguments).

   Multiple single-letter options may be piled-up after a single hyphen.
   For example, use -vrf to verbosely and recursively search for files.

   If multiple conflicting separate options are given, later overrides earlier.
   If multiple conflicting single-letter options are piled after a single colon,
   the result is determined by this descending order of precedence: heabdfrlvq.

   If you want to use an argument that looks like an option (say, you want to
   search for files which contain "--recurse" as part of their name), use a "--"
   option; that will force all command-line entries to its right to be considered
   "arguments" rather than "options".

   All options not listed above are ignored.

   -------------------------------------------------------------------------------
   Description of arguments:

   "find-files.pl" takes 0, 1, or 2 arguments.

   Arg1 (OPTIONAL), if present, must be a Perl-Compliant Regular Expression
   specifying which file names to look for. To specify multiple patterns, use the
   | alternation operator. To apply pattern modifier letters, use an Extended
   RegExp Sequence. For example, if you want to search for items with names
   containing "cat", "dog", or "horse", title-cased or not, you could use this:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   Arg2 (OPTIONAL), if present, must be a boolean predicate using Perl
   file-test operators. The expression must be enclosed in parentheses (else
   this program will confuse your file-test operators for options), and then
   enclosed in single quotes (else the shell won't pass your expression to this
   program intact). If this argument is used, it overrides "--files", "--dirs",
   or "--both", and sets target to "--all" in order to avoid conflicts with
   the predicate.

   Here are some examples of valid and invalid predicate arguments:
   '(-d && -l)'   # VALID:   Finds symbolic links to directories
   '(-l && !-d)'  # VALID:   Finds symbolic links to non-directories
   '(-b)'         # VALID:   Finds block special files
   '(-c)'         # VALID:   Finds character special files
   '(-f&&(-M)<3)' # VALID:   Finds regular files modified less than 3 days ago.
   '(-f&&(-A)<3)' # VALID:   Finds regular files accessed less than 3 days ago.
   '(-f&&(-C)<3)' # VALID:   Finds regular files created  less than 3 days ago.
   '(-f&&(-s)>100000000)' # VALID: Finds regular files bigger than 100MB.
   '(-S || -p)'   # VALID:   Finds sockets and pipes.
    '-d && -l'    # INVALID: missing parentheses       (confuses program      )
    (-d && -l)    # INVALID: missing quotes            (confuses shell        )
     -d && -l     # INVALID: missing parens AND quotes (confuses prgrm & shell)

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
   option ("--files" is assumed if no target is specified).

   Then for each file record matching the regex and target, the boolean expression
   given by Arg2 (or 1 if no predicate is given) is then evaluated; if it is true,
   the file's path is printed; otherwise, the file is skipped. If recursing, this
   procedure is also followed for each subdirectory of the the current directory;
   otherwise, only the current directory is searched.

   Example #1: The following would look for all sockets with names containing
   "pig" or "Pig", in the current directory and all subdirectories, and also print
   stats and directories:
   find-files.pl -arv '(?i:p)ig' '(-S)'

   Example #2: The following will find all block-special and character-special
   files in the current directory with names containing '435', and would print
   the paths and stats, but not directories:
   find-files.pl '435' '(-b || -c)'

   Example #3: The following will find all symbolic links in all subdirectories
   and print their paths, but won't print any entry or exit message, stats, or
   directory headings at all. Note that because this program uses "positional"
   arguments, the regexp argument can't be skipped, but it can be "bypassed" by
   setting it to '.+' meaning "some characters":
   find-files.pl -rq '.+' '(-l)'

   Happy file finding!

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end help
