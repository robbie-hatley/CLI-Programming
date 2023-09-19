#!/usr/bin/perl

# This is a 120-character-wide ASCII-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# day-of-week.pl
# Prints day-of-week for dates from Fri Jan  1, 5000000BCJ (Fri Apr 29, 5000103BCG)
#                                to Sat Dec 31, 5000000CEJ (Sat Sep 01, 5000103CEG).
# Dates must be entered as three integer command-line arguments in the order "year, month, day".
# To enter CE dates, use positive year numbers (eg,  "1974" for 1974CE).
# To enter BC dates, use negative year numbers (eg, "-5782" for 5782BC).
# By default, dates entered will be construed as being Gregorian, but if a -j or --julian option is used,
# the input date will be construed as being Julian. The output will be to STDOUT and will consist of both
# Gregorian and Julian dates in "Wednesday December 27, 2017" format. Thus this program serves not-only
# to print day-of-week, but also as a Gregorian-to-Julian and Julian-to-Gregorian convertor.
#
# Usage examples:
# %day-of-week.pl 1974 8 14
# Gregorian = Wednesday August 14, 1974CEG
# Julian    = Wednesday August  1, 1974CEJ
# %day-of-week.pl 1490 3 18 -j
# Gregorian = Thursday March 27, 1490CEG
# Julian    = Thursday March 18, 1490CEJ
#
# WARNING: this program is fully capable of specifying Gregorian dates for times in which the Gregorian
# calendar did not yet exist (or was not yet in widespread use in English-speaking countries), and Julian
# dates for times in which the Julian calendar was no-longer in widespread use. If in doubt, use a -w or
# --warnings option; this program will print appropriate warnings such "proleptic" (meaning "not in-use
# at that time"), "English" (the English-speaking world was still using Julian for almost 2 centuries after
# the rest of the world had upgraded to Gregorian), or "Julian" (usage of Julian after late 1752 is
# anachronistic).
#
# Author: Robbie Hatley.
#
# Edit history:
# Tue Dec 23, 2014? Started  writing it. (This was dated "Tue Dec 23, 2016", but no such date exists.)
# Wed Dec 24, 2014? Finished writing it. (This was dated "Wed Dec 24, 2016", but no such date exists.)
# Sat Apr 16, 2016: Now using -CSDA; also added some comments.
# Sun Jul 23, 2017: Commented-out unnecessary module inclusions and clarified some puzzling comments. Also,
#                   converted from utf8 back to ASCII.
# Wed Dec 27, 2017: Clarified comments.
# Mon Apr 16, 2018: Started work on expanding the date range from 1899-12-31 -> 9999-12-31
#                                                             to  0001-01-01 -> 9999-12-31
# Wed May 30, 2018: Completed date range expansion.
# Wed Oct 16, 2019: Now gives DOW for both Julian and Gregorian dates.
# Thu Feb 13, 2020: Refactored main() and day_of_week(), implemented emit_despale(), and added "day of week
#                   from elapsed time" feature. (Next up: Gregorian <=> Julian)
# Fri Feb 14, 2020: Cleaned-up some comments.
# Sat Feb 15, 2020: Now gives day of week and both Gregorian and Julian dates for all requests. I also muted
#                   warnings unless user requests them. The minimum date is now Dec 30, 1BCG = Jan 1, 1CEJ,
#                   and the maximum date is now unlimited (though, for dates much past 1000000CEG, the
#                   computation time becomes unworkable). Also, removed "input elapsed time", as it's useless.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Thu Sep 14, 2023: Reduced width from 120 to 110. Corrected impossible dates for "starting writing it" and
#                   "finished writing it" above. Removed CPAN module "common::sense" (antiquated). Reverted
#                   from unicode/UTF-8 to ASCII. Removed CPAN module "Sys::Binmode" (unneeded). Upgraded from
#                   "v5.32" to "v5.38". Not using any other pragmas. Got rid of all prototypes. Now using
#                   signatures. Got rid of all given/when. Refactored to use 00:00:00UTC on 1 1 1 Julian as
#                   "reference instant of time". "Elapsed time" is now 0 instead of 1 for that date.
#                   Clarified date range as being "1 1 1 -j" through "5000000 12 31 -j", which is the same as
#                   "0 12 30" through "5000103 9 1" Gregorian. Re-wrote help(), both improving formatting and
#                   adding new options and greatly-clarified limits on dates. I also added [-e|--debug] and
#                   [-g|--gregorian] options.
# Fri Sep 15, 2023: "Warnings" now come in 3 flavors: "Proleptic", "English", and "Anachronistic".
# Tue Sep 19, 2023: Started work expanding the range to 10 million years centered around the day 1/1/1CEJ.
##############################################################################################################

use v5.38;

# ======= SUBROUTINE PRE-DECLARATIONS ========================================================================

sub process_argv    ; # Process @ARGV and set settings accordingly.
sub days_per_year   ; # How many days in given whole year?
sub days_per_month  ; # How many days in given whole month?
sub is_leap_year    ; # Is given year a leap year?
sub elapsed_time    ; # Days elapsed since Dec 31 1BCJ to given date.
sub emit_despale    ; # Get date from elapsed days.
sub day_of_week     ; # Determine day-of-week for a given date.
sub print_warnings  ; # Print warnings.
sub print_proleptic ; # Print "proleptic use of Gregorian"  message.
sub print_english   ; # Print "English transition period"   message.
sub print_julian    ; # Print "anachronistic use of Julian" message.
sub error           ; # Print error message.
sub help            ; # Print help  message.

# ======= GLOBAL VARIABLES ===================================================================================

# Settings:         # Meaning of setting:        Range:    Meaning of default:
my $Db        = 0 ; # Print diagnostics?         bool      Don't print diagnostics.
my $Julian    = 0 ; # Use Julian Calendar?       bool      Interpret input date as being Gregorian.
my $Warnings  = 0 ; # Emit proleptic warnings?   bool      Don't print proleptic or English warnings.
my $A_Y       = 0 ; # Year  from CL arguments.   pos int   None; 0 is just a "not-yet-initialized" indicator.
my $A_M       = 0 ; # Month from CL arguments.   pos int   None; 0 is just a "not-yet-initialized" indicator.
my $A_D       = 0 ; # Day   from CL arguments.   pos int   None; 0 is just a "not-yet-initialized" indicator.

my @DaysOfWeek
   = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday);

my @Months
   = qw(January   February  March     April     May       June
        July      August    September October   November  December);

# ======= MAIN BODY OF PROGRAM ===============================================================================

{ # begin main
   # Process @ARGV and set settings and arguments accordingly:
   process_argv();

   if ( $Db ) {
      say "\$Julian = $Julian";
   }


   # Declare variables for year, month, day, elapsed-time, and Julian:
   my $G_Y;
   my $G_M;
   my $G_D;
   my $J_Y;
   my $J_M;
   my $J_D;
   my $Elapsed;

   # Get year, month, day from arguments,
   # and derive elapsed time from year, month, and day,
   # and also convert to other calendar:
   if ($Julian)
   {
      $J_Y = $A_Y;
      $J_M = $A_M;
      $J_D = $A_D;
      $Elapsed = elapsed_time($J_Y, $J_M, $J_D, 1);
      ($G_Y, $G_M, $G_D) = emit_despale($Elapsed, 0);
   }
   else
   {
      $G_Y = $A_Y;
      $G_M = $A_M;
      $G_D = $A_D;
      $Elapsed = elapsed_time($G_Y, $G_M, $G_D, 0);
      ($J_Y, $J_M, $J_D) = emit_despale($Elapsed, 1);
   }

   # Calculate day of week from elapsed time since 00:00:00UTC on the morning of Dec 31, 1BCJ:
   my $DayOfWeek = day_of_week($Elapsed);

   # Negative year numbers mean BC:
   my $BCJ = $G_Y < 0 ? 'BCJ' : 'CEJ';
   my $BCG = $G_Y < 0 ? 'BCG' : 'CEG';

   # Print day-of-week, date, and elapsed time:
   printf( "Gregorian = %-9s %-9s %2d, %7d%s\n", $DayOfWeek, $Months[$G_M-1], $G_D, $G_Y, $BCG );
   printf( "Julian    = %-9s %-9s %2d, %7d%s\n", $DayOfWeek, $Months[$J_M-1], $J_D, $J_Y, $BCJ );

   # Depending on which calendar was actually IN-USE on the given date, possibly print a warning message:
   if ($Warnings) {
      print_warnings($A_Y, $A_M, $A_D, $Julian);
   }

   # We be done, so scram:
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =============================================================================

sub process_argv {
   # Get options and arguments:
   my @opts = ();            # options
   my @args = ();            # arguments
   my $s = '[a-zA-Z]';       # single-hyphen allowable chars (English letters only)
   my $d = '[a-zA-Z]';       # double-hyphen allowable chars (English letters only)
   for ( @ARGV ) {
         ( /^-(?!-)$s+$/     # If we get a valid short option
      ||  /^--(?!-)$d+$/ )   # or a valid long option,
      and push @opts, $_     # then push item to @opts
      or  push @args, $_;    # else push item to @args.
   }

   # Process options:
   for ( @opts ) {
      /^-$s*h/ || /^--help$/      and help and exit 777 ;
      /^-$s*e/ || /^--debug$/     and $Db       =  1    ;
      /^-$s*g/ || /^--gregorian$/ and $Julian   =  0    ; # DEFAULT
      /^-$s*j/ || /^--julian$/    and $Julian   =  1    ;
      /^-$s*w/ || /^--warning$/   and $Warnings =  1    ;
   }
   if ( $Db ) {
      say STDERR '';
      say STDERR "\$opts = (", join(', ', map {"\"$_\""} @opts), ')';
      say STDERR "\$args = (", join(', ', map {"\"$_\""} @args), ')';
   }

   # Process arguments:
   my $NA = scalar(@args); # Get number of arguments.
   if (3 != $NA) {         # If number of arguments isn't 3,
      error;               # print error msg,
      help;                # and print help message,
      exit 666;            # and return The Number Of The Beast.
   }

   # Store arguments in variables:
   $A_Y = $args[0];
   $A_M = $args[1];
   $A_D = $args[2];

   # If input is invalid, abort:
   if
   (
      $A_Y < -5000103 || $A_Y > 5000103                         # If year  is out-of-range
      || $A_M < 1 || $A_M > 12                                  # or month is out-of-range,
      || $A_D < 1 || $A_D > days_per_month($A_Y, $A_M, $Julian) # or day   is out-of-range,
   )
   {
      error;                                                    # print error message,
      help;                                                     # and print help message,
      exit 666;                                                 # and return The Number Of The Beast.
   }

   # Return success code 1 to caller:
   return 1;
} # end sub process_argv

sub is_leap_year ($Year, $Julian) {
   # Julian Calendar:
   if ($Julian) {
      if (0 == $Year%4) {return 1;}
      else              {return 0;}
   }
   # Gregorian Calendar:
   else {
      if    ( 0 == $Year%4 && 0 != $Year%100 ) {return 1;}
      elsif ( 0 == $Year%400                 ) {return 1;}
      else                                     {return 0;}
   }
} # end sub is_leap_year

sub days_per_year ($Year, $Julian) {
   my $DaysPerYear = 365;
   if (is_leap_year($Year, $Julian)) {++$DaysPerYear;}
   return $DaysPerYear;
} # end sub days_per_year

sub days_per_month ($Year, $Month, $Julian) {
   state @dpm = (0, 31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
   if ( 2 == $Month ) { return (is_leap_year($Year, $Julian) ? 29 : 28);}
   else {return $dpm[$Month];}
} # end sub days_per_month

# Calculate days elapsed since Dec 31, 1BC JULIAN through given date. Here "days elapsed" means
# "midnights transitioned-through since Dec 31, 1BC Julian = Dec 29, 1BC Gregorian".
# Hence "days elapsed" for Jan 1, 1CE Julian is 1 because only one midnight was transitioned-through
# in order to get from Dec 31, 1BCJ to Jan 1, 1CEJ.
#
# Note that the "zero reference time" is always 23:59:59UTC on Dec 31, 1BC Julian, NEVER Gregorian,
# for the simple reason that the Gregorian calendar didn't exist yet, and wouldn't for another 1582 years!
# So when history books say "event x happened on January 1, 1CE", that always means Jan 1, 1CE Julian.
sub elapsed_time ($Year, $Month, $Day, $Julian) {
   # This sub acts by counting time forward or backwards from Jan 1, 1CE, Julian OR Gregorian. However,
   # Jan 1, 1CEG is Jan 3, 1CEJ, so if we're using Gregorian, we need to start with an offset of +2 days,
   # because our "zero reference time" is actually 00:00:00UTC on Sat Jan 1, 1CEJ:
   my $Elapsed = $Julian ? 0 : 2;

   # BC:
   if ( $Year <= -1 ) {
      # Subtract-out days from whole years which have unelapsed from 00:00:00UTC on Jan 1, 1CEJ
      # down-to (but not including) current year:
      if ( $Year < -1 ) {
         foreach my $PassingYear ( ($Year + 1) .. -1 ) {
            $Elapsed -= days_per_year($PassingYear, $Julian);
         }
      }

      # Next, subtract-out days from whole months which have unelapsed this year down-to (but not including)
      # the current month:
      if ( $Month < 12 ) {
         foreach my $PassingMonth ( ($Month + 1) .. 12 ) {
            $Elapsed -= days_per_month($Year, $PassingMonth, $Julian);
         }
      }

      # Finally, substract-out days which have unelapsed in current month down-to AND INCLUDING today:
      $Elapsed -= (days_per_month($Year, $Month, $Julian) - $Day + 1);
   }

   # CE:
   else {
      # Add-in days from whole years which have elapsed from 00:00:00UTC on Jan 1, 1CEJ
      # up-to (but not including) current year:
      if ($Year > 1) {
         foreach my $PassingYear ( 1 .. $Year - 1 ) {
            $Elapsed += days_per_year($PassingYear, $Julian);
         }
      }

      # Next, add-in days from whole months which have elapsed this year up-to (but not including) the current
      # month, while taking
      if ( $Month > 1 ) {
         foreach my $PassingMonth ( 1 .. $Month - 1 ) {
            $Elapsed += days_per_month($Year, $PassingMonth, $Julian);
         }
      }

      # Finally, add-in days which have elapsed in current month up-to (but not including) today.
      # Subtract 1 from $Day because it's 1-indexed and we need 0-indexed. For example, on June 1 1974,
      # 0 full days have elapsed so far in June, because today hasn't "elapsed" yet:
      $Elapsed += ($Day - 1); #
   }

   # Return elapsed time in full days since 00:00:00UTC, Sat Jan 01, 1CEJ:
   if ( $Db ) {say "Debug msg at end of elapsed_time(): \$Elapsed = $Elapsed"}
   return $Elapsed;
} # end sub elapsed_time

# Given elapsed time in days since Dec 31, 1BCJ, return date as a ($Year, $Month, $Day) list,
# Julian or Gregorian depending on user's request:
sub emit_despale ($Elapsed, $Julian) {
   my $Accum = ($Julian ? 0 : 2) ; # Accumulation of days elapsed or unelapsed.
   my $DPY   = 0                 ; # Days per year.
   my $DPM   = 0                 ; # Days per month.
   my $Year                      ; # Year.
   my $Month                     ; # Month.
   my $Day                       ; # Day

   if ( $Db ) {say "Debug msg near top of emit_despale: \$Accum = $Accum  \$Elapsed = $Elapsed"}

   # If going backward in time from 00:00:00UTC on Jan 1, 1CE (Julian or Gregorian):
   if ( $Elapsed < $Accum ) {
      ($Year,$Month,$Day) = (-1, 12, 31);
      # Determine $Year by subtracting-out days from whole years which have unelapsed:
      while ( $Accum - ($DPY = days_per_year($Year, $Julian)) >= $Elapsed ) {
         $Accum -= $DPY;
         --$Year;
         if ( $Db ) {say "Debug msg in emit_despale: \$Year = $Year"}
         if ( $Year < -5000103 ) {die "Fatal error in emit_despale(): \$Year = $Year.\n";}
      }

      # Determine $Month by subtracting-out days from whole months which have unelapsed:
      while ( $Accum - ($DPM = days_per_month($Year, $Month, $Julian)) >= $Elapsed ) {
         $Accum -= $DPM;
         --$Month;
         if ( $Db ) {say "Debug msg in emit_despale: \$Month = $Month"}
         if ( $Month < 1 ) {die "Fatal error in emit_despale(): \$Month = $Month.\n";}
      }

      # Determine $Day by subtracting-out days in this month which have unelapsed:
      while ( $Accum - 1 > $Elapsed ) {
         --$Accum;
         --$Day;
         if ( $Db ) {say "Debug msg in emit_despale: \$Day = $Day"}
         if ( $Day < 1 ) {die "Fatal error in emit_despale(): \$Day = $Day.\n";}
      }
   }

   # If going foreward in time from 00:00:00UTC on Jan 1, 1CE (Julian or Gregorian):
   else {
      ($Year,$Month,$Day) = (1,1,1);
      # Determine $Year by adding elapsed days from whole years which have elapsed since 00:00:00UTC on
      # Saturday Jan 1, 1CEJ:
      while ( $Accum + ($DPY = days_per_year($Year, $Julian)) <= $Elapsed ) {
         $Accum += $DPY;
         ++$Year; if ( 0 == $Year ) {$Year = 1;}
         if ( $Year > 5000103 ) {die "Fatal error in emit_despale(): \$Year = $Year.\n";}
      }

      # Determine $Month by adding elapsed days from whole months since last second of $Year:
      while ( $Accum + ($DPM = days_per_month($Year, $Month, $Julian)) <= $Elapsed ) {
         $Accum += $DPM;
         ++$Month;
         if ( $Month > 12 ) {die "Fatal error in emit_despale(): \$Month = $Month.\n";}
      }

      # Determine $Day by adding elapsed days since last second of $Month:
      while ( $Accum + 1 <= $Elapsed ) {
         ++$Accum;
         ++$Day;
         if ( $Day > 31 ) {die "Fatal error in emit_despale(): \$Day = $Day.\n";}
      }
   }

   if ( $Db ) {say "Debug msg at end of emit_despale: \$Accum = $Accum  \$Elapsed = $Elapsed"}
   return ($Year, $Month, $Day);
} # end sub emit_despale

sub day_of_week ($Elapsed) {
   # There are only 7 possible values for "day of week" to correspond to the infinity of all dates.
   # The day-of-week values are cycled-through from left to right, then repeated starting again at left,
   # endlessly. This is a "cyclic Abelian group".

   # Hence the only questions are, what leap-days are we using (Julian or Gregorian), and which
   # group-start-point (index 0 through 6) are we using. The group start point will be determined
   # by the "base date", which is "one day before the first date this program can handle", and by
   # the day-of-week of that "base date", and by the number of "days elapsed" which have occurred
   # after that "base day", where "days elapsed" means "midnights transitioned-through".

   # This program uses a "base time" of 00:00:00UTC, Sat Jan 01, 1CEJ
   # which is equivalent to             00:00:00UTC, Sad Dec 30, 1BCG
   # to calculate all dates, Julian and Gregorian.

   # Our zero-reference time is Jan 1, 1CEJ, which is a Saturday (index 6), so to get "day of week",
   # we need only to add an offset of 6 to the "days elapsed" then apply modulo 7:
   return $DaysOfWeek[($Elapsed + 6) % 7];
} # end sub day_of_week

sub print_warnings ($y, $m, $d, $j) {
   if ( $Db ) {say "Debug msg in print_warnings(): \$y = $y  \$m = $m  \$d = $d  \$j = $j"}
   if ( !$j && ($y < 1582 || $y == 1582 && $m < 10 || $y == 1582 && $m == 10 && $d < 15) ) {
      print_proleptic();
   }
   if ( !$j && ($y > 1582 || $y == 1582 && $m > 10 || $y == 1582 && $m == 10 && $d > 14)
            && ($y < 1752 || $y == 1752 && $m <  9 || $y == 1752 && $m ==  9 && $d < 14) ) {
      print_english();
   }
   if (  $j && ($y > 1582 || $y == 1582 && $m > 10 || $y == 1582 && $m == 10 && $d >  4)
            && ($y < 1752 || $y == 1752 && $m <  9 || $y == 1752 && $m ==  9 && $d <  3) ) {
      print_english();
   }
   if (  $j && ($y > 1752 || $y == 1752 && $m >  9 || $y == 1752 && $m ==  9 && $d >  2) ) {
      print_julian();
   }
   return 1;
} # end sub print_warnings

sub print_proleptic {
   print ((<<'   END_OF_PROLEPTIC') =~ s/^   //gmr);
   ###############################################################################
   # WARNING: You entered a Gregorian date which is before the Gregorian         #
   # calendar came into existence on Friday, October 15, 1582CEG (October 5,     #
   # 1582CEJ). Hence, the date you gave is a "proleptic" application of          #
   # The Gregorian Calendar to a point in time in which it did not yet exist.    #
   # Literature of that time used Julian Calendar dates, which are typically     #
   # 11-13 days off from proleptically-applied Gregorian dates.                  #
   ###############################################################################
   END_OF_PROLEPTIC
   return 1;
} # end sub print_proleptic

sub print_english {
   print ((<<'   END_OF_ENGLISH') =~ s/^   //gmr);
   ###############################################################################
   # WARNING: The date you entered is during the nearly-two-century-long period  #
   # during which The English-speaking world was still using The Julian Calendar #
   # even though the rest of The World was using The Gregorian Calendar.         #
   #                                                                             #
   # Although The Gregorian Calendar took effect on Friday October 15, 1582,     #
   # The British Empire and it's colonies (including those which later became    #
   # USA) didn't adopt The Gregorian calendar until September 14, 1752. Thus     #
   # all dates in English-language literature before that date are in            #
   # The Julian Calendar, and are 11-to-13 days off from The Gregorian Calendar. #
   #                                                                             #
   # When The British Empire adopted The Gregorian Calendar on 1752-09-14, the   #
   # date jumped from September 2, 1752 to September 14, 1752, thus seemingly    #
   # slicing 11 days out of history. The dates from Sep 3, 1752 through          #
   # Sep 13, 1752 thus do not appear in English-language literature at all.      #
   # It's not that those dates didn't exist; they did; but they were only used   #
   # in non-English-speaking countries which had already converted to Gregorian  #
   # years or centuries earlier.                                                 #
   #                                                                             #
   # So if the date you typed is in connection with the English language, it's   #
   # best expressed in Julian; whereas if it is in connection with any other     #
   # language (especially Spanish, French, or Italian), it's best expressed in   #
   # Gregorian. (Note: This prescription applies only to the time range from     #
   # Friday October 15, 1582CEG through Wednesday September 13, 1752CEG. Before  #
   # that time period, the whole world was using Julian; and after, Gregorian.)  #
   ###############################################################################
   END_OF_ENGLISH
   return 1;
} # end sub print_english

sub print_julian {
   print ((<<'   END_OF_JULIAN') =~ s/^   //gmr);
   ###############################################################################
   # WARNING: You entered a Julian date which is after the Gregorian calendar    #
   # came into worldwide use on Thu Sep 14, 1752CEG (Thu Sep 03, 1752CEJ).       #
   # Hence, the date you gave is an "anachronistic" application of Julian to a   #
   # point in time in which it was no-longer being widely used. Literature       #
   # written on-or-after Thu Sep 14, 1752CEG nearly always uses the Gregorian    #
   # calendar. Julian after that date is mostly only used in certain religions,  #
   # most notably Christian "orthodox" churches.                                 #
   ###############################################################################
   END_OF_JULIAN
   return 1;
} # end sub print_julian

sub error {
   print ((<<'   END_OF_ERROR') =~ s/^   //gmr);

   Error: day-of-week.pl takes exactly 3 arguments, which must be year, month, and
   day, expressed as 3 separate integers, in that order, with the date being
   earlier than 1 1 1 Julian and no later than 5000000 12 31 Gregorian.
   Help follows:
   END_OF_ERROR
   return 1;
} # end sub error

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Introduction:

   Welcome to Robbie Hatley's nifty "Day Of Week" program. Given a date
   from    Fri Jan 01 5000000BC Julian (Fri Apr 29 5000103BC Gregorian)
   through Sat Dec 31 5000000CE Julian (Sat Sep 01 5000103CE Gregorian)
   this program will tell you what day-of-week (Sun, Mon, Tue, Wed, Thu, Fri, Sat)
   that date is. Dates must be entered as three integer command-line arguments
   in the order "year, month, day".
   To enter CE dates, use positive year numbers (eg,  "1974" for 1974CE).
   To enter BC dates, use negative year numbers (eg, "-5782" for 5782BC).
   By default, dates entered will be construed as Gregorian, but if a -j or
   --julian option is used, the input date will be construed as Julian.
   The output will be to STDOUT and will consist of both Gregorian and Julian
   dates in "Wednesday December 27, 2017" format. Thus this program serves
   not-only to print day-of-week, but also as a Gregorian-to-Julian and
   Julian-to-Gregorian date converter.

   -------------------------------------------------------------------------------
   Command lines:

   day-of-week.pl [-h | --help]              (to print this help and exit)
   day-of-week.pl [options] year month day   (to print day-of-week)

   -------------------------------------------------------------------------------
   Description of options:

   Option:            Meaning:
   -h or --help       Print help and exit.
   -e or --debug      Print diagnostics.
   -g or --gregorian  Construe entered date as Gregorian (DEFAULT)
   -j or --julian     Construe entered date as Julian.
   -w or --warnings   Print "Proleptic" or "English" warnings if appropriate.

   If a "-j" or "--julian" option is used, the date given will be construed
   to be Julian; otherwise, it will be construed to be Gregorian.

   If a "-w" or "--warnings" option is used, this program will warn you when you
   request a Gregorian date for a point in time in which the Gregorian calendar
   was either not in use, or not in use in the English-speaking world. Otherwise,
   no warnings will be given.

   -------------------------------------------------------------------------------
   Description Of Arguments:

   This program must be given exactly 3 arguments, which must be the year, month,
   and day for which you want day-of-week. This date must be
   from    Fri Jan 01 5000000BC Julian (Fri Apr 29 5000103BC Gregorian)
   through Sat Dec 31 5000000CE Julian (Sat Sep 01 5000103CE Gregorian)
   To enter CE dates, use positive year numbers (eg,  "1974" for 1974CE).
   To enter BC dates, use negative year numbers (eg, "-5782" for 5782BC).

   -------------------------------------------------------------------------------
   Usage Examples:

   Example 1 (Gregorian):
     input:   day-of-week.pl 1954 7 3
     output:  Gregorian = Saturday July 3, 1954CEG
              Julian    = Saturday June 20, 1954CEJ

   Example 2 (Julian):
     input:   day-of-week.pl -j 874 5 8
     output:  Gregorian = Saturday May 12, 874CEG
              Julian    = Saturday May 8, 874CEJ


   Happy day-of-week printing!

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
