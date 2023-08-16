#! /bin/perl -CSDA

# This is a 110-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# randomize-file-names.pl
# Renames all files in the current directory (and all subdirs, if a -r or --recurse option is used) to random
# strings of 8 lower-case letters. All file-name information will be lost; only the file bodies will remain,
# with gibberish names.
#
# Edit history:
# Sun May 31, 2015: Wrote first draft.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Tue Dec 11, 2018: Updated comments and warnings.
# Thu Jan 10, 2019: Now no-longer randomizing files with extensions ".ini", ".db", or ".jbf".
# Mon Mar 02, 2020: Added Spotlight, Firefox, and Spotfire modes.
# Sun Mar 08, 2020: "use v5.30;", and now making max 100 attempts to find nonexisting random new name
#                   for each file.
# Fri Nov 20, 2020: Now using sub "find_available_random" from RH::Dir. And, now allowing user to specify
#                   an optional prefix and/or suffix to tack onto file name prefix.
# Sat Nov 21, 2020: Diagnostics now output only if $db.
# Wed Feb 17, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory as
#                   its first argument, target as second, and regexp (instead of wildcard) as third.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Mon Nov 22, 2021: Changed "find_available_random" to "find_avail_rand_name".
# Mon Nov 29, 2021: Refactored. Now using GetFiles, which dramatically simplifies curdire().
# Wed Aug 16, 2023: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.36".
#                   Got rid of "common::sense" (antiquated). Got rid of prototypes. Now using signatures.
#                   Shorted target options from "--target=xxxxx" to just "--xxxxx". Upgraded sub argv.
#                   Made sub error single-purpose.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

use Sys::Binmode;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS ========================================================================

sub argv    ; # Process @ARGV.
sub curdire ; # Process current directory.
sub curfile ; # Process current file.
sub stats   ; # Print statistics.
sub error   ; # Handle errors.
sub help    ; # Print help and exit.

# ======= GLOBAL VARIABLES ===================================================================================

# Settings:                   Meaning of setting:          Range:    Meaning of default:
   $"         = ', '      ; # Quoted-array formatting.     string    comma space
my $db        = 0         ; # Debug?                       bool      Don't debug.
my $Verbose   = 1         ; # Quiet, Terse, or Verbose?    0,1,2     Print dirs and some stats.
my $Recurse   = 0         ; # Recurse subdirectories?      bool      Don't recurse.
my $Target    = 'F'       ; # Type of files to target      FDBA      Process regular files only.
my $Yes       = 0         ; # Proceed without prompting?   bool      Don't skip prompting.
my $Emulate   = 0         ; # Merely simulate renames?     bool      Don't simulate
my $Nine      = 0         ; # Ignore files with PreLen<9?  bool      Don't skip short-name-length files.
my $Spotlight = 0         ; # Ignore all but Spotlight?    bool      Don't skip all-but-spotlight.
my $Firefox   = 0         ; # Ignore all but Firefox?      bool      Don't skip all-but-firefox.
my $NoReRan   = 0         ; # Ignore ran-name files?       bool      Don't skip random-named files.
my $Regexp    = qr/^.+$/o ; # Regexp.                      regexp    Process all file names.
my $Prefix    = ''        ; # Prefix.                      string    ''
my $Suffix    = ''        ; # Suffix.                      string    ''

# Counts of events:
my $direcount = 0; # Count of directories processed by curdire.
my $filecount = 0; # Count of    files    processed by curfile.
my $skipcount = 0; # Count of files skipped because they're ini, db, jbf.
my $ninecount = 0; # Count of files skipped because prefix length < 9.
my $nomacount = 0; # Count of files skipped because NOt MAtching sl or ff.
my $norecount = 0; # Count of files skipped because their names are already randomized.
my $renacount = 0; # Count of files renamed.
my $failcount = 0; # Count of failed attempts to rename files.

# ======= MAIN BODY OF PROGRAM ===============================================================================

{ # begin main
   my $t0 = time;
   argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   say "Recurse    = $Recurse  ";
   say "Target     = $Target   ";
   say "Yes        = $Yes      ";
   say "Emulate    = $Emulate  ";
   say "Nine       = $Nine     ";
   say "Spotlight  = $Spotlight";
   say "Regexp     = $Regexp   ";
   unless ($Yes)
   {
      say 'WARNING: THIS PROGRAM RENAMES ALL TARGETED FILES IN THE CURRENT DIRECTORY';
      say '(AND IN ALL SUBDIRECTORIES IF -r OR --recurse IS USED) TO RANDOM STRINGS OF';
      say '8 lower-case LETTERS. ALL INFORMATION CONTAINED IN THE FILE NAMES WILL BE LOST,';
      say 'AND ONLY THE FILE BODIES WILL REMAIN, WITH GIBBERISH NAMES.';
      say '';
      say 'ARE YOU SURE THAT THAT IS WHAT YOU REALLY WANT TO DO??? ';
      say '';
      say 'Press ":" (shift-semicolon) to continue or any other key to abort.';
      my $char = get_character;
      exit 0 unless ':' eq $char;
   }
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =============================================================================

sub argv {
   # Get options and arguments:
   my @opts = (); my @args = (); my $end_of_options = 0;
   for ( @ARGV ) {
      /^--$/ and $end_of_options = 1 and next;
      !$end_of_options && /^-\pL*$|^--.+$/ and push @opts, $_ or push @args, $_;
   }

   # Process options:
   for ( @opts ) {
      /^-\pL*h|^--help$/      and help and exit 777   ;
      /^-\pL*e|^--debug$/     and $db        =  1     ;
      /^-\pL*q|^--quiet$/     and $Verbose   =  0     ;
      /^-\pL*t|^--terse$/     and $Verbose   =  1     ;
      /^-\pL*v|^--verbose$/   and $Verbose   =  2     ;
      /^-\pL*l|^--local$/     and $Recurse   =  0     ;
      /^-\pL*r|^--recurse$/   and $Recurse   =  1     ;
      /^-\pL*f|^--files$/     and $Target    = 'F'    ;
      /^-\pL*d|^--dirs$/      and $Target    = 'D'    ;
      /^-\pL*b|^--both$/      and $Target    = 'B'    ;
      /^-\pL*a|^--all$/       and $Target    = 'A'    ;
      /^-\pL*y|^--yes$/       and $Yes       =  1     ;
      /^-\pL*m|^--emulate$/   and $Emulate   =  1     ;
      /^-\pL*i|^--nine$/      and $Nine      =  1     ;
      /^-\pL*n|^--noreran$/   and $NoReRan   =  1     ;
      /^-\pL*s|^--spotlight$/ and $Spotlight =  1     ;
      /^-\pL*x|^--firefox$/   and $Firefox   =  1     ;
      /^-\pL*z|^--spotfire$/  and $Spotlight =  1 and $Firefox = 1;
      length($_) > 9 && substr($_, 0, 9) eq '--prefix=' and $Prefix = substr($_, 9);
      length($_) > 9 && substr($_, 0, 9) eq '--suffix=' and $Suffix = substr($_, 9);
   }
   $db and say STDERR "opts = (@opts)\nargs = (@args)";

   # Process arguments:
   my $NA = scalar @args;
   $NA >= 1 and $RegExp = qr/$args[0]/o;                  # Set $RegExp.
   $NA >= 2 and $Predicate = $args[1];                    # Set $Predicate.
   $NA >= 3 && !$db and error($NA) and help and exit 666; # Too many args.

   # Return success code 1 to caller:
   return 1;
} # end sub argv

sub curdire {
   ++$direcount;
   my $cwd = cwd_utf8;
   say "\nDir # $direcount: $cwd\n";
   my $files = GetFiles($cwd, $Target, $Regexp);
   foreach my $file (@{$curdirfiles}) {
      ++$filecount;
      local $_ = e $file->{Path};
      if (eval($Predicate)) {
         ++$findcount;
         say STDOUT "$file->{Path}";
      }
   }
   return 1;
} # end sub curdire

sub curfile ($file) {
   ++$filecount;
   my $path          = $file->{Path};
   my $dire          = get_dir_from_path($path);
   my $name          = $file->{Name};
   my $prefix        = get_prefix($name);
   my $prelen        = length($prefix);
   my $suffix        = get_suffix($name);
   my $new_prefix;
   my $new_name;

   # Announce file name info if debugging:
   say "\$name   = $name"   if $db;
   say "\$prefix = $prefix" if $db;
   say "\$prelen = $prelen" if $db;
   say "\$suffix = $suffix" if $db;

   # Skip desktop, thumbs, pspb, and id files:
   is_data_file($path) && $name =~ m/^desktop.*\.ini$|^thumbs.*\.db$|^pspbrwse.*\.jbf$|id-token/i
   and ++$skipcount and say "Skipped file \"$name\" (dsktp, thumbs, pspb, or ID.)" and return 1;

   # Skip this file if the "Nine" feature is turned on and the prefix length is < 9:
   $Nine && $prelen < 9
   and ++$ninecount and say "Skipped file \"$name\" because prefix length < 9." and return 1;

   # Skip this file if in "Spotlight" mode and file doesn't match sl:
   $Spotlight && !$Firefox && $prefix !~ m/[0-9a-f]{64}/
   and ++$nomacount and say "Skipped file \"$name\" because not Spotlight." and return 1;

   # Skip this file if in "Firefox" mode and file doen't match ff:
   $Firefox && !$Spotlight && $prefix !~ m/[0-9A-F]{40}/
   and ++$nomacount and say "Skipped file \"$name\" because not Firefox." and return 1;

   # Skip this file if in "Spotfire" mode and file doesn't match sl or ff:
   $Spotlight && $Firefox && $prefix !~ m/[0-9a-f]{64}/ && $prefix !~ m/[0-9A-F]{40}/
   and ++$nomacount and say "Skipped file \"$name\" because not Spotlight or Firefox." and return 1;

   # Skip this file if in  "NoReRan" mode and file name is already randomized:
   $NoReRan && $prefix =~ m/\p{Ll}{8}/
   and ++$norecount and say "Skipped file \"$name\" because already random." and return 1;

   # Try to find a random file name that doesn't already exist in file's directory:
   $new_name = find_avail_rand_name($dire, $Prefix, $Suffix . $suffix);
   say "NewName = $new_name" if $db;
   '***ERROR***' eq $new_name
   and warn("Unable to find nonexisting randomized new name for file \"$name\";\n")
   and warn("skipping to next file.\n") and return 0;

   # If debugging or simulating, just go through the motions then return 1:
   $db || $Emulate and say "Simulated Rename: $name => $new_name" and return 1;

   # Otherwise, attempt rename:
   rename_file($name, $new_name)
   and ++$renacount and say "Renamed: $name => $new_name" and return 1
   or  ++$failcount and say "Failed:  $name => $new_name" and return 0;
} # end sub curfile ($file)

sub stats {
   print("\nStatistics for program \"randomize-file-names.pl\":\n");
   if ($Emulate)
   {
      say('Note: in simulation mode; no renames were actually attempted.');
   }
   say "Navigated $direcount directories.";
   say "Found $filecount files matching target \"$Target\" and regexp \"$Regexp\".";
   say "Skipped $skipcount files because they're ini, db, or jbf.";
   if ($Nine) {say "Skipped $ninecount files with prefix length < 9.";}
   if ($Spotlight || $Firefox) {say "Skipped $nomacount files not matching sl and/or ff pattern.";}
   say "Successfully randomized the names of $renacount files.";
   say "Tried but failed to randomize the names of $failcount files.";
   return 1;
} # end sub stats

sub error ($NA)
{
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $NA arguments, but this program takes at most 1 argument,
   which, if present, must be a regular expression expressing which file names
   to randomize. Help follows:
   END_OF_ERROR
} # end sub error ($NA)

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "randomize-file-names.pl", Robbie Hatley's file name randomizer.
   This program randomizes file names by replacing the name of each name with a
   random string of 8 lower-case English letters (a-z).

   This program should NOT be run frivolously, because it destroys all information
   contained in the names of all files it processes. However, in cases where you
   have a bunch of files which ALREADY have long, gibberishy names -- such as,
   files scavenged from a browser cache -- then this program is helpful because
   it assigns a unique, random, short name to each file consisting of exactly 8
   lower-case letters, with equal abundance of each possible first letter.
   This aids both in scrolling through files and in processing them with programs,
   as you can clearly see what percentage have been scrolled or processed so-far,
   because there will be roughly equal numbers of names starting with each
   letter of the alphabet.

   -------------------------------------------------------------------------------
   Skipped Files:

   This program doesn't randomize file names matching any of the following regexps:
   $name =~ m/^desktop.*\.ini$/i;
   $name =~ m/^thumbs.*\.db$/i;
   $name =~ m/^pspbrwse.*\.jbf$/i;
   $name =~ m/ID-Token/i;
   That's because because those are system files, only one of which exists in
   any one directory, rather than data files. "desktop.ini" sets the properties
   of the folder; "Thumbs.db" contains Windows picture thumbnails; "pspbrwse.jbf"
   contains Jasc Paint Shop Pro picture thumbnails; and "ID-Token" identifies
   a folder, partition, or computer.

   -------------------------------------------------------------------------------
   Command Lines:

   randomize-file-names.pl  -h | --help              (to print this help and exit)
   randomize-file-names.pl [options] [Arg1] [Arg2]   (to randomize file names)

   -------------------------------------------------------------------------------
   Description of options:

   Option:              Meaning:
   -h or --help         Print help and exit.
   -e or --debug        Print diagnostics and exit.
   -q or --quiet        Be quiet.
   -t or --terse        Be terse.                       (DEFAULT)
   -v or --verbose      Be verbose.
   -l or --local        DON'T recurse subdirectories.   (DEFAULT)
   -r or --recurse       DO   recurse subdirectories.
   -f or --files        Target Files.
   -d or --dirs         Target Directories.
   -b or --both         Target Both.
   -a or --all          Target All.
   -y or --yes          Randomize file names without prompting.
   -m or --emulate      Merely simulate renames.
   -i or --nine         Ignore files with prefix length < 9.
   -n or --noreran      Ignore files with names that are already randomized
   -s or --spotlight    Ignore all file names other than spotlight photo names
   -x or --firefox      Ignore all file names other than firefox cache names
   -z or --spotfire     Ignore all file names other than spotlight or firefox
   --prefix=NamePrefix  Tack NamePrefix on beginning of file name
   --suffix=NameSuffix  Tack NameSuffix on end of file name before type suffix

   -h or --help        Print help and exit.
   -l or --local       Don't recurse subdirectories.   (DEFAULT)
   -r or --recurse     Do    recurse subdirectories.

   Multiple single-letter options may be piled-up after a single hyphen.
   For example, use -vr to verbosely and recursively process items.

   If multiple conflicting separate options are given, later overrides earlier.

   If multiple conflicting single-letter options are piled after a single colon,
   the result is determined by this descending order of precedence: heabdfrlvtq.

   All options not listed above are ignored.

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

   If the number of arguments is not 0, 1, or 2, this program will print an
   error message and abort.

   Happy item processing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;




   print ((<<'   END_OF_HELP') =~ s/^   //gmr);


   Command line:

   Description of options:
   Option:                  Meaning:
   All other options are ignored.

   Description of arguments:
   In addition to options, this program can take one optional argument which, if
   present, must be a Perl-Compliant Regular Expression (PCRE) specifying which
   file names to randomize. For example, if you want to randomize names of png
   files only, you could type:

      randomize-file-names.pl '^.+\.png$'

   Happy file-name randomizing!

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end help
