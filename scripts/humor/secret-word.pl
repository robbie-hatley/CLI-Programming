#!/usr/bin/env -S perl -C63

##############################################
# "secret-word.pl": Generates a secret word. #
##############################################

use v5.36;
use utf8;

my $your_drink = "Please give me a Scotch on the rocks.";

sub reverse_string ($x) {join reverse split '', $x}

sub bartender_request($preference) {
   my $str1 = "ers";
   my $str2 = reverse_string "rap";
   my $str3 = "amet";
   my $sw   = $str2.$str3.$str1;
   $preference . " The secret word is \"" . $sw . "\".";
}

say bartender_request($your_drink);
