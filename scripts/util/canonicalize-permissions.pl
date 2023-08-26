#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# canonicalize-permissions.pl
# Canonicalizes permissions of directory entries, except for hidden files & directories.
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
# Fri Aug 25, 2023: Added "quiet" and "verbose" options to control output. Added "nodebug" option.
#                   Fixed bug in which all image files were having their perms set TWICE.
#                   Added stipulation that this program does not process hidden files.
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

sub argv     ; # Process @ARGV.
sub curdire  ; # Process current directory.
sub dir_nav  ; # Set a directory to "navigable".
sub set_exec ; # Set a file to "executable".
sub set_noex ; # Set a file to "NOT executable".
sub curfile  ; # Process current file.
sub stats    ; # Print statistics.
sub error    ; # Handle errors.
sub help     ; # Print help and exit.

# ======= VARIABLES: =========================================================================================

# Settings:     Default:       Meaning of setting:          Range:    Meaning of default:
my $Db        = 0          ; # Print diagnostics?           bool      Don't print diagnostics.
my $Verbose   = 0          ; # Print stats?                 bool      Don't print stats.
my $Recurse   = 0          ; # Recurse subdirectories?      bool      Don't recurse.
my $RegExp    = qr/^.+$/o  ; # Regular Expression.          regexp    Process all file names.
my $Target    = 'F'        ; # Files, dirs, both, all?      F|D|B|A   Process regular files only.
my $Predicate = 1          ; # Boolean predicate.           bool      Process files of all types.

# Counters:
my $direcount = 0          ; # Count of directories processed by curdire().
my $filecount = 0          ; # Count of dir entries matching $RegExp and $Target
my $findcount = 0          ; # Count of dir entries also matching $Predicate.
my $hidncount = 0          ; # Count of all hidden entries encountered.
my $opencount = 0          ; # Count of all regular files we could    open.
my $noopcount = 0          ; # Count of all regular files we couldn't open.
my $readcount = 0          ; # Count of all regular files we could    read.
my $nordcount = 0          ; # Count of all regular files we couldn't read.
my $permcount = 0          ; # Count of all permissions set.

# ======= MAIN BODY OF PROGRAM: ==============================================================================
{ # begin main
   my $t0 = time;
   argv;
   my $pname = get_name_from_path($0);
   if ( $Db || $Verbose >= 1 ) {
      say    STDERR '';
      say    STDERR "Now entering program \"$pname\".   ";
      say    STDERR "\$Db        = $Db                  ";
      say    STDERR "\$Verbose   = $Verbose             ";
      say    STDERR "\$Recurse   = $Recurse             ";
      say    STDERR "\$RegExp    = $RegExp              ";
      say    STDERR "\$Target    = $Target              ";
      say    STDERR "\$Predicate = $Predicate           ";
   }

   $Recurse and RecurseDirs {curdire} or curdire;

   stats;
   my $et = time - $t0;
   if ( $Db || $Verbose >= 1 ) {
      say    STDERR '';
      say    STDERR "Now exiting program \"$pname\".";
      printf STDERR "Execution time was %.3f seconds.", $et;
   }
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV :
sub argv {
   # Get options and arguments:
   my @opts = ()            ; # options
   my @args = ()            ; # arguments
   my $end = 0              ; # end-of-options flag
   my $s = '[a-zA-Z0-9]'    ; # single-hyphen allowable chars (English letters, numbers)
   my $d = '[a-zA-Z0-9=.-]' ; # double-hyphen allowable chars (English letters, numbers, equal, dot, hyphen)
   for ( @ARGV ) {
      /^--$/                  # "--" = end-of-options marker = construe all further CL items as arguments,
      and $end = 1            # so if we see that, then set the "end-of-options" flag
      and next;               # and skip to next element of @ARGV.
      !$end                   # If we haven't yet reached end-of-options,
      && ( /^-(?!-)$s+$/      # and if we get a valid short option
      ||   /^--(?!-)$d+$/ )   # or a valid long option,
      and push @opts, $_      # then push item to @opts
      or  push @args, $_;     # else push item to @args.
   }

   # Process options:
   for ( @opts ) {
      /^-$s*h/ || /^--help$/    and help and exit 777 ;
      /^-$s*n/ || /^--nodebug$/ and $Db      =  0     ;
      /^-$s*e/ || /^--debug$/   and $Db      =  1     ;
      /^-$s*q/ || /^--quiet$/   and $Verbose =  0     ;
      /^-$s*v/ || /^--verbose$/ and $Verbose =  1     ;
      /^-$s*l/ || /^--local$/   and $Recurse =  0     ;
      /^-$s*r/ || /^--recurse$/ and $Recurse =  1     ;
      /^-$s*f/ || /^--files$/   and $Target  = 'F'    ;
      /^-$s*d/ || /^--dirs$/    and $Target  = 'D'    ;
      /^-$s*b/ || /^--both$/    and $Target  = 'B'    ;
      /^-$s*a/ || /^--all$/     and $Target  = 'A'    ;
   }
   if ( $Db ) {
      say STDERR '';
      say STDERR "\$opts = (", join(', ', map {"\"$_\""} @opts), ')';
      say STDERR "\$args = (", join(', ', map {"\"$_\""} @args), ')';
   }

   # Process arguments:
   my $NA = scalar(@args);
   $NA >= 1 and $RegExp = qr/$args[0]/;                   # Set $RegExp.
   $NA >= 2 and $Predicate = $args[1];                    # Set $Predicate.
   $NA >= 3 && !$Db and error($NA) and help and exit 666; # Wrong number of arguments.

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

   # Send each file that matches $RegExp, $Target, and $Predicate to curfile():
   foreach my $file (@$curdirfiles) {
      ++$filecount;
      local $_ = e $file->{Path};
      if (eval($Predicate)) {
         ++$findcount;
         curfile($file);
      }
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
   # If this file is hidden, just return:
   if ( '.' eq substr($file->{Name}, 0, 1) ) {
      ++$hidncount;
      return;
   }

   # If we get to here, this file is NOT hidden, so process it normally.

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
            /^(zip|rar|tar|tgz)$/ and set_noex($file);

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
   if ( $Db || $Verbose >= 1 ) {
      say STDERR '';
      say STDERR "Statistics for this directory tree:";
      say STDERR "Navigated $direcount directories.";
      say STDERR "Processed $filecount directory entries matching regexp and target.";
      say STDERR "Found $findcount directory entries also matching predicate.";
      say STDERR "Skipped $hidncount hidden directory entries.";
      say STDERR "Was able to open $opencount regular files with unknown or missing file-name extensions.";
      say STDERR "Failed $noopcount file-open attempts.";
      say STDERR "Was able to read $readcount regular files with unknown or missing file-name extensions.";
      say STDERR "Failed $nordcount file-read attempts.";
      say STDERR "Set $permcount permissions.";
   }
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
   permissions of non-hidden directory entries. Permissions for directories are
   set to "rwxrwxr-x"; things which should be executable are set to "rwxrwxr-x";
   text, pictures, sounds, and videos are set to "-rw-rw-r--"; and everything else
   (links, sockets, hidden files, etc) is left unaltered.

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
   -n or --nodebug   DON'T print diagnostics.                       (DEFAULT)
   -e or --debug     DO    print diagnostics.
   -q or --quiet     DON'T print stats.                             (DEFAULT)
   -v or --verbose   DO    print stats.
   -l or --local     DON'T recurse subdirectories (but not links).  (DEFAULT)
   -r or --recurse   DO    recurse subdirectories (but not links).
   -f or --files     Target files only.                             (DEFAULT)
   -d or --dirs      Target directories only.
   -b or --both      Target both files and directories.
   -a or --all       Target all directory entries.
   Multiple single-letter options can be piled-up after a single hyphen.
   For example, use "-arv" to verbosely process all entries in all subdirectories.

   -------------------------------------------------------------------------------
   Description of arguments:

   In addition to options, this program can take 1 or 2 optional arguments.

   Arg1 (OPTIONAL), if present, must be a Perl-Compliant Regular Expression
   specifying which file names to process. To specify multiple patterns, use the
   | alternation operator. To apply pattern modifier letters, use an Extended
   RegExp Sequence. For example, if you want to process items with names
   containing "cat", "dog", or "horse", title-cased or not, you could use this
   regexp: '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   Arg2 (OPTIONAL), if present, must be a boolean expression using Perl
   file-test operators. The expression must be enclosed in parentheses (else
   this program will confuse your file-test operators for options), and then
   enclosed in single quotes (else the shell won't pass your expression to this
   program intact). Here are some examples of valid and invalid second arguments:

   '(-d && -l)'  # VALID:   Finds symbolic links to directories
   '(-l && !-d)' # VALID:   Finds symbolic links to non-directories
   '(-b)'        # VALID:   Finds block special files
   '(-c)'        # VALID:   Finds character special files
   '(-S || -p)'  # VALID:   Finds sockets and pipes.  (S must be CAPITAL S   )
    '-d && -l'   # INVALID: missing parentheses       (confuses program      )
    (-d && -l)   # INVALID: missing quotes            (confuses shell        )
     -d && -l    # INVALID: missing parens AND quotes (confuses prgrm & shell)

   (Exception: Technically, you can use an integer as a boolean, and it doesn't
   need quotes or parentheses; but if you use an integer, any non-zero integer
   will process all paths and 0 will process no paths, so this isn't very useful.)

   Arguments and options may be freely mixed, but the arguments must appear in
   the order Arg1, Arg2 (RegExp first, then File-Type Predicate); if you get them
   backwards, they won't do what you want, as most predicates aren't valid regexps
   and vice-versa.

   A number of arguments greater than 2 will cause this program to print an error
   message and abort.

   A number of arguments less than 0 will likely rupture our spacetime manifold
   and destroy everything. But if you DO somehow manage to use a negative number
   of arguments without destroying the universe, please send me an email at
   "Hatley.Software@gmail.com", because I'd like to know how you did that!

   But if you somehow manage to use a number of arguments which is an irrational
   or complex number, please keep THAT to yourself. Some things would be better
   for my sanity for me not to know. I don't want to find myself enthralled to
   Cthulhu.

   Happy directory tree permissions canonicalizing!

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
