#!/usr/bin/perl

# This is a 120-character-wide ASCII-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# day-of-week.pl
# Prints day-of-week for dates from Jan 1, 1CEJ (Dec 30, 1BCG) to Dec 31, 5000000CEJ (Sep 1, 5000103CEG).
# Dates must be entered as three integer command-line arguments in the order "year, month, day".
# To enter dates Dec 30, 1BCG or Dec 31, 1BCG, use "0" as "year".
# By default, dates entered will be construed as being Gregorian, but if a -j or --julian option is used,
# the input date will be construed as being Julian. The output will be to STDOUT and will consist of both
# Gregorian and Julian dates in "Wednesday December 27, 2017" format. Thus this program serves not-only
# to print day-of-week, but also as a Gregorian-to-Julian and Julian-to-Gregorian convertor.
#
# Usage examples:
# %day-of-week.pl 1974 8 14
# Gregorian = Wednesday August 14, 1974CEG
# Julian    = Wednesday August 1, 1974CEJ
# %day-of-week.pl 1490 3 18 -j
# Gregorian = Thursday March 27, 1490CEG
# Julian    = Thursday March 18, 1490CEJ
#
# WARNING: this program is fully capable of specifying Gregorian dates for times in which the Gregorian
# calendar did not yet exist (or was not yet in widespread use in English-speaking countries), and Julian
# dates for times in which the Julian calendar was no-longer in widespread use. If in doubt, use a -w or
# --warnings option, and this program will print warnings if you request such "proleptic" (meaning "not in-use
# at that time") uses of dates.
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
sub error           ; # Error message.
sub help            ; # Help for user.

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

   # Calculate day of week from elapsed time since 23:59:59UTC, Dec 31, 1BCJ:
   my $DayOfWeek = day_of_week($Elapsed);

   # Jan 1 and Jan 2 of 1CE Julian are problematic because they're actually
   # Dec 30 and Dec 31 in the year 1BC Gregorian, so we need to be able to
   # print "1BCG" for the year 0 (meaning 1BC) Gregorian:
   my $BCG = 'CEG';
   if (0 == $G_Y)
   {
      $BCG = 'BCG';
      $G_Y = 1;
   }

   # Print day-of-week, date, and elapsed time:
   printf( "Gregorian = %-9s %-9s %2d, %7d%s\n",  $DayOfWeek, $Months[$G_M-1], $G_D, $G_Y, $BCG );
   printf( "Julian    = %-9s %-9s %2d, %7dCEJ\n", $DayOfWeek, $Months[$J_M-1], $J_D, $J_Y       );

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
   my $end = 0;              # end-of-options flag
   my $s = '[a-zA-Z0-9]';    # single-hyphen allowable chars (English letters, numbers)
   my $d = '[a-zA-Z0-9=.-]'; # double-hyphen allowable chars (English letters, numbers, equal, dot, hyphen)
   for ( @ARGV ) {
      /^--$/                 # "--" = end-of-options marker = construe all further CL items as arguments,
      and $end = 1           # so if we see that, then set the "end-of-options" flag
      and next;              # and skip to next element of @ARGV.
      !$end                  # If we haven't yet reached end-of-options,
      && ( /^-(?!-)$s+$/     # and if we get a valid short option
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
   my $NA = scalar(@args);     # Get number of arguments.
   if (3 != $NA) {             # If number of arguments isn't 3,
      error;                   # print error msg,
      help;                    # and print help message,
      exit 666;                # and return The Number Of The Beast.
   }

   # Store arguments in variables:
   $A_Y = $args[0];
   $A_M = $args[1];
   $A_D = $args[2];

   # If input is invalid, bail:
   if
   (
         $Julian && $A_Y <       1 || !$Julian && $A_Y <       0    # If year is too low,
      || $Julian && $A_Y > 5000000 || !$Julian && $A_Y > 5000103    # or year is too high,
      || $A_M < 1 || $A_M > 12                                      # or month is out-of-range,
      || $A_D < 1 || $A_D > days_per_month($A_Y, $A_M, $Julian)     # or day   is out-of-range,
      || !$Julian && $A_Y ==       0 && $A_M  < 12                  # or month is before Dec  1BCG,
      || !$Julian && $A_Y ==       0 && $A_M == 12 && $A_D < 30     # or day is before Dec 30 1BCG,
      || !$Julian && $A_Y == 5000103 && $A_M  >  9                  # or month is after Sep 5000103BCG
      || !$Julian && $A_Y == 5000103 && $A_M ==  9 && $A_D >  1     # or day is after Sep 1 5000103BCG
   )
   {
      error;                                                        # print error message,
      help;                                                         # and print help message,
      exit 666;                                                     # and return The Number Of The Beast.
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
   my @dpm = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
   if ( is_leap_year($Year, $Julian) ) {++$dpm[1];}
   return $dpm[$Month-1];
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
   my $Elapsed = 0;

   # First, we need to give these two cases special handling:

   # Case 1: Jan 1, 1CEJ = Dec 30, 1BCG:
   if    (     $Julian && 1 == $Year &&  1 == $Month &&  1 == $Day
           || !$Julian && 0 == $Year && 12 == $Month && 30 == $Day ) {
      $Elapsed = 0;
   }

   # Case 2: Jan 2, 1CEJ = Dec 31, 1BCG:
   elsif (     $Julian && 1 == $Year &&  1 == $Month &&  2 == $Day
           || !$Julian && 0 == $Year && 12 == $Month && 31 == $Day ) {
      $Elapsed = 1;
   }

   # If we get to here, the date is Jan 3, 1CEJ (Jan 1, 1CEG) or later:
   else {
      # If user specified Gregorian date, add 2 to $Elapsed, because Gregorian dates in 1BC and 1CE are 2 days
      # behind Julian dates:
      if (!$Julian) {$Elapsed += 2;}

      # Next, add-in days from whole years which have elapsed from 00:00:00UTC on Jan 1, 1CEJ
      # up-to (but not including) the current year:
      if ($Year > 1)
      {
         foreach my $PassingYear ( 1 .. $Year - 1 )
         {
            $Elapsed += days_per_year($PassingYear, $Julian);
         }
      }

      # Next, add-in days from whole months which have elapsed this year up-to (but not including) the current
      # month, while taking
      if ($Year > 0 && $Month > 1)
      {
         foreach my $PassingMonth ( 1 .. $Month - 1 )
         {
            $Elapsed += days_per_month($Year, $PassingMonth, $Julian);
         }
      }

      # Finally, add-in days which have elapsed in current month up-to (but not including) today. Subtract 1 from
      # $Day because it's 1-indexed and we need 0-indexed. For example, on June 1 1974, 0 full days have elapsed
      # so far in June, because today has never "elapsed" yet, by definition of "elapsed":
      $Elapsed += ($Day - 1); #
   }

   # Return elapsed time in days since 12:59:59UTC, Dec 31, 1BCJ:
   if ( $Db ) {say "Debug msg at end of elapsed_time(): \$Elapsed = $Elapsed"}
   return $Elapsed;
} # end sub elapsed_time

# Given elapsed time in days since Dec 31, 1BCJ, return date as a ($Year, $Month, $Day) list,
# Julian or Gregorian depending on user's request:
sub emit_despale ($Elapsed, $Julian) {
   my $Accum   = 0; # Accumulation of days elapsed.
   my $DPY     = 0; # Days per year.
   my $DPM     = 0; # Days per month.
   my $Year    = 1; # Year.
   my $Month   = 1; # Month.
   my $Day     = 1; # Day.

   # First of all, if $Elapsed is negative, that's an error:
   if ( $Elapsed < 0 ) {
      die "Fatal error in program \"day-of-week.pl\" in sub emit_despale():\n",
          "This program can only handle dates on or after Dec 31, 1BCG (Jan 1, 1CEJ).\n";
   }

   # The first 2 days of 1CEJ (which are the last two days of 1BCG) need to be handled separately:

   # If $Elapsed is 0, the date is Jan 1, 1CEJ = Dec 30, 1BCG:
   elsif ( 0 == $Elapsed) {
      if ($Julian) {
         ($Year, $Month, $Day) = (1, 1, 1);
      }
      else {
         ($Year, $Month, $Day) =  (0, 12, 30);
      }
   }

   # If $Elapsed is 1, the date is Jan 2, 1CEJ = Dec 31, 1BCG:
   elsif ( 1 == $Elapsed ) {
      if ($Julian) {
         ($Year, $Month, $Day) =  (1, 1, 2);
      }
      else {
         ($Year, $Month, $Day) =  (0, 12, 31);
      }
   }

   # If we get to here, $Elapsed is >= 2 and the date is Jan 3, 1CEJ (Jan 1, 1CEG) or more recent.
   else {
      # If user requested Gregorian date, add 2 TO $Accum, because Gregorian dates in 1BC and 1CE are 2 days
      # behind Julian dates:
      if (!$Julian) {$Accum += 2;}

      # Determine $Year by adding elapsed days from whole years which have elapsed since 00:00:00UTC on
      # Saturday Jan 1, 1CEJ:
      while ( $Accum + ($DPY = days_per_year($Year, $Julian)) <= $Elapsed ) {
         $Accum += $DPY;
         ++$Year;
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

   # Jan 1, 1CEJ is a Saturday (index 6), and the "days elapsed" from Jan 1, 1CEJ to Jan 1, 1CEJ is 0 day,
   # so to get "day of week", we need only to add an offset of 6 to the "days elapsed" then apply modulo 7:
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

   Welcome to Robbie Hatley's nifty "Day Of Week" program. Given a date which is
   no  earlier  than Jan 01       1CE Julian (Dec 30       1BCE Gregorian)
   and no later than Dec 31 5000000CE Julian (Sep 01 5000103CE  Gregorian)
   this program will tell you what day-of-week (Sun, Mon, Tue, Wed, Thu, Fri, Sat)
   that date is. The date you enter will be construed as Gregorian unless you use
   a -j or --julian option, in which case it will be construed as Julian.

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

   If a "-j" or "--julian" option is used, the date given will be assumed
   to be Julian; otherwise, it will be assumed to be Gregorian.

   If a "-w" or "--warnings" option is used, this program will warn you when you
   request a Gregorian date for a point in time in which the Gregorian calendar
   was either not in use, or not in use in the English-speaking world. Otherwise,
   no warnings will be given.

   -------------------------------------------------------------------------------
   Description Of Arguments:

   This program must be given exactly 3 arguments, which must be the year, month,
   and day for which you want day-of-week. This date must be:
   no  earlier  than Jan 01       1CE Julian (Dec 30       1BCE Gregorian)
   and no later than Dec 31 5000000CE Julian (Sep 01 5000103CE  Gregorian).
   To enter either of the last two days of 1BCE Gregorian, use "0" as year.

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
