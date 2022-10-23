#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# list-paths.pl
# Recursively lists all paths to all objects in and under current dir node.
#
# Edit history:
# Sun Apr 05, 2020: Wrote it.
# Fri Feb 12, 2021: Widened to 110. Got rid of "Settings" hash. No strict. Accumulators are now in main::.
# Wed Feb 17, 2021: Refactored to use the new GetFiles(), which now requires a fully-qualified directory as its first
#                   argument, target as second, and regexp (instead of wildcard) as third.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Sat Nov 27, 2021: Fixed a wide character (missing e) bug and shortened sub names. Tested: Works.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use RH::Dir;

# ======================================================================================================================
# SUBROUTINE PRE-DECLARATIONS:

sub argv    ()  ; # Process @ARGV.
sub curdire ()  ; # Process current directory.
sub curfile ($) ; # Process current file.
sub stats   ()  ; # Print statistics.
sub error   ($) ; # Handle errors.
sub help    ()  ; # Print help and exit.

# ======================================================================================================================
# VARIABLES:

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# Settings:                Meaning:                 Possible values:  Default value:
# ------------------------------------------------------------------------------------------------------------
my $Recurse   = 1;       # Recurse subdirectories?  (bool)            1
my $Verbose   = 0;       # Verbose                  (bool)            0
my $Target    = 'A';     # Target                   F|D|B|A           'A'
my $Regexp    = '.+';    # Regular expression.      (regexp)          '.+'

# Counters:
my $direcount = 0; # Count of directories processed by curdire().
my $filecount = 0; # Count of    files    processed by curfile().

# Accumulations of counters from RH::Dir::GetFiles():
my $totfcount = 0; # Count of all directory entries matching $Target and $Regexp.
my $noexcount = 0; # Count of all nonexistent files encountered. 
my $ottycount = 0; # Count of all tty files.
my $cspccount = 0; # Count of all character special files.
my $bspccount = 0; # Count of all block special files.
my $sockcount = 0; # Count of all sockets.
my $pipecount = 0; # Count of all pipes.
my $slkdcount = 0; # Count of all symbolic links to directories.
my $linkcount = 0; # Count of all symbolic links to non-directories.
my $multcount = 0; # Count of all directories with multiple hard links.
my $sdircount = 0; # Count of all directories.
my $hlnkcount = 0; # Count of all regular files with multiple hard links.
my $regfcount = 0; # Count of all regular files.
my $unkncount = 0; # Count of all unknown files.

# Lists of paths which do and do-not exist:
my @LiveFiles;
my @DeadFiles;

# ======================================================================================================================
# MAIN BODY OF PROGRAM:

{ # begin main
   # Get and process options and arguments:
   argv();

   # If using recursion, recurse subdirectories:
   $Recurse and RecurseDirs {curdire} or curdire;

   # Print results:
   stats();

   # We're done, so exit:
   exit 0;
} # end main

# ======================================================================================================================
# SUBROUTINE DEFINITIONS:

sub argv ()
{
   my $help   = 0;
   my @CLArgs = ();
   foreach (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         if ('-h' eq $_ || '--help'         eq $_) {$help    =  1 ;}
         if ('-l' eq $_ || '--local'        eq $_) {$Recurse =  0 ;}
         if ('-r' eq $_ || '--recurse'      eq $_) {$Recurse =  1 ;} # DEFAULT
         if ('-q' eq $_ || '--quiet'        eq $_) {$Verbose =  0 ;} # DEFAULT
         if ('-v' eq $_ || '--verbose'      eq $_) {$Verbose =  1 ;}
         if ('-f' eq $_ || '--target=files' eq $_) {$Target  = 'F';}
         if ('-d' eq $_ || '--target=dirs'  eq $_) {$Target  = 'D';}
         if ('-b' eq $_ || '--target=both'  eq $_) {$Target  = 'B';}
         if ('-a' eq $_ || '--target=all'   eq $_) {$Target  = 'A';} # DEFAULT
      }
      else {push @CLArgs, $_;}
   }

   # If user wants help, just print help and exit:
   if ($help) {help; exit 777;}

   # Otherwise, we must have 0 or 1 arguments:
   my $NumArgs = scalar(@CLArgs);
   given ($NumArgs)
   {
      when (0)  {                    ;} # Do nothing.
      when (1)  {$Regexp = $CLArgs[0];} # Set regexp.
      default   {error($NumArgs)     ;} # Print error and help messages and exit.
   }
   return 1;
} # end sub argv ()

sub curdire ()
{
   # Increment directory counter:
   ++$direcount;

   # Get current working directory:
   my $curdir = cwd_utf8;

   # Get list of targeted files in current directory:
   my $curdirfiles = GetFiles($curdir, $Target, $Regexp);

   # If being verbose, also accumulate all counters from RH::Dir:: to main:: :
   if ($Verbose)
   {
      $main::totfcount += $RH::Dir::totfcount; # all files
      $main::noexcount += $RH::Dir::noexcount; # nonexistent files
      $main::ottycount += $RH::Dir::ottycount; # tty files
      $main::cspccount += $RH::Dir::cspccount; # character special files
      $main::bspccount += $RH::Dir::bspccount; # block special files
      $main::sockcount += $RH::Dir::sockcount; # sockets
      $main::pipecount += $RH::Dir::pipecount; # pipes
      $main::slkdcount += $RH::Dir::slkdcount; # symbolic links to directories
      $main::linkcount += $RH::Dir::linkcount; # symbolic links to non-directories
      $main::multcount += $RH::Dir::multcount; # directories with multiple hard links
      $main::sdircount += $RH::Dir::sdircount; # directories
      $main::hlnkcount += $RH::Dir::hlnkcount; # regular files with multiple hard links
      $main::regfcount += $RH::Dir::regfcount; # regular files
      $main::unkncount += $RH::Dir::unkncount; # unknown files
   }

   # Iterate through these files and process each one:
   foreach my $file (@{$curdirfiles}) 
   {
      curfile($file);
   }
   return 1;
} # end sub curdire ()

sub curfile ($)
{
   # Increment file counter:
   ++$filecount;

   # Get current file:
   my $file = shift;

   # If current file exists, record its hash in @LiveFiles:
   if (-e e $file->{Path})
   {
      push @LiveFiles, $file;
   }

   # If current file unexists, record its hash in @DeadFiles:
   else
   {
      push @DeadFiles, $file;
   }
   return 1;
} # end sub curfile ($)

sub stats ()
{
   if (scalar(@LiveFiles))
   {
      say 'Paths found:' if $Verbose;
      say "$_->{Path}" for (@LiveFiles);
   }

   if (scalar(@DeadFiles))
   {
      say '';
      say 'Paths NOT found:';
      say "$_->{Path}" for (@DeadFiles);
   }

   if ($Verbose)
   {
      say '';
      printf("Traversed %6u directories.\n", $direcount);
      printf("Found %6u paths matching target \"%s\" and regexp \"%s\".\n", $filecount, $Target, $Regexp);
      say '';
      printf("Found %6u total files\n",                            $main::totfcount);
      printf("Found %6u nonexistent files\n",                      $main::noexcount);
      printf("Found %6u tty files\n",                              $main::ottycount);
      printf("Found %6u character special files\n",                $main::cspccount);
      printf("Found %6u block special files\n",                    $main::bspccount);
      printf("Found %6u sockets\n",                                $main::sockcount);
      printf("Found %6u pipes\n",                                  $main::pipecount);
      printf("Found %6u symbolic links to directories\n",          $main::slkdcount);
      printf("Found %6u symbolic links to non-directories\n",      $main::linkcount);
      printf("Found %6u directories with multiple hard links\n",   $main::multcount);
      printf("Found %6u directories\n",                            $main::sdircount);
      printf("Found %6u regular files with multiple hard links\n", $main::hlnkcount);
      printf("Found %6u regular files\n",                          $main::regfcount);
      printf("Found %6u files of unknown type\n",                  $main::unkncount);
   }
   return 1;
} # sub stats ()

sub error ($)
{
   my $NumArgs = shift;
   say "Error: you typed $NumArgs arguments, but \"list-paths.pl\" takes";
   say 'at most 1 argument, which, if present, must be a regular expression';
   say 'specifying which directory entries to process. (Did you forget to';
   say 'put the regex in \'single quotes\'?) Help follows:';
   say '';
   help();
   exit(666);
} # end sub error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "list-paths.pl". This program lists all paths in finds in the
   current directory (and all subdirectories if a -r or --recurse option is used).

   Command line:
   list-paths.pl [options] [argument]

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.
   "-l" or "--local"            Don't recurse subdirectories.
   "-r" or "--recurse"           DO   recurse subdirectories.    (DEFAULT)
   "-q" or "--quiet"            Don't be verbose.                (DEFAULT)
   "-v" or "--verbose"           DO   be verbose.
   "-f" or "--target=files"     List paths of regular files only.
   "-d" or "--target=dirs"      List paths of directories only.
   "-b" or "--target=both"      List both files and directories.
   "-a" or "--target=all"       List ALL paths.                  (DEFAULT)

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

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
