#! /bin/perl -CSDA

# This is a 110-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# rename-toontown-images.pl
# Renames Toontown screenshots to a standard format such that lexical sorting = chronological sorting.
#
# Edit history:
# Fri Jan 29, 2021: Wrote first draft.
# Mon Mar 08, 2021: Heavily refactored. Now also renames TTO screenshots.
# Wed Apr 14, 2021: Expanded width to 120 characters; shorted sub names; cleaned-up formatting and comments.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Mon Nov 22, 2021: Fixed bug on line 188: "/avaname" => "/$avaname".
# Thu Nov 25, 2021: Added timestamping.
# Tue Aug 22, 2023: Upgraded from "v5.32" to "v5.36". Decreased width from 120 to 110. Got rid of CPAN module
#                   "common::sense" (antiquated). Got rid of prototypes. Now using signatures.
##############################################################################################################

# ======= PRELIMINARIES: =====================================================================================

# Pragmas:
use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

# CPAN modules:
use Sys::Binmode;
use Cwd;
use Time::HiRes 'time';

# Homebrew modules:
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv;
sub curdire;
sub curfile;
sub stats;
sub help;

# ======= VARIABLES: =========================================================================================

# Debug?
my $db = 0; # Set to 1 for debug, 0 for no-debug.

# Settings:
my $Recurse   = 0; # Recurse subdirectories?  (bool)
my $Regexp    = qr/^(?:ttr-)?screenshot-\pL{3}-\pL{3}-\d{2}-.*\.(?:jpg|png)$/; # old-style tto/ttr screenshot

# Counters:
my $direcount = 0; # Count of directories processed by curdire().
my $filecount = 0; # Count of files processed by curfile().
my $oldfcount = 0; # Count of tto and/or ttr screenshot files found.
my $malfcount = 0; # Count of files skipped because they have malformed names (# of parts is other-than 10).
my $renacount = 0; # Count of files renamed.
my $failcount = 0; # Count of failed file-rename attempts.

# Hashes:
my %Months =
(
   Jan => '01',
   Feb => '02',
   Mar => '03',
   Apr => '04',
   May => '05',
   Jun => '06',
   Jul => '07',
   Aug => '08',
   Sep => '09',
   Oct => '10',
   Nov => '11',
   Dec => '12',
);

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   say "\nNow entering program \"" . get_name_from_path($0) . "\".\n";
   my $t0 = time;
   argv;
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.\n";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =============================================================================

sub argv {
   my $help = 0;  # Print help and exit?
   foreach (@ARGV)
   {
      if ( /^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/ )
      {
         if ( /^-h$/ || /^--help$/    ) { help(); exit(0); }
         if ( /^-r$/ || /^--recurse$/ ) { $Recurse = 1;    }
      }
   }
   return 1;
} # end sub argv

sub curdire {
   ++$direcount;

   # Get and announce current working directory:
   my $curdir = cwd_utf8;
   say '';
   say "Directory # $direcount:";
   say $curdir;

   # Get list of JPG and PNG files in current directory:
   my $curdirfiles = GetFiles($curdir, 'F', $Regexp);

   # Iterate through these files and send each one to curfile:
   foreach my $file (@{$curdirfiles})
   {
      next if ! -e e $file->{Path};
      next if ! -f e $file->{Path};
      curfile($file);
   }
   return 1;
} # end sub curdire

sub curfile ($file) {
   ++$filecount;
   my $cwd  = cwd_utf8();
   my $path = $file->{Path};
   my $name = $file->{Name};
   my $pref = denumerate_file_name(get_prefix($name));
   my $suff = get_suffix($name);

   # If we get to here, this file is a screenshot file with an old-style name, so increment $oldfcount:
   ++$oldfcount;

   # If prefix begins with "screenshot", tack 'tto-' onto left end of prefix:
   if ($pref =~ m/^screenshot/) {$pref = 'tto-' . $pref;}

   # Get parts from prefix:
   my @Parts = split /-/, $pref;

   # Bail if number of parts isn't 10:
   if (10 != scalar(@Parts))
   {
      ++$malfcount;
      warn "\nError in \"rename-toontown-images.pl\":\n"
         . "This file has a malformed name (# of parts is other-than 10):\n"
         . "${path}\n"
         . "Skipping this file and moving on to next.\n\n";
      return 0;
   }

   # Get attributes from parts:
   my $game    = $Parts[0];          # "tto" or "ttr"
   my $ss      = $Parts[1];          # "screenshot"
   my $year    = $Parts[8];          # eg, "2007"
   my $month   = $Months{$Parts[3]}; # eg, "09"
   my $day     = $Parts[4];          # eg, "30"
   my $dow     = $Parts[2];          # eg, "Sun"
   my $hour    = $Parts[5];          # eg, "01"
   my $min     = $Parts[6];          # eg, "05"
   my $sec     = $Parts[7];          # eg, "33"
   my $serial  = $Parts[9];          # eg, "70299"

   my $newpref = $game    . '-' . $ss                              . '_'
               . $year    . '-' . $month . '-' . $day . '-' . $dow . '_'
               . $hour    . '-' . $min   . '-' . $sec              . '_'
               . $serial;
   my $newname = $newpref . $suff;

   my $avaname; # Available name.

   # If $newname is available in $cwd, use that as $avaname:
   if ( ! -e e path($cwd, $newname) )
   {
      $avaname = $newname;
   }

   # Otherwise, try to find an available enumerated name:
   else
   {
      my $avaname = find_avail_enum_name($newname);
   }

   if ('***ERROR***' eq $avaname)
   {
      ++$failcount;
      warn "\nError in \"rename-toontown-images.pl\":\n"
         . "Couldn't find available enumerated name for this file in current directory:\n"
         . "${path}\n"
         . "Skipping this file and moving on to next.\n\n";
      return 0;
   }

   my $newpath = path($cwd, $avaname);

   # If debugging, emulate rename:
   if ($db)
   {
      say "$path -> $newpath"; return 1;
   }

   # Else attempt rename:
   else
   {
      rename_file($path, $newpath)
      and ++$renacount and say  "$path -> $newpath" and return 1
      or  ++$failcount and warn "Couldn't rename $path to $newpath.\n" and return 0;
   } # end else not debugging
   return 1;
} # end sub curfile ($file)

sub stats {
   say '';
   printf("Navigated %6d directories.\n",                      $direcount);
   printf("Processed %6d files.\n",                            $filecount);
   printf("Found     %6d old-style screenshots.\n",            $oldfcount);
   printf("Endured   %6d screenshots with malformed names.\n", $malfcount) if $malfcount;
   printf("Renamed   %6d files.\n",                            $renacount);
   printf("Failed    %6d file rename attempts.\n",             $failcount);
   return 1;
} # end sub stats

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "rename-toontown-images.pl". This program renames all
   Toontown Rewritten screenshots in the current directory (and all subdirectories
   if a -r or --recurse option is used) from their original format to a format
   in which sorting by name also constitutes sorting by date.

   Command lines:
   rename-toontown-images.pl [-h|--help]     (to print this help and exit)
   rename-toontown-images.pl [-r|--recurse]  (to rename TTR images)

   All other options, and all arguments, are ignored.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
__END__
