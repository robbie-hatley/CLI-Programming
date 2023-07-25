#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# file-files-by-type.pl
# Moves files from current directory into appropriate subdirectories of the current directory (by default), or of the
# parent directory (if a "--one" or "-1" option is used), or of the grandparent directory (if a "--two" or "-2" option 
# is used), based on file name extension. If the appropriate subdirectory does not exist, it will be created. If a file 
# of the same name exists, the moved file will be enumerated. 
#
# Edit history:
# Wed Nov 28, 2018: Started writing it.
# Sat Dec 08, 2018: Added code to create directories.
# Mon Apr 08, 2019: Added "two levels up" option.
# Fri Jul 19, 2019: Fixed minor formatting & comments issues, and added "~" to here-document in help().
# Tue Feb 16, 2021: Now using new GetFiles().
# Fri Mar 19, 2021: Now using Sys::Binmode.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; now using "common::sense" (for a change).
# Fri Aug 19, 2022: Added "-0", "-1", "-2" options and corrected description above and help() below to match.
#                   Also changed the if-pile in curfile() to a given(). Also removed annoying duplication of success
#                   and/or failure messages, by erasing those messages from THIS script so that the equivalent messages
#                   in move_file() in RH::Dir will be the only ones printed.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use RH::Dir;
use RH::Util;
use RH::WinChomp;

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# ======= SUBROUTINE PRE-DECLARATIONS ==================================================================================

sub argv    ();
sub curfile ($);
sub stats   ();
sub help    ();

# ======= GLOBAL VARIABLES =============================================================================================

# Settings:
my $Levels    = 0;     # Go up how many levels before making subdirs? (Default is 0 levels.)
my $Regexp    = '.+';  # Regular expression. (Default is "all possible patterns of characters".)

# Counters:
my $filecount = 0;     # Count of files processed by curfile().
my $succcount = 0;     # Count of files successfully filed-away.
my $failcount = 0;     # Count of files we couldn't file-away.

# ======= MAIN BODY OF PROGRAM =========================================================================================

{ # begin main
   say "\nNow entering program \"file-files-by-type.pl\".\n";
   argv;
   curfile $_ for @{GetFiles(cwd_utf8(), 'F', $Regexp)};
   stats;
   say "\nNow exiting program \"file-files-by-type.pl\".\n";
   exit 0;
} # end main()

# ======= SUBROUTINE DEFINITIONS =======================================================================================

sub argv ()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if ('-h' eq $_ || '--help' eq $_) {help; exit 777;}
         elsif ('-0' eq $_ || '--zero' eq $_) {$Levels = 0;}
         elsif ('-1' eq $_ || '--one'  eq $_) {$Levels = 1;}
         elsif ('-2' eq $_ || '--two'  eq $_) {$Levels = 2;}
         splice @ARGV, $i, 1; # Remove option from @ARGV after processing.
         --$i; # Move index 1-left, so that the "++$i" above moves index back to current spot, with new item.
      }
   }
   if (@ARGV > 0) {$Regexp = $ARGV[0];}
   return 1;
} # end sub argv ()

sub curfile ($) 
{
   ++$filecount;
   my $file = shift;
   my $suffix = get_suffix $file->{Name};
   $suffix =~ s/^\.//;
   if ('' eq $suffix) {$suffix = 'noex';}
   return 1 if 'ini' eq $suffix;
   return 1 if 'db'  eq $suffix;
   return 1 if 'jbf' eq $suffix;
   my $dir;
   given ($Levels)
   {
      when (0) {$dir =            $suffix;}
      when (1) {$dir = '../'    . $suffix;}
      when (2) {$dir = '../../' . $suffix;}
      default  {die "Error in \"file-files-by-type.pl\": Invalid \$Levels.\n$!\n";}
   }
   mkdir $dir unless -e e $dir;
   move_file("$file->{Name}", $dir) and ++$succcount and return 1 
                                    or  ++$failcount and return 0;
} # end sub curfile ($)

sub stats ()
{
   print("\nStats for \"file-files-by-type.pl\":\n");
   printf("Processed %5d files.\n",                   $filecount);
   printf("Filed     %5d files.\n",                   $succcount);
   printf("Failed    %5d file-filing attempts.\n",    $failcount);
   return 1;
} # end sub stats ()

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "file-files-by-type.pl". This program moves all files from the
   current directory into appropriate subdirectories of the current (or parent,
   or grandparent) directory, based on file type (eg: jpg, mp3, txt, exe).
   If the appropriate subdirectory of the target directory does not exist,
   it will be created. If a file of the same name exists, the moved file will 
   be enumerated.

   Command line:
   program-name.pl [options] [regex]

   Description of options:
   Option:             Meaning:
   "-h" or "--help"    Print help and exit.
   "-0" or "--zero"    Move files to subfolders of folder 0 level  up (default)
   "-1" or "--two"     Move files to subfolders of folder 1 level  up
   "-2" or "--two"     Move files to subfolders of folder 2 levels up
   (All other options are ignored.)

   Description of arguments:
   In addition to options, this program can take one optional argument which,
   if present, must be a Perl-Compliant Regular Expression specifying which items
   to process. To specify multiple patterns, use the | alternation operator.
   To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to search for items with names containing "cat",
   "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead. 

   Happy file filing!
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
