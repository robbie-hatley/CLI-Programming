#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# rdj.pl
# Removes all Thumbs*.db (windows thumbnail database) and pspbrwse*.jbf (Jasc Browser File) files from the current
# directory, and also from all subdirs if a "-r" or "-recurse" option is used.
#
# Edit history:
# Sun Jan 31, 2016: Wrote it.
# Fri Apr 15, 2016: Updated for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Mon Dec 18, 2017: Corrected formatting, comments, and help_msg.
# Thu Oct 11, 2018: Now also erasing desktop.ini if -i or --ini.
# Fri Oct 12, 2018: Added "verbose" mode (announces directories).
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Mon Nov 22, 2021: Dramatically shortened names of subroutines. Also fixed major bug which was causing this program to
#                   fail to find any db, jbf, or ini files (turned out to be a $_ issue).
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use Unicode::Normalize qw( NFD NFC );

use RH::Dir;
#use RH::Util;

# ======= SUBROUTINE PRE-DECLARATIONS ==================================================================================

sub argv;
sub curdire;
sub stats;
sub error;
sub help;

# ======= GLOBAL VARIABLES =============================================================================================

my $db = 0;
my @Options;
my @Arguments;
my %Settings = (             # Meaning of setting:        Possible values:
   Help         => 0,         # Print help and exit?       (bool)
   Recurse      => 0,         # Recurse subdirectories?    (bool)
   Ini          => 0,         # Also erase desktop.ini?    (bool)
   Verbose      => 0,         # Announce directories?      (bool)
);

our $direcount = 0; # Count of directories processed.
our $dbfdcount = 0; # Count of Thumbs*.db  files found.
our $dbercount = 0; # Count of Thumbs*.db  files erased.
our $dbnecount = 0; # Count of Thumbs*.db  files not erased.
our $jbfdcount = 0; # Count of pspbrwse*.jbf files found.
our $jbercount = 0; # Count of pspbrwse*.jbf files erased.
our $jbnecount = 0; # Count of pspbrwse*.jbf files not erased.
our $difdcount = 0; # Count of desktop*.ini files found.
our $diercount = 0; # Count of desktop*.ini files erased.
our $dinecount = 0; # Count of desktop*.ini files not erased.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   print("\nNow entering \"rdj.pl\".\n\n") if $Settings{Verbose};

   # Process @ARGV:
   argv;

   # If user wants help, just print help and bail:
   if ( $Settings{Help} ) { help; exit 777; }

   # If number of arguments is out of range, bail:
   if ( @Arguments != 0 ) { error; help; exit 666; }

   # If user asked for recursion, recurse subdirectories; otherwise process current directory only:
   $Settings{Recurse} and RecurseDirs {curdire} or curdire;

   # Print stats:
   stats if $Settings{Verbose};

   # We be done, so scram:
   print("\nNow exiting \"rdj.pl\".\n\n") if $Settings{Verbose};
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub argv
{
   for (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/) {push(@Options,   $_);}
      else                                                 {push(@Arguments, $_);}
   }

   foreach (@Options) 
   {
      if ('-h' eq $_ || '--help'    eq $_) {$Settings{Help}    = 1 ;}
      if ('-r' eq $_ || '--recurse' eq $_) {$Settings{Recurse} = 1 ;}
      if ('-i' eq $_ || '--ini'     eq $_) {$Settings{Ini}     = 1 ;}
      if ('-v' eq $_ || '--verbose' eq $_) {$Settings{Verbose} = 1 ;}
   }
   return 1;
} # end sub argv

sub curdire
{
   ++$direcount;

   # Get current working directory:
   my $curdir = cwd_utf8;

   # Announce directory if being verbose:
   if ($Settings{Verbose})
   {
      say '';
      say "Now processing directory #$direcount: $curdir";
   }

   # Get list of directory entries:
   my $dh = undef;
   opendir($dh, e $curdir) or die "Can't open  directory \"$curdir\"\n$!\n";
   my @entries = d readdir $dh;
   closedir($dh) or die "Can't close directory \"$curdir\"\n$!\n";
   
   if ($db)
   {
      say '';
      say 'Directory entries:';
      say for @entries;
      say '';
   }

   # Get lists of db, jbf, and ini files:
   my @db  = ();
   my @jbf = ();
   my @ini = ();
   ENTRY: foreach my $entry (@entries)
   {
      if ($db)
      {
         say '';
         say 'current entry:';
         say $entry;
         say '';
      }

      # Skip '.', '..', directories, and non-regular files:
      next ENTRY if $entry eq '.';
      next ENTRY if $entry eq '..';
      next ENTRY if   -d e $entry;
      next ENTRY if ! -f e $entry;

      if ($entry =~ m/^Thumbs.*\.db$/)
      {
         say " db: $entry" if $db;
         push(@db, $entry);
         ++$dbfdcount;
      }

      if ($entry =~ m/^pspbrwse.*\.jbf$/)
      {
         say "jbf: $entry" if $db;
         push(@jbf, $entry);
         ++$jbfdcount;
      }

      if ($entry =~ m/^desktop.*\.ini$/ && $Settings{Ini})
      {
         say "ini: $entry" if $db;
         push(@ini, $entry);
         ++$difdcount;
      }
   }

   if ($db)
   {
      say '';
      say 'db files found:';
      say for @db;
      say '';
      say 'jbf files found:';
      say for @jbf;
      say '';
      say 'ini files found:';
      say for @ini;
      say '';
   }

   # Try to erase each file in @db :
   foreach (@db)
   {
      unlink(e($_)) and ++$dbercount and say("erased: $curdir/$_") 
                     or ++$dbnecount and say("couldn't erase: $curdir/$_");
   }

   # Try to erase each file in @jbf :
   foreach (@jbf)
   {
      unlink(e($_)) and ++$jbercount and say("erased: $curdir/$_") 
                     or ++$jbnecount and say("couldn't erase: $curdir/$_");
   }

   # If also erasing ini files, try to erase each file in @ini :
   if ($Settings{Ini})
   {
      foreach (@ini)
      {
         unlink(e($_)) and ++$diercount and say("erased: $curdir/$_") 
                        or ++$dinecount and say("couldn't erase: $curdir/$_");
      }
   }

   return 1;
} # end sub curdire

sub stats
{
   print("\nStatistics for \"rdj.pl\":\n");
   say "Navigated $direcount directories.";
   say "Found $dbfdcount Thumbs*.db files.";
   say "Erased $dbercount Thumbs*.db files.";
   say "Tried but failed to erase $dbnecount Thumbs*.db files.";
   say "Found $jbfdcount pspbrwse*.jbf files.";
   say "Erased $jbercount pspbrwse*.jbf files.";
   say "Tried but failed to erase $jbnecount pspbrwse*.jbf files.";
   if ($Settings{Ini})
   {
      say "Found $difdcount desktop*.ini files.";
      say "Erased $diercount desktop*.ini files.";
      say "Tried but failed to erase $dinecount desktop*.ini files.";
   }
   return 1;
} # end sub stats

sub error
{
   say 'Error: This program takes no arguments.';
   say '';
   return 1;
} # end sub error

sub help
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "rdj". This program erases the following files from the current 
   directory (and from all subdirectories if a -r or --recurse option is used):
   Thumbs*.db     (old Windows thumbnail database files)
   pspbrwse*.jbf  (Jasc Browser Files used by Paint Shop Pro)
   desktop*.ini   (optional, if -i or --ini option is used)

   Command line:
   rdj.pl [options]

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print this help and exit.
   "-r" or "--recurse"          Recurse subdirectories (but not links).
   "-i" or "--ini"              Also erase desktop.ini files.
   "-v" or "--verbose"          Announce directories.

   This program takes no arguments. If any argument is used (not counting one of
   the options specified above), this program will just print an error message
   and exit.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
