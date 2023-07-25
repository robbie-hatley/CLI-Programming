#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# sort-lines-by-unicode-collation-ascending.pl
#
# Written by Robbie Hatley on Wednesday June 24, 2015.
#
# Edit history:
# Wed Jun 24, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sat Apr 16, 2016: Now using -CSDA.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Unicode::Collate;
use RH::WinChomp;

# ======= SUBROUTINE PRE-DECLARATIONS ==================================================================================

sub argv             ;
sub pre_process      ;
sub process_line (_) ;
sub help_msg         ;

# ======= MAIN BODY OF PROGRAM =========================================================================================

MAIN:
{
   argv;
   my $collator = Unicode::Collate->new(preprocess=>\&pre_process);
   say for $collator->sort( map {process_line} <> );
   exit 0;
} # end MAIN

# ======= SUBROUTINE DEFINITIONS =======================================================================================

sub argv
{
   # If user wants help, just print help and bail:
   if ( @ARGV > 0 && ( $ARGV[0] eq '-h' || $ARGV[0] eq '--help' ) )
   {
      help_msg;
      exit 777;
   }

}

sub pre_process
{
   my $str = shift;
   #$str =~ s/\b(?:an?|the)\s+//gi;
   return $str;
}

# Chop-off BOM (if any) from start of line, and chop off
# newlines (if any from ends of lines:
sub process_line (_)
{
   remove_bom;           # Get rid of BOM (if any).
   winchomp;             # Chomp-off newlines.
   return $_;
}

sub help_msg 
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to Robbie Hatley's Nifty unicode collation utility.
   This program unicode-sorts the lines of a file and prints the results to
   STDOUT. The original file is never altered.

   Input  is via STDIN,  pipe, first argument, or redirect from file.

   Output is via STDOUT, pipe, or redirect to file.

   Command lines to sort a file:
   usort infile.txt
   usort < infile.txt > outfile.txt
   usort < infile.txt | uniq > outfile.txt

   Command lines to get help:
   usort -h
   usort --help

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
}
