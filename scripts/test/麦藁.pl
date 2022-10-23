#! /bin/perl -CSDA
# 麦藁.pl
use v5.32;
use utf8;

open(雪, "<:utf8", "/cygdrive/d/Captain's-Den/Varna/Lore/麦藁雪、富士川町、山梨県.txt")
   or die "Can't open file for input. $!\n";
my @lines = <雪>;
close 雪;

open(雪2, ">:utf8", "/cygdrive/d/Captain's-Den/Varna/Lore/麦藁雪、富士川町、山梨県_2.txt") 
   or die "Can't open file for output. $!\n";
print (雪2 $_) for @lines;
close 雪2;
