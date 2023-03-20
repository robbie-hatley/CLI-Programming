#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# for-each-directory-in-tree.pl
# Executes a given command once for each directory in the directory tree descending from the current node.
#
# Edit history:
# Thu Jun 25, 2015: Wrote first draft.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Sat Jan 02, 2021: Simplified and updated.
# Sat Jan 16, 2021: Refactored. Now using indented here documents.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Thu Nov 25, 2021: Renamed "for-each-directory-in-tree.pl" to avoid confusion with other programs. Shortened subroutine
#                   names. Added time stamping.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes qw( time );

use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ()  ; # Process @ARGV.
sub curdire ()  ; # Process current directory.
sub stats   ()  ; # Print statistics.
sub error   ($) ; # 
sub help    ()  ; # Print help.

# ======= VARIABLES: ===================================================================================================

my $db         = 0;   # Set to 1 to debug, 0 to non debug.
my $StartDir   = '';  # Starting current working directory.
my $Command    = '';  # Command to be executed (string).
my $direcount  = 0;   # Count of directories processed by curdire().

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   my $t0 = time;
   argv;
   $StartDir = cwd_utf8();
   RecurseDirs {curdire};
   stats;
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

sub curdire ()
{
   # Increment directory counter:
   ++$direcount;

   # Get and state current working directory:
   my $curdir = cwd_utf8;
   say "\nDirectory # $direcount: \"$curdir\"\n";

   # Execute Command:
   say("Executing command \"$Command\"");
   system(e $Command) if not $db;

   return 1;
} # end sub curdire ()

sub stats ()
{
   say "\nApplied command \"$Command\" to $direcount directories in tree";
   say "descending from node \"$StartDir\".";
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
   print ((<<"   END_OF_HELP") =~ s/^   //gmr);
   Welcome to "for-each-dir.pl", Robbie Hatley's nifty program for
   executing a given command once for each directory of the current
   directory tree descending from the current node. 

   Command lines:
   for-each-dir.pl [-h|--help]  (to print this help and exit)
   for-each-dir.pl command      (to apply command to each directory)

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.

   Description of arguments:
   This program takes exactly 1 argument, which must be a command
   to be executed for the current directory and each of its subdirectories.
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
