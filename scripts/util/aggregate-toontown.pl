#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
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
# Sat Jul 31, 2021: Now a UTF-8-encoded file. Now 120 characters wide. Now using "use utf8", "use Sys::Binmode", and e.
# Wed Oct 27, 2021: Added Help() function.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Thu Nov 25, 2021: Fixed regexp bug that was causing program to find no files. Added timestamping.
# Fri Nov 26, 2021: Fixed yet another regexp bug; this one was causing program to refuse to file files by date.
########################################################################################################################

use v5.32; # WARNING: Do NOT update this until Cygwin updates its Perl to 5.36!
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ()  ;
sub curdire ()  ;
sub curfile ($) ;
sub stats   ()  ;
sub help    ()  ;

# ======= VARIABLES: ===================================================================================================

my $db = 0;
my $JpgPngRegExp = qr/\.(?:jpg)|(?:png)$/o;

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   # Start timer:
   my $t0 = time;

   # Process arguments; if user wants help, just print help and exit;
   # otherwise, ignore any other arguments and continue execution:
   argv();

   # Get program name and platform, and announce program entry:
   my $prgnam = get_name_from_path($0);
   my $pltfrm = $ENV{PLATFORM};

   # Determine directories based on platform, or if platform is invalid, die:
   my ($dir1,$dir2,$dir3);
   if ('Win64' == $pltfrm)
   {
      $dir1 = '/cygdrive/c/Programs/Games/Toontown-Rewritten-A1/screenshots';
      $dir2 = '/cygdrive/c/Programs/Games/Toontown-Rewritten-A2/screenshots';
      $dir3 = '/cygdrive/d/Arcade/Toontown-Rewritten/Screenshots';
   }
   elsif ('Linux' == $pltfrm)
   {
      $dir1 = '/home/aragorn/.toontown-A1/screenshots';
      $dir2 = '/home/aragorn/.toontown-A1/screenshots';
      $dir3 = '/home/aragorn/Data/Celephais/Arcade/Toontown/Screenshots';
   }
   else
   {
      die "Error in \"aggregate-toontown.pl\": Invalid platform.\n$!\n";
   }

   # Announce program entry:
   print "\n";
   print "Now entering program \"$prgnam\" on platform \"$pltfrm\".";

   # Aggregate Toontown screenshots from program directories to Arcade:
   system(e("move-files.pl '$dir1' '$dir3' '$JpgPngRegExp'"));
   system(e("move-files.pl '$dir2' '$dir3' '$JpgPngRegExp'"));

   # Enter Arcade:
   chdir(e($dir3));

   # Rename Toontown screenshot files as necessary:
   print "\n";
   print "Now canonicalizing names of Toontown screenshots....\n";
   system(e("rename-toontown-images.pl"));

   # Get ref to list of file-info hashes of info on files in cu
   my $ImageFiles = GetFiles($dir3, 'F', $JpgPngRegExp);
   my $num = scalar(@{$ImageFiles});

   my $cwd = cwd_utf8;

   # File screenshots by date:
   print "\n";
   print "Now filing Toontown images by date....\n";
   if ($db)
   {
      say "In ATT, in main, above foreach.";
      say "Current directory = $cwd";
      say "Number of files   = $num";
   }
   foreach my $file (@{$ImageFiles})
   {
      my $path  = $file->{Path};
      my $name  = $file->{Name};
      if ($db)
      {
         say "In ATT, in main, inside foreach.";
         say "Current file name = \"$name\".";
      }
      my $pref  = get_prefix($name);
      my @Parts = split /[-_]{1}/, $pref;
      my $year  = $Parts[2];
      my $month = $Parts[3];
      my $dir   = $year . '/' . $month;
      if ( ! -e e $dir ) {mkdir e $dir;}
      move_file($path, $dir);
   }
   print "\n";
   print "Finished filing Toontown images by date.\n";

   # Stop timer and announce exit and execution time:
   my $t1 = time; my $te = $t1 - $t0;
   print "\n";
   print "Now exiting program \"$pname\". Execution time was $te seconds.\n";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub argv ()
{
   for (@ARGV)
   {
      # If user requests help, just print help and exit:
      if ( '-h' eq $_ || '--help' eq $_ ) {help; exit 777;}
      # Otherwise, do nothing:
      else {;}
   }
   return 1;
} # end sub argv ()

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "aggregate-towntown.pl". This program moves all screenshots from
   these two Toontown Rewritten program folders:

      "C:\Programs\Games\Toontown-Rewritten-A1"
      "C:\Programs\Games\Toontown-Rewritten-A2"

   to this folder:

      "D:\Arcade\Toontown-Rewritten\Screenshots"

   It then renames the screenshots according to my standard naming format, then
   moves the files into appropriate year/month subfolders of the screenshots
   folder.

   Command lines:
   aggregate-towntown.pl -h | --help  (to print this help and exit)
   aggregate-towntown.pl              (to aggregate screenshots)

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.

   All other options, and all non-option arguments, are ignored, as there is
   nothing to "adjust" in the way that this program does its job. Just alter
   the program itself in the unlikely event that changes are ever needed.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
