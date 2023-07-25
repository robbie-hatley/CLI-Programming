#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# process-spotlight.pl
# Processes images scavenged from MS Win 10 Spotlight.
#
# Edit history:
# Sat Feb 01, 2020: Wrote first draft. Stub.
# Mon Mar 23, 2020: Wrote second draft. Testing verify_directory.
# Sun Apr 05, 2020: Now fully functional.
# Sat Jun 13, 2020: Now prefering Windows Spotlight file names over gibberish names.
# Tue Jun 23, 2020: Fixed some errors in comments; simplified code.
# Sat Sep 05, 2020: Removed -CSDA from shebang for now because it was causing a "too late" 
#                   error, due to the fact that I'm now invoking this script  via a wrapper
#                   shell script. But that's fine because the -CSDA is now in the perl
#                   invocation line in the wrapper.
# Thu Sep 10, 2020: Put -CSDA back into the shebang, because I'm no longer invoking this
#                   script from a shell-script wrapper. Also, changed "copy" to "cp" because
#                   copy killed timestamps. Also changed "cp -p" to "cp --preserve=timestamps"
#                   because "cp -p" was causing permissions errors.
# Tue Sep 15, 2020: I'm creating a radically-different version of this program, called
#                   "process-spotlight-new.pl", using a subfolder of /d/sl called "Aggregator"
#                   which permanently aggregates all spotlight photos from rhe source
#                   directories, and uses the File::Type and Image::Size CPAN modules to only
#                   copy those files from the sources which are wide jpg files with names
#                   which are not yet in Aggregator to Aggregator, then only copy those files
#                   in Aggregator which are not already in /d/sl to /d/sl .
# Wed Sep 16, 2020: Aggregator now uses jpg files.
# Thu Sep 17, 2020: Fixed bug in which copy_wide_jpgs was trying to copy nonexistent files.
# Tue Oct 27, 2020: Dramatically simplified.
# Fri Oct 30, 2020: Fixed bug that was skipping all Windows SL files, and simplified what's printed.
# Tue Nov 06, 2020: Made an Aragorn-only version of "process-spotlight.pl".
# Mon Nov 09, 2020: Cleaned-up some var names, comments, and formatting.
# Fri Nov 13, 2020: Now converting file names to SHA1 hash. Changed shebang to remove utf8 input.
# Thu Nov 19, 2020: Now also presenting short version of new_name.
# Fri Nov 20, 2020: Fixed "$flag not getting reset" bug, which had been resulting in no files being copied
#                   after detection of first duplicate.
# Fri Dec 18, 2020: Changed "copy_wide_jpgs" to copy to/from arbitrary source and destination.
#                   Moved "copy_wide_jpgs" to RH::Dir. Changed name of "verify_directory" to
#                   "directory_exists" and moved it to RH::Dir.
# Thu Dec 31, 2020: Now using sub "copy_large_images_sha1" to copy images from /usl# to /d/sl.
# Thu Dec 31, 2020: Dramatically simplified, by using "/usl#" SYMLINKDs in "/".
# Fri Mar 12, 2021: Discontinued use of "Administrator".
# Sun Sep 26, 2021: Reinstituted use of "Administrator". Removed "Recent".
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Thu Nov 25, 2021: Simplified subroutine names.
# Tue Dec 14, 2021: Now using "current user" instead of "Aragorn" for single-user photo aggregating.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';
use RH::Dir;

# ======================================================================================================================
# SUBROUTINE PRE-DECLARATIONS:

sub argv (); # Process @ARGV.
sub help (); # Provide user with help.

# ======================================================================================================================
# GLOBAL VARIABLES:

my $db      = 0;
my $Current = 0;

# ======================================================================================================================
# MAIN BODY OF SCRIPT:

{ # begin main
   # Announce program entry, get hi-res entry time $t0, and process arguments:
   my $t0 = time;
   print "\nNow entering \"process-spotlight.pl\".\n";
   argv;

   # Announce mode:
   if ($Current) {print STDOUT "Mode = \"Process Current User Only\".\n";}
   else          {print STDOUT "Mode = \"Process All Users\".\n";}

   # Declare and define a hash of user/directory key/value pairs. Each '/usl#' is a symbolic link in '/' to the actual
   # locations of the Windows Spotlight directories for each user. ("USL" = "User Spotlight Locations".)
   my %USLs = (
                 'Aragorn'       => '/usl1',
                 'Administrator' => '/usl2',
                 'Urgabor'       => '/usl3',
                 'Zebulon'       => '/usl4',
              );

   # If debugging, print all user/directory key/value pairs:
   if ($db)
   {
      print STDOUT "\n";
      for (sort keys %USLs)
      {
         print STDOUT "key = \"$_\"; value = \"$USLs{$_}\".\n";
      }
      print STDOUT "\n";
   }

   # Determine whether or not all needed directories exist:
   my $cusr  = getlogin()   ; # Current user.
   my $cusl  = $USLs{$cusr} ; # Current user's spotlight location.
   my $valid = 0            ; # Do all needed directories exist?
   if ($Current)
   {
      $valid = 
         -e e($cusl)   && -d e($cusl) 
      && -e e('/d/sl') && -d e('/d/sl');
   }
   else
   {
      $valid = 
         -e e('/usl1') && -d e('/usl1')
      && -e e('/usl2') && -d e('/usl2')
      && -e e('/usl3') && -d e('/usl3')
      && -e e('/usl4') && -d e('/usl4')
      && -e e('/d/sl') && -d e('/d/sl');
   }

   # If all needed directories exist, print verification message;
   # otherwise, print error message and exit:
   if ($valid)
   {
      print STDOUT "Verified that all needed directories exist.\n";
   }
   else
   {
      print STDERR "Some of the needed directories don't exist!\n".
                   "Aborting program to prevent disaster!\n".
                   "$!\n";
      exit 666;
   }

   # Update directory /d/sl from user directories:
   foreach my $user (sort keys %USLs)
   {
      next if $Current && $user ne $cusr;
      print STDOUT "\nUser = \"$user\".\n";
      copy_files($USLs{$user}, '/d/sl', 'large', 'unique', 'sha1', 'sl');
   }

   # Get hi-res exit time $t1 and elapsed time $te, print exit message, and exit:
   my $t1 = time;
   my $te = $t1 - $t0;
   print STDOUT "\nNow exiting \"process-spotlight.pl\". Execution time was $te seconds.\n";
   exit 0;
} # end main

# ======================================================================================================================
# SUBROUTINE DEFINITIONS:

sub argv ()
{
   for (@ARGV)
   {
      if ( $_ eq '-h' || $_ eq '--help'    ) { help(); exit; }
      if ( $_ eq '-c' || $_ eq '--current' ) { $Current = 1; }
   }
} # end sub argv ()

# Provide help:
sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "process-spotlight.pl", Robbie Hatley's nifty Windows 10
   "Spotlight" scenic photo aggregator.

   Command lines:
   process-spotlight.pl [-h | --help]     (to print this help and exit)
   process-spotlight.pl [-c | --current]  (process photos for current user)
   process-spotlight.pl                   (process photos for all users)

   To use this program:

   1. This program is only useful on computers running Microsoft Windows 10,
      so to use it, you'll first need such a computer.

   2. Install Cygwin on your computer, including the Perl that comes with it.
      That will give you the Linux-like file-access syntax this script needs.

   3. Give yourself permission to access the Windows Spotlight folders for
      all of your user ids. Those are located here:
      C:\Users\YourUserId\AppData\Local\Packages\
         Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets
      By default they're not accessible, so you'll have to manually sieze control
      by following this procedure:
      1. In Windows Explorer, go into C:\Users\YourUserID\AppData\Local\Packages\
      2. Right-click "Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy"
         and select "properties".
      2. Click "Security" tab.
      3. Click "Advanced".
      4. Sieze ownership, and apply to all children.
      5. Click "OK" to close out of all boxes.
      6. Go back into advanced security settings, give yourself full control, and
         apply to all children.
      7. CLick "OK" to close out of all boxes again.
      8. Do steps 1-7 above for each of your user names.
      You should now have full control of those folders.

   4. Create symbolic links called 'usl1', 'usl2', etc, in Cygwin's root directory
      ('/') to your user spotlight folders (see step 1 above for where those are
      and how to gain access to them). Edit this script as necessary to compensate
      for the actual number of users on your system (and their names) for which
      you want to aggregate Spotlight photos.

   5. Create a symbolic link called 'sl' in '/' to the directory where you want to
      store your Windows10 Spotlight photos. For example:
      cd /
      ln -s '/cygdrive/d/sl' sl

   6. Make this script executable. 

   7. Optional: Rename this script to whatever you like.

   8. Optional: Create a short "alias" for this script in your ~/.bashrc file.
      (I use "psl".)

   9. Run this script by typing it's file name or alias.

   END_OF_HELP
   return 1;
}
__END__
