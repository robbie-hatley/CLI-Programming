#!/usr/bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# fix-spacey-directory-names.pl
# Converts spaces (and other troublesome characters) in directory names to BASH-safe characters.
# Written by Robbie Hatley.
# Edit history:
# Sat Mar 18, 2023: Wrote it.
########################################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;

use Sys::Binmode;
use Time::HiRes 'time';
use Cwd 'getcwd';

use RH::Dir;
use RH::Util;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ; # Process @ARGV.
sub curdire ; # Process current directory.
sub curfile ; # Process current file.
sub stats   ; # Print statistics.
sub error   ; # Handle errors.
sub help    ; # Print help and exit.

# ======= VARIABLES: ===================================================================================================

# Settings:                    Meaning:                     Range:    Default:
my $db        = 0          ; # Debug (print diagnostics)?   bool      0 (don't print diagnostics)
my $RegExp    = qr/^.+$/o  ; # Regular Expression.          regexp    qr/^.+$/o (matches all strings)
my $Recurse   = 1          ; # Recurse subdirectories?      bool      1 (recurse)
my $Verbose   = 1          ; # Be wordy?                    bool      1 (blab)

# Counters:
my $direcount = 0          ; # Count of directories processed by curdire().
my $renacount = 0          ; # Count of directories renamed   by curfile().
my $failcount = 0          ; # Count of failed directory rename attempts.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   # Preliminaries:
   my $t0 = time;
   argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\"." if $Verbose;
   say "RegExp  = $RegExp" if $Verbose;
   say "Recurse = $Recurse" if $Verbose;
   say "Verbose = $Verbose" if $Verbose;

   # Process subdirectories of cwd if recursing:
   RecurseDirs {curdire} if $Recurse;

   # Process cwd:
   curfile(d getcwd);

   # Print stats and elapsed time and exit:
   stats if $Verbose;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds." if $Verbose;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

# Process @ARGV :
sub argv
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL]{1,}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if ( $_ eq '-h' || $_ eq '--help'    ) {help; exit 777;}
         elsif ( $_ eq '-q' || $_ eq '--quiet'   ) {$Verbose =  0 ;}
         elsif ( $_ eq '-v' || $_ eq '--verbose' ) {$Verbose =  1 ;} # DEFAULT
         elsif ( $_ eq '-l' || $_ eq '--local'   ) {$Recurse =  0 ;}
         elsif ( $_ eq '-r' || $_ eq '--recurse' ) {$Recurse =  1 ;} # DEFAULT

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
   if    ( 0 == $NA ) {                                  } # Do nothing.
   elsif ( 1 == $NA ) {$RegExp = qr/$ARGV[0]/o           } # Set $RegExp.
   else               {error($NA); say ''; help; exit 666} # Print error and help messages then exit 666.
   return 1;
} # end sub argv

# Process current directory:
sub curdire
{
   # Get list of subdirectory-info packets in cwd matching $RegExp:
   my $cwd = d getcwd;
   my $curdirfiles = GetFiles($cwd, 'D', $RegExp);

   # Iterate through $curdirfiles and send each file to curfile():
   foreach my $dire (@{$curdirfiles})
   {
      curfile($dire->{Path});
   }
   return 1;
} # end sub curdire

# Process current file:
sub curfile ($oldpath)
{
   # Increment file counter:
   ++$direcount;

   # Announce directory if being verbose:
   say "\nDirectory # $direcount: \"$oldpath\"." if $Verbose;

   # Get cwd and names:
   my $cwd     = get_dir_from_path($oldpath);
   my $oldname = get_name_from_path($oldpath);
   my $newname = $oldname;

   # Clean name:
   $newname = tc $newname;
   $newname =~ s/\'/’/g;
   $newname =~ s/\`/’/g;
   $newname =~ s/\s+-+|-+\s+|\s+-+\s+/_/g;
   $newname =~ s/\s*,\s*/_/g;
   $newname =~ s/\s*\.\s*/_/g;
   $newname =~ s/\s*&\s*/-And-/g;
   $newname =~ s/\s*\(\s*/_/g;
   $newname =~ s/\s*\)\s*$//;
   $newname =~ s/\s*\)\s*/_/g;
   $newname =~ s/\s*\[\s*/_/g;
   $newname =~ s/\s*\]\s*$//;
   $newname =~ s/\s*\]\s*/_/g;
   $newname =~ s/\s+/-/g;
   $newname =~ s/_{2,}/_/g;

   # If new name is different from old name, clean-up directory name:
   if ($newname ne $oldname){
      say "Renaming \"$oldname\" => \"$newname\"";
      my $newpath = path($cwd,$newname);
      rename_file($oldpath,$newpath) and ++$renacount
      or ++$failcount and warn "Rename failed.\n$!\n";}

   # We're done, so scram:
   return 1;
} # end sub curfile

# Print statistics for this program run:
sub stats
{
   say "\nStatistics for this directory tree:";
   say "Examined $direcount directory names.";
   say "Renamed  $renacount troublesome directory names.";
   say "Failed   $failcount renamed attempts.";
   return 1;
} # end sub stats

# Handle errors:
sub error ($err_msg)
{
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $err_msg arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which directories to process.
   END_OF_ERROR
} # end sub error

# Print help:
sub help
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "fix-spacey-directory-names.pl". This program converts spaces and
   other BASH-unfriendly characters in the name of the current directory
   (and in the names of all subdirectories if a -r or --recurse option is used)
   to BASH-safe characters, so that directory names do not require quoting when
   used in BASH commands.

   Command lines:
   program-name.pl -h | --help            (to print this help and exit)
   program-name.pl [options] [arguments]  (to clean-up directory names)

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-q" or "--quiet"            Don't be verbose.
   "-v" or "--verbose"          Do    be Verbose.    (DEFAULT)
   "-l" or "--local"            Don't recurse.
   "-r" or "--recurse"          Do    recurse.       (DEFAULT)

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

   Happy directory-name cleaning!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
