#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# find-files-by-name.pl
# Finds directory entries in current directory (and all subdirectories, unless a -l or --local option is used)
# which match a given target ("files", "directories", "both", or "all") and which have names which match a
# given Perl-Compliant Regular Expression and flags, and prints their full paths. Default recursion is "on",
# default target is "All", default regex is qr(^.+$), and default flags are ''.
# Edit history:
# Sun Sep 06, 2020: Wrote first draft;
# Mon Feb 01, 2021: Now using both regular expression and optional wildcard.
# Tue Feb 09, 2021: Got rid of two versions of this program (I apparently wrote it in 2020 and forgot about it, then
#                   wrote it again in 2021) and consolidated into this version. Got rid of most of the boiler plate
#                   (now using common::sense).
# Sat Feb 13, 2021: No-longer using a wildcard at all, as it's superfluous now that we're using a regex. Now using my
#                   "glob_regexp_utf8" function.
# Sun Feb 28, 2021: Added case-insensitive search.
# Fri Mar 12, 2021: Correct errors in comments, and changed "use v5.16" to "use v5.30".
# Wed Mar 17, 2021: Extreme refactor. Now accepts unlimited number of regexps. Also, now requires qr(delimiters) on each
#                   regexp, like my "match.pl" does. Also, now using Sys::Binmode. Also, now using raw readdir, then
#                   manually decoding each incoming directory entry to "$name", and only encoding IMMEDIATELY BEFORE
#                   send-out, as I've discovered that trying to hold encoded strings in-memory corrupts MinTTY settings
#                   so that some characters become boxes. In other words, my "e" sub should be used inline, in the style
#                   of "functional programming".
# Tue Nov 16, 2021: Now using extended regexp sequences ('(?i:dog)') instead of regexp delimiters ('/dog/i') for args.
# Wed Nov 17, 2021: Now using "if/elsif" instead of "and" in "sub argv ()".
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ()  ; # Process @ARGV.
sub curdire ()  ; # Process current directory.

sub stats   ()  ; # Print statistics.
sub help    ()  ; # Print help.

# ======= VARIABLES: ===================================================================================================

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# Settings:                    Meaning:                  Range:    Default:
my $Recurse   = 1          ; # Recurse subdirectories?   bool      1
my $Verbose   = 0          ; # Be wordy?                 bool      0
my $Target    = 'A'        ; # Files, dirs, both, all?   F|D|B|A   'A'
my $RegExp    = qr/^.+$/o  ; # Regular expression.       regexps   qr/^.+$/o (matches all files)

# Counters:
my $direcount = 0          ; # Count of directories processed.
my $pathcount = 0          ; # Count of paths found matching given target and regexps.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\"."                                 if $Verbose;
   print STDERR "Now entering program \"find-files-by-name.pl\".\n"                                 if $Verbose;
   print STDERR "Verbose = $Verbose\n"                                                              if $Verbose;
   print STDERR "Recurse = $Recurse\n"                                                              if $Verbose;
   print STDERR "Target  = $Target\n"                                                               if $Verbose;
   print STDERR "RegExp  = $RegExp\n"                                                               if $Verbose;
   $Recurse and RecurseDirs {curdire} or curdire;
   stats                                                                                            if $Verbose;
   my $t1 = time; my $te = $t1 - $t0;
   say("\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.") if $Verbose;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub argv ()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if (/^-h$/ || /^--help$/        ) {help; exit 777;}
         elsif (/^-l$/ || /^--local$/       ) {$Recurse =  0 ;}
         elsif (/^-r$/ || /^--recurse$/     ) {$Recurse =  1 ;} # DEFAULT
         elsif (/^-q$/ || /^--quiet$/       ) {$Verbose =  0 ;} # DEFAULT
         elsif (/^-v$/ || /^--verbose$/     ) {$Verbose =  1 ;}
         elsif (/^-f$/ || /^--target=files$/) {$Target  = 'F';}
         elsif (/^-d$/ || /^--target=dirs$/ ) {$Target  = 'D';}
         elsif (/^-b$/ || /^--target=both$/ ) {$Target  = 'B';}
         elsif (/^-a$/ || /^--target=all$/  ) {$Target  = 'A';} # DEFAULT

         # Remove option from @ARGV:
         splice @ARGV, $i, 1;

         # Move the index 1-left, so that the "++$i" above
         # moves the index back to the current @ARGV element,
         # but with the new content which slid-in from the right
         # due to deletion of previous element contents:
         --$i;
      }
   }
   if (scalar(@ARGV) > 0) {$RegExp = qr/$ARGV[0]/o;}
   return 1;
} # end sub argv ()

sub curdire ()
{
   # Increment directory counter:
   ++$direcount;

   # Get current working directory:
   my $cwd = cwd_utf8;

   # If being verbose, announce $curdir:
   print STDERR "\nDir # $direcount: $cwd\n\n" if $Verbose;

   # Return without doing anything further if $cwd is undefined, an empty string, has length < 1, or 
   # the first character isn't "/":
   my $flag;
   if ( !defined($cwd) )
   {
      print STDERR "\n\$cwd is not defined.\n";
      $flag = 1;
   }
   elsif ( $cwd eq '' )
   {
      print STDERR "\n\$cwd is an empty string.\n";
      $flag = 1;
   }
   elsif ( length($cwd) < 1 )
   {
      print STDERR "\n\$cwd is has length less than one.\n";
      $flag = 1;
   }
   elsif ( substr($cwd,0,1) ne '/' )
   {
      print STDERR "\n\$cwd does not start with a slash: $cwd\n";
      $flag = 1;
   }
   else
   {
      $flag = 0;
   }
   if ($flag)
   {
      print STDERR "Warning in \"find-files-by-name.pl\":\n" . 
                   "cwd_utf8 returned an invalid directory name.\n" . 
                   "Skipping this directory and moving on to next.\n\n";
      return 1;
   }

   # Get ref to array of file-info packets for all files in current directory matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, $Target, $RegExp);

   # Increment path counter and print path for each matching file:
   foreach my $file (@{$curdirfiles})
   {
      my $path = $file->{Path};
      my $name = $file->{Name};
      if ($name =~ m/$RegExp/)
      {
         ++$pathcount;
         say $path;
      }
   }
   return 1;
} # end sub curdire ()

sub stats ()
{
   warn "\n";
   warn "Stats for \"find-files-by-name.pl\":\n";
   warn "Target = \"$Target\"\n";
   warn "RegExp = \"$RegExp\"\n";
   warn "Navigated $direcount directories.\n";
   warn "Found $pathcount paths matching given target and regexp.\n";
   return 1;
} # end sub stats ()

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "find-files-by-name.pl". This program finds directory entries in
   the current directory (and all subdirectories, unless a -l or --local option
   is used) which match a given target ("files", "directories", "both", or "all",
   defaulting to "all") and which have names which match given Perl-Compliant
   Regular Expressions (defaulting to the single regular expression '^.+$', which
   matches all file names) and prints their full paths. If no target, no regexps,
   and no options are specified, this program prints all directory-tree entries.

   Command lines:
   find-files-by-name.pl [-h|--help]            (to print help)
   find-files-by-name.pl [options] [arguments]  (to find files)

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-l" or "--local"            Be local.
   "-r" or "--recurse"          Recurse subdirectories. (DEFAULT)
   "-q" or "--quiet"            Be quiet. (DEFAULT)
   "-v" or "--verbose"          Be verbose.
   "-f" or "--target=files"     Find regular files only.
   "-d" or "--target=dirs"      Find directories.
   "-b" or "--target=both"      Find both files and directories.
   "-a" or "--target=all"       Find ALL directory entries. (DEFAULT)
   All other options are ignored.

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

   Happy file finding!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
