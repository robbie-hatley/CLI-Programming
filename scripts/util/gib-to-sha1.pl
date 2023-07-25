#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# gib-to-sha1.pl
# Renames each file in the current directory (and all subdirectories if a -r or --recurse option is used)
# which has a 8-lower-case-letter "gibberish" file name to a name consisting of the sha1 hash of
# the data in the file followed by the original file name extension.
#
# Edit history:
# Wed Nov 11, 2020: Wrote it. (Converts gibberish names to sha1 names only.)
# Mon Dec 21, 2020: Now also has recursion available.
# Sun Jan 03, 2021: Now also processes many other file types besides just jpg. 
# Mon Feb 15, 2021: Split into "gib-to-sha1.pl" and "wsl-to-sha1.pl". "gib-to-sha1.pl" now handles gib only, with no
#                   extension discrimination.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Digest::SHA1 qw(sha1_hex);
use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub process_argv               ()   ;
sub process_current_directory  ()   ;
sub process_current_file       (_)  ;
sub print_stats                ()   ;
sub help                       ()   ;

# ======= VARIABLES: ===================================================================================================

# Debug?
my $db = 0;

# Gibberish file-name pattern:
my $gib = qr(^[a-z]{8}(?:-\(\d{4}\))?(?:\.[a-zA-Z]+)?$);

# Settings:
my $Recurse = 0; # Recurse subdirectories?

# Counters:
my $direcount = 0; # Count of directories processed by process_current_directory().
my $filecount = 0; # Count of gib file names found.
my $renacount = 0; # Count of files renamed.
my $failcount = 0; # Count of failed file-rename attempts.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   process_argv;
   $Recurse ? RecurseDirs {process_current_directory} : process_current_directory;
   print_stats;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub process_argv ()
{
   my $help;
   for (@ARGV)
   {
      if ('-h' eq $_ || '--help'    eq $_) {$help    = 1;}
      if ('-r' eq $_ || '--recurse' eq $_) {$Recurse = 1;}
   }
   if ($help) {help; exit 777;}
   return 1;
} # end sub process_argv ()

sub process_current_directory ()
{
   ++$direcount;
   my $curdir = cwd_utf8;
   say "\nDir # $direcount: \"$curdir\"\n";
   process_current_file for glob_regexp_utf8($curdir, 'F', $gib);
   return 1;
} # end sub process_current_directory ()

sub process_current_file (_)
{
   ++$filecount;
   my $path     = shift;
   my $name     = get_name_from_path($path);
   my $new_name = hash($path, 'sha1', 'name');
   rename_file($name, $new_name)
   and ++$renacount
   and say "Renamed \"$name\" to \"$new_name\""
   and return 1
   or  ++$failcount
   and warn "FAILED to rename \"$name\" to \"$new_name\"\n"
   and return 0;
} # end sub process_current_file (_)

sub print_stats ()
{
   print("\nStats for \"gib-to-sha1.pl\":\n");
   printf("Navigated %6u directories.\n",           $direcount);
   printf("Found     %6u files with gib names.\n",  $filecount);
   printf("Renamed   %6u files.\n",                 $renacount);
   printf("Failed    %6u file-rename attempts.\n",  $failcount);
   return 1;
} # end sub print_stats ()

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "gib-to-sha1.pl". This program renames all regular files in the
   current directory (and all subdirectories if a -r or --recurse option is used)
   which have 8-lower-case-letter "gibberish" file names
   to names consisting of the SHA-1 hash of the data in the file
   followed by the file name extension of the original file.

   Command line:
   gib-to-sha1.pl [options]

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-r" or "--recurse"          Recurse subdirectories.

   This program recognizes no other options and takes no arguments.
   All arguments and non-listed options will be ignored.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
