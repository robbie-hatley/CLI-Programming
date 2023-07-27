#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8 Unicode Perl source-code text file with hard Unix line breaks ("\x{0A}").
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
# Thu Jul 27, 2023: Extreme refactor. Reduced width from 120 to 110 with github in-mind. Upgraded from
#                   "use v5.32;" to "use v5.36;". Got rid of prototypes. Sub "error" is now "error($NA)".
#                   Single-letter options can now be piled-up after a single hyphen. Got rid of
#                   "common::sense" (antiquated). Sub "error" now prints error message ONLY (doesn't run help
#                   or exit; those are called from argv). Still using obsolete given/when via "experimental".
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use experimental 'switch';

use Sys::Binmode;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv         ;
sub rename_files ;
sub stats        ;
sub error        ;
sub help         ;

# ======= GLOBAL VARIABLES: ==================================================================================

# Debug?

# Settings:       Default Value      Description                        Range          Default
   $,           = ', '           ; # Array formatting.                  (string)       ', '
my $db          = 0              ; # Debug?                             (bool)         0
my $Recurse     = 0              ; # Recurse subdirectories?            (bool)         0 (be local)
my $Mode        = 'P'            ; # Prompt mode                        (P, S, Y)      'P'
my $Target      = 'A'            ; # Files, directories, both, or All?  (F, D, B, A)   'A'
my $RegExp      = qr/^(.+)$/o    ; # RegExp.                            (RegExp)       qr/^(.+)$/o
my $Replacement = '$1'           ; # Replacement string.                (string)       '$1'
my $Flags       = ''             ; # Flags for s/// operator.           imsxopdualgre  ''
my $Verbose     = 1              ; # Be verbose?                        (bool)         1 (be verbose)

# Counters:
my $dircount    = 0; # Count of directories processed.
my $filecount   = 0; # Count of files matching target and regexp.
my $samecount   = 0; # Count of files bypassed because NewName == OldName.
my $skipcount   = 0; # Count of files skipped at user's request.
my $renamecount = 0; # Count of files successfully renamed.
my $failcount   = 0; # Count of failed rename attempts.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   say 'Recursion is ' . ($Recurse ? 'on.' : 'off.');
   say "Mode = $Mode";
   say "Target = $Target";
   say "Regular Expression = $RegExp";
   say "Replacement String = $Replacement";
   $Recurse ? RecurseDirs {rename_files} : rename_files;
   stats;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

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
   for (@options) {
      if ( $_ =~ m/^-[^-]*h/ || $_ eq '--help'          ) {help; exit 777;}
      if ( $_ =~ m/^-[^-]*q/ || $_ eq '--quiet'         ) {$Verbose =  0 ;}
      if ( $_ =~ m/^-[^-]*v/ || $_ eq '--verbose'       ) {$Verbose =  1 ;} # DEFAULT
      if ( $_ =~ m/^-[^-]*l/ || $_ eq '--local'         ) {$Recurse =  0 ;} # DEFAULT
      if ( $_ =~ m/^-[^-]*r/ || $_ eq '--recurse'       ) {$Recurse =  1 ;}
      if ( $_ =~ m/^-[^-]*f/ || $_ eq '--target=files'  ) {$Target  = 'F';}
      if ( $_ =~ m/^-[^-]*d/ || $_ eq '--target=dirs'   ) {$Target  = 'D';}
      if ( $_ =~ m/^-[^-]*b/ || $_ eq '--target=both'   ) {$Target  = 'B';}
      if ( $_ =~ m/^-[^-]*a/ || $_ eq '--target=all'    ) {$Target  = 'A';} # DEFAULT
      if ( $_ =~ m/^-[^-]*p/ || $_ eq '--mode=prompt'   ) {$Mode    = 'P';} # DEFAULT
      if ( $_ =~ m/^-[^-]*s/ || $_ eq '--mode=simulate' ) {$Mode    = 'S';}
      if ( $_ =~ m/^-[^-]*y/ || $_ eq '--mode=noprompt' ) {$Mode    = 'Y';}
   }

   # Process arguments:
   my $NA = scalar @arguments;
   if    ( 2 == $NA ) {
      $RegExp      = qr/$arguments[0]/o;
      $Replacement =    $arguments[1];
   }
   elsif ( 3 == $NA ) {
      $RegExp      = qr/$arguments[0]/o;
      $Replacement =    $arguments[1];
      $Flags       =    $arguments[2];
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
   my $curdir = cwd_utf8;
   say "\nDirectory # $dircount: $curdir" if $Verbose;

   # Get list of targeted files in current directory:
   my $curdirfiles = GetFiles($curdir, $Target, $RegExp);

   my $Success = 0;

   # Iterate through these files, possibly renaming some depending on
   # the arguments and options the user gave on the command line,
   # and on the names of the files in the current directory:
   FILE: foreach (@{$curdirfiles})
   {
      ++$filecount;
      my $OldName = $_->{Name};
      my $NewName = $OldName;
      eval('$NewName' . " =~ s/$RegExp/$Replacement/$Flags");

      # Announce old and new file names:
      say '';
      say "OldName = $OldName";
      say "NewName = $NewName";

      if ($OldName eq $NewName) {
         ++$samecount;
         warn "NewName is same as OldName. Moving on to next file.\n";
         next FILE;
      }

      # Generate full paths for old and new file names, and send THOSE to rename_file instead of just the
      # file names, so that any error messages might actually mean something:
      my $OldPath = path($curdir, $OldName);
      my $NewPath = path($curdir, $NewName);

      # What mode are we in?
      given ($Mode) {
         # Prompt Mode:
         when ('P')
         {
            say 'Rename? (Type y for yes, n for no, q to quit, '.
                'or a to rename all).';
            GETCHAR: my $c = get_character;
            given ($c)
            {
               when (['a','A'])
               {
                  $Mode = 'Y';
                  $Success = rename_file($OldPath, $NewPath);
                  if ($Success)
                  {
                     ++$renamecount;
                     say "File successfully renamed.";
                  }
                  else
                  {
                     ++$failcount;
                     say "Error in rnf: File rename attempt failed.";
                  }
               }
               when (['y','Y'])
               {
                  $Success = rename_file($OldPath, $NewPath);
                  if ($Success)
                  {
                     ++$renamecount;
                     say "File successfully renamed.";
                  }
                  else
                  {
                     ++$failcount;
                     say "Error in rnf: File rename attempt failed.";
                  }
               }
               when (['n','N'])
               {
                  ++$skipcount;
                  next FILE;
               }
               when (['q','Q'])
               {
                  stats;
                  exit 0;
               }
               default
               {
                  say 'Invalid keystroke!';
                  say 'Rename? (Type y for yes, n for no, q to quit, '.
                      'or a to rename all).';
                  goto GETCHAR;
               }
            } # end given ($c)
         } # end when (current mode is 'P')

         # No-Prompt Mode:
         when ('Y')
         {
            $Success = rename_file($OldPath, $NewPath);
            if ($Success)
            {
               ++$renamecount;
               say "File successfully renamed.";
            }
            else
            {
               ++$failcount;
               say "Error: File rename attempt failed.";
            }
         } # end when (current mode is 'Y')

         # Simulation Mode:
         when ('S')
         {
            say "Simulation: Would have renamed file file from \"$OldName\" to \"$NewName\".";
         }

         default
         {
            say "Error in rename-files: unknown mode \"$Mode\".";
            exit 666; # Something evil happened.
         }
      } # end given mode
   } # end foreach file
   return 1;
} # end sub rename_files

sub stats {
   printf "\n";
   printf "Processed %5d directories.\n",                                 $dircount;
   printf "Found     %5d files matching target and regexp.\n",            $filecount;
   printf "Bypassed  %5d files because new name was same as old name.\n", $samecount;
   printf "Skipped   %5d files at user's request.\n",                     $skipcount;
   printf "Renamed   %5d files.\n",                                       $renamecount;
   printf "Failed    %5d file rename attempts.\n",                        $failcount;
   return 1;
} # end sub stats

sub error ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: You typed $NA arguments, but rename-files.pl takes 2 or 3 arguments:
   a regular expression, a replacement string, and (optionally) a cluster of
   s/// flag letters. Did you forget to put each argument in 'single quotes'?
   Failure to do this can send dozens (or hundreds, or thousands) of arguments
   to RenameFiles, instead of the required 2 or 3 arguments. Help follows:
   END_OF_ERROR
} # end sub error ($NA)

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to "Rename-Files", Robbie Hatley's file-renaming Perl script. This
   program renames batches of files by replacing matches to a given regular
   expression with a given replacement string.

   Command line:
   rnf [-h] [-p -s -y] [-l -r] [-f -d -b -a] Arg1 Arg2 [Arg3]

   Brief description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-p" or "--mode=prompt"      Prompt before renaming files. (DEFAULT)
   "-s" or "--mode=simulate"    Simulate renames (don't actually rename files).
   "-y" or "--mode=noprompt"    Rename files without prompting.
   "-l" or "--local"            Rename files in current directory only. (DEFAULT)
   "-r" or "--recurse"          Recurse subdirectories.
   "-f" or "--target=files"     Rename regular files only.
   "-d" or "--target=dirs"      Rename directories only.
   "-b" or "--target=both"      Rename both regular files and directories.
   "-a" or "--target=all"       Rename all files. (DEFAULT)
   "-q" or "--quiet"            Don't print directories.
   "-v" or "--verbose"          Print directories. (DEFAULT)
   Multiple single-letter options can be piled-up after a single hyphen.
   For example: "-plfq".
   All options not listed above are ignored.

   Brief description of arguments:
   Arg1: "Regular Expression" giving pattern to search for.        (MANDATORY)
   Arg2: "Replacement String" giving substitution for regex match. (MANDATORY)
   Arg3: "Substitution Flags" giving flags for s/// operator.      (OPTIONAL)

   Example command lines:

   rnf -f 'dog' 'cat'
      (would rename "Dogdog.txt" to "Dogcat.txt")

   rnf -f '(?i:dog)' 'cat'
      (would rename "Dogdog.txt" to "catdog.txt")

   rnf -f '(?i:dog)' 'cat' 'g'
      (would rename "Dogdog.txt" to "catcat.txt")

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

   Directory tree traversal:
   By default, RenameFiles will rename files in the current directory only.
   However, if a "-r" or "--recurse" switch is used, all subdirectories
   of the current directory will also be processed.

   Target selection:
   By default, RenameFiles renames files only, not directories.  However, if a
   "-d" or "--target=dirs" switch is used, it will rename directories instead.
   If a "-b" or "--target=both" switch is used, it will rename both.
   And if a "-a" or "--target=all" switch is use, it will rename ALL files
   (regular files, directories, links, pipes, sockets, etc, etc, etc).

   Arguments:
   Renamefiles takes 2 or 3 command-line arguments. The arguments should be
   enclosed in 'single quotes'. Failure to do this may cause the shell to
   decompose an argument to a list of entries in the current directory and
   send THOSE to Rename-Files, whereas Rename-Files needs the raw arguments.

   Arguments may be freely mixed with options, but arguments must appear in
   the order Arg1, Arg2, Arg3. Detailed descriptions of Arg1, Arg2, and Arg3
   follow:

   Arg1:
   This must be a Perl-Compliant Regular Expression specifying which files
   to rename. To specify multiple patterns, use the | alternation operator.
   To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to search for items with names containing "cat",
   "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   Arg2:
   This must be a replacement string giving the string to substitute for each
   RegExp match this program finds for Arg1. Arg2 may contain backreferences to
   items stored via (parenthetical groups) in the RegExp in Arg1. For example, if
   Arg1 is '(\d{3})(\d{3})' and Arg2 is '$1-$2', then Rename-Files would rename
   "123456" to "123-456".

   Arg3:
   Optional flags for the Perl s/// substitution operator. For example, if Arg1
   is 'dog' and Arg2 is 'cat', normally Rename-Files would rename "dogdog" to
   "catdog", but if Arg3 is 'g' then the result will be "catcat" instead.

   WARNING: Make sure that none of the arguments looks like an option!
   Otherwise, they will be interpretted as "options" rather than as "arguments",
   and this program will not do what you intend. If you avoid arguments of the
   form 'hyphen-letter' (eg, '-h') or 'hyphen-hyphen-word' (eg, '--help') you
   should be OK. As a workaround, you can use '^--help$' as your regexp
   instead of '--help' if you feel that you absolutely MUST give a file such a
   pathological name.

   Happy file renaming!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
