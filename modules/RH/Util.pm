#! /usr/bin/perl

# This is a 110-character-wide UTF-8 Unicode Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# /cygdrive/D/rhe/modules/RH/Util.pm
# Robbie Hatley's "Miscellaneous Utilities" Module
# Written by Robbie Hatley.
# Edit history:
# Tue Jan 23, 2015: Started writing it.
# Tue Jul 07, 2015: Now fully UTF-8 compliant.
# Thu Dec 28, 2017: Added extract_digits; use 5.026_001.
# Sun Dec 31, 2017: Now using Exporter.
# Wed Aug 05, 2020: Did minor cleanup of some formatting (line lengths), added some comments, and use v5.30.
# Sat Nov 20, 2021: Upgraded from "v5.30" to "v5.32". Renewed colophon. Revamped pragmas & encodings.
# Wed Mar 02, 2022: Added descriptions to subroutine prototypes, and corrected a few spellig errars.
# Tue Aug 15, 2023: Decreased width from 120 to 110. Upgraded from "v5.32" to "v5.36". Added ":prototype"
#                   to every subroutine declaration and definition. Now using signatures. Got rid of
#                   "common::sense" (antiquated). Got rid of all "given" and "when".
# Thu Oct 03, 2024: Got rid of Sys::Binmode.
##############################################################################################################

# Package:
package RH::Util;

# Pragmas:
use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

# Encodings:
use open ':std', IN  => ':encoding(UTF-8)';
use open ':std', OUT => ':encoding(UTF-8)';
use open         IN  => ':encoding(UTF-8)';
use open         OUT => ':encoding(UTF-8)';
# NOTE: these may be over-ridden later. Eg, "open($fh, '< :raw', e $path)".

# CPAN modules:
use Encode         qw( :DEFAULT encode decode :fallbacks :fallback_all );
use parent         qw( Exporter                                        );
use POSIX          qw( floor ceil strftime                             );
use Term::ReadKey  qw( ReadMode ReadKey                                );
use Carp           qw( carp croak confess longmess shortmess           );

# Subroutine prototypes and descriptions:
sub round_to_int          :prototype($)  ; # Round any real number to the nearest integer.
sub rand_int              :prototype($$) ; # Return random int in range [n,m] with equal probability
sub get_character         :prototype()   ; # Read-and-return 1 character, unbuffered, unechoed, blocked.
sub is_ascii              :prototype($)  ; # Does a given string appear to be ASCII?
sub is_iso_8859_1         :prototype($)  ; # Does a given string appear to be ISO-8859-1?
sub is_utf8               :prototype($)  ; # Does a given string appear to be UTF-8?
sub extract_digits        :prototype($)  ; # Return just the digits (if any) from the input.
sub eight_rand_lc_letters :prototype()   ; # Return string of 8 random lower-case letters.
sub confess_test          :prototype($)  ; # Test of "confess"

# Symbols to be exported by default:
our @EXPORT =
   qw
   (
      round_to_int            rand_int                get_character
      is_ascii                is_iso_8859_1           tc
      extract_digits          eight_rand_lc_letters   confess_test
   );

# Turn-on debugging?
my $db = 0; # Set to 1 to debug.

# ============================================================================================================
# SUBROUTINE DEFINITIONS:

# Round a floating-point number to the nearest integer by using the usual
# "4.499 rounds to 4 but 4.500 rounds to 5" paradigm:
sub round_to_int :prototype($) ($x) {
   my $f = floor($x);
   my $c =  ceil($x);
   return $x - $f < $c - $x ? $f : $c;
} # end sub round_to_int :prototype($) ($x)

# Subroutine rand_int returns a random integer in the range [m,n] inclusive, where n and m are any two
# integers with n > m, and with n and m being greater than -9.223e+18 and less than 1.844e+19.
# This subroutine insures that the probability of the two end points (m and n) to occur is the same as the
# probability of any of the intermediate integers to occur.
sub rand_int :prototype($$) ($min, $max) {
   $min =~ m/^-?\d+$/
   or die "Error in rand_int: first argument not integer.\n";

   $max =~ m/^-?\d+$/
   or die "Error in rand_int: second argument not integer.\n";

   $min > -9.223e+18 && $min < 1.844e+19
   or die "Error in rand_int: first argument out-of-range.\n";

   $max > -9.223e+18 && $max < 1.844e+19
   or die "Error in rand_int: second argument out-of-range.\n";

   $min <= $max
   or die "Error in rand_int: second argument not greater than first.\n";

   return floor($min+rand($max-$min+1));
} # end sub rand_int :prototype($$) ($min, $max)

# Sub "get_character" pauses the operation of the calling program, waits for the user to enter a keystroke on
# the keyboard, then returns the character generated by that keystroke, without waiting for "Enter" key to be
# pressed and without echoing that character to the screen. This is useful for programs that need user
# intervention (such as, selecting which of two duplicate files a program should erase).
sub get_character :prototype() {
   ReadMode 'cbreak';     # Set read mode to "cbreak" (echo off, unbuffered).
   my $char = ReadKey 0;  # Perform a blocked 1-character read from STDIN using getc and store in "$char".
   ReadMode 'normal';     # Set read mode to "normal" (echo on, buffered).
   return $char;
} # end sub get_character :prototype()

# Is a line of text encoded in ASCII?
sub is_ascii :prototype($) ($text) {
   my $is_ascii = 1;
   foreach my $ord (map {ord} split //, $text) {
      if ($db) {say STDERR "In is_ascii(), at top of foreach. \$ord = $ord"}
      next if (  9 == $ord ); # HT
      next if ( 10 == $ord ); # LF
      next if ( 11 == $ord ); # VT
      next if ( 13 == $ord ); # CR
      next if ( 32 == $ord ); # SP
      next if ( $ord >=  33
             && $ord <= 126); # ASCII glyph
      # If we get to here, all of the above tests failed, which means that our current character
      # is neither commonly-used ASCII whitespace nor an ASCII glyphical character,
      # so set $is_ascii to 0 and break from loop:
      $is_ascii = 0;
      last;
   }
   if ($db) {say STDERR "In is_ascii(), about to return. \$is_ascii = $is_ascii"}
   return $is_ascii;
} # end sub is_ascii :prototype($) ($text)

# Is a line of text encoded in iso-8859-1?
sub is_iso_8859_1 :prototype($) ($text) {
   my $is_iso = 1;
   foreach my $ord (map {ord} split //, $text) {
      if ($db) {say STDERR "In is_iso_8859_1(), at top of foreach. \$ord = $ord"}
      next if (  9 == $ord ); # HT
      next if ( 10 == $ord ); # LF
      next if ( 11 == $ord ); # VT
      next if ( 13 == $ord ); # CR
      next if ( 32 == $ord ); # SP
      next if ( $ord >=  33
             && $ord <= 126); # ASCII glyph
      next if ( $ord >= 160
             && $ord <= 255); # iso-8859-1 character
      # If we get to here, all of the above tests failed, which means that our current character
      # is neither commonly-used iso-8859-1 whitespace nor an iso-8859-1 glyphical character,
      # so set $is_iso to 0 and break from loop:
      $is_iso = 0;
      last;
   }
   if ($db) {say STDERR "In is_iso_8859_1(), about to return. \$is_iso = $is_iso"}
   return $is_iso;
} # end sub is_iso_8859_1 :prototype($) ($text)

# Is a line of text encoded in Unicode then transformed to UTF-8?
sub is_utf8 :prototype($) ($text) {
   my $is_utf8;
   if ( eval {decode('UTF-8', $text, DIE_ON_ERR|LEAVE_SRC)} ) {
      $is_utf8 = 1;
   }
   else {
      $is_utf8 = 0;
   }
   if ($db) {say STDERR "In is_utf8(), about to return. \$is_utf8 = $is_utf8"}
   return $is_utf8;
}

# Convert a string to title-case:
sub tc :prototype($) ($string) {
   return $string =~ s/([\w’]+)/\u\L$1/gr;
}

# Given a string, delete all non-decimal-digit characters and all leading zeros and return the remainder,
# which should now be a string giving the decimal representation of a positive integer, unless the string
# is now empty, in which case return 0:
sub extract_digits :prototype($) ($string) {
   $string =~ s/\D//g;        # Erase all non-digit characters.
   $string =~ s/^0+//g;       # Erase all leading zeros.
   if (length($string) > 0)   # If $string is not empty,
      {return $string}        # return $string;
   else                       # otherwise,
      {return 0}              # return 0.
} # end sub extract_digits :prototype($) ($string)

# Return a string of 8 random lower-case English letters:
sub eight_rand_lc_letters :prototype() {
   return join '', map {chr(rand_int(97, 122))} (1..8);
}

# Test "confess":
sub confess_test :prototype($) ($x) {
   if (7 == $x) {
      say longmess("Pete");
      confess("AARRGGHH!!");
   }
}

1;
