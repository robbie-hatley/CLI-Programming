#! /bin/perl -CSDA

# This is a 110-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
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
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Sat Jul 30, 2022: Now sorts files within each type, so one doesn't get a random jumble of "regular files" as
#                   before. Removed type "M", because in Linux, ALL directories have multiple hard links
#                   pointing to them because of "." and "..". All directories are now type "D" instead of "M".
#                   Corrected omission in help(), which failed to mention the number-of-links column.
#                   Removed mention of "directories with multiple hard links" from dir_stats and stats.
# Sun Jul 30, 2023: Upgraded from "use v5.32;" to "use v5.36;". Got rid of "common::sense" (antiquated).
#                   Got rid of "prototypes". Now using "signature" for error() and dir_stats().
#                   Got rid of all usage of given/when. Reduced width from 120 to 110 with github in mind.
#                   Now counting broken symbolic links and symbolic links to "other than file or directory".
#                   Sub error is now single-purpose (help and exit are called from argv instead).
#                   Multiple single-letter options can now be piled-up after a single hyphen.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;

use Sys::Binmode;
use Cwd;
use Time::HiRes 'time';
use Data::Dumper qw(Dumper);

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv      ;
sub curdire   ;
sub dir_stats ;
sub stats     ;
sub error     ;
sub help      ;

# ======= VARIABLES: =========================================================================================

# Settings:                   Meaning of setting:     Possible values:  Default:
   $,         = ', '      ; # Array formatting.       (string)          ', '
my $db        = 0         ; # Debug?                  0, 1              0 (don't debug)
my $Verbose   = 1         ; # Be verbose?             0, 1, or 2        1 (somewhat verbose)
my $Recurse   = 0         ; # Recurse subdirectories? (bool)            0 (don't recurse)
my $Target    = 'A'       ; # Target                  F|D|B|A           A (list files of all types)
my $Regexp    = qr/^.+$/o ; # Regular Expression.     (regexp)          qr/^.+$/o (matches all strings)
my $Inodes    = 0         ; # Print inodes?           (bool)            0 (don't print inodes)

# Counts of events in this program:
my $direcount = 0; # Count of directories processed.
my $filecount = 0; # Count of files processed.

# Accumulations of counters from RH::Dir :
my $totfcount = 0; # Count of all targeted directory entries matching regexp.
my $noexcount = 0; # Count of all nonexistent files encountered.
my $ottycount = 0; # Count of all tty files.
my $cspccount = 0; # Count of all character special files.
my $bspccount = 0; # Count of all block special files.
my $sockcount = 0; # Count of all sockets.
my $pipecount = 0; # Count of all pipes.
my $brkncount = 0; # Count of all symbolic links to nowhere.
my $slkdcount = 0; # Count of all symbolic links to directories.
my $linkcount = 0; # Count of all symbolic links to files.
my $weircount = 0; # Count of all symbolic links to weirdness.
my $sdircount = 0; # Count of all directories.
my $hlnkcount = 0; # Count of all regular files with multiple hard links.
my $regfcount = 0; # Count of all regular files.
my $unkncount = 0; # Count of all unknown files.

# Hashes:
my %Targets;
$Targets{F} = "Files Only";
$Targets{D} = "Directories Only";
$Targets{B} = "Both Files And Directories";
$Targets{A} = "All Directory Entries";

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   if ($Verbose >= 1) {say STDERR "\nNow entering program \"rhdir.pl\".";}
   argv;
   if ( $Verbose >= 1 ) {
      say STDERR "Verbose  = $Verbose" ;
      say STDERR "Recurse  = $Recurse" ;
      say STDERR "Target   = $Target"  ;
      say STDERR "Regexp   = $Regexp"  ;
      say STDERR "Inodes   = $Inodes"  ;
   }
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $ms = 1000 * (time - $t0);
   if ( $Verbose >= 2 ) {printf STDERR "Now exiting program \"rhdir.pl\". Execution time was %.3ums.\n", $ms;}
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =============================================================================

sub argv {
   my @options;
   my @arguments;
   for (@ARGV) {
      if (/^-[^-]+$/ || /^--[^-]+$/) {push @options  , $_}
      else                           {push @arguments, $_}
   }
   for (@options) {
      if ( $_ =~ m/^-[^-]*h/ || $_ eq '--help'         ) {help; exit 777;}
      if ( $_ =~ m/^-[^-]*q/ || $_ eq '--quiet'        ) {$Verbose =  0 ;}
      if ( $_ =~ m/^-[^-]*v/ || $_ eq '--verbose'      ) {$Verbose =  2 ;}
      if ( $_ =~ m/^-[^-]*l/ || $_ eq '--local'        ) {$Recurse =  0 ;}
      if ( $_ =~ m/^-[^-]*r/ || $_ eq '--recurse'      ) {$Recurse =  1 ;}
      if ( $_ =~ m/^-[^-]*f/ || $_ eq '--target=files' ) {$Target  = 'F';}
      if ( $_ =~ m/^-[^-]*d/ || $_ eq '--target=dirs'  ) {$Target  = 'D';}
      if ( $_ =~ m/^-[^-]*b/ || $_ eq '--target=both'  ) {$Target  = 'B';}
      if ( $_ =~ m/^-[^-]*a/ || $_ eq '--target=all'   ) {$Target  = 'A';}
      if ( $_ =~ m/^-[^-]*i/ || $_ eq '--inodes'       ) {$Inodes  =  1 ;}
   }
   my $NA = scalar(@arguments);
      if ( 0 == $NA ) {                               ; } # Do nothing.
   elsif ( 1 == $NA ) { $Regexp = qr/$arguments[0]/o  ; } # Set $Regexp.
   else               { error($NA); help; exit 666    ; } # Print error and help messages then exit 666.
   return 1;
} # end sub argv

sub curdire {
   ++$direcount;
   my $curdir = cwd_utf8;
   say STDOUT "\nDir # $direcount: \"$curdir\"";

   # Get list of files in current directory matching $Target and $Regexp:
   my $curdirfiles = GetFiles($curdir, $Target, $Regexp);

   if ($db)
   {
      say STDERR '';
      say STDERR 'IN curdire. List of paths from GetFiles:';
      say STDERR $_->{Path} for @{$curdirfiles};
      say STDERR '';
   }

   # If being "somewhat verbose", append total-files and nonexistant-files to accumulators:
   if ($Verbose >= 1)
   {
      $totfcount += $RH::Dir::totfcount; # Total files.
      $noexcount += $RH::Dir::noexcount; # Nonexistent files.
   }

   # If being "VERY verbose", also append all remaining RH::Dir counters to accumulators:
   if ($Verbose >= 2)
   {
      $ottycount += $RH::Dir::ottycount; # tty files
      $cspccount += $RH::Dir::cspccount; # character special files
      $bspccount += $RH::Dir::bspccount; # block special files
      $sockcount += $RH::Dir::sockcount; # sockets
      $pipecount += $RH::Dir::pipecount; # pipes
      $brkncount += $RH::Dir::brkncount; # symbolic links to nowhere
      $slkdcount += $RH::Dir::slkdcount; # symbolic links to directories
      $linkcount += $RH::Dir::linkcount; # symbolic links to files
      $weircount += $RH::Dir::weircount; # symbolic links to weirdness
      $sdircount += $RH::Dir::sdircount; # directories
      $hlnkcount += $RH::Dir::hlnkcount; # regular files with multiple hard links
      $regfcount += $RH::Dir::regfcount; # regular files
      $unkncount += $RH::Dir::unkncount; # unknown files
   }

   # Make a list of types:
   my @Types = split //,'NTYXOPBSLWDHFU';

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
      say STDOUT 'T: Date:       Time:        Size:     Inode:      L:   Bsize:   Blocks:  Name:';
      foreach my $type (@Types)
      {
         foreach my $file (sort {fc($a->{Name}) cmp fc($b->{Name})} @{$TypeLists{$type}})
         {
            ++$filecount;
            printf STDOUT "%-1s  %-10s  %-11s  %-8.2E  %10d  %3u  %7u  %7u  %-s\n",
                          $file->{Type},  $file->{Date},   $file->{Time},
                          $file->{Size},  $file->{Inode},  $file->{Nlink},
                          $file->{Bsize}, $file->{Blocks}, $file->{Name};
         }
      }
   }

   else
   {
      say 'T: Date:       Time:        Size:     L:   Name:';
      foreach my $type (@Types)
      {
         foreach my $file (sort {fc($a->{Name}) cmp fc($b->{Name})} @{$TypeLists{$type}})
         {
            ++$filecount;
            printf STDOUT "%-1s  %-10s  %-11s  %-8.2E  %3u  %-s\n",
                          $file->{Type}, $file->{Date},  $file->{Time},
                          $file->{Size}, $file->{Nlink}, $file->{Name};
         }
      }
   }
   # Print stats for this directory:
   dir_stats($curdir);
   return 1;
} # end sub curdire

sub dir_stats ($curdir) {
   if ( $Verbose >= 1 ) {
      say STDERR "\nStatistics for directory \"$curdir\":";
      say STDERR "Found ${RH::Dir::totfcount} files matching given target and regexp.";
      say STDERR "Found ${RH::Dir::noexcount} nonexistent directory entries.";
   }
   if ( $Verbose >= 2 ) {
      say    STDERR "\nDirectory entries encountered in this directory included:";
      printf STDERR "%7u tty files\n",                              $RH::Dir::ottycount;
      printf STDERR "%7u character special files\n",                $RH::Dir::cspccount;
      printf STDERR "%7u block special files\n",                    $RH::Dir::bspccount;
      printf STDERR "%7u sockets\n",                                $RH::Dir::sockcount;
      printf STDERR "%7u pipes\n",                                  $RH::Dir::pipecount;
      printf STDERR "%7u symbolic links to nowhere\n",              $RH::Dir::brkncount;
      printf STDERR "%7u symbolic links to directories\n",          $RH::Dir::slkdcount;
      printf STDERR "%7u symbolic links to files\n",                $RH::Dir::linkcount;
      printf STDERR "%7u symbolic links to weirdness\n",            $RH::Dir::weircount;
      printf STDERR "%7u directories\n",                            $RH::Dir::sdircount;
      printf STDERR "%7u regular files with multiple hard links\n", $RH::Dir::hlnkcount;
      printf STDERR "%7u regular files\n",                          $RH::Dir::regfcount;
      printf STDERR "%7u files of unknown type\n",                  $RH::Dir::unkncount;
   }
   return 1;
} # end sub dir_stats ($curdir)

sub stats {
   if ( $Verbose >= 1 ) {
      say STDERR "\nStatistics for this tree:";
      say STDERR "Navigated $direcount directories.";
      say STDERR "Processed $filecount files.";
      say STDERR "Found $totfcount files matching given target and regexp.";
      say STDERR "Found $noexcount nonexistent directory entries.";
   }
   if ( $Verbose >= 2 ) {
      say    STDERR "\nDirectory entries encountered in this tree included:";
      printf STDERR "%7u tty files\n",                              $ottycount;
      printf STDERR "%7u character special files\n",                $cspccount;
      printf STDERR "%7u block special files\n",                    $bspccount;
      printf STDERR "%7u sockets\n",                                $sockcount;
      printf STDERR "%7u pipes\n",                                  $pipecount;
      printf STDERR "%7u symbolic links to nowhere\n",              $brkncount;
      printf STDERR "%7u symbolic links to directories\n",          $slkdcount;
      printf STDERR "%7u symbolic links to files\n",                $linkcount;
      printf STDERR "%7u symbolic links to weirdness\n",            $weircount;
      printf STDERR "%7u directories\n",                            $sdircount;
      printf STDERR "%7u regular files with multiple hard links\n", $hlnkcount;
      printf STDERR "%7u regular files\n",                          $regfcount;
      printf STDERR "%7u files of unknown type\n",                  $unkncount;
   }
   return 1;
} # end sub stats

sub error ($NA)
{
   print STDERR ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: rhdir.pl takes zero or one arguments, but you typed $NA. If an argument
   is present, it must be a Perl-Compliant Regular Expression specifying which
   directory entries to list. Help follows:
   END_OF_ERROR
} # end sub error ($NA)

sub help
{
   print STDERR ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to RHDir, Robbie Hatley's Nifty directory listing utility.
   RHDir will list all files and/or folders and/or other objects in
   the current directory (and all subdirectories if a -r or --recurse
   option is used). Each listing line will give the following pieces
   of information about a file:
   1. Type of file (single-letter code; see chart below).
   2. Last-modified Date of file.
   3. Last-modified Time of file.
   4. Size of file in format #.##E+##
   5. Number of hard links to file.
   6. Name of file.
   If a "-i" or "--inodes" option is used, the inode number,
   recommended block size, and number of blocks are also printed.

   The meanings of the Type letters are as follows:
   B - Broken symbolic link
   D - Directory
   F - regular File
   H - regular file with multiple Hard links
   L - symbolic Link to regular file
   N - Nonexistent
   O - sOcket
   P - Pipe
   S - Symbolic link to directory
   T - opens to a Tty
   U - Unknown
   W - symbolic link to something other than a regular file or directory
   X - block special file
   Y - character special file

   After the file listings, this program will print basic statistics, unless
   the verbosity level has been set to 0 using a -q or --quiet option.
   If the verbosity level has been set to 2 using a -v or --verbose option,
   counts of all file types are printed after the basic statistics.
   If neither option is used, stats will be printed but not counts.

   Command lines:
   rhdir.pl [-h | --help]             (to print this help and exit)
   rhdir.pl [options] [Argument]      (to list files)

   Description of options:
   Option:                   Meaning:
   "-h" or "--help"          Print help and exit.
   "-q" or "--quiet"         Be  non-verbose (don't list stats or counts).
   "-v" or "--verbose"       Be VERY verbose (list both stats AND counts).
   "-r" or "--recurse"       Recurse subdirectories.
   "-f" or "--target=files"  List files only.
   "-d" or "--target=dirs"   List directories only.
   "-b" or "--target=both"   List both files and directories.
   "-a" or "--target=all"    List all file-system objects, of all types.
   "-i" or "--inodes"        Print inode numbers, block sizes, & #s of blocks.
   Defaults (what will be printed if no options are used) are as follows:
    - Give file listings for files of all types (dir, reg, link, pipe, etc).
    - Print basic stats such as how many directories and files were processed.
    - Don't print counts of how many files of each type were encountered.
    - List files in current directory only (don't recurse).
    - Don't print inode numbers, recommended block size, or number of blocks.
   Multiple single-letter options may be piled-up after a single hyphen.
   For example, use -vrfi to verbosely recurse and print files and inodes.
   Options other than those listed above will be ignored.

   Description of arguments:
   In addition to options, this program can take one optional argument which, if
   present, must be a Perl-Compliant Regular Expression specifying which items to
   process. To specify multiple patterns, use the | alternation operator.
   To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to search for items with names containing "cat",
   "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else your shell may replace
   it with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   Happy directory listing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
