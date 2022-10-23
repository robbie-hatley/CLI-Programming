#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8 Unicode Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
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
# Tue Nov 16, 2021: Now using common::sense, and now using extended regexp sequences instead of regexp delimiters.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv ()  ;
sub rename_files ()  ;
sub stats        ()  ;
sub error        ($) ;
sub help         ()  ;

# ======= GLOBAL VARIABLES: ============================================================================================

# Debug?
my $db = 0;

# Settings:       Default Value      Description                        Range          Default
my $Recurse     = 0              ; # Recurse subdirectories?            (bool)         0
my $Mode        = 'P'            ; # Prompt mode                        (P, S, Y)      'P'
my $Target      = 'A'            ; # Files, directories, both, or All?  (F, D, B, A)   'A'
my $RegExp      = qr/^.+$/o      ; # RegExp.                            (RegExp)       qr/^(.+)$/o
my $Replacement = '$1'           ; # Replacement string.                (string)       '$1'
my $Flags       = ''             ; # Flags for s/// operator.           imsxopdualgre  

# Counters:
my $dircount     = 0; # Count of directories processed.
my $filecount    = 0; # Count of files matching target and regexp.
my $samecount    = 0; # Count of files bypassed because NewName == OldName.
my $skipcount    = 0; # Count of files skipped at user's request.
my $renamecount  = 0; # Count of files successfully renamed.
my $failcount    = 0; # Count of failed rename attempts.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

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

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub argv ()
{
   my $help = 0;
   my $i    = 0;
   for ( $i = 0 ; $i < @ARGV ; ++$i)
   {
      $_ = $ARGV[$i];
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         say "Option: $_" if $db;
            if ('-h' eq $_ || '--help'          eq $_) {$help    =  1 ;}
         elsif ('-p' eq $_ || '--mode=prompt'   eq $_) {$Mode    = 'P';}
         elsif ('-s' eq $_ || '--mode=simulate' eq $_) {$Mode    = 'S';}
         elsif ('-y' eq $_ || '--mode=noprompt' eq $_) {$Mode    = 'Y';}
         elsif ('-l' eq $_ || '--local'         eq $_) {$Recurse =  0 ;}
         elsif ('-r' eq $_ || '--recurse'       eq $_) {$Recurse =  1 ;}
         elsif ('-f' eq $_ || '--target=files'  eq $_) {$Target  = 'F';}
         elsif ('-d' eq $_ || '--target=dirs'   eq $_) {$Target  = 'D';}
         elsif ('-b' eq $_ || '--target=both'   eq $_) {$Target  = 'B';}
         elsif ('-a' eq $_ || '--target=all'    eq $_) {$Target  = 'A';}
         splice @ARGV, $i, 1; # Remove current option from @ARGV.
         --$i; # Move index one-left so that "++$i" above will move index back to current spot with new item.
      }
      else {say "Argument: $_" if $db;}
   }
   if ($help) {help; exit 777;}
   my $NA = scalar(@ARGV);
   if ($db)
   {
      say 'scalar(@ARGV) = ', scalar @ARGV;
      say 'Arguments:';
      say for @ARGV;
   }

   given ($NA)
   {
      when (2)
      {
         $RegExp      = qr/$ARGV[0]/o;
         $Replacement = $ARGV[1];
      }
      when (3)
      {
         $RegExp      = qr/$ARGV[0]/o;
         $Replacement = $ARGV[1];
         $Flags       = $ARGV[2];
      }
      default
      {
         error $NA;
      }
   }
   return 1;
} # end sub process_argv ()

sub rename_files ()
{
   ++$dircount;

   # Get and announce current working directory:
   my $curdir = cwd_utf8;
   say "\nDirectory # $dircount: $curdir";

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

      if ($OldName eq $NewName)
      {
         ++$samecount;
         warn "NewName is same as OldName. Moving on to next file.\n";
         next FILE;
      }

      # What mode are we in?
      given ($Mode) 
      {
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
                  $Success = rename_file($OldName, $NewName);
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
                  $Success = rename_file($OldName, $NewName);
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
            $Success = rename_file($OldName, $NewName);
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
} # end sub rename_files ()

sub stats ()
{
   printf "\n";
   printf "Processed %5d directories.\n",                                 $dircount;
   printf "Found     %5d files matching target and regexp.\n",            $filecount;
   printf "Bypassed  %5d files because new name was same as old name.\n", $samecount;
   printf "Skipped   %5d files at user's request.\n",                     $skipcount;
   printf "Renamed   %5d files.\n",                                       $renamecount;
   printf "Failed    %5d file rename attempts.\n",                        $failcount;
   return 1;
} # end sub stats ()

sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: You typed $NA arguments, but rename-files.pl takes 2 or 3 arguments:
   a regular expression, a replacement string, and (optionally) a cluster of
   s/// flag letters. Did you forget to put each argument in 'single quotes'? 
   Failure to do this can send dozens (or hundreds, or thousands) of arguments
   to RenameFiles, instead of the required 2 or 3 arguments. Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end sub error ()

sub help ()
{
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

   Brief description of arguments:
   Arg1: "Regular Expression" giving pattern to search for.
   Arg2: "Replacement String" giving substitution for regex match.
   Arg3: "Substitution Flags" giving flags for s/// operator.

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
   Renamefiles takes 2 or 3 command-line arguments. The arguments must be
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
} # end sub help ()
