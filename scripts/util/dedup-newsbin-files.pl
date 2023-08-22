#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# /rhe/scripts/util/dedup-newsbin-files.pl
# "DeDup Newsbin Files"
# Gets rid of duplicate files within file name groups having same base name but different "numerators", where
# a "numerator" is a substring of the form "-(3856)" at the end of the prefix of a file name, and where a
# "base" is a name as it would be if it had no numerators. For example, the "base" of file name
# "Fred-(8874).jpg" is "Fred.jpg".
# Edit history:
# Mon Jun 08, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Wed Feb 17, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory as
#                   its first argument, target as second, and regexp (instead of wildcard) as third.
# Tue Jul 13, 2021: Now 120 characters wide.
# Sat Jul 31, 2021: Now using "use Sys::Binmode" and "e".
# Wed Nov 16, 2021: Now using "use common::sense;".
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate.
# Tue Mar 14, 2023: Added options for local, recursive, quiet, and verbose.
# Thu Aug 03, 2023: Upgraded from "use v5.32;" to "use v5.36;". Got rid of "common::sense" (antiquated).
#                   Went from "cwd_utf8" to "d getcwd". Got rid of prototypes. Changed defaults from "verbose"
#                   and "recurse" to "quiet" and "local". Reduced width from 120 to 110. Shortened sub names.
#                   Got rid of "-l", "--local", "-q", and "--quiet" options as they're already default.
#                   Improved help.
# Mon Aug 21, 2023: An "option" is now "one or two hyphens followed by 1-or-more word characters".
#                   Reformatted debug printing of opts and args to ("word1", "word2", "word3") style.
#                   Inserted text into help explaining the use of "--" as "end of options" marker.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;

use Sys::Binmode;
use Cwd;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv  ;
sub dedup ;
sub stats ;
sub help  ;

# ======= VARIABLES: =========================================================================================

# Debug?
my $db = 0;

# Settings:                 Meaning of setting:       Range:   Meaning of default:
my $Recurse = 0;          # Recurse subdirectories?   bool     Be local.
my $Verbose = 0;          # Be verbose?               bool     Be quiet.
my $RegExp  = qr/^.+$/o;  # Which files?              regexp   Process all regular files.

# Counters:
my $direcount = 0;
my $filecount = 0;
my $ngrpcount = 0;
my $compcount = 0;
my $duplcount = 0;
my $delecount = 0;
my $failcount = 0;

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   my $pname = get_name_from_path($0);
   if ( $Verbose ) {
      say STDERR '';
      say STDERR "Now entering program \"$pname\".";
      say STDERR "Verbose = $Verbose";
      say STDERR "Recurse = $Recurse";
      say STDERR "RegExp  = $RegExp";
   }
   if ( $db ) {exit 555}

   $Recurse and RecurseDirs {dedup} or dedup;

   stats;
   my $ms = 1000 * (time - $t0);
   if ( $Verbose ) {
      printf STDERR "\nNow exiting program \"%s\". Execution time was %.3fms.", $pname, $ms;
   }
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

sub argv {
   # Get options and arguments:
   my @opts = (); my @args = (); my $end_of_options = 0;
   for ( @ARGV ) {
      /^--$/ and $end_of_options = 1 and next;
      !$end_of_options && /^--?\w+$/ and push @opts, $_ or push @args, $_;
   }

   # Process options:
   for ( @opts ) {
      /^-\w*h|^--help$/    and help and exit 777 ;
      /^-\w*v|^--verbose$/ and $Verbose =  1     ;
      /^-\w*r|^--recurse$/ and $Recurse =  1     ;
   }
   if ( $db ) {
      say   STDERR '';
      print STDERR "opts = ("; print STDERR map {'"'.$_.'"'} @opts; say STDERR ')';
      print STDERR "args = ("; print STDERR map {'"'.$_.'"'} @args; say STDERR ')';
   }

   # Process arguments:
   my $NA = scalar(@args);
   if    ( 0 == $NA ) {                              ; } # Use default settings.
   elsif ( 1 == $NA ) { $RegExp = qr/$args[0]/o      ; } # Set $RegExp.
   else               { error($NA); help(); exit 666 ; } # Something evil happened.

   # Return success code 1 to caller:
   return 1;
} # end sub argv

sub dedup {
   ++$direcount;

   # Get current working directory:
   my $curdir = d getcwd;

   # If being verbose, announce directory:
   say STDERR "\nDirectory # $direcount: $curdir\n" if $Verbose;

   # Get reference to array of references to file records for all regular files
   # matching $RegExp in current directory:
   my $files = GetFiles($curdir, 'F', $RegExp);

   # Make a hash of references to arrays of references to file records,
   # with the outer hash keyed by name base:
   my %name_groups;
   foreach my $file (@{$files}) {
      ++$filecount;
      my $name = $file->{Name};
      my $base = denumerate_file_name($name);
      push @{$name_groups{$base}}, $file;
   }

   # Iterate through each name group:
   BASE: foreach my $base (sort keys %name_groups) {
      ++$ngrpcount;

      # How many files are in this name-base group?
      my $count = scalar @{$name_groups{$base}};

      # If fewer than two files exist in this name group, go to next name group:
      next BASE if ($count < 2);

      # "FIRST" LOOP: Iterate through all files of current name group except the last:
      FIRST: for my $i (0..$count-2) {
         # Set $file1 to reference to ith file record:
         my $file1 = $name_groups{$base}->[$i];

         # Skip to next first file if ith file has already been deleted:
         next FIRST if $file1->{Name} eq "***DELETED***";

         # "SECOND" LOOP: Iterate through all files of current name group which are
         # to the right of file "$i":
         SECOND: for my $j ($i+1..$count-1) {
            # Set $file2 to reference to jth file record:
            my $file2 = $name_groups{$base}->[$j];

            # Skip to next second file if jth file has already been deleted:
            next SECOND if $file2->{Name} eq "***DELETED***";

            # Skip to next second file unless jth file is same size as ith file:
            next SECOND unless $file2->{Size} == $file1->{Size};

            # If files i and j have same inode, they're just aliases for the same
            # file, so move on to next second file:
            next SECOND if $file1->{Inode} == $file2->{Inode};

            # Do files have identical content?
            my $identical = FilesAreIdentical($file1->{Name}, $file2->{Name});

            # If FilesAreIdentical didn't die, we successfully compared the current
            # pair of files, so increment "$compcount":
            ++$compcount;

            # If we found no difference between these two files, they're duplicates,
            # so erase the newer file:
            if ($identical) {
               # These files are duplicates, so increment $duplcount:
               ++$duplcount;

               # If file2 has the more-recent Mtime, erase file2:
               if ($file2->{Mtime} > $file1->{Mtime}) {
                  unlink(e($file2->{Name})) # Unlink second file.
                     and say "Erased $file2->{Path}"
                     and $file2->{Name} = "***DELETED***"
                     and ++$delecount
                  or warn("Error in dnf: Failed to unlink $file2->{Path}.\n")
                     and ++$failcount;
                  next SECOND;
               }

               # Otherwise, erase file1:
               else {
                  unlink(e($file1->{Name})) # Unlink first file.
                     and say "Erased $file1->{Path}"
                     and $file1->{Name} = "***DELETED***"
                     and ++$delecount
                  or warn("Error in dnf: Failed to unlink $file1->{Path}.\n")
                     and ++$failcount;
                  next FIRST;
               }#end else (erase file 1)
            }#end if ($identical)
         }#end SECOND loop
      }#end FIRST loop
   }#end BASE loop
   return 1;
}#end sub dedup

sub stats {
   if ($Verbose) {
      say    STDERR "\nStatistics for program \"dedup-newsbin-files.pl\":";
      printf STDERR "Navigated   %6d directories.\n",               $direcount;
      printf STDERR "Encountered %6d files.\n",                     $filecount;
      printf STDERR "Encountered %6d matching file-name groups.\n", $ngrpcount;
      printf STDERR "Compaired   %6d pairs of files.\n",            $compcount;
      printf STDERR "Found       %6d pairs of duplicate files.\n",  $duplcount;
      printf STDERR "Deleted     %6d duplicate files.\n",           $delecount;
      printf STDERR "Failed      %6d file deletion attempts.\n",    $failcount;
   }
   return 1;
} # end sub stats

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "dedup-newsbin-files.pl", Robbie Hatley's nifty program for
   erasing duplicate files within groups of files having the same base name but
   different "numerators", where a "numerator" is a substring of the form
   "-(####)" (where the "####" are any 4 digits) immediately before the
   filename's extension (the rightmost dot and all characters to its right).

   For example, say you had files named "Frank.txt", "Frank-(3956).txt", and
   "Frank-(1987).txt", and say that "Frank-(3956).txt" is an older duplicate of
   "Frank.txt", but "Frank-(1987).txt" differs in content from the other two.
   Then dnf would erase "Frank.txt" because it's a newer duplicate, and leave
   the other two files intact because they differ in content.

   By default, this program only processes the current working directory, but
   if a "-r" or "--recurse" option is used, it also processes all
   subdirectories of the current working directory as well.

   -------------------------------------------------------------------------------
   Command lines:

   dedup-newsbin-files.pl [-h|--help]     (to print this help and exit)
   dedup-newsbin-files.pl [options]       (to erase duplicates)

   -------------------------------------------------------------------------------
   Description of options:

   Option:            Meaning:
   -h or --help       Print this help and exit.
   -r or --recurse    Recurse subdirectories.
   -v or --verbose    Be verbose.
         --           End of options (all further CL items are arguments).

   Multiple single-letter options may be piled-up after a single hyphen.
   For example, to be both recursive and verbose:
   dedup-newsbin-files.pl -rv

   If you want to use an argument that looks like an option (say, you want to
   search for files which contain "--recurse" as part of their name), use a "--"
   option; that will force all command-line entries to its right to be considered
   "arguments" rather than "options".

   All options not listed above are ignored.

   -------------------------------------------------------------------------------
   Description of arguments:

   In addition to the options above, this program can take one optional argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying which
   regular-file groups to dedup. To specify multiple patterns, use the "|"
   alternation operator. To apply pattern modifier letters, use an Extended
   RegExp Sequence. For example, if you want to dedup file groups with names
   containing "cat", "dog", or "horse", title-cased or not, recursively:
   dedup-newsbin-files -vr '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   Happy duplicate file removing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
