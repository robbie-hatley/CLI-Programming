#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# repair-dolphin-directory-files.pl"
# For the current directory and all subdirectories (unless a -l or --local option is used), make sure that the Dolphin
# ".directory" file is uncorrupted and appropriate for the contents of the directory. This means that directories which
# contain 1-or-more picture files (jpg, jpeg, bmp, png, apng, gif, tif, tiff) should have a "thumbnails" or ctrl-1
# ".directory" file, and all other directories should have a "details" or ctrl-3 ".directory" file.
#
# Written by Robbie Hatley.
#
# Edit history:
# Mon Mar 13, 2023: Wrote it.
# Tue Mar 14, 2023: Expanded from jpg to (jpg,bmp,png,gif) and make extensions case-insensitive.
# Sun Mar 19, 2023: Made "error" a "do just one thing" function, fixed "error" and "help" duplication bug, removed all
#                   "prototypes", added "signature" to "error", and added "use utf8" (necessary due to removal of
#                   "use common::sense").
# Mon Mar 20, 2023: Renamed from "dolphin-ctrl1.pl" to "repair-dolphin-directory-files.pl". Changed program semantics
#                   so that it doesn't just paste a ctrl-1 file to "picture" directories, but also pastes a ctrl-3 file
#                   to non-picture directories.
########################################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;

use Sys::Binmode;
use Time::HiRes 'time';
use Sys::Hostname;

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ; # Process @ARGV.
sub curdire ; # Process current directory.
sub stats   ; # Print statistics.
sub error   ; # Handle errors.
sub help    ; # Print help and exit.

# ======= VARIABLES: ===================================================================================================

# Settings:     Default:       Meaning of setting:          Range:    Meaning of default:
my $db        = 0          ; # Debug (print diagnostics)?   bool      Don't print diagnostics.
my $RegExp    = qr/^.+$/o  ; # Regular Expression.          regexp    Process all directory names.
my $Recurse   = 0          ; # Recurse subdirectories?      bool      Don't recurse.
my $Verbose   = 0          ; # Be wordy?                    bool      Be quiet.

# Paths to known ctrl-1 and ctrl-3 ".directory" files:
my $hostname = hostname();
my $ctrl_1_path;
my $ctrl_3_path;
if ( 'excalibur' eq $hostname ) {
   $ctrl_1_path = '/home/aragorn/Data/Ulthar/OS-Resources/Background-Pictures/Scenic/.directory';
   $ctrl_3_path = '/home/aragorn/Data/Celephais/Captain’s-Den/FFS-Profiles/.directory';
}
elsif ( 'optiplex-major' eq $hostname ) {
   $ctrl_1_path = '/home/arthur/Aranath/OS-Resources/Background-Pictures/.directory';
   $ctrl_3_path = '/home/arthur/Belequenta/rhe/scripts/util/.directory';
}
else {
   die "Not set-up for this host.\n$!\n";
}

# Counters:
my $direcount = 0 ; # Count of directories processed by curdire().
my $erascount = 0 ; # Count of ".directory" files erased.
my $erfacount = 0 ; # Count of failed erasure attempts.
my $copycount = 0 ; # Count of ".directory" files copied.
my $cofacount = 0 ; # Count of failed copy attempts.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   if ( $Verbose >= 1 ) {
      say "\nNow entering program \"" . get_name_from_path($0) . "\".";
      say "RegExp  = $RegExp";
      say "Recurse = $Recurse";
      say "Verbose = $Verbose";
   }

   $Recurse and RecurseDirs {curdire} or curdire;

   my $t1 = time; my $te = $t1 - $t0;
   if ( $Verbose >= 1 ) {
      stats;
      say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   }
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
         elsif ( $_ eq '-r' || $_ eq '--recurse' ) {$Recurse =  1 ;} # DEFAULT
         elsif ( $_ eq '-l' || $_ eq '--local'   ) {$Recurse =  0 ;}
         elsif ( $_ eq '-v' || $_ eq '--verbose' ) {$Verbose =  1 ;} # DEFAULT
         elsif ( $_ eq '-q' || $_ eq '--quiet'   ) {$Verbose =  0 ;}

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
   if    ( 0 == $NA ) {                              } # Do nothing.
   elsif ( 1 == $NA ) { $RegExp = qr/$ARGV[0]/o      } # Set $RegExp.
   else               { error($NA); help(); exit 666 } # Print error and help messages then exit 666.
   return 1;
} # end sub argv

# Process current directory:
sub curdire {
   # Get current working directory:
   my $cwd = cwd_utf8;

   # Just return 1 if we're in one of our "exemplar" directories (or if host is unknown):
   if ( 'excalibur' eq $hostname ) {
      if ( '/home/aragorn/Data/Ulthar/OS-Resources/Background-Pictures/Scenic' eq $cwd ) {
         return 1;
      }
      if ( '/home/aragorn/Data/Celephais/Captain’s-Den/FFS-Profiles' eq $cwd ) {
         return 1;
      }
   }

   elsif ( 'optiplex-major' eq $hostname ) {
      if ( '/home/arthur/Aranath/OS-Resources/Background-Pictures' eq $cwd ) {
         return 1;
      }
      if ( '/home/arthur/Belequenta/rhe/scripts/util' eq $cwd ) {
         return 1;
      }
   }

   else {
      return 1;
   }

   # Just return 1 if this directory doesn't match our regexp:
   return 1 if $cwd !~ m/$RegExp/;

   # Increment directory counter:
   ++$direcount;

   # Announce directory if being verbose:
   if ( $Verbose >= 1 ) {
      say "\nDirectory # $direcount: $cwd\n";
   }

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, 'F', $RegExp);

   # Riffle through the files, count how many pictures are here, and get rid of any old (possibly enumerated or
   # corrupted) ".directory" files"
   my $pics = 0;
   foreach my $file (@{$curdirfiles})
   {
      if (
            $file->{Name} =~ m/\A(?:-\(\d{4}\))*\.directory\z/
         )
      {
         unlink(e($file->{Path})) and ++$erascount and say("erased \"$file->{Path}\"")
         or ++$erfacount and warn "Failed to erase \"$file->{Path}\"\n";
      }

      if (
               get_suffix($file->{Name}) =~ m/jpg/i
            || get_suffix($file->{Name}) =~ m/jpeg/i
            || get_suffix($file->{Name}) =~ m/bmp/i
            || get_suffix($file->{Name}) =~ m/png/i
            || get_suffix($file->{Name}) =~ m/apng/i
            || get_suffix($file->{Name}) =~ m/gif/i
            || get_suffix($file->{Name}) =~ m/tif/i
            || get_suffix($file->{Name}) =~ m/tiff/i
         )
      {
         ++$pics;
      }
   }

   # If 1-or-more pictures exist in this directory, paste a ctrl-1 ".directory" file here;
   # otherwise, paste a ctrl-3 ".directory" file here:
   my $spath = ( ( $pics > 0 ) ? ($ctrl_1_path) : ($ctrl_3_path) );
   my $dpath = path($cwd, ".directory");
   !system(e("cp '$spath' '$dpath'")) and ++$copycount and say("created \"$dpath\"")
   or ++$cofacount and warn "Failed to copy .directory file to $cwd\n";

   # We're done, so return 1:
   return 1;
} # end sub curdire

# Print statistics for this program run:
sub stats
{
   say '';
   say 'Statistics for this directory tree:';
   say "Found  $direcount directories matching RegExp.";
   say "Erased $erascount old, enumerated, or corrupted \".directory\" files.";
   say "Failed $erfacount erasure attempts.";
   say "Copied $copycount new \".directory\" files.";
   say "Failed $cofacount copy attempts.";
   return 1;
} # end sub stats

# Handle errors:
sub error ($err_msg)
{
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $err_msg arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which directory entries to process. Help follows:
   END_OF_ERROR
} # end sub error

# Print help:
sub help
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to "dolphin-ctrl1.pl". This program pastes a "ctrl-1" type Dolphin
   ".directory" file to each subdirectory of the current directory which contains
   1-or-more picture (jpg, jpeg, bmp, png, gif, tif, or tiff) files. This causes
   picture files to be displayed as picture thumbnails instead of as lines of text.

   Command lines:
   program-name.pl -h | --help            (to print help and exit)
   program-name.pl [options] [arguments]  (to copy ".directory" )

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print this help and exit.
   "-q" or "--quiet"            Don't print directories.      (DEFAULT)
   "-v" or "--verbose"          Do    print directories.
   "-l" or "--local"            Don't recurse subdirectories. (DEFAULT)
   "-r" or "--recurse"          Do    recurse subdirectories.

   Description of arguments:
   In addition to options, this program can take one optional argument which,
   if present, must be a Perl-Compliant Regular Expression specifying which
   directories to process. To specify multiple patterns, use the | alternation
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
} # end sub help
