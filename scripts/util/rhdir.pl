#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# rhdir.pl
# Prints information about every file in current working directory.
#
# Edit history:
# Sat Dec 06, 2014: Wrote it. (Date is approximate.)
# Fri Jul 17, 2015: Upgraded for utf8.
# Mon Apr 04, 2016: Simplified.
# Sat Apr 16, 2016: Now using -CSDA.
# Sun Sep 23, 2018: "errocount" => "noexcount", and added inodes.
# Sun Sep 30, 2018: Now also discerns hard links.
# Tue Feb 01, 2021: Refactored to use the new GetFiles($dir, $target, $regexp).
# Tue Mar 09, 2021: Changed help() to reflect fact that we're now using PCREs instead of csh wildcards.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Sat Jul 30, 2022: Now sorts files within each type, so one doesn't get a random jumble of "regular files" as before.
#                   Also, removed type "M", because in Linux, ALL directories have multiple hard links pointing to them
#                   because of "." and ".."; all directories are now type "D" instead of "M". Also, corrected ommission
#                   in help(), which failed to mention the number-of-links column. Also, removed mention of "directories
#                   with multiple hard links" from both dir_stats and tree_stats.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use Cwd;
use Time::HiRes 'time';
use Data::Dumper qw(Dumper);

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv       ();
sub curdire    ();
sub dir_stats  ($);
sub tree_stats ();
sub error      ($);
sub help       ();

# ======= VARIABLES: ===================================================================================================

# Use debugging? (Ie, print extra diagnostics?)
my $db = 0;

# Settings:               # Meaning of setting:     Possible values:  Default:
my $Verbose  = 1;         # Be verbose?             0, 1, or 2        1 (somewhat verbose)
my $Recurse  = 0;         # Recurse subdirectories? (bool)            0 (don't recurse)
my $Target   = 'A';       # Target                  F|D|B|A           A (print directory entries of all types)
my $Regexp   = qr/^.+$/o; # Regular Expression.     (regexp)          qr/^.+$/o (matches all strings)
my $Inodes   = 0;         # Print inodes?           (bool)            0 (don't print inodes)

# Counts of events in this program:
my $direcount = 0; # Count of directories processed.
my $filecount = 0; # Count of files processed.

# Accumulations of counters from RH::Dir :
my $totfcount = 0; # Count of all targeted directory entries matching wildcard and verified by GetFiles().
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

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   argv;
   if (2 == $Verbose)
   {
      say "Verbose  = $Verbose" ;
      say "Recurse  = $Recurse" ;
      say "Target   = $Target"  ;
      say "Regexp   = $Regexp"  ;
      say "Inodes   = $Inodes"  ;
   }
   my ($entry_time, $exit_time, $elapsed_time);
   if (2 == $Verbose) {$entry_time = time;}
   $Recurse and RecurseDirs {curdire} or curdire;
   if ($Verbose >= 1) {tree_stats;}
   if (2 == $Verbose)
   {
      $exit_time = time;
      $elapsed_time = $exit_time - $entry_time;
      say "Run-time for \"rhdir.pl\" was $elapsed_time seconds.";
   }
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =======================================================================================

sub argv ()
{
   my $help   = 0;
   my @CLArgs = ();
   foreach (@ARGV)
   {
      if (/^-[\pL]{1,}$/ || /^--[\pL\pP\pS\pN]{2,}$/)
      {
         /^-h$/ || /^--help$/         and $help    =  1 ;
         /^-v$/ || /^--verbose$/      and $Verbose =  2 ;
         /^-q$/ || /^--quiet$/        and $Verbose =  0 ;
         /^-r$/ || /^--recurse$/      and $Recurse =  1 ;
         /^-f$/ || /^--target=files$/ and $Target  = 'F';
         /^-d$/ || /^--target=dirs$/  and $Target  = 'D';
         /^-b$/ || /^--target=both$/  and $Target  = 'B';
         /^-a$/ || /^--target=all$/   and $Target  = 'A';
         /^-i$/ || /^--inodes$/       and $Inodes  =  1 ;
      }
      else {push @CLArgs, $_;}
   }
   $help and help and exit 777;
   my $NA = scalar(@CLArgs);
   given ($NA)
   {
      when (0) {                         ;} # Do nothing.
      when (1) {$Regexp = qr/$CLArgs[0]/o;} # Set $Regexp.
      default  {error($NA)               ;} # Print error and help messages then exit 666.
   }
   return 1;
} # end sub argv ()

sub curdire ()
{
   ++$direcount;
   my $curdir = cwd_utf8;
   say "\nDir # $direcount: \"$curdir\"";

   # Get list of files in current directory matching $Target and $Regexp:
   my $curdirfiles = GetFiles($curdir, $Target, $Regexp);

   if ($db)
   {
      say '';
      say 'IN curdire. List of paths from GetFiles:';
      say $_->{Path} for @{$curdirfiles};
      say '';
   }

   # If being "somewhat verbose", append total-files and nonexistant-files to accumulators:
   if ($Verbose >= 1)
   {
      $totfcount += $RH::Dir::totfcount; # Total files.
      $noexcount += $RH::Dir::noexcount; # Nonexistent files.
   }

   # If being "VERY verbose", also append all remaining RH::Dir counters to accumulators:
   if ($Verbose == 2)
   {
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
   }

   # Make a list of types:
   # WOMBAT RH 2022-07-30: I'm removing "M" from this list PERMANENTLY, because in Linux, EVERY directory has multiple
   # hardlinks to it, so "M" would only be meaningful in Windows, and I'm phasing Windows out of my life:
  #my @Types = split //,'NTYXOPSLMDHFU';
   my @Types = split //,'NTYXOPSLDHFU';

   # Make a hash of refs to lists of refs to file-record hashes, keyed by type:
   my %TypeLists;

   if ($db) {print Dumper \%TypeLists}

   # Use autovivification to insert refs to anonymous arrays into %TypeLists, 
   # and to push refs to file-record hashes into those anonymous arrays:
   foreach my $type (@Types)
   {
      foreach my $file (@{$curdirfiles})
      {
         if ($type eq $file->{Type})
         {
            push @{$TypeLists{$type}}, $file;
         }
      }
   }

   if ($db) {print Dumper \%TypeLists}

   if ($Inodes)
   {
      say 'T: Date:       Time:        Size:     Inode:                #:   Name:';
      foreach my $type (@Types)
      {
         foreach my $file (sort {fc($a->{Name}) cmp fc($b->{Name})} @{$TypeLists{$type}})
         {
            ++$filecount;
            printf("%-1s  %-10s  %-11s  %-8.2E  %20d  %3u  %-s\n", 
                   $file->{Type}, $file->{Date},  $file->{Time}, 
                   $file->{Size}, $file->{Inode}, $file->{Nlink}, $file->{Name});
         }
      }
   }

   else
   {
      say 'T: Date:       Time:        Size:     #:   Name:';
      foreach my $type (@Types)
      {
         foreach my $file (sort {fc($a->{Name}) cmp fc($b->{Name})} @{$TypeLists{$type}})
         {
            ++$filecount;
            printf("%-1s  %-10s  %-11s  %-8.2E  %3u  %-s\n", 
                   $file->{Type}, $file->{Date},  $file->{Time}, 
                   $file->{Size}, $file->{Nlink}, $file->{Name});
         }
      }
   }
   # Print stats for this directory:
   dir_stats($curdir);
   return 1;
} # end sub curdire ()

sub dir_stats ($)
{
   if ($Verbose >= 1)
   {
      my $curdir = shift;
      say "\nStatistics for directory \"$curdir\":";
      say "Found ${RH::Dir::totfcount} files matching given target and regexp.";
      say "Found ${RH::Dir::noexcount} nonexistent directory entries.";
   }

   if ($Verbose == 2)
   {
      say "\nDirectory entries encountered included:";
      printf("%7u tty files\n",                              $RH::Dir::ottycount);
      printf("%7u character special files\n",                $RH::Dir::cspccount);
      printf("%7u block special files\n",                    $RH::Dir::bspccount);
      printf("%7u sockets\n",                                $RH::Dir::sockcount);
      printf("%7u pipes\n",                                  $RH::Dir::pipecount);
      printf("%7u symbolic links to directories\n",          $RH::Dir::slkdcount);
      printf("%7u symbolic links to non-directories\n",      $RH::Dir::linkcount);
      printf("%7u directories\n",                            $RH::Dir::sdircount);
      printf("%7u regular files with multiple hard links\n", $RH::Dir::hlnkcount);
      printf("%7u regular files\n",                          $RH::Dir::regfcount);
      printf("%7u files of unknown type\n",                  $RH::Dir::unkncount);
   }
   return 1;
} # end sub dir_stats ($)

sub tree_stats ()
{
   if ($Verbose >= 1)
   {
      say "\nStatistics for this tree:";
      say "Navigated $direcount directories.";
      say "Processed $filecount files.";
      say "Found $totfcount files matching given target and regexp.";
      say "Found $noexcount nonexistent directory entries.";
   }

   if ($Verbose == 2)
   {
      say "\nDirectory entries encountered included:";
      printf("%7u tty files\n",                              $ottycount);
      printf("%7u character special files\n",                $cspccount);
      printf("%7u block special files\n",                    $bspccount);
      printf("%7u sockets\n",                                $sockcount);
      printf("%7u pipes\n",                                  $pipecount);
      printf("%7u symbolic links to directories\n",          $slkdcount);
      printf("%7u symbolic links to non-directories\n",      $linkcount);
      printf("%7u directories\n",                            $sdircount);
      printf("%7u regular files with multiple hard links\n", $hlnkcount);
      printf("%7u regular files\n",                          $regfcount);
      printf("%7u files of unknown type\n",                  $unkncount);
   }
   return 1;
} # end sub tree_stats ()

sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: rhdir.pl takes zero or one arguments, but you typed $NA. If an argument
   is present, it must be a Perl-Compliant Regular Expression specifying which
   directory entries to list. Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end sub error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to RHDir, Robbie Hatley's Nifty directory listing utility.
   RHDir will list all files and/or folders and/or other objects in
   the current directory (and all subdirectories if a -r or --recurse
   option is used). Each listing line will give the following pieces
   of information about a file:
   1. Type of file (single-letter code, one of NTYXOPSLMDHFU).
   2. Last-modified Date of file.
   3. Last-modified Time of file.
   4. Size of file in format #.##E+##
   5. Number of hard links to file.
   6. Name of file.

   The meanings of the Type letters are as follows:
   N - object is nonexistent
   T - object opens to a TTY
   Y - object is a character special file
   X - object is a block special file
   O - object is a socket
   P - object is a pipe
   S - object is a symbolic link to a directory ("SYMLINKD")
   L - object is a symbolic link to a file
   D - object is a directory
   H - object is a regular file with multiple hard links
   F - object is a regular file
   U - object is of unknown type

   Command line:
   rhdir.pl [options] [Argument]

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-q" or "--quiet"            Be  non-verbose (don't list counts of file types).
   "-v" or "--verbose"          Be VERY verbose (list counts of ALL files types).
   "-r" or "--recurse"          Recurse subdirectories.
   "-f" or "--target=files"     List files only.
   "-d" or "--target=dirs"      List directories only.
   "-b" or "--target=both"      List both files and directories.
   "-a" or "--target=all"       List all file-system objects, of all types.
   "-i" or "--inodes"           Also print inode numbers for all files
   (Defaults are: no help, somewhat verbose, don't recurse, list all, no inodes.)

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

   Happy directory listing!

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
