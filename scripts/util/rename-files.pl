#! /bin/perl -CSDA

# This is a 110-character-wide UTF-8 Unicode Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# rename-files.pl
# Robbie Hatley's Nifty Regular-Expression-Based File Renaming Utility.
# Written by Robbie Hatley.
# Edit history:
# Mon Apr 20, 2015: Started writing it on or about this date.
# Fri Apr 24, 2015: Made many changes. Added options, help, recursal.
# Wed May 15, 2015: Changed Help() to "here document" format.
# Tue Jun 02, 2015: Made various corrections and improvements.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Wed Feb 17, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory as
#                   its first argument, target as second, and regexp (instead of wildcard) as third.
# Tue Nov 16, 2021: Now using common::sense, and now using extended regexp sequences instead of regexp
#                   delimiters.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "Sys::Binmode".
# Thu Jul 27, 2023: Heavily refactored. Reduced width from 120 to 110 with github in-mind. Upgraded from
#                   "use v5.32;" to "use v5.36;". Got rid of prototypes. Sub "error" is now "error($NA)".
#                   Single-letter options can now be piled-up after a single hyphen. Got rid of
#                   "common::sense" (antiquated). Sub "error" now prints error message ONLY (doesn't run help
#                   or exit; those are called from argv). Still using obsolete given/when via "experimental".
# Sat Jul 29, 2023: Got rid of all uses of "given" and "when". Also, I'm now sending all printing to STDERR
#                   except for printing each matching path to STDOUT. That way a 1> redirect should print
#                   matching paths only, and a 2> redirect should print diagnostics only.
# Sun Jul 30, 2023: Used hashes of Modes and Targets to print settings at start of program run, fixed
#                   formatting of execution time, and changed default target to "F" instead of "A".
# Mon Jul 31, 2023: Cleaned up formatting and comments. Fine-tuned definitions of "option" and "argument".
#                   Fixed bug in which $, was being set instead of $" .
#                   Got rid of "--target=xxxx" options in favor of just "--xxxx".
#                   Got rid of "--mode=xxxx"   options in favor of just "--xxxx".
# Tue Aug 01, 2023: Improved help.
# Thu Aug 03, 2023: Now using "my $curdir = d getcwd" instead of "my $curdir = cwd_utf8;".
#                   Fixed execution-time bug (wasn't printing "ms"). Improved help.
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

sub argv         ;
sub rename_files ;
sub stats        ;
sub error        ;
sub help         ;

# ======= VARIABLES: =========================================================================================

# Settings:     Default Value:   Meaning of Setting:                 Range           Default
   $"         = ', '         ; # Quoted-array formatting.            string          Comma space.
my $db        = 0            ; # Debug?                              bool            Don't debug.
my $Recurse   = 0            ; # Recurse subdirectories?             bool            Be local.
my $Mode      = 'P'          ; # Prompt mode                         P|S|Y           Prompt user.
my $Target    = 'F'          ; # Files, directories, both, or All?   F|D|B|A         Regular files only.
my $RegExp    = qr/^(.+)$/o  ; # RegExp.                             RegExp          Match all file names.
my $Replace   = '$1'         ; # Replacement string.                 string          Repl. is same as match.
my $Flags     = ''           ; # Flags for s/// operator.            imsxopdualgre   No flags.
my $Verbose   = 0            ; # Print directories?                  bool            Don't print dirs.

# Counters:
my $dircount  = 0; # Count of directories processed.
my $filecount = 0; # Count of files matching target and regexp.
my $samecount = 0; # Count of files bypassed because NewName == OldName.
my $skipcount = 0; # Count of files skipped at user's request.
my $renacount = 0; # Count of files successfully renamed.
my $failcount = 0; # Count of failed rename attempts.

# Hashes:
my %Modes;
$Modes{P} = 'Prompt';
$Modes{S} = 'Simulate';
$Modes{Y} = 'No-Prompt';
my %Targets;
$Targets{F} = 'Files Only';
$Targets{D} = 'Directories Only';
$Targets{B} = 'Both Files And Directories';
$Targets{A} = 'All Directory Entries';

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   say    STDERR "\nNow entering program \"" . get_name_from_path($0) . "\".";
   say    STDERR 'Directory-printing is ' . ($Verbose ? 'on' : 'off') . ".";
   say    STDERR 'Recursion is '          . ($Recurse ? 'on' : 'off') . ".";
   say    STDERR 'Target is '             . $Targets{$Target}         . ".";
   say    STDERR 'Mode is '               . $Modes{$Mode}             . ".";
   say    STDERR "Regular Expression = $RegExp";
   say    STDERR "Replacement String = $Replace";
   $Recurse ? RecurseDirs {rename_files} : rename_files;
   stats;
   my $ms = 1000 * (time - $t0);
   say    STDERR "\nNow exiting program \"" . get_name_from_path($0) . "\".";
   printf STDERR "Execution time was %.3fms\n", $ms;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

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
      /^-\pL*v|^--verbose$/  and $Verbose =  1     ;
      /^-\pL*l|^--local$/    and $Recurse =  0     ;
      /^-\pL*r|^--recurse$/  and $Recurse =  1     ;
      /^-\pL*f|^--files$/    and $Target  = 'F'    ;
      /^-\pL*d|^--dirs$/     and $Target  = 'D'    ;
      /^-\pL*b|^--both$/     and $Target  = 'B'    ;
      /^-\pL*a|^--all$/      and $Target  = 'A'    ;
      /^-\pL*p|^--prompt$/   and $Mode    = 'P'    ;
      /^-\pL*s|^--simulate$/ and $Mode    = 'S'    ;
      /^-\pL*y|^--noprompt$/ and $Mode    = 'Y'    ;
   }

   # Process arguments:
   my $NA = scalar @args;
   if    ( 2 == $NA ) {
      $RegExp  = qr/$args[0]/o;
      $Replace =    $args[1];
   }
   elsif ( 3 == $NA ) {
      $RegExp  = qr/$args[0]/o;
      $Replace =    $args[1];
      $Flags   =    $args[2];
   }
   else               {
      error($NA);help;exit 666; # Wrong number of arguments, so print error and help messages and exit.
   }

   # Return success code to caller:
   return 1;
} # end sub argv

sub rename_files {
   ++$dircount;

   # Get and announce current working directory:
   my $curdir = d getcwd;
   say STDERR "\nDirectory # $dircount: $curdir" if $Verbose;

   # Get list of targeted files in current directory:
   my $curdirfiles = GetFiles($curdir, $Target, $RegExp);

   my $Success = 0;

   # Iterate through these files, possibly renaming some depending on
   # the arguments and options the user gave on the command line,
   # and on the names of the files in the current directory:
   FILE: foreach (@{$curdirfiles})
   {
      # Increment "files processed" counter:
      ++$filecount;

      # Make variables for old and new names and paths:
      my $OldName = $_->{Name};
      my $OldPath = $_->{Path};
      my $NewName = $OldName;
      eval('$NewName' . " =~ s/$RegExp/$Replace/$Flags");
      my $NewPath = path($curdir, $NewName);

      # Announce path and old and new file names:
      say STDERR '';
      say STDOUT "$OldPath";
      say STDERR "OldName = $OldName";
      say STDERR "NewName = $NewName";

      # Skip to next file if new name is same as old:
      if ($OldName eq $NewName) {
         ++$samecount;
         say STDERR "NewName is same as OldName. Moving on to next file.";
         next FILE;
      }

      # What Mode are we in?

      # Prompt Mode:
      if ( 'P' eq $Mode ) {
         say STDERR 'Rename? (Type y for yes, n for no, q to quit, '.
               'or a to rename all).';
         GETCHAR: my $c = get_character;
         if ( 'a' eq $c || 'A' eq $c ) {
            $Mode = 'Y';
            $Success = rename_file($OldPath, $NewPath);
            if ($Success) {
               ++$renacount;
               say STDERR "File successfully renamed.";
            }
            else {
               ++$failcount;
               say STDERR "Error in rnf: File rename attempt failed.";
            }
         }
         elsif ( 'y' eq $c || 'Y' eq $c ) {
            $Success = rename_file($OldPath, $NewPath);
            if ($Success) {
               ++$renacount;
               say STDERR "File successfully renamed.";
            }
            else {
               ++$failcount;
               say STDERR "Error in rnf: File rename attempt failed.";
            }
         }
         elsif ( 'n' eq $c || 'N' eq $c ) {
            ++$skipcount;
            say STDERR "File skipped.";
            next FILE;
         }
         elsif ( 'q' eq $c || 'Q' eq $c ) {
            say STDERR "Quitting application.";
            stats;
            exit 0;
         }
         else {
            say STDERR 'Invalid keystroke!';
            say STDERR 'Rename? (Type y for yes, n for no, q to quit, '.
                  'or a to rename all).';
            goto GETCHAR;
         }
      } # end if (current mode is 'P')

      # No-Prompt Mode:
      elsif ( 'Y' eq $Mode ) {
         $Success = rename_file($OldPath, $NewPath);
         if ($Success) {
            ++$renacount;
            say STDERR "File successfully renamed.";
         }
         else {
            ++$failcount;
            say STDERR "Error: File rename attempt failed.";
         }
      } # end if (current mode is 'Y')

      # Simulation Mode:
      elsif ( 'S' eq $Mode ) {
         say STDERR "Simulation: Would have renamed file file from \"$OldName\" to \"$NewName\".";
      }

      # Unknown Mode:
      else {
         say STDERR "FATAL ERROR in \"rename-files.pl\": unknown mode \"$Mode\".";
         exit 666; # Something evil happened.
      } # end else (unknown mode)
   } # end foreach file
   return 1;
} # end sub rename_files

sub stats {
   printf STDERR "\n";
   printf STDERR "Processed %5d directories.\n",                                 $dircount;
   printf STDERR "Found     %5d files matching target and regexp.\n",            $filecount;
   printf STDERR "Bypassed  %5d files because new name was same as old name.\n", $samecount;
   printf STDERR "Skipped   %5d files at user's request.\n",                     $skipcount;
   printf STDERR "Renamed   %5d files.\n",                                       $renacount;
   printf STDERR "Failed    %5d file rename attempts.\n",                        $failcount;
   return 1;
} # end sub stats

sub error ($NA) {
   print STDERR ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: You typed $NA arguments, but rename-files.pl takes 2 or 3 arguments:
   a regular expression, a replacement string, and (optionally) a cluster of
   s/// flag letters. Did you forget to put each argument in 'single quotes'?
   Failure to do this can send dozens (or hundreds, or thousands) of arguments
   to RenameFiles, instead of the required 2 or 3 arguments. Help follows:
   END_OF_ERROR
} # end sub error ($NA)

sub help {
   print STDERR ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "rename-files.pl", Robbie Hatley's nifty file-renaming Perl script.
   This program renames batches of directory entries in the current working
   directory (and all of its subdirectories if a -r or --recurse option is used)
   by replacing matches to a given regular expression with a given replacement
   string.

   -------------------------------------------------------------------------------
   Command lines:

   To print this help and exit:
   rename-files.pl [-h|--help]

   To rename files:
   rename-files.pl [-p -s -y] [-l -r] [-f -d -b -a] Arg1 Arg2 [Arg3]

   -------------------------------------------------------------------------------
   Description of options:

   Option:             Meaning:
   -h or --help        Print help and exit.
   -q or --quiet       Don't print directories.                        (DEFAULT)
   -v or --verbose     Print directories.
   -l or --local       Rename files in current directory only.         (DEFAULT)
   -r or --recurse     Recurse subdirectories.
   -p or --prompt      Prompt before renaming files.                   (DEFAULT)
   -s or --simulate    Simulate renames (don't actually rename files).
   -y or --noprompt    Rename files without prompting.
   -f or --files       Rename regular files only.                      (DEFAULT)
   -d or --dirs        Rename directories only.
   -b or --both        Rename both regular files and directories.
   -a or --all         Rename all files.

   Multiple single-letter options can be piled-up after a single hyphen.
   For example: "-ldqy" to rename local directories quietly and without prompting.

   If conflicting separate options are given, later options overrule earlier.

   If conflicting single-letter options are piled-up after a single hyphen,
   then the order of precedence from highest to lowest will be hyspabdfrlvq.

   All options not listed above are ignored.

   -------------------------------------------------------------------------------
   Description of arguments:

   Renamefiles takes 2 or 3 command-line arguments:
   Arg1 (MANDATORY): "Regular Expression" giving pattern to search for.
   Arg2 (MANDATORY): "Replacement String" giving substitution for regex match.
   Arg3 (OPTIONAL ): "Substitution Flags" giving flags for s/// operator.

   Arg1 must be a Perl-Compliant Regular Expression specifying which files
   to rename. To specify multiple patterns, use the | alternation operator.
   To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to search for items with names containing "cat",
   "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   Arg2 must be a replacement string giving the string to substitute for each
   RegExp match this program finds for Arg1. Arg2 may contain backreferences to
   items stored via (parenthetical groups) in the RegExp in Arg1. For example, if
   Arg1 is '(\d{3})(\d{3})' and Arg2 is '$1-$2', then Rename-Files would rename
   "123456" to "123-456".

   Arg3 (optional), if present, must be flags for the Perl s/// substitution
   operator. For example, if Arg1 is 'dog' and Arg2 is 'cat', normally
   Rename-Files would rename "dogdog" to "catdog", but if Arg3 is 'g' then the
   result will be "catcat" instead.

   Examples of argument usage:

   rnf -f 'dog' 'cat'
   (would rename "Dogdog.txt" to "Dogcat.txt")

   rnf -f '(?i:dog)' 'cat'
   (would rename "Dogdog.txt" to "catdog.txt")

   rnf -f '(?i:dog)' 'cat' 'g'
   (would rename "Dogdog.txt" to "catcat.txt")

   The arguments should be enclosed in 'single quotes'. Failure to do this may
   cause the shell to decompose an argument to a list of entries in the current
   directory and send THOSE to Rename-Files, whereas Rename-Files needs the raw
   arguments.

   Arguments may be freely mixed with options, but arguments must appear in
   the order Arg1, Arg2, Arg3.

   WARNING: Make sure that none of the arguments looks like an option!
   Otherwise, they will be interpretted as "options" rather than as "arguments",
   and this program will not do what you intend. If you avoid arguments of the
   form 'hyphen-letter' (eg, '-h') or 'hyphen-hyphen-word' (eg, '--help') you
   should be OK. As a workaround, you can use '^--help$' as your regexp
   instead of '--help' if you feel that you absolutely MUST give a file such a
   pathological name.

   -------------------------------------------------------------------------------
   Directory Navigation:

   By default, RenameFiles will rename files in the current directory only.
   However, if a "-r" or "--recurse" switch is used, all subdirectories
   of the current directory will also be processed.

   -------------------------------------------------------------------------------
   Targets:

   By default, RenameFiles renames regular files only. However, if a "-d" or
   "--dirs" option is used, it will rename directories instead. If a "-b" or
   "--both" option is used, it will rename both regular files and directories.
   And if a "-a" or "--all" switch is use, it will rename ALL directory entries
   (regular files, directories, links, pipes, sockets, etc, etc, etc).

   -------------------------------------------------------------------------------
   Prompting:

   By default, Renamefiles will prompt the user to confirm or reject each rename
   it proposes based on the settings the user gave.  However, this can be altered.

   Using a "-s" or "--mode=simulate" switch will cause Renamefiles to simulate
   file renames rather than actually perform them, displaying the new names which
   would have been used had the rename actually occurred. No files will actually
   be renamed.

   Using a "-y" or "--mode=noprompt" switch will have the opposite effect:
   all renames will be executed automatically without prompting.

   Also, the prompt mode can be changed from "prompt" to "no-prompt" on the fly
   by tapping the 'a' key when prompted.  All remaining renames will then be
   performed automatically without further prompting.

   Happy file renaming!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
