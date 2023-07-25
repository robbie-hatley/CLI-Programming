#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# for-each-immediate-subdirectory.pl
# Executes a given command once for each immediate subdirectory of the current directory (but not for the
# current directory or any lower-level subdirectories). NOTE: this is very different from for-each-dir.pl,
# which walks the ENTIRE directory tree downward from current node, rather than just immediate subdirectories.
#
# Edit history:
# Mon Apr 08, 2019: Wrote it.
# Fri Jul 19, 2019: Simplified it.
# Sat Jan 16, 2021: Refactored. Now using indented here documents.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Thu Nov 25, 2021: Renamed to "for-each-immediate-subdirectory.pl" to avoid confusion. Shortened subroutine names.
#                   Now using GetFiles instead of glob_utf8, so as to more-easily get fully-qualified directory names.
#                   Also added time-stamping.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ();
sub curdire ($);
sub stats   ();
sub error   ($);
sub help    ();

# ======= VARIABLES: ===================================================================================================

my $db         = 0;   # Set to 1 to debug, 0 to non debug.
my $StartDir   = '';  # Starting directory.
my $Command    = '';  # Command to be executed (string).
my $direcount  = 0;   # Count of directories processed by process_current_directory().

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   my $t0 = time;
   argv();
   $StartDir = cwd_utf8;
   my $SubDirs = GetFiles($StartDir, 'D');
   foreach my $SubDir (@{$SubDirs})
   {
      curdire($SubDir->{Path});
   }
   stats();
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ======================================================================================

sub argv ()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL]{1,}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         if (/^-h$/ || /^--help$/) {help; exit 777;}
         splice @ARGV, $i, 1;
         --$i;
      }
   }
   my $NA = scalar(@ARGV);            # Get number of arguments.
   given ($NA)
   {                                  # Given the number of arguments,
      when (1) {$Command = $ARGV[0];} # if 1, set $Command;
      default  {error($NA);}          # else, print error and help messages and exit.
   }
   return 1;
} # end sub argv ()

sub curdire ($)
{
   # Increment directory counter:
   ++$direcount;

   my $SubDir = shift;

   # cd to subdirectory:
   chdir e $SubDir;

   # Announce subdirectory:
   say "\nSubdir # $direcount: \"$SubDir\"\n";

   # Execute Command:
   say("Executing command \"$Command\"");
   system(e $Command) if not $db;

   # cd back to starting directory and return:
   chdir e $StartDir;
   return 1;
} # end sub curdire ($)

sub stats ()
{
   say "\nApplied command \"$Command\" to $direcount immediate subdirectories";
   say "of starting directory \"$StartDir\".";
   return 1;
} # end sub stats ()

sub error ($)
{
   my $NA = shift;
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);
   Error: You typed $NA arguments, but this program requires exactly 1 argument.
   Help follows:

   END_OF_ERROR
   help;
   exit(666);
} # end sub error ($)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "for-each-subdir.pl", Robbie Hatley's nifty program for 
   executing a given command once in each immediate subdirectory of 
   the current directory (but NOT the current directory or any lower-level
   subdirectories). This program will chdir to each immediate subdirectory,
   execute the given command, chdir back to the starting directory, chdir to
   the next immediate subdirectory, etc, eventually ending back in the 
   starting directory.

   Command lines:
   for-each-immediate-subdirectory.pl [-h|--help]  (to print this help and exit)
   for-each-immediate-subdirectory.pl 'command'    (to run command on subdirs)

   This program takes exactly 1 argument, which must be a command
   to be executed for each immediate subdirectory of the current directory.
   The "command" must be something that Bash can execute: a program, a script,
   a system command, etc. I recommend not using commands which, themselves,
   walk directory trees, as this could interfere with the recursion.
   Also, I recommend enclosing the command in 'single quotes' to prevent
   the shell from doing unwanted processing on the command string before
   passing it to this program.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
