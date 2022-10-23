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

use v5.32;
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
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   say "\$JpgPngRegExp = $JpgPngRegExp\n";
   my $t0 = time;

   argv();

   my $dir1 = '/cygdrive/c/Programs/Games/Toontown-Rewritten-A1/screenshots';
   my $dir2 = '/cygdrive/c/Programs/Games/Toontown-Rewritten-A2/screenshots';
   my $dir3 = '/cygdrive/d/Arcade/Toontown-Rewritten/Screenshots';
   system(e("move-files.pl '$dir1' '$dir3' '$JpgPngRegExp'"));
   system(e("move-files.pl '$dir2' '$dir3' '$JpgPngRegExp'"));
   chdir(e($dir3));
   system(e("rename-toontown-images.pl"));
   my $ImageFiles = GetFiles($dir3, 'F', $JpgPngRegExp);

   say "\nNow filing Toontown images by date....\n";

   my $cwd = cwd_utf8;
   my $num = scalar(@{$ImageFiles});
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

   my $t1 = time; my $te = $t1 - $t0;
   say "\nFinished filing Toontown images by date.\n";
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.\n";
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
