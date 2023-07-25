#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# copy-files.pl
# Given the paths of two directories, Source and Destination, this program copies all regular files matching a regexp
# from Source to Destination, enumerating each file for which a file exists in Destination with the same name root.
# Optionally, the program can be instructed to NOT copy any files for which duplicates exist in the destination,
# and/or change the name of the file to its own SHA1 hash.
#
# NOTE: You must have Perl and my RH::Dir module installed in order to use this script. Contact Robbie Hatley
# at <lonewolf@well.com> and I'll send my RH::Dir module to you.
#
# Edit history:
# Sat Jan 02, 2021: Wrote it. 
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Sun Nov 21, 2021: Fixed 4 missing encodes in process_argv.
# Mon Nov 22, 2021: Heavily refactored. Now using sub "copy_files" in RH::Dir instead of local, and using 
#                   a regular expression instead of a wildcard to specify files to copy. Also, now subsumes
#                   the script "copy-large-images.pl".
# Tue Nov 23, 2021: Fixed "won't handle relative directories" bug by using the chdir & cwd trick.
# Sat Dec 04, 2021: Fixed minor error in titlecard ("wildcard"->"regexp").
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub process_argv  ();
sub error_msg     ($);
sub help_msg      ();

# ======= PAGE-GLOBAL LEXICAL VARIABLES: ===============================================================================

# Debugging:
my $db = 0; # Use debugging? (Ie, print diagnostics?)

# Settings:
my $src       = ''; # Srce directory.
my $dst       = ''; # Dest directory.
my $cur       = ''; # Curr directory.
my @CopyArgs  = (); # Arguments for copy_files().

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   say "\nNow entering program \"" . get_name_from_path($0) . "\".\n";
   my $t0 = time;
   process_argv;
   if ($db)
   {
      warn "In main body of program \"copy-files.pl\"\n",
           "Just ran process_argv().\n",
           "\$src = \"$src\"\n",
           "\$dst = \"$dst\"\n",
           "\@CopyArgs = \n",
           join("\n", @CopyArgs) . "\n";
      exit(84);
   }

   # Get FULLY-QUALIFIED versions of current, source, and destination directories:

   # Get current working directory:
   $cur = cwd_utf8;

   # CD to src, grab full path, then CD back to cur:
   chdir_utf8 $src;
   $src = cwd_utf8;
   chdir_utf8 $cur;

   # CD to dst, grab full path, then CD back to cur:
   chdir_utf8 $dst;
   $dst = cwd_utf8;
   chdir_utf8 $cur;

   # Copy files:
   copy_files($src, $dst, @CopyArgs);

   # We're done, so exit:
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.\n";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub process_argv ()
{
   my @CLArgs   = ();     # Command-Line Arguments from @ARGV (not including options).

   if ($db)
   {
      warn "In program \"copy-files.pl\", in sub process_argv().\n",
           "\@ARGV = \n",
           join("\n", @ARGV) . "\n";
   }

   foreach (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if ( '-h' eq $_ || '--help'   eq $_ ) {help_msg; exit(777)     ;}
         elsif ( '-S' eq $_ || '--sl'     eq $_ ) {push @CopyArgs, 'sl'    ;}
         elsif ( '-s' eq $_ || '--sha1'   eq $_ ) {push @CopyArgs, 'sha1'  ;}
         elsif ( '-u' eq $_ || '--unique' eq $_ ) {push @CopyArgs, 'unique';}
         elsif ( '-l' eq $_ || '--large'  eq $_ ) {push @CopyArgs, 'large' ;}
      }
      else
      {
         push @CLArgs, $_;
      }
   }
   my $NA = scalar(@CLArgs);
   if ( $NA < 2 || $NA > 3 ) {error_msg($NA); help_msg; exit(666);}
   $src = $CLArgs[0];
   $dst = $CLArgs[1];
   if ( ! -e e $src ) {die "Error: $src doesn't exist.    \n";}
   if ( ! -d e $src ) {die "Error: $src isn't a directory.\n";}
   if ( ! -e e $dst ) {die "Error: $dst doesn't exist.    \n";}
   if ( ! -d e $dst ) {die "Error: $dst isn't a directory.\n";}
   if ( $NA > 2 ) {push @CopyArgs, 'regexp=' . $CLArgs[2];}

   if ($db)
   {
      warn "In copy-files.pl, in process_argv, at bottom.\n",
           "scalar(\@CLArgs) = " . scalar(@CLArgs) . "\n",
           "\@CLArgs = \n",
           join("\n", @CLArgs) . "\n",
           "scalar(\@CopyArgs) = " . scalar(@CopyArgs) . "\n",
           "\@CopyArgs = \n",
           join("\n", @CopyArgs) . "\n";
   }

   return 1;
} # end sub process_argv

sub error_msg ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: \"copy-files.pl\" takes 2 mandatory arguments (which must be paths to
   a source directory and a destination directory), and 1 optional argument
   (which, if present, must be a regular expression specifying which files to
   copy), but you typed $NA arguments. Help follows:

   END_OF_ERROR
   return 1;
}

sub help_msg ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "copy-files.pl", Robbie Hatley's nifty file-copying utility.
   This program copies all files matching a regexp from a source directory
   (let's call it "dir1") to a destination directory (let's call it "dir2"),
   enumerting each file if necessary, but skipping all "Thumbs*.db",
   "pspbrwse*.jbf", and "desktop*.ini" files. Optionally, this program can
   skip any files in dir1 for which duplicates exist in dir2, and/or rename
   the copied files' name roots to the files' own SHA1 hashes.

   Command lines:
   copy-files.pl [-h|--help]                    (to print this help and exit)
   copy-files.pl [options] dir1 dir2 [regexp]   (to copy files)

   Description of options:
   Option:             Meaning:
   "-h" or "--help"    Print help and exit.
   "-S" or "--sl"      Shorten names for when processing Windows Spotlight images.
   "-s" or "--sha1"    Change name root of each file to its own hash.
   "-u" or "--unique"  Don't copy files for which duplicates exist in destination.
   "-l" or "--large"   Move only large image files (W=1200+, H=600+).
   All other options will be ignored.

   Description of arguments:
   "copy-files.pl" takes two mandatory arguments which must be paths to existing
   directories; dir1 is the source directory and dir2 is the destination 
   directory. 

   Additionally, "copy-files.pl" can take a third, optional argument which,
   if present, must be a Perl-Compliant Regular Expression describing which files
   to copy. To specify multiple patterns, use the | alternation operator.
   To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to search for items with names containing "cat",
   "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead. 

   Also note that this program cannot act recursively; it copies files only from
   the root level of dir1 to the root level of dir2; the contents of any
   subdirectories of dir1 or dir2 are not touched.

   Happy file copying!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
}
