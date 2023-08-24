#! /bin/perl -CSDA

# This is a 110-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# aggregate-toontown.pl
# Aggregates TTR screenshots from my two TTR program screenshots folders to a folder in my Arcade.
#
# Edit history:
# Thu Oct 29, 2020: Wrote it.
# Sat Jan 02, 2021: Refactored to use my new "move-files.pl" script.
# Sun Jan 03, 2021: Sub "move-file" in RH::Dir now uses system(mv), so cross-system moving actually does
#                   work now. Also, simplified dir names, and now moving to 2021 instead of 2020.
# Fri Jan 29, 2021: Now also renames and files-away screenshots in appropriate year/month directories.
# Sat Feb 13, 2021: Simplified. Now an ASCII file. No-longer uses -CSDA. Runs on all Perl versions.
# Sat Jul 31, 2021: Now a UTF-8-encoded file. Now 120 characters wide. Now using "use utf8",
#                   "use Sys::Binmode", and e.
# Wed Oct 27, 2021: Added Help() function.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate. Now using "common::sense".
# Thu Nov 25, 2021: Fixed regexp bug that was causing program to find no files. Added timestamping.
# Fri Nov 26, 2021: Fixed yet another regexp bug; this one was causing program to refuse to file files by date.
# Thu Aug 17, 2023: Reduced width from 120 to 110. Upgraded from "V5.32" to "v5.36". Got rid of CPAN module
#                   "common::sense" (antiquated). Got rid of prototypes. Program is very broken, though,
#                   because it's trying to use directories which don't exist. TO-DO: Fix dirs.
# Sat Aug 19, 2023: Fixed directories and returned full multi-platform functionality.
# Thu Aug 24, 2023: Got rid of "/...|.../" in favor of "/.../ || /.../" (speeds-up program).
##############################################################################################################

# ======= PRELIMINARIES: =====================================================================================

# Pragmas:
use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

# CPAN:
use Sys::Binmode;
use Cwd;
use Time::HiRes 'time';

# Homebrew modules:
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv;
sub aggregate;
sub help;

# ======= VARIABLES: =========================================================================================

# Settings:
my $db = 0;
my $image_regexp = qr/\.jpg$|\.png$/io;
my $program_dir_1   = 'not_set';
my $program_dir_2   = 'not_set';
my $screenshots_dir = 'not_set';
my $platform = $ENV{PLATFORM};

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   say    'Now entering program "aggregate-toontown.pl".';
   say    "Platform = \"$platform\".";

   aggregate;

   my $ms = 1000 * (time - $t0);
   say    '';
   say    'Now exiting program "aggregate-toontown.pl".';
   printf "Execution time was %.3fms.\n", $ms;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV :
sub argv {
   for ( @ARGV ) {
      /^-h$/ || /^--help$/   and help and exit 777;
      /^-1$/ || /^--debug1$/ and $db = 1;
      /^-2$/ || /^--debug2$/ and $db = 2;
      /^-3$/ || /^--debug3$/ and $db = 3;
   }
   return 1;
} # end sub argv

sub aggregate {

   # ---------------------------------------------------------------------------------------------------------
   # Aggregate Toontown Screenshots From Toontown Program Director(y|ies) To Screeshots Directory:

   # File aggregation method will vary depending on platform:
   if ( $platform eq 'Linux'  ) {
      # Set directory variables for Linux:
      $program_dir_1   = '/home/aragorn/.var/app/com.toontownrewritten.Launcher/data/screenshots';
      $screenshots_dir = '/d/Arcade/Toontown-Rewritten/Screenshots';

      if ( $db ) {
         say STDERR 'In ATT, in "if (Linux)", about to aggregate.';
         say STDERR "Platform                = $platform";
         say STDERR "Source      directory 1 = $program_dir_1";
         say STDERR "Source      directory 2 = $program_dir_2";
         say STDERR "Destination directory   = $screenshots_dir";
         if ( 1 == $db ) {exit 111}
      }

      # Aggregate Toontown screenshots from the all-accounts program directory to Arcade:
      system(e("move-files.pl '$program_dir_1' '$screenshots_dir' '$image_regexp'"));
   }
   elsif ( $platform eq 'Win64' ) {
      # Set directory variables for Windows:
      $program_dir_1   = '/c/Programs/Games/Toontown-Rewritten-A1/screenshots';
      $program_dir_2   = '/c/Programs/Games/Toontown-Rewritten-A2/screenshots';
      $screenshots_dir = '/d/Arcade/Toontown-Rewritten/Screenshots';

      if ( $db ) {
         say STDERR 'In ATT, in "if (Win64)", about to aggregate.';
         say STDERR "Platform                = $platform";
         say STDERR "Source      directory 1 = $program_dir_1";
         say STDERR "Source      directory 2 = $program_dir_2";
         say STDERR "Destination directory   = $screenshots_dir";
         if ( 1 == $db ) {exit 111}
      }

      # Aggregate Toontown screenshots from both per-account program directories to Arcade:
      system(e("move-files.pl '$program_dir_1' '$screenshots_dir' '$image_regexp'"));
      system(e("move-files.pl '$program_dir_2' '$screenshots_dir' '$image_regexp'"));
   }
   else {
      if ( $db ) {
         say STDERR 'In ATT, in "if (invalid platform)", about to die.';
         say STDERR "Platform                = $platform";
         say STDERR "Source      directory 1 = $program_dir_1";
         say STDERR "Source      directory 2 = $program_dir_2";
         say STDERR "Destination directory   = $screenshots_dir";
         if ( 1 == $db ) {exit 111}
      }
      die "Error in \"aggregate-toontown.pl\":\nInvalid platform \"$platform\".\n$!\n";
   }

   # ---------------------------------------------------------------------------------------------------------
   # Re-name Screenshots:

   # Enter screenshots directory:
   chdir(e($screenshots_dir));

   # Get ref to list of file-info hashes for all jpg and png files in screenshots directory:
   my $ImageFiles1 = GetFiles($screenshots_dir, 'F', $image_regexp);
   my $num1 = scalar @$ImageFiles1;

   if ( $db )
   {
      say STDERR 'In ATT, about to rename files.';
      say STDERR "Screenshots dir = \"$screenshots_dir\".";
      # Sanity check!!! Are we actually where we think we are???
      my $cwd = d(getcwd);
      say STDERR "CWD = \"$cwd\".";
      say STDERR "Number of files before renaming = $num1";
      say STDERR "Names  of files before renaming:";
      say STDERR $_->{Name} for @$ImageFiles1;
      if ( 2 == $db ) {exit 222}
   }

   # Rename Toontown screenshot files as necessary:
   say STDOUT '';
   say STDOUT 'Now canonicalizing names of Toontown screenshots....';
   system(e('rename-toontown-images.pl'));

   # Get ref to list of file-info hashes for all jpg and png files in screenshots directory:
   my $ImageFiles2 = GetFiles($screenshots_dir, 'F', $image_regexp);
   my $num2 = scalar(@{$ImageFiles2});

   if ( $db )
   {
      say STDERR 'In ATT, after renaming files.';
      say STDERR "Screenshots dir = \"$screenshots_dir\".";
      # Sanity check!!! Are we actually where we think we are???
      my $cwd = d(getcwd);
      say STDERR "CWD = \"$cwd\".";
      say STDERR "Number of files after renaming = $num2";
      say STDERR "Names  of files after renaming:";
      say STDERR $_->{Name} for @$ImageFiles2;
      if ( 3 == $db ) {exit 333}
   }

   # ---------------------------------------------------------------------------------------------------------
   # File Screenshots By Date:

   say STDOUT '';
   say STDOUT 'Now filing Toontown images by date....';
   foreach my $file (@$ImageFiles2)
   {
      my $path  = $file->{Path};
      my $name  = $file->{Name};
      my $pref  = get_prefix($name);
      my @Parts = split /[-_]/, $pref;
      my $year  = $Parts[2];
      my $month = $Parts[3];
      my $dir   = $year . '/' . $month;
      if ( ! -e e $dir ) {mkdir e $dir;}
      move_file($path, $dir);
   }
   say STDOUT '';
   say STDOUT 'Finished filing Toontown images by date.';

   # Return success code 1 to caller:
   return 1;
}

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "aggregate-towntown.pl". This program moves all screenshots
   from the Toontown-Rewritten program director(y|ies) to the directory
   "/d/Arcade/Toontown-Rewritten/Screenshots". It then renames the files according
   to a chronological-order naming format, then moves the files into appropriate
   year/month subdirectories of the screenshots directory.

   -------------------------------------------------------------------------------
   Command Lines:

   aggregate-towntown.pl [-h | --help]   (to print this help and exit)
   aggregate-towntown.pl [options]       (to aggregate screenshots)

   -------------------------------------------------------------------------------
   Description of Options:

   Option:         Meaning:
   -h or --help    Print this help and exit.
   -1 or --debug1  Print diagnostics and exit after first  breakpoint.
   -2 or --debug2  Print diagnostics and exit after second breakpoint.
   -3 or --debug3  Print diagnostics and exit after third  breakpoint.

   All other options are ignored.

   -------------------------------------------------------------------------------
   Description of Arguments:

   You can type as many arguments as you like on the command line.
   This program will ignore them all.

   "Going UP, sir!"

   If you need to alter what this program does, edit this script.

   Happy Toontown screenshot aggregating!

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
__END__
