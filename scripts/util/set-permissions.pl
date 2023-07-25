#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# set-permissions.pl
# Sets permissions for some common file types.
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
sub stats   ; # Print statistics.
sub help    ; # Print help and exit.

# ======= VARIABLES: ===================================================================================================

# Settings:                    Meaning:                     Range:    Default:
my $db        = 0          ; # Debug (print diagnostics)?   bool      0 (Don't print diagnostics.)
my $Verbose   = 1          ; # Be wordy?                    bool      1 (Blab.)
my $Recurse   = 1          ; # Recurse subdirectories?      bool      1 (Recurse.)

# Counters:
my $direcount = 0          ; # Count of directories processed by curdire().

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   say '';
   say "Now entering program \"" . get_name_from_path($0) . "\".";
   say "Recurse = $Recurse";
   say "Verbose = $Verbose";
   say '';
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
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
            if ( $_ eq '-h' || $_ eq '--help'         ) {help; exit 777;}
         elsif ( $_ eq '-q' || $_ eq '--quiet'        ) {$Verbose =  0 ;}
         elsif ( $_ eq '-v' || $_ eq '--verbose'      ) {$Verbose =  1 ;} # DEFAULT
         elsif ( $_ eq '-l' || $_ eq '--local'        ) {$Recurse =  0 ;}
         elsif ( $_ eq '-r' || $_ eq '--recurse'      ) {$Recurse =  1 ;} # DEFAULT

         # Remove option from @ARGV:
         splice @ARGV, $i, 1;

         # Move the index 1-left, so that the "++$i" above
         # moves the index back to the current @ARGV element,
         # but with the new content which slid-in from the right
         # due to deletion of previous element contents:
         --$i;
      }
   }
   return 1;
} # end sub argv

# Process current directory:
sub curdire
{
   # Increment directory counter:
   ++$direcount;

   # Get cwd:
   my $cwd    = d getcwd;
   my $dir    = get_dir_from_path($cwd);
   my $name   = get_name_from_path($cwd);
   my $parent = get_name_from_path($dir);

   # Announce directory if being verbose:
   say "Directory #$direcount: \"$cwd\"" if $Verbose;

   my $command = '';

   # If this is a binary-executables directory, set everything to be executable:
   if ( $name eq 'bin' || $parent eq 'bin_lin' ){
      $command = 'chmod 775 * 2> /dev/null';
      system(e $command);
   }

   # Otherwise, only set permissions for files with the following name extensions:
   else {
      $command = 'chmod 664'
               . ' *.pdf  *.PDF  *.chm  *.CHM  *.epub *.EPUB *.txt  *.TXT'
               . ' *.doc  *.DOC  *.odt  *.ODT  *.ods  *.ODS  *.htm  *.HTM'
               . ' *.html *.HTML *.jpg  *.JPG  *.png  *.PNG  *.gif  *.GIF'
               . ' *.bmp  *.BMP  *.tif  *.TIF  *.tiff *.TIFF *.xcf  *.XCF'
               . ' *.zip  *.ZIP  *.rar  *.RAR  *.tar  *.TAR  *.tgz  *.TGZ'
               . ' *.ion  *.ION  *.eml  *.EML  *.log  *.LOG'
               . ' *.c    *.C    *.cpp  *.CPP  *.h    *.H    *.hpp  *.HPP'
               . ' *.pm   *.PM   *.cism *.cppism *.cismh *.cppismh'
               . ' makefile maketail'
               . ' 2> /dev/null';
      system(e $command);

      $command = 'chmod 775'
               . ' *.pl   *.PL   *.perl *.PERL *.py   *.PY   *.sh   *.SH'
               . ' *.exe  *.EXE  *.awk  *.AWK  *.sed  *.SED'
               . ' 2> /dev/null';
      system(e $command);
   }
   return 1;
} # end sub curdire

# Print statistics for this program run:
sub stats
{
   say '';
   say 'Statistics for this directory tree:';
   say "Set permissions in $direcount directories.";
   return 1;
} # end sub stats

# Print help:
sub help
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "set-permissions.pl". This program sets correct permissions
   for many common file types for all files in the current directory
   (and all subdirectories unless a -l or --local option is used).

   Command lines:
   set-permissions.pl -h | --help            (to print this help and exit)
   set-permissions.pl [options] [arguments]  (to set permissions)

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-q" or "--quiet"            Don't be verbose.
   "-v" or "--verbose"          Do    be Verbose.    (DEFAULT)
   "-l" or "--local"            Don't recurse.
   "-r" or "--recurse"          Do    recurse.       (DEFAULT)

   All arguments other than the above options are ignored.

   Happy permission setting!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
