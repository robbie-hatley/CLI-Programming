#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# file-type-statistics.pl
# Prints how many files of each name-extension ("*.jpg", "*.avi", etc) exist in directories.
# Written by Robbie Hatley.
#
# Edit history:
# Sun Feb 21, 2021: Wrote it. Later that day, fine-tuned it a bit.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub process_argv              ()  ;
sub process_current_directory ()  ;
sub process_current_file      ($) ;
sub stats                     ()  ;
sub help                      ()  ;

# ======= VARIABLES: ===================================================================================================

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

#Program Settings:
#  Setting:           Meaning:                  Range:   Default:
my $Recurse = 0 ;   # Recurse subdirectories?   (bool)   0
my $Size    = 0 ;   # Sort by size?             (bool)   0

# Counters:
my $direcount = 0; # Count of directories processed by process_current_directory().
my $filecount = 0; # Count of    files    processed by process_current_file().

# File types counter hash (how many files have we seen of each type?):
my %file_types;

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   process_argv();
   my $cwd = cwd_utf8;
   say "File-type statistics for \"$cwd\".";
   $Recurse ? say 'Recursion is On.' : say 'Recursion is Off.';
   $Recurse and RecurseDirs {process_current_directory} or process_current_directory;
   stats;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub process_argv ()
{
   foreach (@ARGV)
   {
      if ($_ eq '-h' || $_ eq '--help'   ) {help        ;}
      if ($_ eq '-r' || $_ eq '--recurse') {$Recurse = 1;}
      if ($_ eq '-s' || $_ eq '--size'   ) {$Size    = 1;}
   }
   return 1;
} # end sub process_argv ()

sub process_current_directory ()
{
   ++$direcount;
   my $curdir = cwd_utf8;
   my @curdirpaths = glob_regexp_utf8($curdir, 'F');
   foreach my $path (@curdirpaths)
   {
      process_current_file($path);
   }
   return 1;
} # end sub process_current_directory ()

sub process_current_file ($)
{
   ++$filecount;
   my $path = shift;
   my $name = get_name_from_path($path);
   if ($db) {say "In process_current_file. Current file name = \"$name\".";}
   my $suff = get_suffix($name);
   $suff =~ s/^\.htm$/.html/i;
   $suff =~ s/^\.tif$/.tiff/i;
   $suff =~ s/^\.jpeg$/.jpg/i;
   $suff =~ s/^\.mpeg$/.mpg/i;
   $suff = fc $suff;
   ++$file_types{$suff};
   return 1;
} # end sub process_current_file ($)

sub stats ()
{
   printf("Extension:  Count:\n");
   my @sorted_keys;
   if ($Size)
   {
      @sorted_keys = sort {$file_types{$b} <=> $file_types{$a}} keys %file_types;
   }
   else
   {
      @sorted_keys = sort keys %file_types;
   }
   printf("%-12s%6d\n", $_, $file_types{$_}) for @sorted_keys;
   return 1;
} # end sub stats ()

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "file-types-statistics.pl". This program collects and prints
   file-type statistics (based on file name extension ("*.jpg", "*.avi", etc))
   for all files in the current directory (and all subdirectories if a -r or
   --recurse option is used).

   Command line:
   file-types-statistics.pl [options]

   Available options:
   Option:               Meaning:
   "-h" or "--help"      Print help and exit.
   "-r" or "--recurse"   Recurse subdirectories.
   "-s" or "--size"      Sort by size instead of by extension.

   All options not listed above, and all non-option arguments, are ignored.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   exit 777;
} # end sub help ()
