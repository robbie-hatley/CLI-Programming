#!/usr/bin/env -S perl -C63

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# repair-directory-dates.pl
# Repairs the dates on directories which have been "bumped" by "repair-dolphin-directory-files.pl" (or other
# program that creates, removes, or alters hidden files in directories) by setting the directory dates to the
# date of the most-recent non-hidden file in the directory.
# Written by Robbie Hatley.
# Edit history:
# Sat Mar 23, 2024: Wrote it.
# Thu Aug 15, 2024: -C63; got rid of unnecessary "use" statements.
##############################################################################################################

use v5.36;
use utf8;
use Cwd 'getcwd';
use Time::HiRes 'time';
use RH::Dir;
use RH::Util;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ; # Process @ARGV.
sub curdire ; # Process current directory.
sub curfile ; # Process current file.
sub stats   ; # Print statistics.
sub error   ; # Handle errors.
sub help    ; # Print help and exit.

# ======= GLOBAL VARIABLES: ==================================================================================

our $t0     ; # Seconds since 00:00:00 on Thu Jan 1, 1970.

# ======= START TIMER: =======================================================================================

BEGIN {$t0 = time}

# ======= LEXICAL VARIABLES: =================================================================================

# Setting:      Default Value:   Meaning of Setting:         Range:     Meaning of Default:
my $Db        = 0            ; # Debug?                      bool       Don't debug.
my $Verbose   = 1            ; # Be wordy?                   0,1,2      Be quiet.
my $Recurse   = 0            ; # Recurse subdirectories?     bool       Be local.

# Counts of events in this program:
my $direcount = 0 ; # Count of directories processed by curdire.
my $filecount = 0 ; # Count of files processed by curdire loop.
my $hidncount = 0 ; # Count of hidden files.
my $opencount = 0 ; # Count of non-hidden files.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   # Set program name:
   my $pname = substr $0, 1 + rindex $0, '/';

   # Process @ARGV:
   argv;

   # Print program-entry message if being terse or verbose:
   if ( $Verbose >= 1 ) {
      say    STDERR '';
      say    STDERR "Now entering program \"$pname\"." ;
   }

   # Print global settings if being verbose:
   if ( $Verbose >= 2 ) {
      say    STDERR "\$Db        = $Db";
      say    STDERR "\$Verbose   = $Verbose";
      say    STDERR "\$Recurse   = $Recurse";
   }

   # Process current directory (and all subdirectories if recursing):
   $Recurse and RecurseDirs {curdire} or curdire;

   # Print stats:
   stats;

   # Print exit message if being terse or verbose:
   if ( $Verbose >= 1 ) {
      say    STDERR '';
      say    STDERR "Now exiting program \"$pname\".";
      printf STDERR "Execution time was %.3f seconds.", time - $t0;
   }

   # Exit program, returning success code "0" to caller:
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV :
sub argv {
   # Get options and arguments:
   my @opts = ();            # options
   my $end = 0;              # end-of-options flag
   my $s = '[a-zA-Z0-9]';    # single-hyphen allowable chars (English letters, numbers)
   my $d = '[a-zA-Z0-9=.-]'; # double-hyphen allowable chars (English letters, numbers, equal, dot, hyphen)
   for ( @ARGV ) {           # For each element of @ARGV,
         ( /^-(?!-)$s+$/     # if we get a valid short option
      ||  /^--(?!-)$d+$/ )   # or a valid long option,
      and push @opts, $_;    # then push item to @opts
   }

   # Process options:
   for ( @opts ) {
      /^-$s*h/ || /^--help$/    and help and exit 777 ;
      /^-$s*n/ || /^--ndebug$/  and $Db      =  0     ; # Default is "don't debug".
      /^-$s*e/ || /^--debug$/   and $Db      =  1     ;
      /^-$s*q/ || /^--quiet$/   and $Verbose =  0     ;
      /^-$s*t/ || /^--terse$/   and $Verbose =  1     ; # Default is "verbosity level 1".
      /^-$s*v/ || /^--verbose$/ and $Verbose =  2     ;
      /^-$s*l/ || /^--local$/   and $Recurse =  0     ; # Default is "don't recurse".
      /^-$s*r/ || /^--recurse$/ and $Recurse =  1     ;
   }
   if ( $Db ) {
      say STDERR '';
      say STDERR "\$opts = (", join(', ', map {"\"$_\""} @opts), ')';
   }

   # (Non-option arguments are ignored.)

   # Return success code 1 to caller:
   return 1;
} # end sub argv

# Process current directory:
sub curdire {
   # Increment directory counter:
   ++$direcount;

   # Get current working directory:
   my $cwd = d getcwd;

   # Announce current working directory if being terse or verbose:
   if ( $Verbose >= 1) {
      say "\nDirectory # $direcount: $cwd\n";
   }

   # Try to open, read, and close $cwd; if any of those operations fail, die:
   my $dh = undef;
   opendir $dh, e $cwd
   or die "Fatal error: Couldn't open  directory \"$cwd\".\n$!\n";

   my @names = sort {$a cmp $b} d(readdir($dh));
   scalar(@names) >= 2 # $dir should contain at least '.' and '..'!
   or die "Fatal error: Couldn't read  directory \"$cwd\".\n$!\n";

   closedir $dh
   or die "Fatal Error: Couldn't close directory \"$cwd\".\n$!\n";

   # Set the time stamp of the current working directory to the time stamp
   # of the most-recently-modified of the non-hidden files present:
   my $max_Mtime = 0;
   foreach my $name (@names) {
      next if '.'  eq $name;
      next if '..' eq $name;
      ++$filecount;
      # Don't base cwd's date on hidden files:
      if ( '.' eq substr($name, 0, 1) ) {++$hidncount;next;}
      ++$opencount;
      my @stats = lstat e $name;
      if ( scalar(@stats) < 13 ) {
         warn "Warning: Can't lstat \"$name\" in \"$cwd\".\n";
         next;
      }
      if ( $stats[9] > $max_Mtime ) { $max_Mtime = $stats[9] }
   }
   utime $max_Mtime, $max_Mtime, e($cwd);

   # Return success code 1 to caller:
   return 1;
} # end sub curdire

# Print statistics for this program run:
sub stats {
   if ( $Verbose >= 1 ) {
      say    STDERR '';
      say    STDERR 'Statistics for this directory tree:';
      say    STDERR "Navigated $direcount directories.";
      say    STDERR "Found $hidncount hidden files.";
      say    STDERR "Found $opencount non-hidden files.";
   }
   return 1;
} # end sub stats

# Print help:
sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "repair-directory-dates.pl". This program sets the mod date of the
   current working directory (and all of its subdirectories if a -r or --recurse
   option is used) to the mod date of the most-recently-modified non-hidden item
   within.

   -------------------------------------------------------------------------------
   Command lines:

   repair-directory-dates.pl -h | --help     (to print this help and exit)
   repair-directory-dates.pl [options]       (to set directory dates)

   -------------------------------------------------------------------------------
   Description of options:

   Option:            Meaning:
   -h or --help       Print help and exit.
   -n or --ndebug     DON'T print diagnostics.        (DEFAULT)
   -e or --debug      Print diagnostics.
   -q or --quiet      Be quiet.
   -t or --terse      Be terse.                       (DEFAULT)
   -v or --verbose    Be verbose.
   -l or --local      DON'T recurse subdirectories.   (DEFAULT)
   -r or --recurse    DO    recurse subdirectories.

   Multiple single-letter options may be piled-up after a single hyphen.
   For example, use -qr to quietly and recursively process items.

   If multiple conflicting separate options are given, later overrides earlier.
   If multiple conflicting single-letter options are piled after a single hyphen,
   the result is determined by this descending order of precedence: herlvtq.

   If you want to use an argument that looks like an option (say, you want to
   search for files which contain "--recurse" as part of their name), use a "--"
   option; that will force all command-line entries to its right to be considered
   "arguments" rather than "options".

   All options not listed above, and all non-option arguments, are ignored.

   Happy directory dating!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
__END__
