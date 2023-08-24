#! /usr/bin/perl

# This is a 120-character-wide UTF-8 Unicode Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# RH/RegTest.pm
# Regular Expression Test Module
# Class for testing regular expressions.
# Usage:
#    my $tester = RH::RegTest->new(@ARGV);
#    $tester->match($MyDamnString);
# Written by Robbie Hatley.
# Edit history:
# Tue Mar 24, 2015:
#    Wrote it.
# Sun Dec 31, 2017:
#    use v5.26.
# Sat Nov 20, 2021: use v5.32. Renewed colophon. Revamped pragmas & encodings.
# Wed Aug 23, 2023: Upgraded from "v5.32" to "v5.36". Reduced width from 120 to 110. Got rid of CPAN module
#                   "common::sense" (antiquated). Got rid of all prototypes. Now using signatures.
# Thu Aug 24, 2023: Changed to C-style {bracing}. Got rid of "o" option on the qr// (unnecessary).
#                   Added some comments to clarify various tricky bits.
##############################################################################################################

# Package:
package RH::RegTest;

# Pragmas:
use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

# CPAN modules:
use Sys::Binmode;
# Note: Don't use "use parent 'Exporter';" here, because this module doesn't export anything,
# because it is a class. Also, don't put -CSDA on the shebang, because it's too late for that.

# Encodings:
use open ':std', IN  => ':encoding(UTF-8)';
use open ':std', OUT => ':encoding(UTF-8)';
use open         IN  => ':encoding(UTF-8)';
use open         OUT => ':encoding(UTF-8)';
# NOTE: these may be over-ridden later. Eg, "open($fh, '< :raw', e $path)".

sub new {
   my $class  = shift;
   my $re = @_ ? shift : '^.+$';
   my $RegExp = qr/$re/;
   if ( ! defined $RegExp ) {die "Bad RegExp \"$re\".\n$!\n";}
   say "RegExp = \"$RegExp\"";
   my $self = {RegExp => $RegExp};
   return bless $self, $class;
}

sub match {
   my $Self    = shift;
   my $RegExp  = $Self->{RegExp};
   my $Text    = shift;
   say '';
   say "Text   = \"$Text\"";
   my @Matches = $Text =~ m/$RegExp/;
   # If match, the above will return either the list (1) if no captures, or the list ($1, $2, $3...).
   # If no match, the above will return the list (0). So either way, we can easily determine match/no-match
   # by just testing for if (@Matches), because if() forces scalar context, same as "if (scalar(@Matches))".
   if (@Matches) {
      say "Text matches RegExp.";
      say ( "Length  of \$` = "  ,   length($`) ,        );
      say ( "Content of \$` = \"",          $`  , "\""   );
      say ( "Length  of \$& = "  ,   length($&) ,        );
      say ( "Content of \$& = \"",          $&  , "\""   );
      say ( "Length  of \$' = "  ,   length($') ,        );
      say ( "Content of \$' = \"",          $'  , "\""   );
      # If there were 1-or-more captures, $1 will be set; otherwise, $1 will be undefined ("false" in boolean
      # context). So the easiest way to determine "Were there captures?" is "if ($1) {...} else {...}".
      if ($1) {
         say scalar(@Matches), " captures: ", join(', ', map {"\"$_\""} @Matches);
      }
      else {
         say('No captures.');
      }
   }
   else {
      say "Text does NOT match Regex.";
   }
}

1;
