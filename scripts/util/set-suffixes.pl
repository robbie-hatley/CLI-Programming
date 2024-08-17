#!/usr/bin/env -S perl -C63

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# set-suffixes.pl
# Sets correct file-name suffixes on files, based on File::Type and on scrutiny of file contents.
#
# Edit history:
# Mon May 04, 2015: Wrote first draft.
# Wed May 13, 2015: Updated and changed Help to "Here Document" format.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sun Feb 07, 2015: Made minor improvements.
# Sat Apr 16, 2016: Now using -CSDA.
# Tue Dec 19, 2017: Adjusted formatting, comments, err_msg, help_msg.
# Sun Jan 03, 2021: Edited.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Sat Aug 12, 2023: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.38". Got rid of
#                   "common::sense" (antiquated). Got rid of all prototypes. Now using signatures.
# Sun Aug 13, 2023: Added section headers to help. Renamed from "set-extensions.pl" to "set-suffixes.pl".
# Sat Sep 02, 2023: Changed all $db to $Db. Got rid of all "/o" on all qr(). Entry and exit messages are now
#                   always printed to STDERR regardless of $Verbose. Got rid of "--nodebug" as that's already
#                   default. Updated argv. Updated help. Increased parallelism "(g|s)et-suffixes.pl".
#                   Stats now always print to STDERR. Got rid of "quiet" and "verbose" options.
#                   Instead, I'm now using STDERR for messages, stats, diagnostics, STDOUT for dirs/files.
# Wed Jul 31, 2024: Added both :prototype() and signatures () to all subroutines.
# Thu Aug 15, 2024: -C63; Width 120->110; erased unnecessary "use ..."; added protos & sigs to all subs.
##############################################################################################################

use v5.36;
use utf8;
use Cwd 'getcwd';
use Time::HiRes 'time';
use File::Type;
use RH::Dir;


# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    :prototype()  ;
sub curdire :prototype()  ;
sub curfile :prototype($) ;
sub stats   :prototype()  ;
sub error   :prototype($) ;
sub help    :prototype()  ;

# ======= PAGE-GLOBAL LEXICAL VARIABLES: =====================================================================

# Settings:     Defaults:   # Meaning of setting:         Range:    Meaning of default:
my $Db        = 0         ; # Debug?                      bool      Don't debug.
my $Recurse   = 0         ; # Recurse subdirectories?     bool      Don't recurse subdirectories.
my $RegExp    = qr/^.+$/o ; # Process which file names?   regexp    Process files of all names.

# Event counters:
my $direcount = 0; # Count of directories processed.
my $filecount = 0; # Count of files processed.
my $typecount = 0; # Count of files of known type.
my $unkncount = 0; # Count of files of unknown type.
my $samecount = 0; # Count of files with new name same as old.
my $diffcount = 0; # Count of files with new name different from old.
my $renacount = 0; # Count of files successfully renamed.
my $failcount = 0; # Count of failed file-rename attempts.

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

# Process @ARGV:
sub argv :prototype() () {
   # Get options and arguments:
   my @opts = ();            # options
   my @args = ();            # arguments
   my $end = 0;              # end-of-options flag
   my $s = '[a-zA-Z0-9]';    # single-hyphen allowable chars (English letters, numbers)
   my $d = '[a-zA-Z0-9=.-]'; # double-hyphen allowable chars (English letters, numbers, equal, dot, hyphen)
   for ( @ARGV ) {           # For each element of @ARGV,
      /^--$/                 # "--" = end-of-options marker = construe all further CL items as arguments,
      and $end = 1           # so if we see that, then set the "end-of-options" flag
      and next;              # and skip to next element of @ARGV.
      !$end                  # If we haven't yet reached end-of-options,
      && ( /^-(?!-)$s+$/     # and if we get a valid short option
      ||  /^--(?!-)$d+$/ )   # or a valid long option,
      and push @opts, $_     # then push item to @opts
      or  push @args, $_;    # else push item to @args.
   }

   # Process options:
   for ( @opts ) {
      /^-$s*h/ || /^--help$/    and help and exit 777 ;
      /^-$s*e/ || /^--debug$/   and $Db      =  1     ;
      /^-$s*l/ || /^--local$/   and $Recurse =  0     ;
      /^-$s*r/ || /^--recurse$/ and $Recurse =  1     ;
   }

   # If debugging, print the options and arguments:
   if ( $Db ) {
      say STDERR '';
      say STDERR "\$opts = (", join(', ', map {"\"$_\""} @opts), ')';
      say STDERR "\$args = (", join(', ', map {"\"$_\""} @args), ')';
   }

   # Process arguments:
   my $NA = scalar(@args);      # Get number of arguments.
                                # If number of arguments == 0, do nothing.
   $NA >= 1                     # If number of arguments >= 1,
   and $RegExp = qr/$args[0]/o; # set $RegExp.
   $NA >= 2 && !$Db             # If number of arguments >= 2 and we're not debugging,
   and error($NA)               # print error message,
   and help                     # and print help message,
   and exit 666;                # and exit, returning The Number Of The Beast.

   # Return success code 1 to caller:
   return 1;
} # end sub argv

# Process current directory:
sub curdire :prototype() () {
   ++$direcount;
   my $curdir = d getcwd;
   say STDOUT '';
   say STDOUT "Directory # $direcount: $curdir";
   say STDOUT '';
   my @paths = glob_regexp_utf8($curdir, 'F', $RegExp);
   for my $path (@paths) {
      next unless is_data_file($path);
      curfile $path;
   }
   return 1;
} # end sub curdire

# Process current file:
sub curfile :prototype($) ($old_path) {
   ++$filecount;
   my $old_name  = get_name_from_path($old_path);
   my $old_dir   = get_dir_from_path ($old_path);
   my $old_pref  = get_prefix        ($old_name);
   my $new_suff  = get_correct_suffix($old_path);

   # If new suffix is '.unk', increment $unkncount, otherwise increment $typecount:
   $new_suff eq '.unk' and ++$unkncount or ++$typecount;

   # Make new name and path:
   my $new_name = $old_pref . $new_suff;
   my $new_path = path($old_dir, $new_name);

   # Increment "same" counter if new name is same as old name, else increment "different" counter:
   $new_name eq $old_name and ++$samecount or  ++$diffcount;

   # If debugging, print values of various variables:
   if ($Db) {
      say STDERR '';
      say STDERR "In \"set-suffixes.pl\", in curfile, after setting variables.";
      say STDERR "\$filecount = \"$filecount\".";
      say STDERR "\$old_path  = \"$old_path\".";
      say STDERR "\$old_dir   = \"$old_dir\".";
      say STDERR "\$old_name  = \"$old_name\".";
      say STDERR "\$old_pref  = \"$old_pref\".";
      say STDERR "\$new_suff  = \"$new_suff\".";
      say STDERR "\$new_name  = \"$new_name\".";
      say STDERR "\$new_path  = \"$new_path\".";
      say STDERR "old and new names are SAME"      if $new_name eq $old_name;
      say STDERR "old and new names are DIFFERENT" if $new_name ne $old_name;
      say STDERR '';
   }

   # If new name is same as old name, announce that old name is correct and return 1:
   if ( $new_name eq $old_name ) {
      say STDOUT "Correct:   \"$old_name\"";
      return 1;
   }

   # Otherwise, announce that old name is incorrect and attempt rename:
   else {
      print STDOUT "Incorrect: \"$old_name\" => \"$new_name\"";
      rename_file($old_path, $new_path)
      and ++$renacount
      and say STDOUT " (rename succeeded)"
      and return 1
      or  ++$failcount
      and say STDOUT " (rename failed)"
      and return 0;
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
} # end sub curfile

# Print statistics:
sub stats :prototype() () {
   say STDERR '';
   say STDERR "Stats for \"set-suffixes.pl\":";
   say STDERR "Navigated $direcount directories.";
   say STDERR "Encountered $filecount files.";
   say STDERR "Found $typecount files of known type.";
   say STDERR "Found $unkncount files of unknown type.";
   say STDERR "Found $samecount files with correct suffix.";
   say STDERR "Found $diffcount files with  wrong  suffix.";
   say STDERR "Successfully renamed $renacount files.";
   say STDERR "Tried but failed to rename $failcount files.";
   return 1;
} # end sub stats

# Handle errors:
sub error :prototype($) ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $NA arguments, but this program takes at most
   one argument, which, if present, must be a regular expression describing
   which items to process. Help follows:
   END_OF_ERROR
   return 1;
} # end sub error

# Print help:
sub help :prototype() () {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "set-suffixes.pl", Robbie Hatley's nifty file name extension
   setter. This program determines the types of the files in the current directory
   (and all subdirectories if a -r or --recurse option is used) then displays the
   original file names, then, if the original suffix was incorrect, it also sets
   and displays the file's name with the correct suffix. For example, if a file
   is named "cat.txt", but the file is actually a jpg file, this program will
   rename the file to "cat.jpg".

   Note that this program DOES alter the names of files. To just DISPLAY the
   correct file names, use my program "get-suffixes.pl" instead.

   -------------------------------------------------------------------------------
   Command lines:

   set-extensions.pl [-h|--help]            (to print this help and exit)
   set-extensions.pl [options] [argument]   (to set file-name extensions)

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

   Happy suffix setting!

   Cheers,
   Robbie Hatley,
   Programmer.
   END_OF_HELP
   return 1;
} # end sub help
