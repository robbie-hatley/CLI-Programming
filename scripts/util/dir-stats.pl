#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# dir-stats.pl
# Prints statistics for all items in current directory (and all subdirectories if a -r or --recurse option is used).
#
# Edit history:
# Sat Jan 02, 2021: Wrote it.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv       ();
sub curdire    ();
sub curfile    ($);
sub list_paths ();
sub dir_stats  ();
sub tot_stats  ();
sub error      ($);
sub help       ();

# ======= LEXICAL VARIABLES: ===========================================================================================

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# Settings (needed by curdire, which may be called indirectly from a functor):
my $Recurse   = 0         ; # Recurse subdirectories?   (bool)
my $Target    = 'A'       ; # Target                    (F|D|B|A)
my $RegExp    = qr/^.+$/o ; # Regular expression.       (regexp)
my $List      = 0         ; # List paths?               (bool)

# Counts of events in this program:
my $direcount = 0; # Count of directories processed by curdire().
my $filecount = 0; # Count of    files    processed by curfile().
my $findcount = 0; # Count of found instances  of   xxxxxxx.
my $failcount = 0; # Count of failed attempts to do xxxxxxx.

# Accumulations of counters from RH::Dir::GetFiles():
my $totfcount = 0; # Count of all targeted directory entries matching regexp and verified by GetFiles().
my $noexcount = 0; # Count of all nonexistent files encountered. 
my $ottycount = 0; # Count of all tty files.
my $cspccount = 0; # Count of all character special files.
my $bspccount = 0; # Count of all block special files.
my $sockcount = 0; # Count of all sockets.
my $pipecount = 0; # Count of all pipes.
my $slkdcount = 0; # Count of all symbolic links to directories.
my $linkcount = 0; # Count of all symbolic links to non-directories.
my $multcount = 0; # Count of all directories with multiple hard links.
my $sdircount = 0; # Count of all directories.
my $hlnkcount = 0; # Count of all regular files with multiple hard links.
my $regfcount = 0; # Count of all regular files.
my $unkncount = 0; # Count of all unknown files.

# Arrays of items found and not-found:
my @LocalFilePaths = ();
my @LocalDeadPaths = ();

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{
   print("\nNow entering program \"dir-stats.pl\".\n\n");

   # Get and process options and arguments:
   argv();
   say "Recurse = $Recurse";
   say "Target  = $Target";
   say "RegExp  = $RegExp";
   say "List    = $List";

   $Recurse and RecurseDirs {curdire} or curdire;

   # Print total stats:
   tot_stats;

   # We be done, so scram:
   print("\nNow exiting program \"dir-stats.pl\".\n\n");
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =======================================================================================

sub argv ()
{
   my $help   = 0;  # Just print help and exit?
   my @CLArgs = (); # Command-Line Arguments (not including options).

   # Get and process options and arguments.
   # An "option" is "-a" where "a" is any single alphanumeric character, 
   # or "--b" where "b" is any cluster of 2-or-more printable characters.
   foreach (@ARGV)
   {
      say "item from \@ARGV = $_" if $db;
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         say "item is an option" if $db;
         m/^-h$/ || m/^--help$/         and $help    =  1 ;
         m/^-l$/ || m/^--list$/         and $List    =  1 ;
         m/^-r$/ || m/^--recurse$/      and $Recurse =  1 ;
         m/^-f$/ || m/^--target=files$/ and $Target  = 'F';
         m/^-d$/ || m/^--target=dirs$/  and $Target  = 'D';
         m/^-b$/ || m/^--target=both$/  and $Target  = 'B';
         m/^-a$/ || m/^--target=all$/   and $Target  = 'A';
      }
      else
      {
         say "item is an argument" if $db;
         push @CLArgs, $_;
      }
   }
   if ($help) {help(); exit(777);}                   # If user wants help, just print help and exit.
   my $NumArgs = scalar(@CLArgs);                    # Get number of arguments.
   given ($NumArgs)
   {                                                 # Given the number of arguments,
      when (0) {;}                                   # if =0, do nothing;
      when (1) {$RegExp = qr/$CLArgs[0]/o;}          # if =1, set $RegExp;
      default  {error($NumArgs); help(); exit(666);} # if >1, print error and help messages and exit.
   }
   return 1;
} # end subroutine argv

sub curdire ()
{
   ++$direcount;

   # Get and announce current working directory:
   my $curdir = cwd_utf8;
   say '';
   say "Directory # $direcount:";
   say $curdir;

   say "In curdire. \$Target = $Target" if $db;
   say "In curdire. \$RegExp = $RegExp" if $db;

   # Get list of targeted files in current directory:
   my $curdirfiles = GetFiles($curdir, $Target, $RegExp);

   # Append all counters from "RH::Dir" to "dir-stats.pl" accumulators:
   $totfcount += $RH::Dir::totfcount; # all files
   $noexcount += $RH::Dir::noexcount; # nonexistent files
   $ottycount += $RH::Dir::ottycount; # tty files
   $cspccount += $RH::Dir::cspccount; # character special files
   $bspccount += $RH::Dir::bspccount; # block special files
   $sockcount += $RH::Dir::sockcount; # sockets
   $pipecount += $RH::Dir::pipecount; # pipes
   $slkdcount += $RH::Dir::slkdcount; # symbolic links to directories
   $linkcount += $RH::Dir::linkcount; # symbolic links to non-directories
   $multcount += $RH::Dir::multcount; # directories with multiple hard links
   $sdircount += $RH::Dir::sdircount; # directories
   $hlnkcount += $RH::Dir::hlnkcount; # regular files with multiple hard links
   $regfcount += $RH::Dir::regfcount; # regular files
   $unkncount += $RH::Dir::unkncount; # unknown files

   # Iterate through these files, possibly renaming some depending on settings
   # and possibly other user input:
   foreach my $file (@{$curdirfiles}) 
   {
      curfile($file);
   }

   # If listing, print per-directory stats:
   list_paths if $List;

   # Print stats for this directory:
   dir_stats;

   return 1;
} # end subroutine curdire

sub curfile ($)
{
   ++$filecount;
   my $file = shift;
   if (-e e $file->{Name})
   {
      ++$findcount;
      push @LocalFilePaths, $file->{Path} if $List;
      return 1;
   }
   else
   {
      ++$failcount;
      push @LocalDeadPaths, $file->{Path} if $List;
      return 0;
   }
} # end sub curfile

sub list_paths ()
{
   say "\nList of paths found in this directory:";
   if (@LocalFilePaths) {say for @LocalFilePaths}
   else                 {say '(none)'}
   say "\nList of paths NOT found in this directory:";
   if (@LocalDeadPaths) {say for @LocalDeadPaths}
   else                 {say '(none)'}
   @LocalFilePaths=();
   @LocalDeadPaths=();
   return 1;
} # end sub list_paths

sub dir_stats ()
{
   say "\nEntries encountered in this directory included:";
   printf("%7u files matching target \"%s\" and regexp \"%s\".\n", $RH::Dir::totfcount, $Target, $RegExp);
   printf("%7u nonexistent files.\n",                     $RH::Dir::noexcount);
   printf("%7u tty files\n",                              $RH::Dir::ottycount);
   printf("%7u character special files\n",                $RH::Dir::cspccount);
   printf("%7u block special files\n",                    $RH::Dir::bspccount);
   printf("%7u sockets\n",                                $RH::Dir::sockcount);
   printf("%7u pipes\n",                                  $RH::Dir::pipecount);
   printf("%7u symbolic links to directories\n",          $RH::Dir::slkdcount);
   printf("%7u symbolic links to non-directories\n",      $RH::Dir::linkcount);
   printf("%7u directories with multiple hard links\n",   $RH::Dir::multcount);
   printf("%7u directories\n",                            $RH::Dir::sdircount);
   printf("%7u regular files with multiple hard links\n", $RH::Dir::hlnkcount);
   printf("%7u regular files\n",                          $RH::Dir::regfcount);
   printf("%7u files of unknown type\n",                  $RH::Dir::unkncount);
   return 1;
} # end sub dir_stats

sub tot_stats ()
{
   say "\nStatistics for this directory tree:";
   say "Navigated $direcount directories.";
   say "Examined $filecount files matching regexp \"$RegExp\".";
   say "Found $findcount file paths.";
   say "Failed $failcount path-finding attempts.";

   if ($direcount > 1)
   {
   say '\nDirectory entries encountered included:';
   printf("%7u total files\n",                            $totfcount);
   printf("%7u nonexistent files\n",                      $noexcount);
   printf("%7u tty files\n",                              $ottycount);
   printf("%7u character special files\n",                $cspccount);
   printf("%7u block special files\n",                    $bspccount);
   printf("%7u sockets\n",                                $sockcount);
   printf("%7u pipes\n",                                  $pipecount);
   printf("%7u symbolic links to directories\n",          $slkdcount);
   printf("%7u symbolic links to non-directories\n",      $linkcount);
   printf("%7u directories with multiple hard links\n",   $multcount);
   printf("%7u directories\n",                            $sdircount);
   printf("%7u regular files with multiple hard links\n", $hlnkcount);
   printf("%7u regular files\n",                          $regfcount);
   printf("%7u files of unknown type\n",                  $unkncount);
   }
   return 1;
} # end sub tot_stats

sub error ($)
{
   my $NumArgs = shift;
   print ((<<'   END_OF_ERROR') =~ s/^   //gmr);
   Error: you typed $NumArgs arguments, but
   \"dir-stats.pl\" takes at most 1 argument, which, if present,
   must be a regular expression specifying which directory entries
   to process. (Did you forget to put the regexp in 'single quotes'?)
   Help follows:

   END_OF_ERROR
   help;
   return 1;
} # end sub error

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "dir-stats.pl", Robbie Hatley's nifty directory statistics
   printing program. This program prints stats on all of the objects in the
   current directory (and all subdirectories if a -r or --recurse option
   is used).

   Command line:
   dir-stats.pl [options] [argument]

   Description of available options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-r" or "--recurse"          Recurse subdirectories (but not links).
   "-f" or "--target=files"     Target files only.
   "-d" or "--target=dirs"      Target directories only.
   "-b" or "--target=both"      Target both files and directories.
   "-a" or "--target=all"       Target all objects (DEFAULT).
   "-l" or "--list"             Also list paths found and not found.

   Description of arguments:
   In addition to options, this program can take one optional argument which, if
   present, must be a Perl-Compliant Regular Expression specifying which items to
   process. To specify multiple patterns, use the | alternation operator.
   To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to search for items with names containing "cat",
   "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead. 

   Happy statistics printing!
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
