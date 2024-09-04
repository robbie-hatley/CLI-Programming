#!/usr/bin/env perl

=pod

The Weekly Challenge #013-1: "Last Friday"
Task: Write a script to give the dates of the last Friday of
every month in a given year, in ISO-8601 with "/" as separator.

Solution in Perl written by Robbie Hatley on Tue Sep 03, 2024.

=cut

use Date::Day;

my $year = @ARGV[0];
my @days_per_month = (31,28,31,30,31,30,31,31,30,31,30,31);
if ( 0 == $year % 4 && !(0 == $year % 100 && 0 != $year % 400) ) {
   $days_per_month[1] = 29;
}
my @last_fridays;
MONTH: for my $month (reverse 1..12) {
   DAY: for my $day (reverse 1..$days_per_month[$month-1]) {
      if ('FRI' eq day($month,$day,$year)) {
         unshift @last_fridays, [$year,$month,$day];
         next MONTH;
      }
   }
}

for (@last_fridays) {
   printf("%0d/%02d/%02d\n",$_->[0],$_->[1],$_->[2]);
}
