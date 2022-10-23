#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# delta.pl
# Presents "added" lines which are in a second file but not in a first,
# and "subtracted" lines which are in a first file but not in a second.
# 
# Edit history:
# Sat May 07, 2016 - Wrote it.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Encode 'encode_utf8';

# ======= SUBROUTINE PRE-DECLARATIONS ==================================================================================

sub get_options_and_arguments;
sub process_options;
sub element_is_in_array($$);
sub error_msg;
sub help_msg;

# ======= GLOBAL VARIABLES =============================================================================================

our @Arguments;  # CL args not starting with '-'
our @Options;    # CL args starting with '-'
our $Help = 0;   # Print help and exit?

# ======= MAIN BODY OF PROGRAM =========================================================================================

# main
{
   # Extract @Arguments and @Options from @ARGV:
   get_options_and_arguments;

   # Process options::
   process_options;

   # If user wants help, just print help and bail:
   if ($Help) 
   {
      help_msg;
      exit 777;
   }

   # If number of arguments is out of range, bail:
   if ( @Arguments != 2 ) 
   {
      error_msg;
      exit 666;
   }

   my $fh1;
   open($fh1, '<', encode_utf8 $Arguments[0]) or die "Can't open first file.\n$!\n";
   my @First = <$fh1>;
   close($fh1);

   my $fh2;
   open($fh2, '<', encode_utf8 $Arguments[1]) or die "Can't open second file.\n$!\n";
   my @Second = <$fh2>;
   close($fh2);
   
   my @Added;
   foreach (@Second)
   {
      if (!element_is_in_array($_, \@First))
      {
         push(@Added, $_);
      }
   }

   my @Subtracted;
   foreach (@First)
   {
      if (!element_is_in_array($_, \@Second))
      {
         push(@Subtracted, $_);
      }
   }

   say("\n\nAdded lines:");
   print @Added;

   say("\n\nSubtracted lines:");
   print @Subtracted;

   # We be done, so scram:
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =======================================================================================

sub get_options_and_arguments
{
   foreach (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         push(@Options, $_);
      }
      else
      {
         push(@Arguments, $_);
      }
   }
   return 1;
}

sub process_options
{
   foreach (@Options) 
   {
      if ('-h' eq $_ || '--help' eq $_) {$Help = 1;}
   }
   return 1;
}

sub element_is_in_array($$)
{
   my $Element  = shift;
   my $ArrayRef = shift;
   foreach (@$ArrayRef) {return 1 if $Element eq $_;}
   return 0;
}

sub error_msg 
{
   say "Error: you typed ${\scalar(@Arguments)} arguments,";
   say 'but delta.pl takes exactly 2 arguments, which must be';
   say 'names of text files in the current directory.';
   say 'Type "delta.pl -h" to get help.';
   return 1;
}

sub help_msg 
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "delta.pl". This program presents "added" lines which are in 
   a second file but not in a first, and "subtracted" lines which are in 
   a first file but not in a second. 

   So, the output of this program will make sense only if the first and second
   arguments are paths of two text files, "File1" and "File2", in the current
   directory, and "File2" is a later version of "File1". For example:
   delta.pl 'MyScript-V3.71.pl' 'MyScript-V3.72.pl'

   Command lines:
   delta.pl [-h|--help]       (to get this help)
   delta.pl arg1 arg2         (to present differences between 2 files)

   Description of options:
   Option:                      Meaning:
   "-h" or "--help"             Print help and exit.

   This program takes exactly two arguments, which must be names of text files
   in the current directory. This program will then present you with two lists:
   A list of   "Added"    lines which are in file2 but not file1.
   A list of "Subtracted" lines which are in file1 but not file2.

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
}
