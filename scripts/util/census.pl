#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# /rhe/scripts/util/census.pl
# Robbie Hatley's nifty file-system census utility. Prints how many files and bytes are in the current
# directory and each of its subdirectories.
# Written by Robbie Hatley.
# Edit history:
# Fri May 08, 2015: Wrote first draft.
# Thu Jul 09, 2015: Various minor improvements.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Sun Sep 20, 2020: Corrected errors in Help.
# Mon Sep 21, 2020: Corrected more errors in Help, increased width to 97, changed "--atleast="
#                   to "--files=", added "--gb=", improved comments and formatting, and now
#                   ANDing "--gb=" and "--files=" together.
# Wed Feb 17, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory as
#                   its first argument, target as second, and regexp (instead of wildcard) as third.
# Wed Nov 17, 2021: Added "use common::sense;", shortened sub names, added comments, corrected errors in help, wrapped
#                   regexp in qr//, refactored argv(), added sub dirstats(), and unscrambled the logic in curdire().
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use Time::HiRes 'time';

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv     ();
sub dirstats ($$$);
sub curdire  ();
sub stats    ();
sub error    ($);
sub help     ();

# ======= LEXICAL VARIABLES: ===========================================================================================

# Debug?
my $db = 0;

# Settings:                  Description:                          Range:                  Defaults:
my $Recurse   = 1        ; # Recurse subdirectories?               (bool)                  1
my $Regexp    = qr/^.+$/ ; # Regular expression.                   (regexp)                qr/^.+$/
my $Empty     = 0        ; # Show only empty directories?          (bool)                  0
my $GB        = 0.0      ; # Show only dirs with >= $GB GB?        (non-negative real)     0.0
my $Files     = 0        ; # Show only dirs with >= $Files files.  (non-negative integer)  0

# Counters of events in "census.pl" only:
my $direcount = 0; # Count of directories processed.
my $gigacount = 0; # Count of gigabytes of data processed.

# Accumulations of counters from RH::Dir::GetFiles():
my $regfcount = 0; # Count of all regular files seen.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{
   say "\nNow entering program \"census.pl\".";
   my $enter_time = time;

   # Process @ARGV:
   argv();

   say '';
   say "\$Recurse  = $Recurse";
   say "\$Regexp   = $Regexp";
   say "Minimum dir size  = ${GB}GB.";
   say "Minimum dir files = $Files files.";

   say '';
   say 'Populations of directories in this tree:';

   $Recurse and RecurseDirs {curdire} or curdire;

   # Print stats:
   stats;

   my $exit_time = time;
   my $elapsed_time = $exit_time - $enter_time;
   say "\nNow exiting program \"census.pl\".";
   say "\nExecution time for \"census.pl\" was $elapsed_time seconds.";
   exit 0;
} # end MAIN

# ======= SUBROUTINE DEFINITIONS ================================================================

sub argv ()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL]{1,}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if (/^-h$/ || /^--help$/ ) {help; exit 777;}
         elsif (/^-l$/ || /^--local$/) {$Recurse =  0 ;} # Default is 1.
         elsif (/^-e$/ || /^--empty$/) {$Empty   =  1 ;} # Default is 0.
         elsif (/^--gb=(\d+\.?\d*)$/ ) {$GB      = $1 ;} # Default is 0.0.
         elsif (/^--files=(\d+)$/    ) {$Files   = $1 ;} # Default is 0.

         # Remove option from @ARGV:
         splice @ARGV, $i, 1;

         # Move the index 1-left, so that the "++$i" above
         # moves the index back to the current @ARGV element,
         # but with the new content which slid-in from the right
         # due to deletion of previous element contents:
         --$i;
      }
   }
   my $NA = scalar(@ARGV);
   given ($NA)                            # Given the number of remaining items in @ARGV,
   {
      when (0) {;}                        # if =0, do nothing;
      when (1) {$Regexp = qr/$ARGV[0]/;}  # if =1, set $Regexp;
      default  {error($NA); exit(666);}   # if >1, print error and help messages and exit.
   }
   return 1;
} # end sub argv ()

sub dirstats ($$$)
{
   my $files     = shift;
   my $gigabytes = shift;
   my $directory = shift;
   printf("%5d Files  %6.3fGB  %s\n", $files, $gigabytes, $directory);
   return 1;
} # end sub dirstats ($$$)

sub curdire ()
{
   # Were's starting to process a directory, so increment $dircount:
   ++$direcount;

   # Get CWD:
   my $curdir = cwd_utf8;

   # Get files:
   my $curdirfiles = GetFiles($curdir, 'F', $Regexp);

   # How many gigabytes of regular-file data are in this directory? Don't assume that all files in $curdirfiles will
   # have their ->{Type} field set to "F"! Some won't be, because GetFiles() uses a different file typing criteria than
   # glob_regexp_utf8 (which uses a simple -f check), so even if you request "naught but regular files" from GetFiles,
   # some of the files it returns may have ->{Type} set to something else because while those files may be "regular
   # files", they may also be something else! But we're only interested here in normal data files (txt, jpg, mp3, etc),
   # so lets restrict ourselves to tallying the sizes of files with ->{Type} set to 'F':
   my $bytes = 0;
   foreach my $file (@{$curdirfiles})
   {
      if ('F' eq $file->{Type})
      {
         $bytes += $file->{Size};
      }
   }
   my $gigabytes = $bytes/1000000000.0;
   $gigacount += $gigabytes;

   # Append count of regular files from RH::Dir to local counter:
   $regfcount += $RH::Dir::regfcount; # regular files

   # If in "show empties only" mode,
   # then only print directories which contain zero regular files:
   if ($Empty) 
   {
      if (0 == $RH::Dir::regfcount)
      {
         say "Empty: $curdir";
      }
      else
      {
         ; # Do nothing.
      }
   }

   # Otherwise,
   # display info for this directory if it contains at-least $Files files and at-least $GB gigabytes of data:
   else
   {
      if ($RH::Dir::regfcount >= $Files && $gigabytes >= $GB)
      {
         dirstats($RH::Dir::regfcount, $gigabytes, $curdir);
      }
      else
      {
         ; # Do nothing.
      }
   }
   return 1;
} # end sub curdire ()

sub stats ()
{
   say "";
   say "Navigated $direcount directories.";
   say "Encountered $regfcount regular files matching regexp \"$Regexp\",";
   say "taking up $gigacount GB of disk space.";
   return 1;
} # end sub stats ()

sub error ($)
{
   my $NumArgs = shift;
   print ((<<'   END_OF_ERROR') =~ s/^   //gmr);
   Error: You typed $NumArgs arguments, but Census takes at most 1 argument,
   which (if present) must be a regular expression specifying which directories
   and/or files to process. Help follows:

   END_OF_ERROR
   help;
   return 1;
} # end sub error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "census.pl", Robbie Hatley's nifty directory-tree census utility.
   This program prints how many files and bytes are in the current directory and
   each of its subdirectories.

   Command line to get help:
   census.pl [-h|--help]

   Regular command line:
   census.pl [-l|--local] [-t|--terse] [--files=####] [--gb=##] [Arg1]

   Description of options:
   Option:                Meaning:
   "-h" or "--help"       Print help and exit.
   "-l" or "--local"      DON'T recurse subdirectories. (Default is to recurse.)
   "--files=####"         Only display directories containing at least ####
                          files, where #### is any non-negative integer.
                          Note that --atleast=#### must be all one token,
                          and hence it cannot contain spaces.
                          Valid:   --atleast=350
                          Invalid: --atleast = 350
   "--gb=##"              Only display directories containing at least ##
                          gigabytes, where ## is any non-negative integer.
                          Note that --gb=## must be all one token,
                          and hence it cannot contain spaces.
                          Valid:   --gb=350
                          Invalid: --gb = 350
   "-e" or "--empty"      Only display directories containing 0 regular files.

   NOTE: "-e" overrides "gb=" and/or "files=" and prints info ONLY on
   directories which are empty.

   NOTE: "--gb=" and "--files=" do NOT contradict or override; instead,
   they are logically ANDed together. So if you command:
   census.pl --gb=1.3 --files=500
   then census.pl will print info on only those folders which contain both
   1.3GB-or-more of content AND 500+ files.

   If "-e|--empty", "--gb=", or "--files=" are NOT used, then this program prints
   info on ALL directories in the directory tree descending from the cwd.

   Description of arguments:
   In addition to options, "census.pl" can take one optional argument which, if
   present, must be a Perl-Compliant Regular Expression specifying which items to
   process. To specify multiple patterns, use the | alternation operator.
   To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to search for items with names containing "cat",
   "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead. 

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
