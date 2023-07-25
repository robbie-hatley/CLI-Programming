#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# merge-files.pl
# Given the paths of two directories, Source and Destination, this script first deletes all "Thumbs.db", "pspbrwse.jbf",
# and "desktop.ini" files from Source, then moves all remaining files from Source to Destination, enumerating each file
# for which a file exists in Destination with a matching name, then erases the Source directory if it's now empty.
#
# NOTE: You must have Perl and my RH::Dir module installed in order to use this script. Contact Robbie Hatley
# at <lonewolf@well.com> and I'll send my RH::Dir module to you.
#
# Edit history:
# Mon May 04, 2015: Wrote first draft, but it's just a stub.
# Wed May 13, 2015: Updated and changed Help to "Here Document" format,
#                   and cleaned up,    but still just a STUB.
# Fri Jul 17, 2015: Upgraded for utf8, but still just a STUB.
# Sat Apr 16, 2016: Now using -CSDA,   but still just a STUB.
# Mon Dec 25, 2017: Now splicing options from @ARGV; and, made program fully functional.
# Wed Dec 27, 2017: Renamed from "rhmerge.pl" to "merge-files.pl".
# Sat Oct 27, 2018: Dramatically simplified main body of program, split program into more subroutines, improved help,
#                   removed enumeration of dir2, added code to print $mergcount and $failcount, and moved "merge_file"
#                   from RH::Dir back to this file, as it's only being used here and nowhere else.
# Thu Feb 20, 2020: At some point I must have moved "merge_file()" back OUT of this program and back into
#                   my RH::Dir module, because it's sure-as-Hell no longer HERE.
# Sun Mar 08, 2020: Changed version to "use v5.30;", and corrected comments above to mention the fact
#                   that this program erases the "Source" directory after emptying it. Also added missing
#                   info in help_msg regarding the fact that this program erases the source directory after
#                   emptying it (by merging its files into the destination directory).
# Tue Dec 22, 2020: Got rid of all global variables, and combined the 4 argument-processing functions into
#                   "process_argv".
# Sat Jan 02, 2021: Renamed from "Merge Files" to "Merge Directories", and refactored to use my new
#                   "move_file" function in RH::Dir. Removed dedup and denumerate functions (those can
#                   easily be run from command line by typing ddf dfn so there's no point doing it here).
#                   Removed advanced statistics, as user can always use my "dir-stats.pl".
#                   Fixed bug where dir1 couldn't be removed because it was the current directory.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Tue Nov 30, 2021: Fixed wide-character errors due to not using e. Tested: Now works.
# Sat Dec 04, 2021: Renamed back to "merge-files.pl", as that's a more accurate description of what this script does.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use Encode;

use RH::Dir;
use RH::Util;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub process_argv      ();
sub merge_directories ($$);
sub print_stats       ();
sub error_msg         ();
sub help_msg          ();

# ======= PAGE-GLOBAL LEXICAL VARIABLES: ===============================================================================

# Debugging:
my $db = 0; # Use debugging? (Ie, print diagnostics?)

# Counts of events:
my $delecount = 0; # Count of all files deleted from Dir1
my $mergcount = 0; # Count of all files successfully merged.
my $failcount = 0; # Count of all files which couldn't be merged. 

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{
   say "\nNow entering program \"merge-directories.pl\".";
   my ($dir1, $dir2) = process_argv();
   merge_directories($dir1, $dir2);
   print_stats();
   say "\nNow exiting program \"merge-directories.pl\".";
   exit 0;
}

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub process_argv ()
{
   my $help     = 0;   # Print help and exit?
   my $dir1     = '';  # Directory 1 (source)
   my $dir2     = '';  # Directory 2 (destination)
   my @CLArgs   = ();  # Command-Line Arguments from @ARGV (not including options).
   foreach (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         /^-h$/ || /^--help$/ and $help = 1;
      }
      else
      {
         push @CLArgs, $_;
      }
   }
   if ($help)        {help_msg; exit(777);}
   if (@CLArgs != 2) {error_msg; help_msg; exit(666);}
   $dir1 = $CLArgs[0];
   $dir2 = $CLArgs[1];
   if ( ! -e e $dir1 ) {die "Error: $dir1 doesn't exist.    \n";}
   if ( ! -d e $dir1 ) {die "Error: $dir1 isn't a directory.\n";}
   if ( ! -e e $dir2 ) {die "Error: $dir2 doesn't exist.    \n";}
   if ( ! -d e $dir2 ) {die "Error: $dir2 isn't a directory.\n";}
   return ($dir1, $dir2);
} # end sub process_argv

sub merge_directories ($$)
{
   my ($dir1, $dir2) = @_;
   my @spaths = glob_utf8("${dir1}/* ${dir1}/.*");
   if ($db)
   {
      say $dir1;
      say $dir2;
      say for @spaths;
   }

   say '';
   say "Getting rid of junk in \"${dir1}\" and moving remainder to \"${dir2}\"...";
   foreach my $spath (@spaths)
   {
      my $sname = get_name_from_path($spath);
      if    ($sname eq '.' || $sname eq '..') {next;}
      elsif (-d e $spath)                     {next;}
      elsif ($sname =~ m/^Thumbs.*\.db$/    ) {unlink(e $spath) and say "unlinked $spath" and ++$delecount;}
      elsif ($sname =~ m/^pspbrwse.*\.jbf$/ ) {unlink(e $spath) and say "unlinked $spath" and ++$delecount;}
      elsif ($sname =~ m/^desktop.*\.ini$/  ) {unlink(e $spath) and say "unlinked $spath" and ++$delecount;}
      else  {move_file($spath,$dir2) and ++$mergcount or  ++$failcount;}
   }

   # What contents (if any) is still in dir1?
   @spaths = glob_utf8("${dir1}/* ${dir1}/.*");
   my $remainder = scalar @spaths;
   if ($db)
   {
      say for @spaths;
      say "remainder = $remainder";
   }

   # If the only two things in this directory are now '.' and '..', remove this directory:
   if (2 == $remainder)
   {
      # Because we're about to attempt to delete directory $dir1, we first need to get it's absolute address,
      # then chdir to root, so that we will never be attempting to delete a directory at or above our current
      # location on the directory tree, which never works:
      chdir_utf8 $dir1;
      $dir1 = cwd_utf8;
      chdir_utf8 '/';
      say "\nRemoving directory \"${dir1}\"...";
      rmdir_utf8($dir1)
      and say "Directory \"${dir1}\" has been removed."
      or say "Failed to remove directory \"${dir1}\".";
   }

   # Otherwise, we can't, because it's not empty:
   else
   {
      say "\nCan't remove directory \"${dir1}\" because it's not empty.";
   }

   return 1;
} # end subroutine merge_directories

sub print_stats ()
{
   say '';
   say "Statistics from \"merge-directories.pl\":";
   say "Deleted $delecount files from source directory.";
   say "Merged $mergcount files.";
   say "Failed to merge $failcount files.";
   return 1;
}

sub error_msg ()
{
   print ((<<'   END_OF_ERROR') =~ s/^   //gmr);
   Error: "merge-files.pl" takes exactly 2 arguments, which must be paths
   to an existing source directory and an existing destination directory.

   END_OF_ERROR
   return 1;
}

sub help_msg ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "merge-files.pl", Robbie Hatley's nifty directory merging
   utility. This program moves all files from a source directory (lets call it
   "dir1") to a destination directory (let's call it "dir2"), enumerting each file
   if necessary, after first unlinking all "Thumbs*.db", "pspbrwse*.jbf", and
   "desktop*.ini" files from the source directory. This program then removes the
   now-empty dir1 (or prints a warning if dir1 is not empty).

   Command line:
   merge-files.pl [-h|--help] [-v|--verbose] dir1 dir2

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-v" or "--verbose"          Be verbose.

   "merge-directories.pl" takes exactly two arguments which must be paths of
   existing directories; dir1 is the source directory and the dir2 is the
   destination directory.

   Also note that "merge-directories.pl" is intended for use with source
   directories which do NOT have subdirectories. If subdirectories of dir1
   exist, the files in the root of dir1 will be moved to the root of dir2,
   but the subdirectories and their contents will not be touched and
   dir1 will not be erased after file merging. I suggest first merging all
   subdirectories of dir1 upward one at a time, from the bottom up, before merging
   dir1 to dir2. 

   Or, run this program through "for-each-immediate-subdirectory.pl" with
   arguments "." and "..":

   for-each-immediate-subdirectory.pl 'merge-files.pl "." ".."'

   (Do this after first dumping all subdirectories of dir1 into a subdir
   of dir1 called "subdirs", then cd to "subdirs", so that everything from
   all the subdirs of "subdirs" will be merged into dir1, and "subdirs" and
   all of its subdirs will be erased. THEN you can merge from dir1 to dir2
   and have dir1 emptied and erased afterwards.)

   Happy directory merging!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
}
