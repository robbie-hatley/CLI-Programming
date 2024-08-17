#!/usr/bin/env -S perl -C63

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# file-mime-types.pl
# Prints the MIME types of all files in the current directory (and all subdirectories if a -r or --recurse
# option is used).
# Written by Robbie Hatley.
# Edit history:
# Mon Mar 20, 2023: Wrote it.
# Thu Aug 03, 2023: Renamed from "file-types.pl" to "file-mime-types.pl". Reduced width from 120 to 110.
#                   Removed "-l", and "--local" options, as these are already default. Improved help.
# Thu Sep 07, 2023: Nixed superfluous "double quotes" in help. Got rid of "/o" on all qr().
#                   Improved entry/exit message-printing in main (now using $pname).
# Thu Aug 15, 2024: -C63; got rid of unnecessary "use" statements.
##############################################################################################################

use v5.36;
use utf8;
use Cwd 'getcwd';
use File::Type;
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

# ======= VARIABLES: =========================================================================================

# Settings:                   Meaning:                     Range:    Default:
my $Db        = 0         ; # Debug (print diagnostics)?   bool      0 (Don't print diagnostics.)
my $Recurse   = 0         ; # Recurse subdirectories?      bool      0 (Don't recurse.)
my $RegExp    = qr/^.+$/  ; # Regular Expression.          regexp    qr/^.+$/o (matches all strings)

# Counters:
my $direcount = 0         ; # Count of directories processed by curdire().
my $filecount = 0         ; # Count of dir entries processed by curfile().

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   my $pname = get_name_from_path($0);
   argv;
   say    STDERR "Now entering program \"$pname\".";
   say    STDERR "RegExp  = $RegExp";
   say    STDERR "Recurse = $Recurse";
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $ms = 1000 * (time - $t0);
   print  STDERR "Now exiting program \"$pname\".\n";
   printf STDERR "Execution time was %.3fms.\n", $ms;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

# Process @ARGV :
sub argv {
   # Get options and arguments:
   my @opts = ();            # options
   my @args = ();            # arguments
   my $end = 0;              # end-of-options flag
   my $s = '[a-zA-Z0-9]';    # single-hyphen allowable chars (English letters, numbers)
   my $d = '[a-zA-Z0-9=.-]'; # double-hyphen allowable chars (English letters, numbers, equal, dot, hyphen)
   for ( @ARGV ) {
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
   if ( $Db ) {
      say STDERR '';
      say STDERR "\$opts = (", join(', ', map {"\"$_\""} @opts), ')';
      say STDERR "\$args = (", join(', ', map {"\"$_\""} @args), ')';
   }

   # Process arguments:
   my $NA = scalar(@args);     # Get number of arguments.
   if ( $NA >= 1 ) {           # If number of arguments >= 1,
      $RegExp = qr/$args[0]/;  # set $RegExp to $args[0].
   }
   if ( $NA >= 2 && !$Db ) {   # If number of arguments >= 2 and we're not debugging,
      error($NA);              # print error message,
      help;                    # and print help message,
      exit 666;                # and exit, returning The Number Of The Beast.
   }

   # Return success code 1 to caller:
   return 1;
} # end sub argv

# Process current directory:
sub curdire
{
   # Increment directory counter:
   ++$direcount;

   # Get and announce current working directory:
   my $cwd = d getcwd;
   say STDOUT "\nDirectory # $direcount: $cwd\n";

   # Get list of fully-qualified paths of all regular files in current directory matching $RegExp:
   my $curfiles = GetFiles($cwd, 'F', $RegExp);

   # Set-up a file-typing functor and file-type variable:
   my $typer = File::Type->new();
   my $type  = '';

   # Iterate through $curdirpaths and print the MIME type of each file:
   foreach my $file (@$curfiles)
   {
      ++$filecount;
      $type = $typer->checktype_filename($file->{Path});
      if ( ! defined $type ) {$type = 'undefined';}
      printf("%-80s = %-30s\n", $file->{Name}, $type);
   }
   return 1;
} # end sub curdire

# Print statistics for this program run:
sub stats
{
   say "\nFile-Mime-Types Statistics for this directory tree:";
   say "Navigated $direcount directories.";
   say "Found $filecount paths matching given regexp.";
   return 1;
} # end sub stats

# Handle errors:
sub error ($err_msg)
{
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $err_msg arguments, but this program takes at most 1 argument,
   which, if present, must be a Perl-Compliant Regular Expression specifying
   which directory entries to process.
   END_OF_ERROR
   return 1;
} # end sub error

# Print help:
sub help
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to "file-mime-types.pl", Robbie Hatley's nifty file MIME types printer.
   This program prints the MIME type of every file in the current directory
   (and all subdirectories if a -r or --recurse option is used).

   -------------------------------------------------------------------------------
   Command lines:

   file-types.pl -h | --help               (to print help and exit)
   file-types.pl [options] [arguments]     (to print MIME types of files)

   -------------------------------------------------------------------------------
   Description of options:

   Option:             Meaning:
   -h or --help        Print this help.
   -e or --debug       Print diagnostics
   -l or --local       Don't recurse subdirectories.    (DEFAULT)
   -r or --recurse     Do    recurse subdirectories.
   All other options are ignored.

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

   Happy type printing!
   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
