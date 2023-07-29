#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# find-files-by-type.pl
# Finds directory entries in current directory (and all subdirectories, unless a -l or --local option is used)
# by type, such as "regular file", "directory", "symbolic link", "socket", "pipe", "block special file",
# "character special file", or any boolean expression based on Perl file-type operators.
# Also allows specifying files by a RegExp to be matched against file names.
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

sub argv    ; # Process @ARGV.
sub curdire ; # Process current directory.
sub curfile ; # Process current file.
sub stats   ; # Print statistics.
sub error   ; # Handle errors.
sub help    ; # Print help and exit.

# ======= VARIABLES: =========================================================================================

# Settings:                      Meaning:                  Range:    Default:
   $,         = ', '         ; # Array formatting.         string    ', '
my $db        = 0            ; # Debug?                    bool      0 (don't debug)
my $Recurse   = 0            ; # Recurse subdirectories?   bool      0
my $Verbose   = 0            ; # Be wordy?                 bool      0
my $RegExp    = qr/^.+$/o    ; # Regular expression.       regexps   qr/^.+$/o (matches all files)
my $Predicate = '(-f || -d)' ; # File-test boolean.        bool      regular files and directories

# Counters:
my $direcount = 0            ; # Count of directories processed by curdire().
my $filecount = 0            ; # Count of files found which match target and regexp.
my $findcount = 0            ; # Count of files found which also match predicate.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   if ($Verbose) {
      print STDERR "\nNow entering program \"" . get_name_from_path($0) . "\".\n";
      print STDERR "Recurse   = $Recurse\n";
      print STDERR "RegExp    = $RegExp\n";
      print STDERR "Predicate = $Predicate\n";
   }
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $ms;
   if ($Verbose) {
      $ms = 1000 * (time - $t0);
      print  STDERR "\nNow exiting program \"" . get_name_from_path($0) . "\".\n";
      printf STDERR "Execution time was %.3fms.\n", $ms;
   }
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV:
sub argv {
   # Get options and arguments:
   my @options;
   my @arguments;
   for (@ARGV) {
      if (/^-[^-]+$/ || /^--[^-]+$/) {push @options  , $_}
      else                           {push @arguments, $_}
   }
   if ($db) {
      say "options   = (@options)";
      say "arguments = (@arguments)";
   }

   # Process options:
   for ( @options ) {
      if ( $_ =~ m/^-[^-]*h/ || $_ eq '--help'         ) {help; exit 777;}
      if ( $_ =~ m/^-[^-]*q/ || $_ eq '--quiet'        ) {$Verbose =  0 ;} # Be quiet.      (DEFAULT)
      if ( $_ =~ m/^-[^-]*v/ || $_ eq '--verbose'      ) {$Verbose =  1 ;} # Be verbose.
      if ( $_ =~ m/^-[^-]*l/ || $_ eq '--local'        ) {$Recurse =  0 ;} # Don't recurse. (DEFAULT)
      if ( $_ =~ m/^-[^-]*r/ || $_ eq '--recurse'      ) {$Recurse =  1 ;} # Recurse.
   }

   # Process arguments:
   my $NA = scalar(@arguments);
   if    ( 0 == $NA ) {
      ;                             # Do nothing. (Use default settings.)
   }
   elsif ( 1 == $NA ) {
      $Predicate = $arguments[0];   # Set predicate.
   }
   elsif ( 2 == $NA ) {
      $Predicate = $arguments[0];   # Set predicate.
      $RegExp = qr/$arguments[1]/;  # Set RegExp.
   }
   else               {
      error($NA);                   # Print error message.
      help();                       # Print help message.
      exit 666;                     # Exit, returning error code 666 to OS.
   }

   # Return success code 1 to caller:
   return 1;
} # end sub argv

# Process current directory:
sub curdire {
   # Increment directory counter:
   ++$direcount;

   # Get current working directory:
   my $cwd = d getcwd;

   # Announce $cwd if being verbose:
   print STDERR "\nDir # $direcount: $cwd\n\n" if $Verbose;

   # Return without doing anything further if $cwd is not a fully-qualified path to an existing directory:
   my $valid = is_valid_qual_dir($cwd);
   if ( ! $valid )
   {
      warn "Warning in \"find-files-by-type.pl\":\n" .
           "getcwd returned an invalid directory name.\n" .
           "Skipping this directory and moving on to next.\n\n";
      return 1;
   }

   # Get ref to array of file-info packets for all files in current directory matching 'A' and $RegExp:
   my $curdirfiles = GetFiles($cwd, 'A', $RegExp);

   # Print path for each matching file:
   foreach my $file (@{$curdirfiles}) {
      ++$filecount;
      local $_ = e $file->{Path};
      if (eval($Predicate)) {
         ++$findcount;
         say "$file->{Path}";
      }
   }

   # Return success code 1 to caller:
   return 1;
} # end sub curdire

# Print stats:
sub stats {
   # If being verbose, print stats for this program run:
   if ( $Verbose > 0 ) {
      print STDERR "\n";
      print STDERR "Statistics for \"find-files-by-type.pl\":\n";
      print STDERR "Navigated $direcount directories.\n";
      print STDERR "Found $filecount paths matching target \"A\" and regexp \"$RegExp\".\n";
      print STDERR "Found $findcount paths also matching predicate \"$Predicate\".\n";
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

   Welcome to "find-files-by-type.pl". This program finds directory entries in
   the current directory (and all subdirectories if a -r or --recurse option
   is used) which match a given file-type predicate (defaulting to '(-f || -d)')
   and which have names which match a given Perl-Compliant Regular Expression
   (defaulting to the regular expression '^.+$', which matches all file names)
   and prints their full paths.

   If no predicate, no regexps, and no options are specified, this program prints
   all files & dirs in the current directory, which probably isn't what you want,
   so I suggest using options and arguments to specify what you're looking for.

   Command lines:
   find-files-by-type.pl [-h|--help]              (to print help)
   find-files-by-type.pl [options] [arg1] [arg2]  (to find files)

   -------------------------------------------------------------------------------
   Description of options:

   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-l" or "--local"            Be local.                                (DEFAULT)
   "-r" or "--recurse"          Recurse subdirectories.
   "-q" or "--quiet"            Be quiet.                                (DEFAULT)
   "-v" or "--verbose"          Be verbose.
   Multiple single-letter options may be piled-up after a single hyphen, like so:
   find-files-by-type.pl -rv '(-c || -b)'
   If multiple conflicting options are given, the last dominates.
   If multiple conflicting letters are piled after a single colon,
   the last of these dominates: hqvlrfdba.
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
