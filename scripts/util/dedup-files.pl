#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8 Unicode Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# dedup-files.pl
# This program finds and unlinks duplicate files in the current directory (and all of its subdirectories if
# a -r or --recurse option is used).
#
# This program works by making a list of all files encountered in each subdirectory, ordered by size. 
# Within each size group, it compares each file to all the files to its right. For each pair of duplicate
# files it finds, it gives the user these choices:
#
# 1. Erase first file.
# 2. Erase second file.
# 3. Ignore this pair of duplicate files and move to next.
# 4. Quit.
# 5. Enter no-prompt mode and erase all newer duplicates without prompting.
#
# This program was written by Robbie Hatley, starting 2005-06-21, as a "learn Perl" exercise.
#
# Edit History:
# Tue Jun 21, 2005: Started writing it.
# Thu Nov 20, 2014: Getting back to this exercise after 9-year hiatus.
# Mon Nov 24, 2014: Got it working up to the point of alerting user as to whether each pair of same-size
#                   files are identical or different.
# Thu Dec 04, 2014: Now fully functional.
# Wed Dec 10, 2014: Found and fixed a bug which was causing some files to be flagged as duplicates even
#                   though they weren't. This was caused by not resetting the read pointer on file 1
#                   before trying to compare it to file 2. I fixed this bug by moving the open() statements
#                   to just before start of BUFFER loop, and moving the close() statements to just after end
#                   of the BUFFER loop, and adding seek($fh, 0, 0) statements to just before the BUFFER loop,
#                   to make sure the read pointers were 0.
# Sat Dec 13, 2014: Added inodes to collection of info. To-do: I need to check whether file 1 is an "alias"
#                   for file 2 (same inode).
# Fri Mar 20, 2015: I went through and tightened things up based on things I've learned recently. For one
#                   thing, I declared all of the global variables up front with "our", and got rid of the ugly
#                   "$::varname" syntax, and cleaned up messy syntax for addressing elements of file records.
# Mon Mar 23, 2015: Merged counter initializations to declarations. Added $regucount.
# Sun Apr 12, 2015: I changed the two main counters in RH::Dir to $totfcount & $regfcount, and I made local
#                   copies in this file's package, NOT aliased to the ones in RH::Dir, so that I can grab
#                   snapshots immediately after any call to a "get files" function in RH::Dir.
# Fri Apr 24, 2015: Made many changes. Added options, help, recursion, etc. Also renamed script to "ddf".
# Wed May 13, 2015: Changed Help from multiple say's littered with single and double quotes to a
#                   "Here Document" format.
# Thu Jul 09, 2015: Made corrections to ensure correct handling of incoming utf8 data from all sources.
# Fri Jul 17, 2015: Further upgraded for utf8.
# Thu Apr 14, 2016: Now using -CSDA.
# Fri Apr 15, 2016: Added no-prompt mode, and did some refactoring to cut size of over-lengthy sub
#                   "process_current_directory". Added subs "erase_newer" and "dup_prompt".
# Thu Jul 11, 2018: Now has "Spotlight" mode for deduping Windows 10 "Spotlight" photos.
# Wed Mar 11, 2020: Added sub "erase_older" for Spotlight purposes. Also changed spotlight to prefer
#                   64-character "spotlight" names over 8-character "gibberish" names. Also created sub
#                   "annotate_file" which adds a spotlight name to the name of an identical non-spotlight-name
#                   file, like so:
#                   File1 old name: Green-Pasture.jpg
#                   File2     name: 620b14e79a353f16.jpg
#                   File1 new name: Green-Pasture(620b14e79a353f16).jpg
#                   This makes it much easier to look-up files on the "windows10spotlight.com" web site.
# Sun Mar 15, 2020: Found, fixed bug causing crash in newer() / older() selection code (missing braces).
#                   Also, got rid of file "annotation", as it turns out that "windows10spotlight.com" is
#                   using SHA1 hashes rather than Windows Spotlight id strings. Also, spotlight duplicates
#                   now result in unlinking the NEWER file instead of the OLDER file.
# Wed Jul 08, 2020: Removed spurious "Unlinked file" notice in erase_newer, as it duplicates the notices
#                   from unlink_file, and it was resulting in "Unlinked file ***DELETED***" being printed.
# Sat Aug 15, 2020: Cleaned up spotlight logic, and "use v5.30;".
# Sun Jan 10, 2021: Got rid of "Settings" hash. All settings variables are now declared and initialized by
#                   "$main::VarName = DefaultValue;"
# Mon Feb 01, 2021: Widened to 120 characters. Cleaned up comments. Simplified padding of file name field.
# Thu Feb 11, 2021: Got rid of "delete both files" option. Clarified Help. Replaced multiple mode variables
#                   with "$PromptMode". Clarified comments. Now using "use experimental 'switch';".
# Fri Nov 05, 2021: Now presents per-directory stats as well as per-tree stats. In order to do this, I had to make most
#                   functions return result-code strings rather than just return 0 or 1.
# Tue Nov 16, 2021: Got rid of most of the boilerplate; now using common::sense instead. Also, now putting
#                   "double quotes" around names of files presented to user for possible unlinking.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "Sys::Binmode".
# Fri Aug 19, 2022: Clarified comments in spotlight() regarding file-name preferences.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv            ()   ;
sub print_two_files ($$) ;
sub process_curdir  ()   ;
sub dup_prompt      ($$) ;
sub spotlight       ($$) ;
sub no_prompt       ($$) ;
sub erase_newer     ($$) ;
sub erase_older     ($$) ;
sub unlink_file     ($)  ;
sub stats           ()   ;
sub help            ()   ;

# ======= VARIABLES: ===================================================================================================

# Debug?
my $db = 0; # Set this to 0 for no-debug, 1 for debug

# Settings:          # Meaning of setting:                  Possible values:
my $Recurse    = 0;  # Recurse subdirectories?              0 => Local     (don't traverse subdirs)
                     #                                      1 => Recurse   (do    traverse subdirs)
my $PromptMode = 0;  # Prompting Mode.                      0 => DupPrompt (ask user what to do)
                     #                                      1 => Spotlight (process Spotlight files)
                     #                                      2 => NoPrompt  (act without prompting user)
my $PrejudMode = 0;  # Prejudice Mode.                      0 => Newer     (prejudice against newer files)
                     #                                      1 => Older     (prejudice against older files)

# Note: The "0" value for each of the above settings is the "default" setting, which may be overridden by
# command-line options or by this program itself.

# Note regarding settings: 

# Prompting Modes:
# This program is always in 1 of 3 prompting modes: DupPrompt, Spotlight, or NoPrompt.
# DupPrompt Mode asks the user what to do before taking any action.
# Spotlight Mode takes some actions without asking, but if it has a question, it switches to DupPrompt Mode.
# NoPrompt  Mode does whatever the fuck it thinks best and doesn't ask the user a goddamn thing.

# Prejudice Modes:
# NoPrompt Mode can operate in either of 2 file-age prejudice modes: "newer" or "older".
# "newer" prejudice discriminates against newer files.
# "older" prejudice discriminates against older files.
# These prejudices don't affect Spotlight Mode or DupPrompt mode.

# SHA1 hash pattern:
my $shapat = qr(^[0-9a-f]{40}(?:-\(\d{4}\))?(?:\.\w+)?$);

# Gibberish pattern:
my $gibpat = qr(^[a-z]{8}(?:-\(\d{4}\))?(?:\.\w+)?$);

# Windows SpotLight pattern:
my $wslpat = qr(^[0-9a-f]{64}(?:-\(\d{4}\))?(?:\.\w+)?$);

# Counters:
my $direcount = 0; # Count of directories traversed.
my $regfcount = 0; # Count of regular files seen.
my $compcount = 0; # Count of comparisons of file pairs.
my $duplcount = 0; # Count of duplicate file pairs found.
my $ignocount = 0; # Count of ignored duplicate file pairs.
my $delecount = 0; # Count of deleted files.
my $failcount = 0; # Count of failed attempts at deleting files.
my $errocount = 0; # Count of errors.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   $Recurse and RecurseDirs {process_curdir} or process_curdir;
   stats;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub argv ()
{
   foreach (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if ('-h' eq $_ || '--help'      eq $_) {help;   exit 777;                  }
         elsif ('-l' eq $_ || '--local'     eq $_) {$Recurse    = 0 ;                  } # DEFAULT
         elsif ('-r' eq $_ || '--recurse'   eq $_) {$Recurse    = 1 ;                  }
         elsif ('-p' eq $_ || '--prompt'    eq $_) {$PromptMode = 0 ;                  } # DEFAULT
         elsif ('-s' eq $_ || '--spotlight' eq $_) {$PromptMode = 1 ;                  }
         elsif ('-n' eq $_ || '--newer'     eq $_) {$PromptMode = 2 ; $PrejudMode = 0 ;}
         elsif ('-o' eq $_ || '--older'     eq $_) {$PromptMode = 2 ; $PrejudMode = 1 ;}
      }
   }
   return 1;
} # end sub process_argv ()

# Print two files, with times and dates, aligned:
sub print_two_files ($$)
{
   my $file1 = shift;
   my $file2 = shift;

   # Get time and date strings for both files:
   my $time1 = time_from_mtime $file1->{Mtime};
   my $time2 = time_from_mtime $file2->{Mtime};
   my $date1 = date_from_mtime $file1->{Mtime};
   my $date2 = date_from_mtime $file2->{Mtime};

   # Set file name field width to max file name length + 2:
   my $nl1 = length($file1->{Name});             # nl1 = Name Length 1.
   my $nl2 = length($file2->{Name});             # nl2 = Name Length 2.
   my $fnw = $nl2 > $nl1 ? $nl2 + 2 : $nl1 + 2 ; # fnw = File-Name Width.

   # Print first file:
   printf
   (
      "%-${fnw}s%-18s%-10s%d bytes\n", 
      $file1->{Name}, $date1, $time1, $file1->{Size}
   );

   # Print second file:
   printf
   (
      "%-${fnw}s%-18s%-10s%d bytes\n", 
      $file2->{Name}, $date2, $time2, $file2->{Size}
   );

   # We successfully completed executing this function, so return 1:
   return 1;
} # end sub print_two_files ($$)

sub process_curdir ()
{
   # We just entered a new directory, so increment directory counter:
   ++$direcount;

   # Variables used by this function only:
   my $result    = ''; # Result of processing pair of duplicate files.
   my $regfdirec =  0; # Count of regular files processed.
   my $compdirec =  0; # Count of comparisons of file pairs.
   my $dupldirec =  0; # Count of duplicate file pairs found.
   my $ignodirec =  0; # Count of ignored duplicate file pairs.
   my $deledirec =  0; # Count of deleted files.
   my $faildirec =  0; # Count of failed attempts at deleting files.
   my $errodirec =  0; # Count of errors.

   # Get and announce current working directory:
   my $curdir = cwd_utf8;
   say "\nDir # $direcount: \"$curdir\"\n";

   # Get hash of arrays of file records for for all regular files
   # in current directory, keyed by size:
   my $curdirfiles = GetRegularFilesBySize;

   # Append regular-files count from RH::Dir:: to main:: and to local: 
   $regfcount += $RH::Dir::regfcount;
   $regfdirec += $RH::Dir::regfcount;

   # Iterate through the keys of the hash, in inverse order of size:
   my @sizes = sort {$b<=>$a} keys %{$curdirfiles};
   SIZE: foreach my $size (@sizes)
   {
      # How many files in this size group?
      my $count = scalar @{$curdirfiles->{$size}};

      # If fewer than two files exist of this size, go to next size group:
      next SIZE if ($count < 2);

      # "FIRST" LOOP: Iterate through all files of current size except last:
      FIRST: foreach my $i (0..$count-2)
      {
         # Set $file1 to reference to first file record:
         my $file1 = $curdirfiles->{$size}->[$i];

         say("FIRST file name = ", $file1->{Name}) if $db;

         # "SECOND" LOOP: Iterate through all files of current size which are 
         # to the right of file "$i":
         SECOND: foreach my $j ($i+1..$count-1)
         {
            #
            # Skip to next FIRST file if $file1 has already been deleted.
            #
            # Note: This MUST be HERE, and NOT above start of "SECOND" loop,
            # because actions taken in "SECOND" loop may CAUSE the "FIRST" file
            # to become "***DELETED***" or "***FAILED***".
            #
            # Note: Don't take any actions, return anything, or count anything
            # at this point, because we're just skipping-over the remains of
            # situations which have ALREADY been noted and acted-on.
            # Only print anything if debugging:
            #
            if ( $file1->{Name} eq '***DELETED***' )
            {
               say "FIRST file was deleted. Name = ", $file1->{Name} if $db;
               next FIRST;
            }
            if ( $file1->{Name} eq '***FAILED***' )
            {
               say "FIRST file was failed. Name = ", $file1->{Name} if $db;
               next FIRST;
            }

            # Set $file2 to reference to second file record:
            my $file2 = $curdirfiles->{$size}->[$j];

            say("SECOND file name = ", $file2->{Name}) if $db;

            #
            # Skip to next SECOND file if $file2 has already been deleted:
            #
            # Note: Don't take any actions, return anything, or count anything
            # at this point, because we're just skipping-over the remains of
            # situations which have ALREADY been noted and acted-on.
            # Only print anything if debugging:
            #
            if ( $file2->{Name} eq '***DELETED***' )
            {
               say "SECOND file was deleted. Name = ", $file2->{Name} if $db;
               next SECOND;
            }
            if ( $file2->{Name} eq '***FAILED***' )
            {
               say "SECOND file was failed. Name = ", $file2->{Name} if $db;
               next SECOND;
            }

            # If files i and j have same inode, they're just aliases for the
            # same file, so move on to next second file:
            next SECOND if $file1->{Inode} == $file2->{Inode};

            # Do files have identical content?
            my $identical = RH::Dir::FilesAreIdentical($file1->{Name}, $file2->{Name});

            # If FilesAreIdentical didn't die, we successfully compared the
            # current pair of files, so increment "$compdirec" and "$compcount":
            ++$compdirec;
            ++$compcount;

            # If we found no difference between these two files, 
            # then they're duplicates. If in no-prompt mode, erase
            # the newer file without prompting; otherwise, present 
            # options to user:
            if ($identical)
            {
               # Announce identicality:
               printf("\nThese two files are identical:\n");

               # Print info on both files, aligned:
               print_two_files($file1,$file2);

               # Warn user if files are empty:
               if (0 == $file1->{Size})
               {
                  say "Note: Files contain 0 bytes of data.";
               }

               # Increment $dupldirec and $duplcount:
               ++$dupldirec;
               ++$duplcount;

               # Call appropriate subroutine depending on value of $PromptMode:
               given ($PromptMode)
               {
                  # If in DupPrompt mode, call dup_prompt:
                  when (0)
                  {
                     $result = dup_prompt($file1, $file2);
                  }
                  # If in Spotlight mode, call spotlight:
                  when (1)
                  {
                     $result = spotlight($file1, $file2);
                  }

                  # If in NoPrompt mode, call no_prompt:
                  when (2)
                  {
                     $result = no_prompt($file1, $file2);
                  }

                  # Otherwise, we're in an unknown mode:
                  default
                  {
                     say "Error in \"dedup-files.pl\": unknown mode $PromptMode";
                     $result = "error";
                  }
               } # end given ($PromptMode)

               # We just finished processing a pair of identical files.
               # The result of that was "ignored", "deleted", "failed", "error", or "exit".
               # Increment counters (and maybe exit program) accordingly:
               given ($result)
               {
                  when ('ignored')
                  {
                     ++$ignodirec;
                     ++$ignocount;
                  }
                  when ('deleted')
                  {
                     ++$deledirec;
                     ++$delecount;
                  }
                  when ('failed')
                  {
                     ++$faildirec;
                     ++$failcount;
                  }
                  when ('error')
                  {
                     ++$errodirec;
                     ++$errocount;
                  }
                  when ('exit')
                  {
                     stats;
                     exit 0;
                  }
               } # end given (result of processing pair of duplicate files)
            } # end if identical
            else # if not identical
            {
               say("\nThese two files are same-size but different:");
               print_two_files($file1,$file2);
            } # end if not identical
         } # end SECOND file loop
      } # end FIRST file loop
   } # end SIZE group loop

   if ($db)
   {
      # Did we ACTUALLY mark any files as being deleted or failed?
      foreach my $size (sort {$b<=>$a} keys %{$curdirfiles})
      {
         # Say the names of all of the files in this size group:
         say '';
         say "Files of size $size:";
         say $_->{Name} for (@{$curdirfiles->{$size}});
      }
      say '';
   }

   say '';
   say 'Statistics for this directory:';
   printf("Processed %6d files.\n",                    $regfdirec);
   printf("Compared  %6d pairs of files.\n",           $compdirec);
   printf("Found     %6d pairs of duplicate files.\n", $dupldirec);
   printf("Ignored   %6d pairs of duplicate files.\n", $ignodirec);
   printf("Deleted   %6d files.\n",                    $deledirec);
   printf("Failed    %6d file deletion attempts.\n",   $faildirec);
   printf("Suffered  %6d errors.\n",                   $errodirec);

   # We successfully completed executing this function, so return 1:
   return 1;
} # end sub process_curdir ()

# Mode 0 (DupPrompt):
sub dup_prompt ($$)
{
   my ($file1, $file2) = @_;
   my $char = '\x{00}';

   # Get a keystroke from user:
   while (42)
   {
      # Ask user what to do:
      print("Type 1 to unlink \"$file1->{Name}\"\n");
      print("Type 2 to unlink \"$file2->{Name}\"\n");
      print("Type 3 to ignore these duplicates\n");
      print("Type 4 to enter no-prompt mode and unlink all newer duplicates\n");
      print("Type 5 to enter no-prompt mode and unlink all older duplicates\n");
      print("Type 6 to end program and return to bash\n");
      $char = RH::Util::get_character;
      given ($char)
      {
         when ('1') # DELETE FIRST FILE
         {
            return unlink_file($file1); # Unlink first file.
         }

         when ('2') # DELETE SECOND FILE
         {
            return unlink_file($file2); # Unlink second file.
         }

         when ('3') # IGNORE THIS PAIR OF DUPLICATES
         {
            say "Ignoring these duplicates.";
            return 'ignored';
         }

         when ('4') # ERASE ALL NEWER DUPLICATES WITHOUT PROMPTING
         {
            say "Entering no-prompt mode and erasing all newer duplicates.";
            $PromptMode = 2;
            $PrejudMode = 0;
            return erase_newer ($file1, $file2);
         }

         when ('5') # ERASE ALL OLDER DUPLICATES WITHOUT PROMPTING
         {
            say "Entering no-prompt mode and erasing all older duplicates.";
            $PromptMode = 2;
            $PrejudMode = 1;
            return erase_older ($file1, $file2);
         }

         when ('6') # COMPUTER, END PROGRAM
         {
            say "Ending program, by your command.";
            return 'exit';
         }

         when (undef)
         {
            say "Error in \"dedup-files.pl\":\n"
              . "get_character returned undef.\n"
              . "$!\n"
              . "Continuing execution, but if this keeps happening,\n"
              . "consider aborting the program using Ctrl-C.";
            return 'error';
         }

         default
         {
            say "Invalid key.";
            # NOTE: Don't return here; that way execution continues at top of while() loop.
         }
      } # end given ($char)
   } # end while (42) {get keystroke from user}
} # end sub dup_prompt ($$) (MODE 0)

# Mode 1 (Spotlight):
sub spotlight ($$)
{
   my ($file1, $file2) = @_;

   # Prefered order of names for Windows 10 Spotlight scenic photographs is
   # 1. Descriptive names
   # 2. SHA1-hash names (40 hexadecimal digits)
   # 3. Gibberish names (8 lower-case letters)
   # 4. Windows-Spotlight names (64 hexadecimal digits)
   # So, we attempt to get rid of the least-desirable types of file names first,
   # then the next-least-desirable,
   # then the next-next-least-desirable,
   # and if all else fails, ask user what to do:
   
   # WSL + NON-WSL:
   if ($file1->{Name} =~ $wslpat && $file2->{Name} !~ $wslpat)
   {
      return unlink_file($file1); # Unlink first file.
   }

   # NON-WSL + WSL:
   elsif ($file1->{Name} !~ $wslpat && $file2->{Name} =~ $wslpat)
   {
      return unlink_file($file2); # Unlink second file.
   }

   # GIB + NON-GIB:
   elsif ($file1->{Name} =~ $gibpat && $file2->{Name} !~ $gibpat)
   {
      return unlink_file($file1); # Unlink first file.
   }

   # NON-GIB + GIB:
   elsif ($file1->{Name} !~ $gibpat && $file2->{Name} =~ $gibpat)
   {
      return unlink_file($file2); # Unlink second file.
   }

   # SHA + NON-SHA:
   elsif ($file1->{Name} =~ $shapat && $file2->{Name} !~ $shapat)
   {
      return unlink_file($file1); # Unlink first file.
   }

   # NON-SHA + SHA:
   elsif ($file1->{Name} !~ $shapat && $file2->{Name} =~ $shapat)
   {
      return unlink_file($file2); # Unlink second file.
   }

   # OTHER + OTHER:
   else
   {
      say 'Neither file has a gib, wsl, or sha1 name, so entering user-intervention mode.';
      return dup_prompt($file1, $file2);
   }
} # end sub spotlight ($$) (MODE 1)

# Mode 2 (NoPrompt):
sub no_prompt ($$)
{
   my ($file1, $file2) = @_;
   if ( 1 == $PrejudMode )
   {
      return erase_older($file1, $file2);
   }
   else
   {
      return erase_newer($file1, $file2);
   }
} # end sub no_prompt ($$) (MODE 2)

# Erase newer file:
sub erase_newer ($$)
{
   my ($file1, $file2) = @_;
   if ($file1->{Mtime} > $file2->{Mtime})
   {
      return unlink_file($file1); # Unlink first file.
   }
   else
   {
      return unlink_file($file2); # Unlink second file.
   }
} # end sub erase_newer ($$)

# Erase older file:
sub erase_older ($$)
{
   my ($file1, $file2) = @_;
   if ($file1->{Mtime} < $file2->{Mtime})
   {
      return unlink_file($file1); # Unlink first file.
   }
   else
   {
      return unlink_file($file2); # Unlink second file.
   }
} # end sub erase_older ($$)

# Unlink (erase) a file:
sub unlink_file ($)
{
   my $file = shift;
   my $success = unlink e $file->{Name};
   if ( $success )
   {
      say "Successfully unlinked $file->{Name}";
      $file->{Name} = "***DELETED***";
      return 'deleted';
   }
   else
   {
      warn("Failed to unlink $file->{Name}\n$!\n");
      $file->{Name} = "***FAILED***";
      return 'failed';
   }
} # end sub unlink_file ($)

sub stats ()
{
   say '';
   say 'Statistics for this tree:';
   printf("Navigated %6d directories.\n",              $direcount);
   printf("Processed %6d files.\n",                    $regfcount);
   printf("Compared  %6d pairs of files.\n",           $compcount);
   printf("Found     %6d pairs of duplicate files.\n", $duplcount);
   printf("Ignored   %6d pairs of duplicate files.\n", $ignocount);
   printf("Deleted   %6d duplicate files.\n",          $delecount);
   printf("Failed    %6d file deletion attempts.\n",   $failcount);
   printf("Suffered  %6d errors.\n",                   $errocount);

   # We successfully completed executing this function, so return 1:
   return 1;
} # end sub stats ()

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to dedup-files, Robbie Hatley's nifty duplicate-file
   finding and removing program.

   Command line:
   dedup-files.pl [options]

   Description of options:

   Option:               Meaning:
   "-h" or "--help"      Print help and exit.
   "-l" or "--local"     Don't traverse subdirectories.               (DEFAULT)
   "-r" or "--recurse"   Traverse subdirectories.
   "-p" or "--prompt"    Enter DupPrompt mode (ask user what to do).  (DEFAULT)
   "-s" or "--spotlight" Enter Spotlight mode (erase gibberish names).
   "-n" or "--newer"     Enter NoPrompt  mode (don't prompt user)
                         and be prejudiced against newer duplicates.
   "-o" or "--older"     Enter NoPrompt  mode (don't prompt user)
                         and be prejudiced against older duplicates.

   All other options are ignored. If contradictory options are given, 
   the right-most prevails (eg, "-n -o" is the same as "-o").

   All non-option arguments are ignored.

   By default, dedup-files is in "DupPrompt" (interactive) mode and does not
   automatically unlink any file without first asking you what to do.
   Using a "-p" or "--prompt" option explicitly sets this mode, but this
   is normally unnecessary, except for contradicing modes set to-the-left on the
   command line.(In case of contradiction between two options, the further-right
   prevails.)

   In interactive mode, for each pair of duplicates files found, dedup-files
   gives you these 6 choices:

   1. Unlink first  file.
   2. Unlink second file.
   3. Ignore this pair of duplicate files and move on to next.
   4. Enter no-prompt mode and unlink all newer duplicates.
   5. Enter no-prompt mode and unlink all older duplicates.
   6. End program and return to BASH.

   So, using dedup-files you can trim duplicates from your file collection with 
   surgical precision, if that's what you want to do. (Or, you can bludgeon them
   to death with a fucking sledgehammer if THAT'S what you want to do. Read on.)

   If you use a "-s" or "--spotlight" option, dedup-files goes into "Spotlight"
   mode and automatically unlinks duplicate files in cases where one of a pair
   of duplicate files has a name which is clearly less-preferred than the other.
   WSL names are preffered over GIB names; SHA names are preffered over WSL
   names; and descriptive names are prefered over SHA1 names. If dedup-files
   can't figure out what to do while in Spotlight mode, it switches to DupPrompt
   mode and asks you what to do.

   if you use a "-n", or "--newer" option, dedup-files will erase all newer
   duplicate files in the current directory (and all subdirectories as well
   if a "-r" or "--recurse" option was also used) without prompting. So be 
   careful, because if you say "dedup-files.pl -r -n", this program may erase 
   a large number of files without stopping to ask for your permission. If that's
   not what you want to do, it's better to run dedup-files in interactive mode.

   if you use a "-o", or "--older" option, dedup-files will erase all older
   duplicate files in the current directory (and all subdirectories as well
   if a "-r" or "--recurse" option was also used) without prompting. So be 
   careful, because if you say "dedup-files.pl -r -o", this program may erase 
   a large number of files without stopping to ask for your permission. If that's
   not what you want to do, it's better to run dedup-files in interactive mode.

   Happy duplicate file removing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP

   # We successfully completed executing this function, so return 1:
   return 1;
} # end sub help ()
