#!/usr/bin/env -S perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# /rhe/scripts/util/s
# "s" = "Substitute" = Robbie Hatley's nifty substitution script.
# Runs an s/pattern/replacement/options substitution on lines of text.
# Input of pattern, replacement, and options is via command-line arguments.
# Input of text being processed is via STDIN, pipe, or redirect.
# Output is to STDOUT. (Doesn't alter input.)
#
# Written by Robbie Hatley in December 2014 (exact date unknown).
#
# Edit history:
# Mon Dec 01, 2014: Wrote it sometime in December 2014.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 02, 2016: Added help. Added "#!/usr/bin/env -S perl -CSDA".
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
# Sat Aug 03, 2024: Reduced width from 120 to 110; upgraded from "v5.32" to "v5.36"; added "use utf8";
#                   got rid of "use common::sense"; got rid of "use Sys::Binmode".
##############################################################################################################

use v5.36;
use utf8;

my $Db = 0;

# main body of script:
{
   # Process arguments:
   for (@ARGV) {
      if ('-h' eq $_ || '--help' eq $_) {
         Help();
         exit 777;
      }
   }
   my $command;
   my $n = scalar @ARGV;
   if    (2 == $n) {
      $command = "s/$ARGV[0]/$ARGV[1]/";
   }
   elsif (3 == $n) {
      $command = "s/$ARGV[0]/$ARGV[1]/$ARGV[2]";
   }
   else {
         die
         "Error: substitute.pl requires either two arguments (pattern, replacement)\n".
         "or three arguments (pattern, replacement, options).\n";
   }

   # If debugging, print command and exit:
   if ($Db) {
      say "Command = $command";
      exit(888);
   }

   # Print substituted versions of all lines from STDIN to STDOUT:
   while (<STDIN>) {
      eval("$command");
      print;
   }
   exit 0;
}

sub Help
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "substitute.pl". Like the Perl s/// function (which it uses),
   this program performs regular-expression substitution on whatever lines
   of text are fed to it via STDIN. The output is fed to STDOUT. The input
   is not altered (ie, this program is a "filter").

   Command lines for help:
   s -h
   s --help
   (Those just print this help and exit.)

   Command lines for substitution:
   Cmmd Line:               Meaning:
   s arg1 arg2              s/arg1/arg2/
   s arg1 arg2 arg3         s/arg1/arg2/arg3

   Basically, s examines each line of text coming in on STDIN, looking for
   matches to the regular expression in arg1, and substituting the replacement
   pattern in arg2 for those matches, while obeying the s/// flags given via
   arg3 (if present).

   Output is written to STDOUT.

   The original text coming in via STDIN is not altered.

   NEEDLESS TO SAY, THIS IS AN EXTREMELY DANGEROUS PERL SCRIPT. THIS SCRIPT
   IS INTENDED FOR USE BY EXPERIENCED PERL PROGRAMMERS WITH NO ILL INTENT.
   IT IS BEST NOT TO SHARE THIS SCRIPT WITH THE GENERAL PUBLIC, AS SOME
   PERSONS MIGHT USE IT FOR NEFARIOUS PURPOSES.

   AND I'M NOT EVEN GOING TO MENTION HOW DANGEROUS IT IS TO FEED AN 'e' FLAG
   TO THIS SCRIPT AS PART OF ITS THIRD ARGUMENT.

   THIS SCRIPT IS LIKE A REVVING CHAIN SAW. IT'S A USEFUL TOOL, BUT USE IT
   CAREFULLY.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
}
