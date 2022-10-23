#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# age.pl
# Lists files in current directory (and all subdirs if -r or --recurse is used) in increasing order of age,
# and prints age in days for each file.
#
# Edit history:
# Mon Jul 05, 2021: Wrote it.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv       ()  ;
sub curdire    ()  ;
sub curfile    ($) ;
sub tree_stats ()  ;
sub error      ($) ;
sub help       ()  ;

# ======= VARIABLES: ===================================================================================================

# Use debugging? (Ie, print extra diagnostics?)
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# Settings:                  Meaning:                  Range:    Default:
my $Recurse = 0          ; # Recurse subdirectories?   bool      0 (don't recurse)
my $Target  = 'A'        ; # Target                    F|D|B|A   A (print directory entries of all types)
my $RegExp  = qr/^.+$/o  ; # Regular Expression.       regexp    qr/^.+$/o (matches all strings)

# Counts of events in this program:
my $direcount = 0; # Count of directories processed.
my $filecount = 0; # Count of files processed.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   say "Recurse = $Recurse";
   say "Target  = $Target";
   say "RegExp  = $RegExp";
   $Recurse and RecurseDirs {curdire} or curdire;
   tree_stats;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

# Process @ARGV :
sub argv ()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL]{1,}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if ( $_ eq '-h' || $_ eq '--help'         ) {help; exit 777;}
         elsif ( $_ eq '-r' || $_ eq '--recurse'      ) {$Recurse =  1 ;}
         elsif ( $_ eq '-f' || $_ eq '--target=files' ) {$Target  = 'F';}
         elsif ( $_ eq '-d' || $_ eq '--target=dirs'  ) {$Target  = 'D';}
         elsif ( $_ eq '-b' || $_ eq '--target=both'  ) {$Target  = 'B';}
         elsif ( $_ eq '-a' || $_ eq '--target=all'   ) {$Target  = 'A';}
         splice @ARGV, $i, 1;
         --$i;
      }
   }
   my $NA = scalar(@ARGV);
   given ($NA)
   {
      when (0) {                       ;} # Do nothing.
      when (1) {$RegExp = qr/$ARGV[0]/o;} # Set $RegExp.
      default  {error($NA)             ;} # Print error and help messages then exit 666.
   }
   return 1;
} # end sub argv ()

# Process current directory:
sub curdire ()
{
   # Increment directory counter:
   ++$direcount;

   # Get and announce current working directory:
   my $cwd = cwd_utf8;
   say "\nDirectory # $direcount: $cwd\n";

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, $Target, $RegExp);

   # Make array to hold re-ordered list of files:
   my @Files = sort {$b->{Mtime} <=> $a->{Mtime}} @{$curdirfiles};

   # Print header:
   say '   Age  File  Size      # of   Name   ';
   say '(days)  Type  (bytes)   Links  of file';

   # Iterate through $Files and send each file to curfile():
   foreach my $file (@Files)
   {
      curfile($file);
   }
   return 1;
} # end sub curdire ()

# Process current file:
sub curfile ($)
{
   ++$filecount;
   my $file = shift;
   my $age = (time() - $file->{Mtime}) / 86400;
   printf
   (
      " %5u    %-1s   %-8.2E  %5u  %-s\n", 
      $age, 
      $file->{Type},
      $file->{Size},
      $file->{Nlink},
      $file->{Name}
   );
   return 1;
} # end sub curfile ($)

sub tree_stats ()
{
   say "Navigated $direcount directories.";
   say "Processed $filecount files.";
   return 1;
} # end sub tree_stats ()

sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $NA arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which directory entries to process. Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end sub error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "age.pl", Robbie Hatley's Nifty list-files-by-age utility.
   This program will list all files in the current directory (and all
   subdirectories if a -r or --recurse option is used) in increasing
   order of age. Each listing line will give the following pieces
   of information about a file:
   1. Age of file in days.
   2. Type of file (single-letter code, one of NTYXOPSLMDHFU).
   3. Size of file in format #.##E+##
   4. Name of file.

   The meanings of the Type letters are as follows:
   N - object is nonexistent
   T - object opens to a TTY
   Y - object is a character special file
   X - object is a block special file
   O - object is a socket
   P - object is a pipe
   S - object is a symbolic link to a directory ("SYMLINKD")
   L - object is a symbolic link to a file
   M - object is a directory with multiple hard links
   D - object is a directory
   H - object is a regular file with multiple hard links
   F - object is a regular file
   U - object is of unknown type

   Command line:
   rhdir.pl [options] [Argument]

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-r" or "--recurse"          Recurse subdirectories.
   "-f" or "--target=files"     List files only.
   "-d" or "--target=dirs"      List directories only.
   "-b" or "--target=both"      List files and directories.
   "-a" or "--target=all"       List everything.
   (Defaults are: no help, no recurse, list files only.)

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

   Happy file age listing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
