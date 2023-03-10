#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# canoperm.pl
# Canonicalizes permissions in current directory tree.
# Written by Robbie Hatley.
# Edit history:
# Sun Mar 05, 2023: Wrote it.
########################################################################################################################

use v5.36;
use strict;
use warnings;

use Sys::Binmode;
use Time::HiRes 'time';

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    :prototype()  ; # Process @ARGV.
sub curdire :prototype()  ; # Process current directory.
sub curfile :prototype($) ; # Process current file.
sub stats   :prototype()  ; # Print statistics.
sub error   :prototype($) ; # Handle errors.
sub help    :prototype()  ; # Print help and exit.

# ======= VARIABLES: ===================================================================================================

# Settings:                    Meaning:                     Range:    Default:
my $db        = 0          ; # Debug (print diagnostics)?   bool      0 (don't print diagnostics)
my $Verbose   = 0          ; # Be wordy?                    bool      0 (don't be verbose)
my $Recurse   = 1          ; # Recurse subdirectories?      bool      1 (recurse)
my $Target    = 'A'        ; # Files, dirs, both, all?      F|D|B|A   A (process all directory entries)
my $RegExp    = qr/^.+$/o  ; # Regular Expression.          regexp    qr/^.+$/o (matches all strings)

# Counters:
my $direcount = 0          ; # Count of directories processed by curdire().
my $filecount = 0          ; # Count of dir entries processed by curfile().

# Accumulations of counters from RH::Dir::GetFiles():
my $totfcount = 0          ; # Count of all targeted directory entries matching regexp and verified by GetFiles().
my $noexcount = 0          ; # Count of all nonexistent files encountered. 
my $ottycount = 0          ; # Count of all tty files.
my $cspccount = 0          ; # Count of all character special files.
my $bspccount = 0          ; # Count of all block special files.
my $sockcount = 0          ; # Count of all sockets.
my $pipecount = 0          ; # Count of all pipes.
my $slkdcount = 0          ; # Count of all symbolic links to directories.
my $linkcount = 0          ; # Count of all symbolic links to non-directories.
my $multcount = 0          ; # Count of all directories with multiple hard links.
my $sdircount = 0          ; # Count of all directories.
my $hlnkcount = 0          ; # Count of all regular files with multiple hard links.
my $regfcount = 0          ; # Count of all regular files.
my $unkncount = 0          ; # Count of all unknown files.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   say "Target  = $Target";
   say "RegExp  = $RegExp";
   say "Recurse = $Recurse";
   say "Verbose = $Verbose";
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

# Process @ARGV :
sub argv :prototype()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL]{1,}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if ( $_ eq '-h' || $_ eq '--help'         ) {help; exit 777;}

         elsif ( $_ eq '-l' || $_ eq '--local'        ) {$Recurse =  0 ;}
         elsif ( $_ eq '-r' || $_ eq '--recurse'      ) {$Recurse =  1 ;} # Default

         elsif ( $_ eq '-f' || $_ eq '--target=files' ) {$Target  = 'F';}
         elsif ( $_ eq '-d' || $_ eq '--target=dirs'  ) {$Target  = 'D';}
         elsif ( $_ eq '-b' || $_ eq '--target=both'  ) {$Target  = 'B';}
         elsif ( $_ eq '-a' || $_ eq '--target=all'   ) {$Target  = 'A';} # Default.

         elsif ( $_ eq '-q' || $_ eq '--quiet'        ) {$Verbose =  0 ;} # Default
         elsif ( $_ eq '-v' || $_ eq '--verbose'      ) {$Verbose =  1 ;}

         elsif ( $_ eq '-y' || $_ eq '--debug=yes'    ) {$db      =  1 ;}
         elsif ( $_ eq '-n' || $_ eq '--debug=no'     ) {$db      =  0 ;} # Default

         # Remove option from @ARGV:
         splice @ARGV, $i, 1;

         # Move the index 1-left, so that the "++$i" above moves the index back to the current @ARGV element,
         # but with the new content which slid-in from the right due to deletion of previous element contents:
         --$i;
      }
   }
   my $NA = scalar(@ARGV);
   if    ( 0 == $NA ) {                          } # Do nothing.
   elsif ( 1 == $NA ) {$RegExp = qr/$ARGV[0]/o   } # Set $RegExp.
   else               {error($NA); help; exit 666} # Print error and help messages then exit 666.
   return 1;
} # end sub argv :prototype()

# Process current directory:
sub curdire :prototype()
{
   # Increment directory counter:
   ++$direcount;

   # Get and announce current working directory:
   my $cwd = cwd_utf8;
   say "\nDirectory # $direcount: $cwd\n";

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, $Target, $RegExp);

   # If being verbose, also accumulate all counters from RH::Dir:: to main:
   if ($Verbose)
   {
      $totfcount += $RH::Dir::totfcount; # all directory entries found
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
   }

   # Iterate through $curdirfiles and send each file to curfile():
   foreach my $file (@{$curdirfiles})
   {
      curfile($file);
   }
   return 1;
} # end sub curdire :prototype()

# Process current file:
sub curfile :prototype($)
{
   # Increment file counter:
   ++$filecount;

   # Get file and path:
   my $file   = shift;
   my $path   = $file->{Path};

   # Announce path:
   say $path;

   # We're done, so scram:
   return 1;
} # end sub curfile :prototype($)

# Print statistics for this program run:
sub stats :prototype()
{
   say '';
   say 'Statistics for this directory tree:';
   say "Target  = $Target";
   say "RegExp  = $RegExp";
   say "Navigated $direcount directories.";
   say "Found $filecount paths matching given target and regexp.";

   if ($Verbose)
   {
      say '';
      say 'Directory entries encountered in this tree included:';
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
} # end sub stats :prototype()

# Handle errors:
sub error :prototype($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $NA arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which directory entries to process. Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end sub error ($)

# Print help:
sub help :prototype()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "canoperm.pl". This program canonicalizes the permissions of
   all directories and files in the current directory tree. Directory permissions
   are set to "drwxrwxr-x", things which should be executable are set to
   "-rwxrwxr-x", and everything else is set to "-rw-rw-r--".

   Command lines:
   canoperm.pl -h | --help            (to print this help and exit)
   canoperm.pl [options] [arguments]  (to canonicalize permissions)

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.

   "-l" or "--local"            Don't recurse subdirectories.
   "-r" or "--recurse"          Recurse subdirectories (but not links). (Default.)

   "-f" or "--target=files"     Target files only.
   "-d" or "--target=dirs"      Target directories only.
   "-b" or "--target=both"      Target both files and directories.
   "-a" or "--target=all"       Target all files, directory entries.    (Default.)

   "-q" or "--quiet"            Be quiet.                               (Default.)
   "-v" or "--verbose"          Print lots of extra statistics.

   "-n" or "--debug=no"         Don't print diagnostics.                (Default.)
   "-y" or "--debug=yes"        Do    print diagnostics.

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

   Happy directory tree permissions canonicalizing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help :prototype()
