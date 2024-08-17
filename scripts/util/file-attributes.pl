#!/usr/bin/env -S perl -C63

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# file-attributes.pl
# Prints attributes of the file (if any) at path ARGV[0].
#
# Edit history:
# Tue Jun 09, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Mon Dec 18, 2017: Improved comments and help and error messages.
# Sat Nov 20, 2021: Now using "common::sense" and "Sys::Binmode".
# Thu Aug 15, 2024: Width 120->110, upgraded from "v5.32" to "v5.36", removed unnecessary "use" statements.
##############################################################################################################

# ======= PRAGMAS AND MODULES: ===============================================================================

use v5.36;
use utf8;
use Cwd 'cwd';
use POSIX 'floor', 'ceil', 'strftime';
use RH::Util;
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub process_argv          :prototype();
sub print_file_attributes :prototype(_);
sub help                  :prototype();

# ======= GLOBAL VARIABLES: ==================================================================================

my @Paths; # Paths of files to give attributes for.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{
   process_argv;
   print_file_attributes for @Paths;
   exit 0;
}

# ======= SUBROUTINE DEFINITIONS: ============================================================================

sub process_argv :prototype() () {
   my $help;
   my $cwd  = d cwd;
   foreach (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         if ('-h' eq $_ || '--help' eq $_) {$help = 1;}
      }
      else
      {
         push @Paths, path($cwd,$_);
      }
   }
   if ($help) {help; exit 777;}
   return 1;
} # end sub process_argv

sub print_file_attributes :prototype(_) ($path) {
   my $name = get_name_from_path($path);

   # Get current file's info, using lstat instead of stat, so that for
   # links, we get info for the link ITSELF, rather than what it links to:
   my ( $dev,   $inode, $mode,  $nlink,
        $uid,   $gid,   $rdev,  $size,
        $atime, $mtime, $ctime          )
      = lstat e $path;

   my @ModTimeFields = localtime($mtime);
   my @InoTimeFields = localtime($ctime);
   my @AccTimeFields = localtime($atime);
   my $mod_date = strftime('%F',   @ModTimeFields);
   my $mod_time = strftime("%T%Z", @ModTimeFields);
   my $ino_date = strftime('%F',   @InoTimeFields);
   my $ino_time = strftime("%T%Z", @InoTimeFields);
   my $acc_date = strftime('%F',   @AccTimeFields);
   my $acc_time = strftime("%T%Z", @AccTimeFields);

   printf("Path =         %s\n", $path);
   printf("Name =         %s\n", $name);
   printf("Inode=         %d\n", $inode);
   printf("Links=         %d\n", $nlink);
   printf("Mod time =     %s on %s\n", $mod_time, $mod_date);
   printf("Inode time =   %s on %s\n", $ino_time, $ino_date);
   printf("Access time =  %s on %s\n", $acc_time, $acc_date);
   printf("Size =         %d\n", -s e $path);
   printf("Exists?        %s\n", (-e e $path) ? 'Yes' : 'No');
   printf("Empty?         %s\n", (-z e $path) ? 'Yes' : 'No');
   printf("Readable?      %s\n", (-r e $path) ? 'Yes' : 'No');
   printf("Writable?      %s\n", (-w e $path) ? 'Yes' : 'No');
   printf("Executable?    %s\n", (-x e $path) ? 'Yes' : 'No');
   printf("Plain file?    %s\n", (-f e $path) ? 'Yes' : 'No');
   printf("Directory?     %s\n", (-d e $path) ? 'Yes' : 'No');
   printf("Symbolic Link? %s\n", (-l e $path) ? 'Yes' : 'No');
   printf("SYMLINKD?      %s\n", ((-l e $path) && (-d e $path)) ? 'Yes' : 'No');
   printf("Block special? %s\n", (-b e $path) ? 'Yes' : 'No');
   printf("Char special?  %s\n", (-c e $path) ? 'Yes' : 'No');
   printf("Pipe?          %s\n", (-p e $path) ? 'Yes' : 'No');
   printf("Socket?        %s\n", (-S e $path) ? 'Yes' : 'No');
   printf("TTY?           %s\n", (-t e $path) ? 'Yes' : 'No');
   return 1;
} # end sub print_file_attributes

sub help :prototype() () {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to "file-attributes.pl", Robbie Hatley's nifty program for
   displaying file attributes.

   The only options are "-h" or "--help", both of which just print this
   help and exit. All other options are ignored.

   "file-attributes.pl" will interpret all non-option arguments as being
   paths to files, and it will attempt to print the attributes of those
   files.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
