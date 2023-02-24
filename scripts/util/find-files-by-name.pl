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
#
# Written by Robbie Hatley.
#
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
# Mon Feb 20, 2023: Upgraded to 5.36. Got rid of all prototypes (they were all empty anyway). Fixed help and argv.
#                   Put 'use feature "signatures";' after 'use common::sense;" to fix conflict between
#                   common::sense and signatures.
########################################################################################################################

use v5.36;
use common::sense;
use feature "signatures";

use Sys::Binmode;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv     ; # Process @ARGV.
sub curdire  ; # Process current directory.
sub stats    ; # Print statistics.
sub error    ; # Print error message, print help message, and exit 666.
sub help     ; # Print help.

# ======= VARIABLES: ===================================================================================================

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# Settings:                    Meaning:                  Range:    Default:
my $Recurse   = 1          ; # Recurse subdirectories?   bool      1
my $Verbose   = 0          ; # Be wordy?                 bool      0
my $RegExp    = qr/^.+$/o  ; # Regular expression.       regexps   qr/^.+$/o (matches all files)
my $Target    = 'A'        ; # Files, dirs, both, all?   F|D|B|A   'A'

# Counters:
my $direcount = 0          ; # Count of directories processed.
my $pathcount = 0          ; # Count of paths found matching given target and regexps.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   print STDERR "\nNow entering program \"" . get_name_from_path($0) . "\".\n"  if $Verbose;
   print STDERR "Verbose   = $Verbose\n"                                        if $Verbose;
   print STDERR "Recurse   = $Recurse\n"                                        if $Verbose;
   print STDERR "RegExp    = $RegExp\n"                                         if $Verbose;
   print STDERR "Target    = $Target\n"                                         if $Verbose;
   $Recurse and RecurseDirs {curdire} or curdire;
   stats                                                                        if $Verbose;
   my $t1 = time; my $te = $t1 - $t0;
   print STDERR "\nNow exiting program \"" . get_name_from_path($0) . "\".\n"   if $Verbose;
   print STDERR "Execution time was $te seconds.\n"                             if $Verbose;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

# Process @ARGV:
sub argv
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

   # Get number of arguments and take action accordingly:
   my $NA = scalar @ARGV;
   if    ( 0 == $NA ) {}                                               # Do nothing. (Use default settings.)
   elsif ( 1 == $NA ) {$RegExp = qr/$ARGV[0]/;}                        # Set RegExp.
   else               {error($NA);}                                    # Error.


   return 1;                                                           # Redi ad munus vocationis.
} # end sub argv

# Process current directory:
sub curdire
{
   # Increment directory counter:
   ++$direcount;

   # Get current working directory:
   my $cwd = cwd_utf8;

   # If being verbose, announce $cwd:
   print STDERR "\nDir # $direcount: $cwd\n\n" if $Verbose;

   # Return without doing anything further if $cwd is not a fully-qualified path to an existing directory:
   my $valid = is_valid_qual_dir($cwd);
   if ( ! $valid )
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
} # end sub curdire

# Print stats:
sub stats
{
   warn "\n";
   warn "Stats for \"find-files-by-name.pl\":\n";
   warn "Target = \"$Target\"\n";
   warn "RegExp = \"$RegExp\"\n";
   warn "Navigated $direcount directories.\n";
   warn "Found $pathcount paths matching given target and regexp.\n";
   return 1;
} # end sub stats

# Print error and help messages and exit 666:
sub error ($NA)
{
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $NA arguments, but \"find-files-by-name.pl\"
   requires either 0 or 1 arguments. Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end error ($NA)

# Print help message:
sub help
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
   In addition to options, this program takes 0 or 1 arguments.
   
   Argument 1 (optional), if present, must be a Perl-Compliant Regular Expression
   specifying which items to process. To specify multiple patterns, use the "|"
   alternation operator. To apply pattern modifier letters, use an Extended RegExp
   Sequence. For example, if you want to search for items with names containing
   "cat", "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   A number of arguments other than 0 or 1 will result in this program printing
   an error message and this help message and terminating.

   (A number of arguments less than 0 will likely rupture our spacetime manifold
   and destroy everything. But if you DO somehow manage to use a negative number
   of arguments without destroying the universe, please send me an email at
   "Hatley.Software@gmail.com", because I'd like to know how you did that!)

   (But if you somehow manage to use a number of arguments which is an irrational
   or complex number, please keep THAT to yourself. Some things would be better
   for my sanity for me not to know. I don't want to find myself enthralled to
   Cthulhu.)

   Happy file finding!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
