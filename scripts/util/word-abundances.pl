#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# word-abundances.pl
# Prints the abundances of the words in the strings fed to it.
#
# Edit history:
# Sat Jan 09, 2021: Wrote it.
# Sat Sep 18, 2021: Added help.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Thu Nov 25, 2021: Cleaned up formatting and comments, and added debugging.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use RH::Dir;

sub help;

my $db        = 0;
my @Fields    = ();
my $NumFields = 0;
my %Ab        = ();

{ # begin main body of program
   if ((scalar(@ARGV) > 0) && ('-h' eq $ARGV[0] || '--help' eq $ARGV[0])) {help; exit;}
   while (<>)
   {
      s/[\pC\pZ\s]+$//;                            # Snip trailing control, separator, and space characters.
      if ($db)
      {
         say "In word-abundance, in while(), near top;";
         say "raw incoming text line = \"$_\".";
      }
      @Fields = ();                                # Clear the Fields array for receiving data.
      for my $Field (split /[\pC\pZ\s]+/, $_)      # Split using clusters of control, separator, or space as separators.
      {
         $Field =~ s/\W//g;                        # Get rid of non-word characters
         $Field = fc $Field;                       # Fold Case.
         next if $Field eq '';                     # Skip field if empty.
         next if $Field =~ m/^[\pC\pZ\s]+$/;       # Skip field if white-space-only.
         push @Fields, $Field;                     # Push field onto array.
      }
      $NumFields = scalar(@Fields);
      if ($db)
      {
         say "In word-abundance, in while(), near bottom;";
         say "number of fields = $NumFields.";
      }
      map {++$Ab{$_}} @Fields;                     # Increment hash elements (autovivify if necessary).
   }
   for my $key (sort {$Ab{$b}<=>$Ab{$a}} keys %Ab) # Index hash by reverse order of abundance.
   {
      say "$key => $Ab{$key}";                     # Display how many strings were received for each key.
   }
   exit;
} # end main body of program

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "word-abundance.pl", Robbie Hatley's nifty program for
   displaying the abundances of words in a file.

   Command line to print this help and exit:
   word-abundance.pl [-h|--help]

   Command lines to display abundances of words in files:
   word-abundance.pl   MyFile.txt
   word-abundance.pl   MyFile.txt > MyOutput.txt
   word-abundance.pl < MyFile.txt
   word-abundance.pl < MyFile.txt > MyOutput.txt
   MyProgram | word-abundance.pl  > MyOutput.txt

   No other options or arguments are recognized.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
