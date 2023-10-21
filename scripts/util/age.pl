#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# age.pl
# Lists files in current directory (and all subdirs if -r or --recurse is used) in decreasing order of age,
# and prints age in days for each file.
#
# Edit history:
# Mon Jul 05, 2021: Wrote it.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Fri Aug 04, 2023: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.36". Got rid of
#                   "common::sense" (antiquated). Now using "strict", "warnings", "utf8". Got rid of all
#                   prototypes (now using signatures instead). Shortened name of sub "tree_stats" to "stats".
#                   Now using "d getcwd" instead of "cwd_utf8". Changed "--target=xxxx" to just "--xxxx".
#                   Put headers in help.
# Fri Aug 11, 2023: Added end-of-options marker. Added debug option.
# Sat Sep 09, 2023: Got rid of '/o' on all qr(). Applied qr($_) to all incoming arguments. Improved help.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

use Sys::Binmode;
use Cwd;
use Time::HiRes 'time';

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ;
sub curdire ;
sub stats   ;
sub help    ;

# ======= VARIABLES: =========================================================================================

# Settings:   Default:        Meaning of setting:       Range:    Meaning of default:
   $"       = ', '        ; # Quoted-array formatting.  string    Comma space.
my $db      = 0           ; # Debug?                    bool      Don't debug.
my $Verbose = 0           ; # Be verbose?               bool      Shhhh!! Be quiet!!
my $Recurse = 0           ; # Recurse subdirectories?   bool      Don't recurse.
my $Target  = 'F'         ; # Target                    F|D|B|A   Regular files only.
my @RegExps = (qr/^.+$/)  ; # Regular Expressions.      regexps   All file names.

# Counts of events in this program:
my $direcount = 0; # Count of directories processed.
my $filecount = 0; # Count of files processed.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   my $pname = get_name_from_path($0);
   argv;
   if ( $Verbose >= 1 ) {
      say STDERR "\nNow entering program \"$pname\".";
      say STDERR "Recurse = $Recurse";
      say STDERR "Target  = $Target";
      say STDERR "RegExps = (@RegExps)";
      say STDERR "Verbose = $Verbose";
   }
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $ms = 1000 * ($t0 - time);
   if ( $Verbose >= 1 ) {
      printf STDERR "\nNow exiting program \"%s\". Execution time was %.3fms.", $pname, $ms;
   }
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV :
sub argv {
   # Get options and arguments:
   my @opts = (); my @args = (); my $end_of_opts = 0;
   for ( @ARGV ) {
      /^--$/ and $end_of_opts = 1 and next;
      if   (/^-\pL*$|^--/) {push @opts, $_ }
      else                 {push @args, $_ }
   }

   # Process options:
   for ( @opts ) {
      /^-\pL*h|^--help$/     and help and exit 777 ;
      /^-\pL*e|^--debug$/    and $db      =  1     ;
      /^-\pL*q|^--quiet$/    and $Verbose =  0     ; # DEFAULT
      /^-\pL*v|^--verbose$/  and $Verbose =  1     ;
      /^-\pL*l|^--local$/    and $Recurse =  0     ; # DEFAULT
      /^-\pL*r|^--recurse$/  and $Recurse =  1     ;
      /^-\pL*f|^--files$/    and $Target  = 'F'    ; # DEFAULT
      /^-\pL*d|^--dirs$/     and $Target  = 'D'    ;
      /^-\pL*b|^--both$/     and $Target  = 'B'    ;
      /^-\pL*a|^--all$/      and $Target  = 'A'    ;
   }

   # Interpret all arguments (if any) as being Perl-Compliant Regular Expressions specifying
   # which file names to process:
   @args and push @RegExps, map {qr($_)} @args;

   # Return success code 1 to caller:
   return 1;
} # end sub argv

# Process current directory:
sub curdire {
   # Increment directory counter:
   ++$direcount;

   # Get and announce current working directory:
   my $cwd = d getcwd;
   say STDOUT "\nDirectory #$direcount: $cwd\n";

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my @combined_files = ();
   for my $RegExp ( @RegExps ) {
      my $curdirfiles = GetFiles($cwd, $Target, $RegExp);
      push @combined_files, @$curdirfiles;
   }

   # Make array of refs to file-info hashes, sorted in order of increasing age:
   my @Files = sort {$b->{Mtime} <=> $a->{Mtime}} @combined_files;

   # Get rid of file-info packets with duplicate paths. Since we just sorted files by age, any two duplicate
   # files should have the same age and hence be adjacent, so we need only look for adjacent duplicates.
   # (Duplicate searching is necessary because if user uses multiple regexps, there may be some overlap
   # in their matches, and it would be very confusing to the user to see duplicate files in the printout.)
   for ( my $i = 0 ; $i <= $#Files - 1 ; ++$i ) {
      my $j = $i + 1;
      # While i and j are duplicates, get rid of j:
      while ( $j <= $#Files && $Files[$i]->{Path} eq $Files[$j]->{Path} ) {
         splice @Files, $j, 1;
      }
   }

   # Print header:
   say STDOUT '   Age  File  Size      # of   Name   ';
   say STDOUT '(days)  Type  (bytes)   Links  of file';

   # Iterate through $Files and print info for each file in order of d:
   foreach my $file (@Files)
   {
      ++$filecount;
      my $age = (time() - $file->{Mtime}) / 86400;
      printf STDOUT " %5u    %-1s   %-8.2E  %5u  %-s\n",
         $age, $file->{Type}, $file->{Size}, $file->{Nlink}, $file->{Name};
   }
   return 1;
} # end sub curdire

sub stats {
   if ( $Verbose >= 1 ) {
      say "Navigated $direcount directories.";
      say "Processed $filecount files.";
   }
   return 1;
} # end sub stats

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "age.pl", Robbie Hatley's Nifty list-files-by-age utility. This
   program will list all files in the current directory (and all subdirectories if
   a -r or --recurse option is used) in increasing order of age (newest files on
   top, oldest at bottom). Each listing line will give the following pieces of
   information about a file:
   1. Age of file in days.
   2. Type of file (single-letter code, one of NTYXOPSLMDHFU).
   3. Size of file in format #.##E+##
   4. Name of file.

   -------------------------------------------------------------------------------
   Meanings of Type Letters:

   B - Broken symbolic link
   D - Directory
   F - regular File
   H - regular file with multiple Hard links
   L - symbolic Link to regular file
   N - Nonexistent
   O - sOcket
   P - Pipe
   S - Symbolic link to directory
   T - opens to a Tty
   U - Unknown
   W - symbolic link to something Weird (not a regular file or directory)
   X - block special file
   Y - character special file

   -------------------------------------------------------------------------------
   Command Lines:

   age.pl [-h|--help]             (to print this help and exit)
   age.pl [options] [Argument]    (to list files by increasing age)

   -------------------------------------------------------------------------------
   Description of Options:

   Option:           Meaning:
   -h or --help      Print help and exit.
   -e or --debug     Print diagnostics and exit.
   -r or --recurse   Recurse subdirectories.
   -f or --files     List files only.
   -d or --dirs      List directories only.
   -b or --both      List files and directories.
   -a or --all       List everything.
   (Defaults are: no help, no recurse, list files only.)

   -------------------------------------------------------------------------------
   Description of Arguments:

   In addition to options, this program can take one-or-more optional arguments,
   which, if present, will be interpreted as Perl-Compliant Regular Expressions
   specifying which items to process. To apply pattern modifier letters, use an
   Extended RegExp Sequence. For example, if you want to search for files with
   names containing "Robbie" or "robbie", you could use '(?i:R)obbie'.

   Be sure to enclose each regexp in 'single quotes', else BASH may misintepret
   your regexps as csh wildcards and replace your regexps with matching names of
   files in the current directory and send THOSE to this program, whereas this
   program needs the raw regexps instead.


   Happy files-by-age listing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
