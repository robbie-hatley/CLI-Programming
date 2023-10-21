#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# Template.pl
# This file serves as a template for making new file and directory maintenance scripts.
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
# Sun Aug 06, 2023: Improvements to argv, error, and help. Added $Predicate.
# Sat Aug 12, 2023: Fixed wrong width in colophon.
# Mon Aug 21, 2023: An "option" is now "one or two hyphens followed by 1-or-more word characters".
#                   Reformatted debug printing of opts and args to ("word1", "word2", "word3") style.
#                   Inserted text into help explaining the use of "--" as "end of options" marker.
# Thu Aug 24, 2023: Redefined what characters may exist in options:
#                   short option = 1 hyphen , NOT followed by a hyphen, followed by [a-zA-Z0-9]+
#                   long  option = 2 hyphens, NOT followed by a hyphen, followed by [a-zA-Z0-9-=.]+
#                   I use negative look-aheads to check for "NOT followed by a hyphen".
#                   Got rid of "o" option on qr// (unnecessary). Put "\$" before variable names to be printed.
#                   Removed code that exits after printing settings if debugging. Inserted code that puts
#                   program in "simulate" mode near bottom of curfile() if debugging. Fixed bug in which "-"
#                   was being interpretted as "character range" instead of "hyphen", by changing
#                   "$d = [a-zA-Z0-9-=.]+" to "$d = [a-zA-Z0-9=.-]+". Added "nodebug" option. Fixed bug in
#                   which curfile was never being called.
# Mon Aug 28, 2023: Clarified sub argv().
#                   Got rid of "/...|.../" in favor of "/.../ || /.../" (speeds-up program).
#                   Simplified way in which options and arguments are printed if debugging.
#                   Removed "$" = ', '" and "$, = ', '". Got rid of "/o" from all instances of qr().
#                   Changed all "$db" to $Db". Debugging now simulates renames instead of exiting in main.
#                   Removed "no debug" option as that's already default in all of my programs.
# Fri Sep 01, 2023: Entry & exit messages are now printed regardless, to STDERR.
#                   STDERR = entry & exit messages, stats, diagnostics, and severe errors.
#                   STDOUT = directories ("Dir # 27: Dogs") and files ("Successfully renamed asdf to yuio").
#                   Stats also go to STDERR, but are controlled by verbosity level (0=none, 1=some, 2=all).
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
use warnings FATAL => 'utf8';

use Sys::Binmode;
use Cwd;
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
my $Db        = 0            ; # Debug?                      bool       Don't debug.
my $Verbose   = 0            ; # Be wordy?                   0,1,2      Be quiet.
my $Recurse   = 0            ; # Recurse subdirectories?     bool       Be local.
my $Target    = 'A'          ; # Files, dirs, both, all?     F|D|B|A    Process all file types.
my $RegExp    = qr/^.+$/     ; # Regular expression.         regexp     Process all file names.
my $Predicate = 1            ; # Boolean predicate.          bool       Process all file types.

# Counts of events in this program:
my $direcount = 0 ; # Count of directories processed by curdire().
my $filecount = 0 ; # Count of files found which match file-name regexp.
my $predcount = 0 ; # Count of files found which also match file-type predicate.

# Accumulations of counters from RH::Dir::GetFiles():
my $totfcount = 0 ; # Count of all directory entries encountered.
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
   # Set time and program variables:
   my $t0 = time;
   my $pname = substr $0, 1 + rindex $0, '/';

   # Process @ARGV:
   argv;

   # Print entry message if being terse or verbose:
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

   # Print exit message if being terse or verbose:
   if ( $Verbose >= 1 ) {
      say    STDERR '';
      say    STDERR "Now exiting program \"$pname\".";
      printf STDERR "Execution time was %.3f seconds.", time - $t0;
   }

   # Exit program, returning success code "0" to caller:
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV :
sub argv {
   # Get options and arguments:
   my @opts = ();            # options
   my @args = ();            # arguments
   my $end = 0;              # end-of-options flag
   my $s = '[a-zA-Z0-9]';    # single-hyphen allowable chars (English letters, numbers)
   my $d = '[a-zA-Z0-9=.-]'; # double-hyphen allowable chars (English letters, numbers, equal, dot, hyphen)
   for ( @ARGV ) {
      /^--$/                 # "--" = end-of-options marker = construe all further CL items as arguments,
      and $end = 1           # so if we see that, then set the "end-of-options" flag
      and next;              # and skip to next element of @ARGV.
      !$end                  # If we haven't yet reached end-of-options,
      && ( /^-(?!-)$s+$/     # and if we get a valid short option
      ||  /^--(?!-)$d+$/ )   # or a valid long option,
      and push @opts, $_     # then push item to @opts
      or  push @args, $_;    # else push item to @args.
   }

   # Process options:
   for ( @opts ) {
      /^-$s*h/ || /^--help$/    and help and exit 777 ;
      /^-$s*e/ || /^--debug$/   and $Db      =  1     ;
      /^-$s*q/ || /^--quiet$/   and $Verbose =  0     ;
      /^-$s*t/ || /^--terse$/   and $Verbose =  1     ;
      /^-$s*v/ || /^--verbose$/ and $Verbose =  2     ;
      /^-$s*l/ || /^--local$/   and $Recurse =  0     ;
      /^-$s*r/ || /^--recurse$/ and $Recurse =  1     ;
      /^-$s*f/ || /^--files$/   and $Target  = 'F'    ;
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

   # Use all arguments as RegExps?
   # my $re; $NA >= 1 and $re = join '|', @args and $RegExp = qr/$re/o;

   # Use positional arguments instead?
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
   my $cwd = d getcwd;

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

   # Process each path that matches $RegExp, $Target, and $Predicate:
   foreach my $file (sort {$a->{Name} cmp $b->{Name}} @$curdirfiles) {
      ++$filecount;
      local $_ = e $file->{Path};
      if (eval($Predicate)) {
         ++$predcount;
         curfile($file);
      }
   }

   # Return success code 1 to caller:
   return 1;
} # end sub curdire

# Process current file:
sub curfile ($file) {
   # Get path:
   my $path = $file->{Path};

   # Announce path:
   if ( $Db ) {
      say STDOUT "Simulate: $path";
      # (Don't actually DO anything to file at $path.)
   }
   else {
      say STDOUT "Activate: $path";
      # (Insert code here to DO something to file at $path.)
   }

   # Return success code 1 to caller:
   return 1;
} # end sub curfile

# Print statistics for this program run:
sub stats {
   if ( $Verbose >= 1 ) {
      say    STDERR '';
      say    STDERR 'Statistics for this directory tree:';
      say    STDERR "Navigated $direcount directories.";
      say    STDERR "Found $filecount files matching regexp \"$RegExp\" and target \"$Target\".";
      say    STDERR "Found $predcount files which also match predicate \"$Predicate\".";
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
sub error ($err_msg) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $err_msg arguments, but this program takes at most
   # arguments, which must be blah blah blah. Help follows:
   END_OF_ERROR
   return 1;
} # end sub error

# Print help:
sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "[insert Program Name here]". This program does blah blah blah
   to all files in the current directory (and all subdirectories if a -r or
   --recurse option is used).

   -------------------------------------------------------------------------------
   Command lines:

   program-name.pl -h | --help                       (to print this help and exit)
   program-name.pl [options] [Arg1] [Arg2] [Arg3]    (to [perform funciton] )

   -------------------------------------------------------------------------------
   Description of options:

   Option:            Meaning:
   -h or --help       Print help and exit.
   -e or --debug      Print diagnostics.
   -q or --quiet      Be quiet.                         (DEFAULT)
   -t or --terse      Be terse.
   -v or --verbose    Be verbose.
   -l or --local      DON'T recurse subdirectories.     (DEFAULT)
   -r or --recurse    DO    recurse subdirectories.
   -f or --files      Target Files.
   -d or --dirs       Target Directories.
   -b or --both       Target Both.
   -a or --all        Target All.                       (DEFAULT)
         --           End of options (all further CL items are arguments).

   Multiple single-letter options may be piled-up after a single hyphen.
   For example, use -vr to verbosely and recursively process items.

   If multiple conflicting separate options are given, later overrides earlier.
   If multiple conflicting single-letter options are piled after a single hyphen,
   the result is determined by this descending order of precedence: heabdfrlvtq.

   If you want to use an argument that looks like an option (say, you want to
   search for files which contain "--recurse" as part of their name), use a "--"
   option; that will force all command-line entries to its right to be considered
   "arguments" rather than "options".

   All options not listed above are ignored.

   -------------------------------------------------------------------------------
   Description of arguments:

   In addition to options, this program can take 1 or 2 optional arguments.

   Arg1 (OPTIONAL), if present, must be a Perl-Compliant Regular Expression
   specifying which file names to process. To specify multiple patterns, use the
   | alternation operator. To apply pattern modifier letters, use an Extended
   RegExp Sequence. For example, if you want to process items with names
   containing "cat", "dog", or "horse", title-cased or not, you could use this
   regexp: '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   Arg2 (OPTIONAL), if present, must be a boolean predicate using Perl
   file-test operators. The expression must be enclosed in parentheses (else
   this program will confuse your file-test operators for options), and then
   enclosed in single quotes (else the shell won't pass your expression to this
   program intact). If this argument is used, it overrides "--files", "--dirs",
   or "--both", and sets target to "--all" in order to avoid conflicts with
   the predicate. Here are some examples of valid and invalid predicate arguments:
   '(-d && -l)'  # VALID:   Finds symbolic links to directories
   '(-l && !-d)' # VALID:   Finds symbolic links to non-directories
   '(-b)'        # VALID:   Finds block special files
   '(-c)'        # VALID:   Finds character special files
   '(-S || -p)'  # VALID:   Finds sockets and pipes.  (S must be CAPITAL S   )
    '-d && -l'   # INVALID: missing parentheses       (confuses program      )
    (-d && -l)   # INVALID: missing quotes            (confuses shell        )
     -d && -l    # INVALID: missing parens AND quotes (confuses prgrm & shell)

   (Exception: Technically, you can use an integer as a boolean, and it doesn't
   need quotes or parentheses; but if you use an integer, any non-zero integer
   will process all paths and 0 will process no paths, so this isn't very useful.)

   Arguments and options may be freely mixed, but the arguments must appear in
   the order Arg1, Arg2 (RegExp first, then File-Type Predicate); if you get them
   backwards, they won't do what you want, as most predicates aren't valid regexps
   and vice-versa.

   A number of arguments greater than 2 will cause this program to print an error
   message and abort.

   A number of arguments less than 0 will likely rupture our spacetime manifold
   and destroy everything. But if you DO somehow manage to use a negative number
   of arguments without destroying the universe, please send me an email at
   "Hatley.Software@gmail.com", because I'd like to know how you did that!

   But if you somehow manage to use a number of arguments which is an irrational
   or complex number, please keep THAT to yourself. Some things would be better
   for my sanity for me not to know. I don't want to find myself enthralled to
   Cthulhu.

   Happy item processing!

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
__END__
