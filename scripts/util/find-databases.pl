#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# find-databases.pl
# Lists all *.db database files except for Thumbs*.db in the current directory,
# and also from all subdirectories if a "-r" or "-recurse" option is used.
#
# Edit history:
# Tue Feb 02, 2016: Wrote it.
# Sat Apr 16, 2016: Now using -CSDA.
# Mon Dec 18, 2017: Updated comments, formatting, error_msg, help_msg.
# Fri Dec 22, 2017: Now slicing options from @ARGV.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use RH::Dir;
use RH::Util;

# ======= SUBROUTINE PRE-DECLARATIONS ==================================================================================

sub argv    ()  ; # Process @ARGV.
sub curdire ()  ; # Process current directory.
sub stats   ()  ; # Print statistics.
sub help    ()  ; # Print help and exit.

# ======= GLOBAL VARIABLES =============================================================================================

my $Recurse   = 0; # Recurse subdirectories? (bool)
my $direcount = 0; # Count of directories processed.
my $dbfdcount = 0; # Count of *.db  files found.

# ======= MAIN BODY OF PROGRAM =========================================================================================

{ # begin main
   argv;
   $Recurse and say 'Recursion: On.' or say 'Recursion: Off.';
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =======================================================================================

sub argv ()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL]{1,}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if ( $_ eq '-h' || $_ eq '--help'         ) {help; exit 777;}
         elsif ( $_ eq '-r' || $_ eq '--recurse'      ) {$Recurse =  1 ;}
         splice @ARGV, $i, 1;
         --$i;
      }
   }
   return 1;
} # end sub argv ()

sub curdire ()
{
   ++$direcount;
   my $curdir = cwd_utf8;
   my @paths = glob_regexp_utf8($curdir, 'F', '\.db$');
   foreach my $path (@paths)
   {
      if ( get_prefix(get_name_from_path($path)) !~ m/thumb/i )
      {
         ++$dbfdcount;
         say $path;
      }
   }
   return 1;
} # end sub curdire ()

sub stats ()
{
   print("\nStatistics for \"find-databases.pl\":\n");
   say "Navigated $direcount directories.";
   say "Found $dbfdcount *.db files (not including \"Thumbs.db\" files).";
   return 1;
} # end sub stats ()

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "find-databases.pl". This program lists all "*.db" files,
   OTHER THAN "Thumbs*.db" files, found in the current directory (and in all
   subdirectories if a -r or --recurse option is used).

   Command line:
   find-databases.pl [-h | --help | -r | --recurse]

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print this help and exit.
   "-r" or "--recurse"          Recurse subdirectories.
   All other options are ignored.

   All non-option arguments are ignored.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
