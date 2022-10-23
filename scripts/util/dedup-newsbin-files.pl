#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# /rhe/scripts/util/dedup-newsbin-files.pl
# "DeDup Newsbin Files"
# Gets rid of duplicate files within file name groups having same base name but different numerators. (By "numerator",
# I mean a substring of the form "-(3856)" at the end of the prefix of a file name. By "base", I mean the name as it
# would be if it had no numerators; for example, the "base" of file name "Fred-(8874).jpg" is "Fred.jpg".)
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
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub process_argv        ();
sub dedup_newsbin_files ();
sub print_stats         ();
sub help_msg            ();

# ======= VARIABLES: ===================================================================================================

# Debug?
my $db = 0;

# Settings:
my $Recurse = 0;  # Recurse subdirectories?   (bool)

# Counters:
my $direcount = 0;
my $filecount = 0;
my $ngrpcount = 0;
my $compcount = 0;
my $duplcount = 0;
my $delecount = 0;
my $failcount = 0;

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   process_argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   $Recurse and RecurseDirs {dedup_newsbin_files} or dedup_newsbin_files;
   print_stats;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub process_argv ()
{
   my $help   = 0;  # Just print help and exit?

   # Get and process options and arguments.
   # An "option" is "-a" where "a" is any single alphanumeric character, 
   # or "--b" where "b" is any cluster of 2-or-more printable characters.
   foreach (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         /^-h$/ || /^--help$/     and $help    = 1;
         /^-r$/ || /^--recurse$/  and $Recurse = 1;
      }
   }
   if ($help) {help_msg(); exit(777);} # If user wants help, just print help and exit.
   return 1;
} # end sub process_argv ()

sub dedup_newsbin_files ()
{
   ++$direcount;

   # Get and announce current working directory:
   my $curdir = cwd_utf8;
   say '';
   say '';
   say "Directory # $direcount:";
   say $curdir;

   # Get reference to array of references to file records for all regular files
   # in current directory:
   my $files = GetFiles($curdir, 'F');

   # Make a hash of references to arrays of references to file records,
   # with the outer hash keyed by name base:
   my %name_groups;
   foreach my $file (@{$files})
   {
      ++$filecount;
      my $name = $file->{Name};
      my $base = denumerate_file_name($name);
      push @{$name_groups{$base}}, $file;
   }

   # Iterate through each name group:
   BASE: foreach my $base (sort keys %name_groups)
   {
      ++$ngrpcount;

      # How many files are in this name-base group?
      my $count = scalar @{$name_groups{$base}};

      # If fewer than two files exist in this name group, go to next name group:
      next BASE if ($count < 2);

      # "FIRST" LOOP: Iterate through all files of current name group except the last:
      FIRST: for my $i (0..$count-2)
      {
         # Set $file1 to reference to ith file record:
         my $file1 = $name_groups{$base}->[$i];

         # Skip to next first file if ith file has already been deleted:
         next FIRST if $file1->{Name} eq "***DELETED***";

         # "SECOND" LOOP: Iterate through all files of current name group which are 
         # to the right of file "$i":
         SECOND: for my $j ($i+1..$count-1)
         {
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
            if ($identical)
            {
               # These files are duplicates, so increment $duplcount:
               ++$duplcount;

               # If file2 has the more-recent Mtime, erase file2:
               if ($file2->{Mtime} > $file1->{Mtime})
               {
                  unlink(e($file2->{Name})) # Unlink second file.
                     and say "Erased $file2->{Name}"
                     and $file2->{Name} = "***DELETED***"
                     and ++$delecount
                  or warn("Error in dnf: Failed to unlink $file2->{Name}.\n") 
                     and ++$failcount;
                  next SECOND;
               }

               # Otherwise, erase file1:
               else
               {
                  unlink(e($file1->{Name})) # Unlink first file.
                     and say "Erased $file1->{Name}"
                     and $file1->{Name} = "***DELETED***"
                     and ++$delecount
                  or warn("Error in dnf: Failed to unlink $file1->{Name}.\n")
                     and ++$failcount;
                  next FIRST;
               }#end else (erase file 1)
            }#end if ($identical)
         }#end SECOND loop
      }#end FIRST loop
   }#end BASE loop
   return 1;
}#end sub dedup_newsbin_files ()

sub print_stats ()
{
   print("\nStatistics for program \"dedup-newsbin-files.pl\":\n");
   printf("Navigated   %6d directories.\n",              $direcount);
   printf("Encountered %6d files.\n",                    $filecount);
   printf("Encountered %6d file name groups.\n",         $ngrpcount);
   printf("Compaired   %6d pairs of files.\n",           $compcount);
   printf("Found       %6d pairs of duplicate files.\n", $duplcount);
   printf("Deleted     %6d duplicate files.\n",          $delecount);
   printf("Failed      %6d file deletion attempts.\n",   $failcount);
   return 1;
} # end sub print_stats ()

sub help_msg ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
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

   Command lines:
   dedup-newsbin-files.pl [-h|--help]     (to print this help and exit)
   dedup-newsbin-files.pl [-r|--recurse]  (to erase duplicates)

   Description of options:
   Option:              Meaning:
   "-h" or "--help"     Print this help and exit.
   "-r" or "--recurse"  Recurse subdirectories.

   Description of arguments:
   This program ignores all arguments except for the two options mentioned 
   above.

   Happy duplicate file removing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help_msg ()
