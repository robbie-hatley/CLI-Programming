#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# synchronize.pl
# Synchronizes two directories. Given two directories, this program first erases any Thumbs*.db and pspbrwse*.jbf files
# which exist in either directory, then copies any files  which are in one of the two directories, but not the other,
# to the other directory, then gets rid of any duplicate files, then checks to make sure that the two directories now
# have the same files with the same dates and sizes.
#
# NOTE: You must have Perl, my RH modules, and my scripts "rdj.pl" and "dedup-files.pl" installed in order to use this
# script. If you don't have these, contact Robbie Hatley at <lonewolf@well.com> and I'll send these to you.
#
# Edit history:
# Tue Sep 08, 2020: Wrote it.
# Thu Feb 18, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory as
#                   its first argument, target as second, and regexp (instead of wildcard) as third.
# Sat Jul 31, 2021: Now using "use Sys:Binmode" and "e".
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Mon Nov 29, 2021: Refactored: simplified argv(), etc. Tested: Works. 
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS ==================================================================================

sub argv  ()  ; # Process @ARGV.
sub synch ()  ; # Synchronize contents of two directories.
sub help  ()  ; # Print help and exit.

# ======= GLOBAL VARIABLES =============================================================================================

my $db = 1;

# Data shared between subroutines:
our $dir1      = '';# Directory 1
our $dir2      = '';# Directory 2
our $dir1files = 0; # Ref to array of file records for directory #1
our $dir2files = 0; # Ref to array of file records for directory #2

# ======= MAIN BODY OF PROGRAM =========================================================================================
{
   print("\nNow entering program \"synchronize.pl\".\n\n");
   argv;
   synch;
   print("\nNow exiting program \"synchronize.pl\".\n\n");
   exit 0;
}

# ======= SUBROUTINE DEFINITIONS =======================================================================================

sub argv ()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL]{1,}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if ( $_ eq '-h' || $_ eq '--help' ) {help; exit 777;}
         splice @ARGV, $i, 1;
         --$i;
      }
   }

   my $NA = scalar(@ARGV);

   if ($db)
   {
      say '';
      say "We have ${NA} Arguments:";
      say for @ARGV;
   }

   # Abandon ship if @Arguments does not now consist of absolute paths to two existing directories:
   if ( 2 != $NA          ) {die "Error: number of arguments must be 2.\n";}
   if ( ! -e e $ARGV[0]   ) {die "Error: dir1 does not exist.          \n";}
   if ( ! -e e $ARGV[1]   ) {die "Error: dir2 does not exist.          \n";}
   if ( ! -d e $ARGV[0]   ) {die "Error: dir1 is not a directory.      \n";}
   if ( ! -d e $ARGV[1]   ) {die "Error: dir2 is not a directory.      \n";}
   if ( $ARGV[0] !~ m#^/# ) {die "Error: dir1 is not absolute.         \n";}
   if ( $ARGV[1] !~ m#^/# ) {die "Error: dir2 is not absolute.         \n";}

   # If we get to here, @Arguments consists of absolute paths to two existing
   # directories, so store them in global variables $dir1 and $dir2:
   $dir1 = $ARGV[0];
   $dir2 = $ARGV[1];

   # We're done, so return:
   return 1;
} # end sub argv

sub synch ()
{
   my $filename; # Name of a file.
   my $newpath;  # Proposed new path for a file.

   # Announce directories:
   say 'Attempting to synchronize files between these two directories:';
   say "Dir1: $dir1";
   say "Dir2: $dir2";

   # Attempt to chdir to dir 1:
   chdir(e($dir1)) or die "Couldn't cd to $dir1.\n$!\n";

   # Get rid of Thumbs.db and pspbrwse.jbf files:
   say '';
   say 'Getting rid of Thumbs*.db and pspbrwse*.jbf files in dir1:';
   !system(e "rdj.pl") or die "Failed to rid $dir1 of thumbnail files.\n$!\n";

   # Get list of regular files in dir 1:
   $dir1files = GetFiles($dir1, 'F');

   # Attempt to chdir to dir 2:
   chdir(e($dir2)) or die "Couldn't cd to $dir2.\n$!\n";

   # Get rid of Thumbs.db and pspbrwse.jbf files:
   say '';
   say 'Getting rid of Thumbs*.db and pspbrwse*.jbf files in dir2:';
   !system(e "rdj.pl") or die "Failed to rid $dir2 of thumbnail files.\n$!\n";

   # Get list of regular files in dir 2:
   $dir2files = GetFiles($dir2, 'F');

   # Attempt to chdir to dir 1 again:
   chdir(e($dir1)) or die "Couldn't cd to $dir1.\n$!\n";

   # Synch from dir1 to dir2:
   say '';
   say 'Synching files from dir1 to dir2:';
   foreach my $file (@{$dir1files}) 
   {
      $filename = $file->{Name};
      $newpath  = path($dir2, $filename);
      if ( ! -e e $newpath )
      {
         system(e "cp -p '$filename' '$dir2'");
      }
   }

   # Attempt to chdir to dir 2 again:
   chdir(e($dir2)) or die "Couldn't cd to $dir2.\n$!\n";

   # Synch from dir2 to dir1:
   say '';
   say 'Synching files from dir2 to dir1:';
   foreach my $file (@{$dir2files}) 
   {
      $filename = $file->{Name};
      $newpath  = path($dir1, $filename);
      if ( ! -e e $newpath )
      {
         system(e "cp -p '$filename' '$dir1'");
      }
   }

   # Get rid of duplicates:
   say '';
   chdir(e($dir1)) or die "Couldn't cd to $dir1\n$!\n";
   say "Deduping $dir1";
   system(e "dedup-files.pl -s");
   chdir(e($dir2)) or die "Couldn't cd to $dir2\n$!\n";
   say "Deduping $dir2";
   system(e "dedup-files.pl -s");
   
   # Denumerate:
   chdir(e($dir1)) or die "Couldn't cd to $dir1\n$!\n";
   say "Denumerating $dir1";
   system(e "denumerate-file-names.pl");
   chdir(e($dir2)) or die "Couldn't cd to $dir2\n$!\n";
   say "Denumerating $dir2";
   system(e "denumerate-file-names.pl");

   # Ensure that the two directories are now identical:
   say '';
   $dir1files = GetFiles($dir1, 'F');
   $dir2files = GetFiles($dir2, 'F');
   foreach my $file (@{$dir1files}) 
   {
      $filename = $file->{Name};
      if ( ! -e e path($dir2, $filename) )
      {
         warn "Warning: $filename does not exist in $dir2";
      }
      else
      {
         if ( -s e path($dir1, $filename) != -s e path($dir2, $filename) )
         {
            warn "Warning: $filename has different sizes in the two dirs.\n";
         }
         if ( -M e path($dir1, $filename) != -M e path($dir2, $filename) )
         {
            warn "Warning: $filename has different dates in the two dirs.\n";
         }
      }
   }
   foreach my $file (@{$dir2files}) 
   {
      $filename = $file->{Name};
      if ( ! -e e path($dir1, $filename) )
      {
         warn "Warning: $filename does not exist in $dir1";
      }
   }

   # We're done, so scram:
   return 1;
} # end sub synch ()

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "synchronize.pl", Robbie Hatley's nifty directory synchronizer.
   Given absolute paths to two existing directories, this program first erases
   any Thumbs*.db and pspbrwse*.jbf files from both directories, then copies all
   files which are in one directory but not the other to the other, then erases
   all duplicate files in both directories (asking for user intervention if 
   in-doubt about which duplicate to erase). It then prints warnings about any
   file in either directory which doesn't have an exact duplicate (time, date,
   size, and content) in the other directory.

   Command line:
   synchronize.pl [-h|--help]     (to print this help)
   synchronize.pl dir1  dir2      (to synch directories)

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.

   Description of arguments:
   "merge-files.pl" takes exactly two arguments which must be absolute paths
   (starting with "/") to existing directories.

   Happy directory synchronizing!

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
