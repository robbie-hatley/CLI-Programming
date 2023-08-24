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
# Thu Aug 24, 2023: Redefined what characters may exist in options:
#                   short option = 1 hyphen , NOT followed by a hyphen, followed by [a-zA-Z0-9]+
#                   long  option = 2 hyphens, NOT followed by a hyphen, followed by [a-zA-Z0-9-=]+
#                   I use negative look-aheads to check for "NOT followed by a hyphen". Also, dramatically
#                   improved help. Options now include help, debug, quiet, verbose, local, recurse.
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
sub error;
sub help;

# ======= VARIABLES: =========================================================================================

# Debug?

# Settings:
my $db        = 0; # Print diagnostics and exit?
my $Verbose   = 0; # Print stats?
my $Recurse   = 0; # Recurse subdirectories?
my $RegExp    = qr/^(?:ttr-)?screenshot-\pL{3}-\pL{3}-\d{2}-.*\.(?:jpg|png)$/io; # tto or ttr screenshot

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
   my $t0 = time;
   argv;
   my $pname = get_name_from_path($0);
   if ( $db || $Verbose >= 1 ) {
      say STDERR '';
      say STDERR "Now entering program \"$pname\".";
      say STDERR "\$Verbose   = $Verbose             ";
      say STDERR "\$Recurse   = $Recurse             ";
      say STDERR "\$RegExp    = $RegExp              ";
   }

   $Recurse and RecurseDirs {curdire} or curdire;

   stats;
   my $ms = 1000 * (time - $t0);
   if ( $Verbose >= 1 ) {
      printf STDERR "\nNow exiting program \"%s\". Execution time was %.3fms.\n", $pname, $ms;
   }
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =============================================================================

sub argv {
   # Get options and arguments:
   my @opts = ()               ; # options
   my @args = ()               ; # arguments
   my $end  = 0                ; # end-of-options flag
   my $s    = '[a-zA-Z0-9]'    ; # single-hyph allowable chars (English letters, numbers)
   my $d    = '[a-zA-Z0-9=.-]' ; # double-hyph allowable chars (English letters, numbers, equal, dot, hyphen)
   for ( @ARGV ) {
      /^--$/ and $end = 1 and next; # -- = end-of-options marker = construe all further CL items as arguments
      !$end                         # If we haven't reached end-of-options,
      && /^-(?!-)$s+$|^--(?!-)$d+$/  # and if we get a valid short or long option,
      and push @opts, $_            # then push item to @opts
      or  push @args, $_;           # else push item to @args.
   }

   # Process options:
   for ( @opts ) {
      /^-$s*h|^--help$/     and help and exit 777 ;
      /^-$s*e|^--debug$/    and $db      =  1     ;
      /^-$s*q|^--quiet$/    and $Verbose =  0     ; # DEFAULT
      /^-$s*v|^--verbose$/  and $Verbose =  1     ;
      /^-$s*l|^--local$/    and $Recurse =  0     ; # DEFAULT
      /^-$s*r|^--recurse$/  and $Recurse =  1     ;
   }
   if ( $db ) {
      say   STDERR '';
      print STDERR "opts = ("; print STDERR map {'"'.$_.'"'} @opts; say STDERR ')';
      print STDERR "args = ("; print STDERR map {'"'.$_.'"'} @args; say STDERR ')';
   }

   # Ignore all arguments.

   # Return success code 1 to caller:
   return 1;
} # end sub argv

sub curdire {
   ++$direcount;

   # Get and announce current working directory:
   my $curdir = cwd_utf8;
   say STDOUT '';
   say STDOUT "Directory # $direcount:";
   say STDOUT $curdir;

   # Get list of JPG and PNG files in current directory:
   my $curdirfiles = GetFiles($curdir, 'F', $RegExp);

   # Iterate through these files and send each one to curfile:
   foreach my $file (@$curdirfiles) {
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
      say STDOUT "$name -> $newname"; return 1;
   }

   # Else attempt rename:
   else
   {
      rename_file($path, $newpath)
      and ++$renacount and say STDOUT "$path -> $newpath" and return 1
      or  ++$failcount and warn "Couldn't rename $path to $newpath.\n" and return 0;
   } # end else not debugging
   return 1;
} # end sub curfile ($file)

sub stats {
   if ( $db || $Verbose >= 1 ) {
      say '';
      printf("Navigated %6d directories.\n",                      $direcount);
      printf("Processed %6d files.\n",                            $filecount);
      printf("Found     %6d old-style screenshots.\n",            $oldfcount);
      printf("Endured   %6d screenshots with malformed names.\n", $malfcount) if $malfcount;
      printf("Renamed   %6d files.\n",                            $renacount);
      printf("Failed    %6d file rename attempts.\n",             $failcount);
   }
   return 1;
} # end sub stats

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "rename-toontown-images.pl". This program renames all
   Toontown Rewritten screenshots in the current directory (and all subdirectories
   if a -r or --recurse option is used) from their original format to a format
   in which sorting by name also constitutes sorting by date.

   -------------------------------------------------------------------------------
   Command Lines:
   program-name.pl -h | --help                       (to print this help and exit)
   program-name.pl [options] [Arg1] [Arg2] [Arg3]    (to rename TT images )

   -------------------------------------------------------------------------------
   Description of options:

   Option:            Meaning:
   -h or --help       Print help and exit.
   -e or --debug      Print diagnostics and exit.
   -q or --quiet      Be quiet.                       (DEFAULT)
   -v or --verbose    Be verbose.
   -l or --local      Don't recurse subdirectories.   (DEFAULT)
   -r or --recurse    Do    recurse subdirectories.

   Multiple single-letter options may be piled-up after a single hyphen.
   For example, use -vr to verbosely and recursively process items.

   If multiple conflicting separate options are given, later overrides earlier.
   If multiple conflicting single-letter options are piled after a single colon,
   the result is determined by this descending order of precedence: herlvq.

   All options not listed above are ignored.

   -------------------------------------------------------------------------------
   Description of arguments:

   This program ignores all arguments.

   Happy Toontown image renaming!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
__END__
