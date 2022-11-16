#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# find-files-by-type.pl
# Finds directory entries by type (eg: "regular file", "directory", "symbolic link", 
# "socket", "pipe", "block special file", "character special file", etc, etc, etc).
# Written by Robbie Hatley.
# Edit history:
# Thu May 07, 2015: Wrote first draft.
# Mon May 11, 2015: Tidied some things up a bit, including using a
#                   "here" document to clean-up Help().
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Sun Dec 24, 2017: Splice options from @ARGV to @Options;
#                   added file type counters for use if being verbose.
# Tue Sep 22, 2020: Improved Help().
# Wed Feb 17, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory as
#                   its first argument, target as second, and regexp (instead of wildcard) as third.
# Tue Nov 16, 2021: Got rid of most boilerplate; now using "use common::sense" instead.
# Wed Nov 17, 2021: Now using "use Sys::Binmode". Also, fixed hidden bug which was causing program to fail to find
#                   any files with names using non-English letters, by setting "local $_ = e file->{Path}" in sub
#                   "process_current_file". (It was the "sending unencoded names to shell under Sys::Binmode" bug,
#                   previously hidden due to a compensating bug in Perl itself which is removed by Sys::Binmode.)
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate, and now using "common::sense".
# Sat Nov 27, 2021: Shortened sub names. Tested: Works.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';

use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ()  ; # Process @ARGV.
sub curdire ()  ; # Process current directory.
sub curfile ($) ; # Process current file.
sub stats   ()  ; # Print statistics.
sub error   ($) ; # Handle errors.
sub help    ()  ; # Print help and exit.

# ======= VARIABLES: ===================================================================================================

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

#Program Settings:             Meaning:                 Range:     Default:
my $Recurse   = 0          ; # Recurse subdirectories?  (bool)     0
my $Verbose   = 0          ; # Verbose                  (bool)     0
my $Quiet     = 0          ; # Quiet                    (bool)     0
my $Regexp    = qr/^.+$/   ; # Regular expression.      (regexp)   qr/^.+$/
my $Predicate = '-f || -d' ; # File-test boolean.       (boolean expresion using Perl file-test operators)

# Counters:
my $direcount = 0; # Count of directories processed by curdire().
my $filecount = 0; # Count of dir entries processed by curfile().
my $findcount = 0; # Count of files found which match predicate.

# Accumulations of counters from RH::Dir::GetFiles():
our $totfcount = 0; # Count of all targeted directory entries matching regexp and verified by GetFiles().
our $noexcount = 0; # Count of all nonexistent files encountered. 
our $ottycount = 0; # Count of all tty files.
our $cspccount = 0; # Count of all character special files.
our $bspccount = 0; # Count of all block special files.
our $sockcount = 0; # Count of all sockets.
our $pipecount = 0; # Count of all pipes.
our $slkdcount = 0; # Count of all symbolic links to directories.
our $linkcount = 0; # Count of all symbolic links to non-directories.
our $multcount = 0; # Count of all directories with multiple hard links.
our $sdircount = 0; # Count of all directories.
our $hlnkcount = 0; # Count of all regular files with multiple hard links.
our $regfcount = 0; # Count of all regular files.
our $unkncount = 0; # Count of all unknown files.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   my $t0 = time;
   argv;
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub argv ()
{
   my $help   = 0;  # Just print help and exit?
   my @CLArgs = (); # Command-Line Arguments (not including options).
   foreach (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
            if (/^-h$/ || /^--help$/   ) {help; exit 777 ; }
         elsif (/^-r$/ || /^--recurse$/) {$Recurse = 1   ; } 
         elsif (/^-v$/ || /^--verbose$/) {$Verbose = 1   ; }
         elsif (/^-q$/ || /^--quiet$/  ) {$Quiet   = 1   ; }
      }
      else {push @CLArgs, $_;}
   }
   if ($help) {}           # If user wants help, print help and exit 777.
   my $NA = scalar @CLArgs;               # Get number of arguments.
   given ($NA)                            # Given the number of arguments,
   {
      when (0) {error($NA)                 ;} # if $NA == 0, print error & help messages and exit 666;
      when (1) {$Predicate = $CLArgs[0]    ;} # if $NA == 1, set $Predicate;
      when (2) {$Predicate = $CLArgs[0]    ;
                $Regexp    = qr/$CLArgs[1]/;} # if $NA == 2, set $Predicate and $Regexp;
      default  {error($NA)                 ;} # if $NA  > 2, print error & help messages and exit 666.
   }
   return 1;
} # end sub argv ()

sub curdire ()
{
   ++$direcount;
   my $curdir = cwd_utf8;
   say "\nDir # $direcount: $curdir\n" unless $Quiet;
   my $curdirfiles = GetFiles($curdir, 'A', $Regexp);
   if ($Verbose)
   {
      $totfcount += $RH::Dir::totfcount; # all directory entries found
      $noexcount += $RH::Dir::noexcount; # nonexistent files
      $ottycount += $RH::Dir::ottycount; # tty files
      $cspccount += $RH::Dir::cspccount; # character special files
      $bspccount += $RH::Dir::bspccount; # block special files
      $sockcount += $RH::Dir::sockcount; # sockets
      $pipecount += $RH::Dir::pipecount; # pipes
      $slkdcount += $RH::Dir::slkdcount; # symbolic links to directories
      $linkcount += $RH::Dir::linkcount; # symbolic links to non-directories
      $multcount += $RH::Dir::multcount; # directories with multiple hard links
      $sdircount += $RH::Dir::sdircount; # directories
      $hlnkcount += $RH::Dir::hlnkcount; # regular files with multiple hard links
      $regfcount += $RH::Dir::regfcount; # regular files
      $unkncount += $RH::Dir::unkncount; # unknown files
   }
   foreach my $file (@{$curdirfiles})
   {
      curfile($file);
   }
   return 1;
} # end sub curdire ()

sub curfile ($)
{
   ++$filecount;
   my $file = shift;
   local $_ = e $file->{Path};
   if (eval($Predicate))
   {
      say "MATCH: $file->{Path}";
      ++$findcount;
   }
   return 1;
} # end sub curfile ()

sub stats ()
{
   say '';
   say 'Statistics for this directory tree:';
   say "Navigated $direcount directories.";
   say "Found $filecount items matching regexp \"$Regexp\".";
   say "Found $findcount items also matching predicate \"$Predicate\".";
   if ($Verbose)
   {
      say '';
      say 'Directory entries encountered in this tree included:';
      printf("%7u total files\n",                            $totfcount);
      printf("%7u nonexistent files\n",                      $noexcount);
      printf("%7u tty files\n",                              $ottycount);
      printf("%7u character special files\n",                $cspccount);
      printf("%7u block special files\n",                    $bspccount);
      printf("%7u sockets\n",                                $sockcount);
      printf("%7u pipes\n",                                  $pipecount);
      printf("%7u symbolic links to directories\n",          $slkdcount);
      printf("%7u symbolic links to non-directories\n",      $linkcount);
      printf("%7u directories with multiple hard links\n",   $multcount);
      printf("%7u directories\n",                            $sdircount);
      printf("%7u regular files with multiple hard links\n", $hlnkcount);
      printf("%7u regular files\n",                          $regfcount);
      printf("%7u files of unknown type\n",                  $unkncount);
   }
   return 1;
} # end sub stats ()

sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: you typed $NA arguments, but \"find-files-by-type.pl\"
   requires either 1 or 2 two arguments. Help follows:

   END_OF_ERROR
   help;
   exit 666;
} # end error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "find-files-by-type.pl", Robbie Hatley's nifty file finding
   utility. Given a boolean expression using Perl file test operators,
   and an optional Csh-style file-path wildcard, this program will find
   all files in the current directory (and in all subdirectories if a
   -r or --recurse option is used) which match the given specifications.
   For example, you could us the following command line to find all SYMLINKD
   objects in current directory branch:

   find-files-by-type.pl -r '(-d && -l)'

   Command line:
   find-files-by-type.pl [options] Arg1 [Arg2]

   Description of options:
   Option:              Meaning:
   -h or --help         Print help and exit.
   -r or --recurse      Recurse subdirectories.
   -v or --verbose      Be verbose.
   -q or --quiet        Be quiet (don't print directories being processed).

   (Note that a "target" option is NOT provided, as that would conflict with the
   whole idea of this program, which is to specify what types of files to look for
   by using Perl file-test boolean expressions.)

   Description of arguments:

   "find-files-by-type.pl" takes either 1 or 2 arguments:

   Argument 1 is a boolean exression using Perl file-test operators. The
   expression must be enclosed in parentheses (else this program will confuse
   your file-test operators for options), and then enclosed in single quotes
   (else the shell won't pass your expression to this program intact).
   Here are some examples of valid and invalid first arguments:

   '(-d && -l)'  # VALID:   Finds symbolic links to directories
   '(-l && !-d)' # VALID:   Finds symbolic links to non-directories
   '(-b)'        # VALID:   Finds block special files
   '(-c)'        # VALID:   Finds character special files
   '(-S || -p)'  # VALID:   Finds sockets and pipes.  (S must be CAPITAL S!  )

    '-d && -l'   # INVALID: missing parentheses       (confuses program      )
    (-d && -l)   # INVALID: missing quotes            (confuses shell        )
     -d && -l    # INVALID: missing parens AND quotes (confuses prgrm & shell)

   Argument 2 (optional), if present, must be a Perl-Compliant Regular Expression
   specifying which items to process. To specify multiple patterns, use the | 
   alternation operator. To apply pattern modifier letters, use an Extended 
   RegExp Sequence. For example, if you want to search for items with names 
   containing "cat", "dog", or "horse", title-cased or not, you could use this 
   regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead. 

   Description of Operation:

   "find-files-by-type.pl" will first obtain a list of file records for all
   files matching the regex in Argument 2 (or qr/^.+$/ if no regex is given)
   in the current directory (and all subdirectories if a -r or --recurse option
   is used). Then for each file record matching the regex, the boolean expression
   given by Argument 1 is then evaluated. If it is true, the file's path is
   printed; otherwise, the file is skipped.

   If the number of arguments is not 1 or 2, this program will print an
   error message and abort.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end help ()
