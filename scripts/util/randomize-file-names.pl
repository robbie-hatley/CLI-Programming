#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# randomize-file-names.pl
# Renames all files in the current directory (and all subdirs, if a -r or --recurse option is used) to random strings of
# 8 lower-case letters. All file-name information will be lost; only the file bodies will remain, with gibberish names.
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
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Mon Nov 22, 2021: Changed "find_available_random" to "find_avail_rand_name".
# Mon Nov 29, 2021: Refactored. Now using GetFiles, which dramatically simplifies curdire().
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';
use RH::Util;
use RH::Dir;

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# ======= SUBROUTINE PRE-DECLARATIONS ==================================================================================

sub argv    ()  ; # Process @ARGV.
sub curdire ()  ; # Process current directory.
sub curfile ($) ; # Process current file.
sub stats   ()  ; # Print statistics.
sub error   ($) ; # Handle errors.
sub help    ()  ; # Print help and exit.

# ======= GLOBAL VARIABLES =============================================================================================

# Settings:                   Meaning:                     Range:    Default:
my $Recurse   = 0         ; # Recurse subdirectories?      (bool)    0
my $Target    = 'F'       ; # Type of files to target      (FDBA)    'F'
my $Yes       = 0         ; # Proceed without prompting?   (bool)    0
my $Emulate   = 0         ; # Merely simulate renames?     (bool)    0
my $Nine      = 0         ; # Ignore files with PreLen<9?  (bool)    0
my $Spotlight = 0         ; # Ignore all but Spotlight?    (bool)    0
my $Firefox   = 0         ; # Ignore all but Firefox?      (bool)    0
my $NoReRan   = 0         ; # Ignore ran-name files?       (bool)    0
my $Regexp    = qr/^.+$/o ; # Regexp.                      (regexp)  qr/^.+$/o
my $Prefix    = ''        ; # Prefix.                      (string)  ''
my $Suffix    = ''        ; # Suffix.                      (string)  ''

# Counts of events occurring in main:: only:
my $direcount = 0; # Count of directories processed by process_current_directory.
my $filecount = 0; # Count of    files    processed by process_current_file.
my $skipcount = 0; # Count of files skipped because they're ini, db, jbf.
my $ninecount = 0; # Count of files skipped because prefix length < 9.
my $nomacount = 0; # Count of files skipped because NOt MAtching sl or ff.
my $norecount = 0; # Count of files skipped because their names are already randomized.
my $renacount = 0; # Count of files renamed.
my $failcount = 0; # Count of failed attempts to rename files.

# ======= MAIN BODY OF PROGRAM =========================================================================================

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

# ======= SUBROUTINE DEFINITIONS =======================================================================================

sub argv ()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         if ('-h' eq $_ || '--help'         eq $_ ) {help; exit 777  ;}
         if ('-r' eq $_ || '--recurse'      eq $_ ) {$Recurse   =  1 ;}
         if ('-f' eq $_ || '--target=files' eq $_ ) {$Target    = 'F';}
         if ('-d' eq $_ || '--target=dirs'  eq $_ ) {$Target    = 'D';}
         if ('-b' eq $_ || '--target=both'  eq $_ ) {$Target    = 'B';}
         if ('-a' eq $_ || '--target=all'   eq $_ ) {$Target    = 'A';}
         if ('-y' eq $_ || '--yes'          eq $_ ) {$Yes       =  1 ;}
         if ('-e' eq $_ || '--emulate'      eq $_ ) {$Emulate   =  1 ;}
         if ('-9' eq $_ || '--nine'         eq $_ ) {$Nine      =  1 ;}
         if ('-n' eq $_ || '--noreran'      eq $_ ) {$NoReRan   =  1 ;}
         if ('-s' eq $_ || '--spotlight'    eq $_ ) {$Spotlight =  1 ;}
         if ('-x' eq $_ || '--firefox'      eq $_ ) {$Firefox   =  1 ;}
         if ('-z' eq $_ || '--spotfire'     eq $_ ) {$Spotlight =  1 ; 
                                                     $Firefox   =  1 ;}
         if (substr($_, 0, 9) eq '--prefix='){$Prefix = substr($_, 9);}
         if (substr($_, 0, 9) eq '--suffix='){$Suffix = substr($_, 9);}
         splice @ARGV, $i, 1;
         --$i;
      }
   }
   my $NA = scalar(@ARGV);
   given ($NA)
   {
      when (0)
      {
         ; # Do nothing.
      }
      when (1)
      {
         $Regexp = splice @ARGV;
      }
      default
      {
         error($NA);
      }
   }
   return 1;
} # end sub argv ()

sub curdire ()
{
   ++$direcount;
   my $cwd = cwd_utf8;
   say "\nDir # $direcount: $cwd\n";
   my $files = GetFiles($cwd, $Target, $Regexp);
   for my $file (@{$files}) 
   {
      next if ! is_data_file($file->{Path});
      curfile($file);
   }
   return 1;
} # end sub curdire ()

sub curfile ($)
{
   ++$filecount;
   my $file          = shift;
   my $path          = $file->{Path};
   my $dire          = get_dir_from_path($path);
   my $name          = $file->{Name};
   my $prefix        = get_prefix($name);
   my $prelen        = length($prefix);
   my $suffix        = get_suffix($name);
   my $new_prefix;
   my $new_name;
   my $attempts;
   my $name_success;
   my $result;

   # Announce file name info if debugging:
   say "\$name   = $name"   if $db;
   say "\$prefix = $prefix" if $db;
   say "\$prelen = $prelen" if $db;
   say "\$suffix = $suffix" if $db;

   # Abort this file rename if suffix is ini, db, or jbf:
   if ('.ini' eq $suffix || '.db' eq $suffix || '.jbf' eq $suffix)
   {
      say "Skipped file \"$name\" because ini, db, or jbf";
      ++$skipcount;
      return 1;
   }

   # Abort this file rename if the "Nine" feature is turned on and
   # the prefix length is < 9:
   if ($Nine && $prelen < 9)
   {
      say "Skipped file \"$name\" because prefix length < 9";
      ++$ninecount;
      return 1;
   }

   # Abort this file rename if in  "Spotlight" mode and
   # file doesn't match sl:
   if ($Spotlight && !$Firefox)
   {
      if ($prefix !~ m/[0-9a-f]{64}/)
      {
         say "Skipped file \"$name\" because not Spotlight.";
         ++$nomacount;
         return 1;
      }
   }

   # Abort this file rename if in  "Firefox" mode and
   # file doen't match ff:
   if ($Firefox && !$Spotlight)
   {
      if ($prefix !~ m/[0-9A-F]{40}/)
      {
         say "Skipped file \"$name\" because not Firefox.";
         ++$nomacount;
         return 1;
      }
   }

   # Abort this file rename if in  "Spotfire" mode and
   # file doesn't match sl or ff:
   if ($Spotlight && $Firefox)
   {
      if ($prefix !~ m/[0-9a-f]{64}/ && $prefix !~ m/[0-9A-F]{40}/)
      {
         say "Skipped file \"$name\" because not Spotlight or Firefox.";
         ++$nomacount;
         return 1;
      }
   }

   # Abort this file rename if in  "NoReRan" mode and
   # file already has randomized name:
   if ($NoReRan)
   {
      if ($prefix =~ m/\p{Ll}{8}/)
      {
         say "Skipped file \"$name\" because its name is already randomized.";
         ++$norecount;
         return 1;
      }
   }

   # Try to find a random file name that doesn't already exist in file's directory:
   $new_name = 
   find_avail_rand_name
   (
      $dire,            # the directory in which the file resides
      $Prefix,          # user-specified name prefix to be tacked on front
      $Suffix . $suffix # user-specified name suffix to be tacked on back, plus file-type suffix
   );

   say "NewName = $new_name" if $db;

   if ('***ERROR***' eq $new_name)
   {
      warn("Unable to find nonexisting randomized new name for file \"$name\";\n");
      warn("file renamed aborted.\n");
      return 0;
   }

   # If debugging or simulating, just go through the motions then return 1:
   if ($db || $Emulate)
   {
      say "Simulated Rename: $name => $new_name";
      return 1;
   }

   # Otherwise, attempt rename:
   $result = rename_file($name, $new_name);

   if ($result)
   {
      ++$renacount;
      say "Renamed: $name => $new_name";
   }

   else
   {
      ++$failcount;
      say "Failed: $name => $new_name";
   }

   return $result;
} # end sub curfile ($)

sub stats ()
{
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

sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $NA arguments, but this program takes at most 1 argument,
   which, if present, must be a regular expression expressing which file names
   to randomize. Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end sub error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "randomize-file-names.pl", Robbie Hatley's file name randomizer.
   This program will randomize the names of all regular files (or all regular 
   files matching a regexp if one is given) in the current directory (and all
   subdirectories of the current directory as well, if a -r or --recurse switch is
   used) except for certain specific files which aren't randomized (see "Skipped
   Files" section below). The file-name suffixes will not be affected, but the
   prefixes will be turned into strings of 8 random lower-case English letters.

   This program should not be run frivolously, because it destroys all information
   contained in the names of all files it processes. However, in cases where you
   have a bunch of files which ALREADY have long, gibberishy names -- such as,
   files scavenged from a browser cache -- then this program is helpful because
   it assigns a unique, random, short name to each file consisting of exactly 8
   lower-case letters, with equal abundance of each possible first letter.
   This aids both in scrolling through files and in processing them with programs,
   as you can clearly see what percentage have been scrolled or processed so-far,
   because there will be roughly equal numbers of names starting with each
   letter of the alphabet. 

   Command line:
   randomize-file-names.pl [options] [argument]

   Description of options:
   Option:                  Meaning:
   "-h" or "--help"         Print help and exit.
   "-r" or "--recurse"      Recurse subdirectories.
   "-f" or "--target=files" Target files only.
   "-d" or "--target=dirs"  Target directories only.
   "-b" or "--target=both"  Target both files and directories.
   "-a" or "--target=all"   Target all (files, directories, symlinks, etc).
   "-y" or "--yes"          Randomize file names without prompting.
   "-e" or "--emulate"      Merely simulate renames.
   "-9" or "--nine"         Ignore files with prefix length < 9.
   "-n" or "--noreran"      Ignore files with names that are already randomized
   "-s" or "--spotlight"    Ignore all file names other than spotlight photo names
   "-x" or "--firefox"      Ignore all file names other than firefox cache names
   "-z" or "--spotfire"     Ignore all file names other than spotlight or firefox
   "--prefix=NamePrefix"    Tack NamePrefix on beginning of file name
   "--suffix=NameSuffix"    Tack NameSuffix on end of file name before type suffix
   All other options are ignored.

   Description of arguments:
   In addition to options, this program can take one optional argument which, if
   present, must be a Perl-Compliant Regular Expression (PCRE) specifying which
   file names to randomize. For example, if you want to randomize names of png
   files only, you could type:

      randomize-file-names.pl '^.+\.png$'

   Files Skipped:
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

   Happy file-name randomizing!

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end help ()
