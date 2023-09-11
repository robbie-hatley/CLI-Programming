#!/usr/bin/perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# get-suffixes.pl
# Gets correct file-name suffixes on regular files, based on File::Type and on scrutiny of file contents.
# (Doesn't rename any files. To set correct suffixes, use my program "set-suffixes.pl" instead.)
# Written by Robbie Hatley.
# Edit history:
# Sat Aug 12, 2023: Wrote it. (STUBB!!!)
# Sun Aug 13, 2023: Fleshed-out help section. Renamed to "get-suffixes.pl". No-longer skips files < 50 bytes.
#                   Changed all "warn" to "say STDERR" and all "say" and "print" to "say STDOUT".
#                   Changed file-renaming code to file-name-printing code. Made fully-functional.
# Sat Sep 02, 2023: Changed all $db to $Db. Got rid of all "/o" on all qr(). Entry and exit messages are now
#                   always printed to STDERR regardless of $Verbose. Got rid of "--nodebug" as that's already
#                   default. Updated argv. Updated help. Increased parallelism "(g|s)et-suffixes.pl".
#                   Stats now always print to STDERR. Got rid of "quiet" and "verbose" options.
#                   Instead, I'm now using STDERR for messages, stats, diagnostics, STDOUT for dirs/files.
##############################################################################################################

use v5.38;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

use Sys::Binmode;
use Cwd;
use Time::HiRes 'time';
use File::Type;

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ;
sub curdire ;
sub curfile ;
sub stats   ;
sub error   ;
sub help    ;

# ======= PAGE-GLOBAL LEXICAL VARIABLES: =====================================================================

# Settings:     Defaults:  # Meaning of setting:         Range:    Meaning of default:
my $Db        = 0        ; # Debug?                      bool      Don't debug.
my $Recurse   = 0        ; # Recurse subdirectories?     bool      Don't recurse subdirectories.
my $RegExp    = qr/^.+$/ ; # Process which file names?   regexp    Process files of all names.

# Event counters:
my $direcount = 0; # Count of directories processed.
my $filecount = 0; # Count of files processed.
my $typecount = 0; # Count of files of known type.
my $unkncount = 0; # Count of files of unknown type.
my $samecount = 0; # Count of files with new name same as old.
my $diffcount = 0; # Count of files with new name different from old.



# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   my $pname = get_name_from_path($0);
   argv;
   say STDERR "Now entering program \"$pname\".";
   say STDERR "\$Db      = \"$Db\".";
   say STDERR "\$Recurse = \"$Recurse\".";
   say STDERR "\$RegExp  = \"$RegExp\".";

   $Recurse and RecurseDirs {curdire} or curdire;

   stats;
   say    STDERR '';
   say    STDERR "Now exiting program \"$pname\".";
   printf STDERR "Execution time was %.3f seconds.", time - $t0;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =============================================================================

sub argv {
   # Get options and arguments:
   my @opts = ();             # options
   my @args = ();             # arguments
   my $end = 0;               # end-of-options flag
   my $s = '[a-zA-Z0-9]';     # single-hyphen allowable chars (English letters, numbers)
   my $d = '[a-zA-Z0-9=.-]';  # double-hyphen allowable chars (English letters, numbers, equal, dot, hyphen)
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
      /^-$s*e/ || /^--debug$/   and $Db      =  1     ;
      /^-$s*l/ || /^--local$/   and $Recurse =  0     ;
      /^-$s*r/ || /^--recurse$/ and $Recurse =  1     ;
   }
   if ( $Db ) {
      say STDERR '';
      say STDERR "\$opts = (", join(', ', map {"\"$_\""} @opts), ')';
      say STDERR "\$args = (", join(', ', map {"\"$_\""} @args), ')';
   }

   # Process arguments:
   my $NA = scalar(@args);     # Get number of arguments.
   $NA >= 1                    # If number of arguments >= 1,
   and $RegExp = qr/$args[0]/; # set $RegExp.
   $NA >= 2 && !$Db            # If number of arguments >= 2 and we're not debugging,
   and error($NA)              # print error message,
   and help                    # and print help message,
   and exit 666;               # and exit, returning The Number Of The Beast.

   # Return success code 1 to caller:
   return 1;
} # end sub argv ()

sub curdire {
   ++$direcount;
   my $curdir = cwd_utf8;
   say STDOUT '';
   say STDOUT "Directory # $direcount: $curdir";
   say STDOUT '';
   my @paths = glob_regexp_utf8($curdir, 'F', $RegExp);
   for my $path (@paths) {
      next unless is_data_file($path);
      curfile $path;
   }
   return 1;
} # end sub curdire ()

sub curfile ($path) {
   ++$filecount;
   my $name = get_name_from_path($path);
   my $dir  =  get_dir_from_path($path);
   my $new_suff = get_correct_suffix($path);
   # If new suffix is '.unk', increment $unkncount, otherwise increment $typecount:
   $new_suff eq '.unk' and ++$unkncount or ++$typecount;

   if ($Db) {
      say STDERR '';
      say STDERR "In \"get-suffixes.pl\", in curfile, after getting new suffix.";
      say STDERR "\$filecount = \"$filecount\".";
      say STDERR "\$path  = \"$path\".";
      say STDERR "\$new_suff  = \"$new_suff\".";
   }

   # Make new name and path:
   my $new_name = get_prefix($name) . $new_suff;
   my $new_path = path($dir, $new_name);
   # Increment "same" counter if new name is same as old name, else increment "diff" counter:
   $new_name eq $name and ++$samecount or  ++$diffcount;

   if ($Db) {
      say STDERR '';
      say STDERR "In \"get-suffixes.pl\", in curfile, after making new name and path.";
      say STDERR "old name = \"$name\".";
      say STDERR "new name = \"$new_name\".";
      say STDERR "new path = \"$new_path\".";
      say STDERR "old and new names are DIFFERENT" if $new_name ne $name;
      say STDERR "old and new names are SAME"      if $new_name eq $name;
   }

   # If new name is same as old name, announce that old name is correct:
   if ( $new_name eq $name ) {
      say STDOUT "Correct:   \"$name\"";
      return 1;
   }

   # Otherwise, announce that old name is incorrect:
   else {
      say STDOUT "Incorrect: \"$name\" => \"$new_name\"";






      return 1;
   }

   # We can't possibly get here.
   # But if we do, something truly bizarre has happened,
   # so print some cryptic shit and return 666:

   print ((<<'   666') =~ s/^   //gmr);

   Back, he spurred like a madman, shrieking a curse to the sky,
   With the white road smoking behind him and his rapier brandished high.
   Blood red were his spurs in the golden noon; wine-red was his velvet coat;
   When they shot him down on the highway,
           Down like a dog on the highway,
   And he lay in his blood on the highway, with a bunch of lace at his throat.
   666

   return 666;
} # end sub curfile ($path)

sub stats {
   say STDERR '';
   say STDERR "Stats for \"get-suffixes.pl\":";
   say STDERR "Navigated $direcount directories.";
   say STDERR "Encountered $filecount files.";
   say STDERR "Found $typecount files of known type.";
   say STDERR "Found $unkncount files of unknown type.";
   say STDERR "Found $samecount files with correct suffix.";
   say STDERR "Found $diffcount files with  wrong  suffix.";


   return 1;
} # end sub stats

# Handle errors:
sub error ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $NA arguments, but this program takes at most
   one argument, which, if present, must be a regular expression describing
   which items to process. Help follows:
   END_OF_ERROR
   return 1;
} # end sub error ($NA)

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "set-suffixes.pl", Robbie Hatley's nifty file name extension
   setter. This program determines the types of the files in the current directory
   (and all subdirectories if a -r or --recurse option is used) then displays the
   original file names, then, if the original suffix was incorrect, it also gets
   and displays the file's name with the correct suffix. For example, if a file
   is named "cat.txt", but the file is actually a jpg file, this program will
   display the new file name as "cat.jpg".

   Note that this program DOESN'T alter the names of files. To set correct
   file-name suffixes, use my program "set-suffixes.pl" instead.

   -------------------------------------------------------------------------------
   Command lines:

   get-extensions.pl [-h|--help]            (to print this help and exit)
   get-extensions.pl [options] [argument]   (to get file-name extensions)

   -------------------------------------------------------------------------------
   Description of options:

   Option:            Meaning:
   -h or --help       Print help and exit.
   -e or --debug      DO    print diagnostics and exit.
   -l or --local      DON'T recurse subdirectories.                      (DEFAULT)
   -r or --recurse    DO    recurse subdirectories.
         --           End of options (all further CL items are arguments).

   Multiple single-letter options may be piled-up after a single hyphen.
   For example, use -vr to verbosely and recursively process items.

   If multiple conflicting separate options are given, later overrides earlier.
   If multiple conflicting single-letter options are piled after a single hyphen,
   the result is determined by this descending order of precedence: herlvq.

   If you want to use an argument that looks like an option (say, you want to
   search for files which contain "--recurse" as part of their name), use a "--"
   option; that will force all command-line entries to its right to be considered
   "arguments" rather than "options".

   All options not listed above are ignored.

   -------------------------------------------------------------------------------
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

   Happy suffix getting!

   Cheers,
   Robbie Hatley,
   Programmer.
   END_OF_HELP
   return 1;
} # end sub help
__END__
