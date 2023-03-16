#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# "dolphin-ctrl1.pl"
# Pastes appropriate ".directory" file to each subdirectory of current directory with 1-or-more picture files
# (jpg, bmp, png, or gif) in it.
#
# Written by Robbie Hatley.
#
# Edit history:
# Mon Mar 13, 2023: Wrote it.
# Tue Mar 14, 2023: Expanded from jpg to (jpg,bmp,png,gif) and make extensions case-insensitive.
########################################################################################################################

use v5.36;
use strict;
use warnings;

use Sys::Binmode;
use Time::HiRes 'time';

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    :prototype()  ; # Process @ARGV.
sub curdire :prototype()  ; # Process current directory.
sub stats   :prototype()  ; # Print statistics.
sub error   :prototype($) ; # Handle errors.
sub help    :prototype()  ; # Print help and exit.

# ======= VARIABLES: ===================================================================================================

# Settings:                    Meaning:                     Range:    Default:
my $db        = 0          ; # Debug (print diagnostics)?   bool      0 (don't print diagnostics)
my $RegExp    = qr/^.+$/o  ; # Regular Expression.          regexp    qr/^.+$/o (process all directories)
my $Recurse   = 1          ; # Recurse subdirectories?      bool      1 (recurse)
my $Verbose   = 0          ; # Be wordy?                    bool      0 (be quiet)

# Path to a known "ctrl-1"-style ".directory" file:
my $dpath = '/home/aragorn/rem/Xanadu/Adults/Naked/.directory';

# Counters:
my $direcount = 0          ; # Count of directories processed by curdire().
my $copycount = 0          ; # Count of ".directory" files copied.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   say "RegExp  = $RegExp";
   say "Recurse = $Recurse";
   say "Verbose = $Verbose";
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

# Process @ARGV :
sub argv :prototype()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL]{1,}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if ( $_ eq '-h' || $_ eq '--help'    ) {help; exit 777;}
         elsif ( $_ eq '-r' || $_ eq '--recurse' ) {$Recurse =  1 ;} # DEFAULT
         elsif ( $_ eq '-l' || $_ eq '--local'   ) {$Recurse =  0 ;}
         elsif ( $_ eq '-v' || $_ eq '--verbose' ) {$Verbose =  1 ;}
         elsif ( $_ eq '-q' || $_ eq '--quiet'   ) {$Verbose =  0 ;} # DEFAULT

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
   if    ( 0 == $NA ) {                          } # Do nothing.
   elsif ( 1 == $NA ) {$RegExp = qr/$ARGV[0]/o   } # Set $RegExp.
   else               {error($NA); help; exit 666} # Print error and help messages then exit 666.
   return 1;
} # end sub argv :prototype()

# Process current directory:
sub curdire :prototype()
{
   # Get current working directory:
   my $cwd = cwd_utf8;

   # Just return 1 if this directory doesn't match our regexp:
   return 1 if $cwd !~ m/$RegExp/;

   # Increment directory counter:
   ++$direcount;

   # Announce directory if being verbose:
   say "\nDirectory # $direcount: $cwd\n" if $Verbose;

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, 'F', $RegExp);

   # How many jpg files are in this directory?
   my $jpgs = 0;
   foreach my $file (@{$curdirfiles})
   {
      if 
      (
            get_suffix($file->{Name}) =~ m/jpg/i
         || get_suffix($file->{Name}) =~ m/bmp/i
         || get_suffix($file->{Name}) =~ m/png/i
         || get_suffix($file->{Name}) =~ m/gif/i
      )
      {
         ++$jpgs;
         last;
      }
   }

   # If 1-or-more jpgs exist in this directory, then copy a "picture view" ".directory" file here:
   if ( $jpgs >= 1 )
   {
      my $directory_file_path = path($cwd, ".directory");
      if ( -e e $directory_file_path )
      {
         say "Erasing $directory_file_path";
         unlink e path($cwd, ".directory");
      }
      say ".directory => $cwd";
      my $success = ! system(e("cp '$dpath' '$cwd'"));
      if ( $success ) {++$copycount;}
      else            {warn "Failed to copy .directory file to $cwd\n";}
   }

   # We're done, so return 1:
   return 1;
} # end sub curdire :prototype()

# Print statistics for this program run:
sub stats :prototype()
{
   say '';
   say 'Statistics for this directory tree:';
   say "Found $direcount directories matching RegExp.";
   say "Copied $copycount copies of \".directory\" to directories with pictures.";
   return 1;
} # end sub stats :prototype()

# Handle errors:
sub error :prototype($)
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

# Print help:
sub help :prototype()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "dolphin-ctrl1.pl". This program pastes a "ctrl-1" type Dolphin
   ".directory" file to each subdirectory of the current directory which contains
   1-or-more picture (jpg, bmp, png, or gif) files. This causes picture files to 
   be displayed as picture thumbnails instead of as lines of text.

   Command lines:
   program-name.pl -h | --help            (to print help and exit)
   program-name.pl [options] [arguments]  (to copy ".directory" )

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-r" or "--recurse"          Recurse subdirectories. (DEFAULT)
   "-l" or "--local"            Don't recurse subdirectories.
   "-v" or "--verbose"          Print directories.
   "-q" or "--quiet"            Don't print directories. (DEFAULT)

   Description of arguments:
   In addition to options, this program can take one optional argument which,
   if present, must be a Perl-Compliant Regular Expression specifying which 
   directories process. To specify multiple patterns, use the | alternation 
   operator. To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to search for items with names containing "cat",
   "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead. 

   Happy picture viewing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help :prototype()
