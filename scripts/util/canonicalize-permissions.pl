#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# canonicalize-permissions.pl
# Canonicalizes permissions in current directory tree.
# Written by Robbie Hatley.
# Edit history:
# Sun Mar 05, 2023: Wrote stub. (NOT YET FUNCTIONAL.)
# Thu Aug 04, 2023: Reduced width from 120 to 100. Got rid of all prototypes (using signatures instead).
#                   Got rid of cwd_utf8 (using "d getcwd" instead). Got rid of file-type counters.
#                   Got rid of "--debug=no", "--local", "--quiet" (already defaults).
#                   Changed "--debug=yes" to just "--debug". Now using "my $pname = get_name_from_path($0);".
#                   Elapsed time is now in milliseconds.
# Wed Aug 09, 2023: Dramatically symplified permission-setting. Created new subs "dir_nav", "set_exec", and
#                   "set_noex". Added several new suffixes. Now handles makefiles (noex).
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";

use Sys::Binmode;
use Cwd;
use Time::HiRes 'time';

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ; # Process @ARGV.
sub curdire ; # Process current directory.
sub curfile ; # Process current file.
sub stats   ; # Print statistics.
sub error   ; # Handle errors.
sub help    ; # Print help and exit.

# ======= VARIABLES: =========================================================================================

# Settings:     Default:       Meaning of setting:          Range:    Meaning of default:
my $db        = 0          ; # Debug (print diagnostics)?   bool      Don't print diagnostics.
my $Recurse   = 0          ; # Recurse subdirectories?      bool      Don't recurse.
my $Target    = 'F'        ; # Files, dirs, both, all?      F|D|B|A   Process regular files only.
my $RegExp    = qr/^.+$/o  ; # Regular Expression.          regexp    Process all file names.

# Counters:
my $direcount = 0          ; # Count of directories processed by curdire().
my $filecount = 0          ; # Count of dir entries processed by curfile().
my $opencount = 0          ; # Count of all regular files we could    open.
my $noopcount = 0          ; # Count of all regular files we couldn't open.
my $readcount = 0          ; # Count of all regular files we could    read.
my $nordcount = 0          ; # Count of all regular files we couldn't read.
my $permcount = 0          ; # Count of all permissions set.

# ======= MAIN BODY OF PROGRAM: ==============================================================================
{ # begin main
   my $t0 = time;
   my $pname = get_name_from_path($0);
   argv;
   say STDERR "\nNow entering program \"$pname\".";
   say STDERR "Target  = $Target";
   say STDERR "RegExp  = $RegExp";
   say STDERR "Recurse = $Recurse";
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $ms = 1000 * (time - $t0);
   printf STDERR "\nNow exiting program \"%s\". Execution time was %.3fms.", $pname, $ms;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV :
sub argv {
   # Get options and arguments:
   my @opts;
   my @args;
   for ( @ARGV ) {
      if (/^-\pL*$|^--.*$/) {push @opts, $_}
      else                  {push @args, $_}
   }

   # Process options:
   for ( @opts ) {
      /^-\pL*h|^--help$/     and help and exit 777 ;
      /^-\pL*e|^--debug$/    and $db      =  1     ;
      /^-\pL*l|^--local$/    and $Recurse =  0     ;
      /^-\pL*r|^--recurse$/  and $Recurse =  1     ; # DEFAULT
      /^-\pL*f|^--files$/    and $Target  = 'F'    ;
      /^-\pL*d|^--dirs$/     and $Target  = 'D'    ;
      /^-\pL*b|^--both$/     and $Target  = 'B'    ;
      /^-\pL*a|^--all$/      and $Target  = 'A'    ; # DEFAULT
   }

   # Process arguments:
   my $NA = scalar(@args);
   if    ( 0 == $NA ) {                                  } # Use default settings.
   elsif ( 1 == $NA ) { $RegExp = qr/$args[0]/o          } # Set $RegExp.
   else               { error($NA) and help and exit 666 } # Something evil happened.

   # Return success code 1 to caller:
   return 1;
} # end sub argv

# Process current directory:
sub curdire {
   # Increment directory counter:
   ++$direcount;

   # Get and announce current working directory:
   my $cwd = d getcwd;
   say "\nDirectory # $direcount: $cwd\n";

   # Get list of file-info packets in $cwd matching $Target and $RegExp:
   my $curdirfiles = GetFiles($cwd, $Target, $RegExp);

   # Iterate through $curdirfiles and send each file to curfile():
   foreach my $file (@{$curdirfiles})
   {
      curfile($file);
   }
   return 1;
} # end sub curdire

# Set a directory to "navigable":
sub dir_nav ($file) {
   chmod 0775, e($file->{Path});
   say "Set directory \"$file->{Name}\" to navigable.";
   ++$permcount;
}

# Set a file to "executable":
sub set_exec ($file) {
   chmod 0775, e($file->{Path});
   say "Set file \"$file->{Name}\" to executable.";
   ++$permcount;
}

# Set a file to "not executable":
sub set_noex ($file) {
   chmod 0664, e($file->{Path});
   say "Set file \"$file->{Name}\" to NOT-executable.";
   ++$permcount;
}

# Process current file:
sub curfile ($file) {
   # Increment file counter:
   ++$filecount;

   if    ( 'D' eq $file->{Type} ) { # Directories need to be navigable.
      dir_nav($file);
   }
   elsif ( 'F' eq $file->{Type} ) { # Regular files, however, are a mixed bag.
      my $suf = get_suffix($file->{Name});
      if ( 0 != length $suf ) { # File name DOES have a suffix.
         my $lsuf = lc substr $suf, 1;
         for ( $lsuf ) {

            # Scripts in in known languages DO need to be executable:
            /^(apl|awk|pl|perl|py|raku|sed|sh)$/ and set_exec($file);

            # Source, header, library, and module files DON'T need to be executable:
            /^(c|cpp|cppism|h|hpp|cppismh|a|pm)$/ and set_noex($file);

            # Document files DON'T need to be executable:
            /^(chm|doc|epub|txt|pdf|htm|html|doc|odt|ods|ion|eml|log)$/ and set_noex($file);

            # Picture files DON'T need to be executable:
            /^(jpg|jpeg|tif|tiff|bmp|gif|png|xcf)$/ and set_noex($file);

            # Archive files DON'T need to be executable:
            /^(zip|rar|tar|tgz|bmp|gif|png|xcf)$/ and set_noex($file);

            # Sound files DON'T need to be executable:
            /^(mp3|ogg|flac|wav)$/ and set_noex($file);

            # Video files DON'T need to be executable:
            /^(mpg|mpeg|mp4|mov|avi|flv)$/ and set_noex($file);
         }
      } # end if (suffix)

      # Make files DON'T need to be executable:
      elsif ( (lc $file->{Name}) =~ m/^make(file|tail)$/ ) {
         set_noex($file);
      } # end elsif (make file)

      # If we couldn't make a decision regarding the permissions of this file based on its name,
      # resort to opening the file and looking at the first 4 bytes of its contents:
      else { # File name DOESN'T have a suffix.
         my $fh;
         my $buffer;
         if ( open $fh, "< :raw", e $file->{Path} ) {
            # We WERE able to open this file:
            ++$opencount;
            if ( read($fh, $buffer, 4) && 4 == length($buffer) ) {
               # We WERE able to read this file:
               ++$readcount;

               # Shebang scripts DO need to be executable:
               '#!' eq substr($buffer, 0, 2) and set_exec($file);

               # Linux "ELF" ("Executable & Linkable Format") programs DO need to be executable:
               "\x{7F}ELF" eq substr($buffer, 0, 4) and set_exec($file);

            } # end could read
            else {
               # We WEREN'T able to read this file:
               ++$nordcount;
            } # end couldn't read
            close($fh);
         } # end could open
         else {
            # We WEREN'T able to open this file:
            ++$noopcount;
         } # end couldn't open
      } # end else (no suffix)
   } # end regular file

   # For things OTHER THAN regular files and directories, do nothing:
   else {
      ; # Do nothing.
   } # end else (neither dir nor file)

   # Return success code 1 to caller:
   return 1;
} # end sub curfile ($file)

# Print statistics for this program run:
sub stats {
   say STDERR "\nStatistics for this directory tree:";
   say STDERR "Navigated $direcount directories.";
   say STDERR "Processed $filecount directory entries.";
   say STDERR "Was able to open $opencount regular files with unknown or missing file-name extensions.";
   say STDERR "Failed $noopcount file-open attempts.";
   say STDERR "Was able to read $readcount regular files with unknown or missing file-name extensions.";
   say STDERR "Failed $nordcount file-read attempts.";
   say STDERR "Set $permcount permissions.";
   return 1;
} # end sub stats

# Handle errors:
sub error ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $NA arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which directory entries to process. Help follows:
   END_OF_ERROR
} # end sub error

# Print help:
sub help
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "canononicalize-permissions.pl". This program canonicalizes the
   permissions of directory entries. Permissions for directories are set to
   "rwxrwxr-x"; things which should be executable are set to "rwxrwxr-x";
   text, pictures, sounds, and videos are set to "-rw-rw-r--"; and everything else
   (links, sockets, etc) is left unaltered.

   By default, this program acts on regular files only and in the current working
   directory only, but this can be altered (see "Description of Option" below).

   -------------------------------------------------------------------------------
   Command Lines:

   canoperm.pl -h | --help            (to print this help and exit)
   canoperm.pl [options] [arguments]  (to canonicalize permissions)

   -------------------------------------------------------------------------------
   Description of Options:

   Option:           Meaning:
   -h or --help      Print help and exit.
   -e or --debug     Print diagnostics.
   -l or --local     DON'T recurse subdirectories (but not links).  (DEFAULT)
   -r or --recurse   DO    recurse subdirectories (but not links).
   -f or --files     Target files only.                             (DEFAULT)
   -d or --dirs      Target directories only.
   -b or --both      Target both files and directories.
   -a or --all       Target all directory entries.
   Multiple single-letter options can be piled-up after a single hyphen.
   For example, use "-ar" to process ALL entires in ALL subdirectories.

   -------------------------------------------------------------------------------
   Description of arguments:
   In addition to options, this program can take one optional argument which, if
   present, must be a Perl-Compliant Regular Expression specifying which items to
   process. To specify multiple patterns, use the | alternation operator.
   To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to process items with names containing "cat",
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
} # end sub help
