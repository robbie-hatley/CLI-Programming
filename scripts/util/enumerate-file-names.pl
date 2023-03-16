#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# enumerate-file-names.pl
# Adds a "numerator" of the form "-(####)" (where # means "random digit") at end of the prefix of the name of
# every file in the current working directory (and all of its subdirectories if a "-r" or "--recurse" option
# is used). This helps with the aggregation and de-duping of files with the same name prefix and possibly
# the same content.
#
# Also check-out the following programs, which are intended to be used in conjunction with this program:
# "dedup-files.pl"
# "dedup-newsbin-files.pl"
# "denumerate-file-names.pl"
#
# Author: Robbie Hatley.
#
# Edit history:
# Mon Apr 27, 2015: Wrote first draft. Kinda skeletal at this point. Stub.
# Thu Apr 30, 2015: Made many additions and changes. Now fully functional.
# Mon Jul 06, 2015: Corrected some minor errors.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Mon Dec 25, 2017: Added and corrected comments.
# Mon Feb 24, 2020: Changed width to 110 and added entry, stats, and exit announcements.
# Tue Jan 19, 2021: Heavily refactored. Got rid of all global vars, now using prototypes, etc.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Sat Dec 04, 2021: Now using regexp instead of wildcard.
# Wed Mar 15, 2023: Added options for local, recursive, quiet, and verbose.
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
sub curfile ($) ; # Process current file.
sub stats   ()  ; # Print statistics.
sub error   ($) ; # Handle errors.
sub help    ()  ; # Print help and exit.

# ======= VARIABLES: ===================================================================================================

# Settings:                    Meaning:                     Range:    Default:
my $db        = 0          ; # Debug (print diagnostics)?   bool      0 (don't print diagnostics)
my $Target    = 'F'        ; # Files, dirs, both, all?      F|D|B|A   F (files only)
my $RegExp    = qr/^.+$/o  ; # Regular Expression.          regexp    qr/^.+$/o (matches all strings)
my $Recurse   = 1          ; # Recurse subdirectories?      bool      1 (recurse)
my $Verbose   = 1          ; # Be verbose?                  bool      1 (be verbose)

# Counters:
my $direcount = 0          ; # Directories processed.
my $filecount = 0          ; # Files processed.
my $skipcount = 0          ; # Files skipped.
my $enumcount = 0          ; # Files enumerated.
my $failcount = 0          ; # Failed enumeration attempts.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   say "Target  = $Target";
   say "RegExp  = $RegExp";
   say "Recurse = $Recurse";
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
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
            if ( $_ eq '-h' || $_ eq '--help'    ) {help; exit 777;}
         elsif ( $_ eq '-l' || $_ eq '--local'   ) {$Recurse =  0 ;}
         elsif ( $_ eq '-r' || $_ eq '--recurse' ) {$Recurse =  1 ;} # Default
         elsif ( $_ eq '-q' || $_ eq '--quiet'   ) {$Verbose =  0 ;}
         elsif ( $_ eq '-v' || $_ eq '--verbose' ) {$Verbose =  1 ;} # Default
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

   # Get current working directory:
   my $cwd = cwd_utf8;

   # If being verbose, announce current working directory:
   say "\nDirectory # $direcount: $cwd\n" if $Verbose;

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, $Target, $RegExp);

   # Iterate through $curdirfiles and send each file to curfile():
   foreach my $file (@{$curdirfiles})
   {
      curfile($file);
   }
   return 1;
} # end sub curdire ()

# Process current file:
sub curfile ($)
{
   # Increment file counter:
   ++$filecount;

   # Get file, path, and name:
   my $file = shift;
   my $path = $file->{Path};
   my $name = $file->{Name};

   # Declare and initialize any other variables we'll need here:
   my $newname = '';
   my $success = 0;

   # Try to find an available enumerated version of $name:
   $newname = find_avail_enum_name($name);
   if ($newname eq '***ERROR***')
   {
      warn
      "\nWarning in sub curfile in program \"enumerate-file-names.pl\":\n".
      "could not enumerate this file:\n".
      "$name\n".
      "because no available enumerated version of the file's name could be found.\n".
      "Skipping to next file.\n";
      ++$skipcount;
      return 0;
   }

   # If we get to here, attempt to rename the file from $name to $newname:
   $success = rename_file($name, $newname);
   if ($success)
   {
      say "$name => $newname";
      ++$enumcount;
      return 1;
   }
   else
   {
      warn 
      "\nError in sub curfile in program \"enumerate-file-names.pl\":\n".
      "The followed attempted file rename failed:\n".
      "$name => $newname\n".
      "Moving on to next file.\n";
      ++$failcount;
      return 0;
   }
} # end sub curfile ($)

# Print statistics for this program run:
sub stats ()
{
   say '';
   say 'Statistics for program "enumerate-file-names.pl":';
   say "\$RegExp = '$RegExp'.";
   printf("Traversed  %6u directories.           \n" , $direcount);
   printf("Found      %6u files matching RegExp. \n" , $filecount);
   printf("Skipped    %6u unenumerable files.    \n" , $skipcount);
   printf("Enumerated %6u files.                 \n" , $enumcount);
   printf("Failed     %6u file rename attempts.  \n" , $failcount);
   return 1;
} # end sub stats ()

# Handle errors:
sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $NA arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which files to enumerate. Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end sub error ($)

# Print help:
sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to EnumerateFileNames, Robbie Hatley's file-enumerating script.
   This program tacks "numerators" of the form "-(####)" (where "#" is any digit)
   to the ends of the prefixes of all file names in the current working 
   directory (and all of its subdirectories if a -r or --recurse option is used).

   Command line:
   enumerate-file-names.pl [-h|--help]            (to print this help and exit)
   enumerate-file-names.pl [-r|--recurse] [Arg1]  (to enumerate file names)

   Description of options:
   Option:               Meaning:
   "-h" or "--help"      Print help and exit.
   "-l" or "--local"     Don't recurse subdirectories.
   "-r" or "--recurse"   Recurse subdirectories.         (DEFAULT)
   "-q" or "--quiet"     Don't announce directories.
   "-v" or "--verbose"   Do    announce directories.     (DEFAULT)

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

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
