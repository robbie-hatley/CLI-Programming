#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
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
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Sat Dec 04, 2021: Now using regexp instead of wildcard.
# Wed Mar 15, 2023: Added options for local, recursive, quiet, and verbose.
# Sat Aug 19, 2023: Upgraded from "v5.32" to "v5.36". Reduced width from 120 to 110. Got rid of CPAN module
#                   "common::sense" (antiquated). Got rid of all prototypes. Now using signatures.
# Sun Aug 20, 2023: Now printing diagnostics, errors, and stats to STDERR, but everything else to STDOUT.
# Mon Aug 21, 2023: Increased parallelism between "denumerate-file-names.pl" and "enumerate-file-names.pl".
# Mon Aug 21, 2023: An "option" is now "one or two hyphens followed by 1-or-more word characters".
#                   Reformated debug printing of opts and args to ("word1", "word2", "word3") style.
#                   Inserted text into help explaining the use of "--" as "end of options" marker.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

use Sys::Binmode;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ; # Process @ARGV.
sub curdire ; # Process current directory.
sub curfile ; # Process current file.
sub stats   ; # Print statistics.
sub error   ; # Handle errors.
sub help    ; # Print help and exit.

# ======= VARIABLES: =========================================================================================

# Settings:                       Meaning of setting:          Range:    Meaning of default:
   $"         = ' '           ; # Quoted array formatting.     string    Separate elements with spaces.
   $,         = ' '           ; # Listed array formatting.     string    Separate elements with spaces.
my $db        = 0             ; # Debug (print diagnostics)?   bool      Don't print diagnostics.
my $Verbose   = 0             ; # Be verbose?                  bool      Be quiet.
my $Recurse   = 0             ; # Recurse subdirectories?      bool      Don't recurse.
my $RegExp    = qr/^[^.].+$/o ; # What files to enumerate?     regexp    Process only non-hidden files.
my $Bypass    = 0             ; # Bypass already-enumerated?   bool      Don't bypass already-enumerated.

# Counters:
my $direcount = 0 ; # Count of directories processed.
my $filecount = 0 ; # Count of files processed.
my $bypacount = 0 ; # Count of files bypassed because they were already enumerated.
my $skipcount = 0 ; # Count of files skipped because no available enumerated name could be found.
my $attecount = 0 ; # Count of file rename attempts.
my $succcount = 0 ; # Count of files successfully renamed.
my $failcount = 0 ; # Count of failed file rename attempts.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   my $pname = get_name_from_path($0);
   if ( $db || $Verbose ) {
      say STDERR '';
      say STDERR "Now entering program \"$pname\".";
      say STDERR "\$db      = $db";
      say STDERR "\$Verbose = $Verbose";
      say STDERR "\$Recurse = $Recurse";
      say STDERR "\$RegExp  = $RegExp";
   }
   if ( $db ) {exit 555}

   $Recurse and RecurseDirs {curdire} or curdire;

   stats;
   my $te = time - $t0;
   if ( $Verbose ) {
      say    STDERR '';
      say    STDERR "Now exiting program \"$pname\".";
      printf STDERR "Execution time was %.3f seconds.", $te;
   }
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

sub argv {
   # Get options and arguments:
   my @opts = (); my @args = (); my $end_of_options = 0;
   for ( @ARGV ) {
      /^--$/ and $end_of_options = 1 and next;
      !$end_of_options && /^--?\w+$/ and push @opts, $_ or push @args, $_;
   }

   # Process options:
   for ( @opts ) {
      /^-\w*h|^--help$/     and help and exit 777 ;
      /^-\w*e|^--debug$/    and $db      =  1     ;
      /^-\w*q|^--quiet$/    and $Verbose =  0     ;
      /^-\w*v|^--verbose$/  and $Verbose =  1     ;
      /^-\w*l|^--local$/    and $Recurse =  0     ;
      /^-\w*r|^--recurse$/  and $Recurse =  1     ;
      /^-\w*b|^--bypass$/   and $Bypass  =  1     ;
   }
   if ( $db ) {
      say   STDERR '';
      print STDERR "opts = ("; print STDERR map {'"'.$_.'"'} @opts; say STDERR ')';
      print STDERR "args = ("; print STDERR map {'"'.$_.'"'} @args; say STDERR ')';
   }

   # Process arguments:
   my $NA = scalar @args;
   $NA >= 1 and $RegExp = qr/$args[0]/o;                  # Set $RegExp.
   $NA >= 2 && !$db and error($NA) and help and exit 666; # Too many arguments.

   # Return success code 1 to caller:
   return 1;
} # end sub argv

# Process current directory:
sub curdire {
   # Increment directory counter:
   ++$direcount;

   # Get current working directory:
   my $cwd = cwd_utf8;

   # Announce current working directory:
   say STDOUT '';
   say STDOUT "Directory # $direcount: $cwd";

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, 'F', $RegExp);

   # Iterate through $curdirfiles and send each file to curfile():
   foreach my $file ( @$curdirfiles ) {
      curfile($file);
   }
   return 1;
} # end sub curdire

# Process current file:
sub curfile ($file)
{
   # Increment file counter:
   ++$filecount;

   # Get path and name:
   my $path = $file->{Path};
   my $name = $file->{Name};

   # Bypass this file if it is numerated and $Bypass is set:
   if ( get_prefix($name) =~ m/-\(\d\d\d\d\)$/ && $Bypass ) {
      ++$bypacount;
      return 1;
   }

   # Set $newname to a  enumerated version of $name:
   my $newname = find_avail_enum_name($name);

   # Skip this file if no suitable new name was available (only happens if nearly 10,000 copies exist):
   if ( $newname eq '***ERROR***' ) {
      say STDOUT '';
      say STDOUT "Can't  enumerate \"$name\" because no available name could be found.";
      ++$skipcount;
      return 1;
   }

   # If we get to here, attempt to rename the file from $name to $newname:
   ++$attecount;
   say STDOUT '';
   say STDOUT "File rename attempt #$attecount:";
   say STDOUT "Old name: $name";
   say STDOUT "New name: $newname";
   if ( rename_file($name, $newname) ) {
      ++$succcount;
      say STDOUT "File successfully renamed!";
      return 1;
   }
   else {
      ++$failcount;
      say STDOUT "File rename failed!";
      return 0;
   }
} # end sub curfile ($file)

# Print statistics for this program run:
sub stats {
   if ( $Verbose ) {
      say    STDERR '';
      say    STDERR 'Statistics for program "enumerate-file-names.pl":';
      printf STDERR "Traversed   %6u directories.           \n" , $direcount;
      printf STDERR "Found       %6u files matching RegExp. \n" , $filecount;
      printf STDERR "Bypassed    %6u numerated files.       \n" , $bypacount;
      printf STDERR "Skipped     %6u unenumerable files     \n" , $skipcount;
      printf STDERR "Attempted   %6u file renames.          \n" , $attecount;
      printf STDERR "Enumerated  %6u files.                 \n" , $succcount;
      printf STDERR "Failed      %6u file rename attempts.  \n" , $failcount;
   }
   return 1;
} # end sub stats

# Handle errors:
sub error ($NA)
{
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $NA arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which files to enumerate. Help follows:
   END_OF_ERROR
} # end sub error ($NA)

# Print help:
sub help
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to EnumerateFileNames, Robbie Hatley's file-enumerating script.
   This program tacks "numerators" of the form "-(####)" (where "#" is any digit)
   to the ends of the prefixes of all regular files in the current working
   directory (and all of its subdirectories if a -r or --recurse option is used).

   -------------------------------------------------------------------------------
   Command Lines:

   enumerate-file-names.pl [-h|--help]             (to print this help and exit)
   enumerate-file-names.pl [-r|--recurse] [Arg1]   (to enumerate file names)

   -------------------------------------------------------------------------------
   Description of Options:

   Option:            Meaning:
   -h or --help       Print this help and exit.
   -e or --debug      Print diagnostics then exit.
   -q or --quiet      DON'T print directories and stats.  (DEFAULT)
   -v or --verbose    DO    print directories and stats.
   -l or --local      DON'T recurse subdirectories.       (DEFAULT)
   -r or --recurse    DO    recurse subdirectories.
   -b or --bypass     Bypass already-numerated files.
         --           End of options (all further CL items are arguments).

   If you want to use an argument that looks like an option (say, you want to
   search for files which contain "--recurse" as part of their name), use a "--"
   option; that will force all command-line entries to its right to be considered
   "arguments" rather than "options".

   All options not listed above are ignored.

   -------------------------------------------------------------------------------
   Description of Arguments:

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

   Happy file enumerating!

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
__END__
