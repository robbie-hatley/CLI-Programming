#! /usr/bin/perl
my @sorted = sort { $a <=> $b } @ARGV;
$,=" ";
print @sorted;
print;
