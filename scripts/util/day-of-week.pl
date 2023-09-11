#!/usr/bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# day-of-week.pl
# Prints day-of-week for any day from Jan 1, 1 CE through Dec 31, 9999 CE.
# Input:  Date in YYYY-MM-DD format, as sole command-line argument.
# Output: Date in "Wednesday December 27, 2017" format, to STDOUT.
# Author: Written Tuesday December 23, 2016, by Robbie Hatley.
#
# Edit history:
# Tue Dec 23, 2016: Started  writing it.
# Wed Dec 24, 2016: Finished writing it.
# Sat Apr 16, 2016: Now using -CSDA; also added some comments.
# Sun Jul 23, 2017: Commented-out unnecessary module inclusions and clarified some puzzling comments. Also, converted
#                   from utf8 back to ASCII.
# Wed Dec 27, 2017: Clarified comments.
# Mon Apr 16, 2018: Started work on expanding the date range from 1899-12-31 -> 9999-12-31 to   0001-01-01 -> 9999-12-31
# Wed May 30, 2018: Completed date range expansion.
# Wed Oct 16, 2019: Now gives DOW for both Julian and Gregorian dates.
# Thu Feb 13, 2020: Refactored main() and day_of_week(), implemented emit_despale(), and added "day of week from elapsed
#                   time" feature. (Next up: Gregorian <=> Julian)
# Fri Feb 14, 2020: Cleaned-up some comments.
# Sat Feb 15, 2020: Now gives day of week and both Gregorian and Julian dates for all requests. I also muted warnings
#                   unless user requests them. The minimum date is now Dec 30, 1BCG = Jan 1, 1CEJ, and the maximum date
#                   is now unlimited (though, for dates much past 1000000CEG, the computation time becomes unworkable).
#                   Also, removed "input elapsed time", as it's useless.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

# ======= SUBROUTINE PRE-DECLARATIONS ==================================================================================

sub process_argv    ();     # Process @ARGV and set settings accordingly.
sub days_per_year   ($$);   # How many days in given whole year?
sub days_per_month  ($$$);  # How many days in given whole month?
sub is_leap_year    ($$);   # Is given year a leap year?
sub elapsed_time    ($$$$); # Days elapsed since Dec 31 1BCJ to given date.
sub emit_despale    ($$);   # Get date from elapsed days.
sub day_of_week     ($);    # Determine day-of-week for a given date.
sub print_warnings  ($$$$); # Print warnings.
sub print_proleptic ();     # Print proleptic message.
sub print_english   ();     # Print English proleptic message.
sub error_msg       ();     # Error message.
sub help_msg        ();     # Help for user.

# ======= GLOBAL VARIABLES =============================================================================================

# Settings:        # Meaning of setting:       Possible values:
my $Julian   = 0;  # Use Julian Calendar?      (bool)
my $Warnings = 0;  # Emit proleptic warnings?  (bool)
my $A_Year   = 0;  # Year  from CL arguments.
my $A_Month  = 0;  # Month from CL arguments.
my $A_Day    = 0;  # Day   from CL arguments.

my @DaysOfWeek
   = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday);

my @Months
   = qw(January   February  March     April     May       June
        July      August    September October   November  December);

# ======= MAIN BODY OF PROGRAM =========================================================================================

{ # begin main
   # Process @ARGV and set settings and arguments accordingly:
   process_argv();

   # Declare variables for year, month, day, elapsed-time, and Julian:
   my $G_Year;
   my $G_Month;
   my $G_Day;
   my $J_Year;
   my $J_Month;
   my $J_Day;
   my $Elapsed;

   # Get year, month, day from arguments,
   # and derive elapsed time from year, month, and day,
   # and also convert to other calendar:
   if ($Julian)
   {
      $J_Year  = $A_Year;
      $J_Month = $A_Month;
      $J_Day   = $A_Day;
      $Elapsed = elapsed_time($J_Year, $J_Month, $J_Day, 1);
      ($G_Year, $G_Month, $G_Day) = emit_despale($Elapsed, 0);
   }
   else
   {
      $G_Year  = $A_Year;
      $G_Month = $A_Month;
      $G_Day   = $A_Day;
      $Elapsed = elapsed_time($G_Year, $G_Month, $G_Day, 0);
      ($J_Year, $J_Month, $J_Day) = emit_despale($Elapsed, 1);
   }

   # Calculate day of week from elapsed time since 23:59:59UTC, Dec 31, 1BCJ:
   my $DayOfWeek = day_of_week($Elapsed);

   # Jan 1 and Jan 2 of 1CE Julian are problematic because they're actually
   # Dec 30 and Dec 31 in the year 1BC Gregorian, so we need to be able to
   # print "1BCG" for the year 0 (meaning 1BC) Gregorian:
   my $BCG = 'CEG';
   if (0 == $G_Year)
   {
      $BCG = 'BCG';
      $G_Year = 1;
   }

   # Print day-of-week, date, and elapsed time:
   printf("Gregorian = %s %s %d, %d%s\n",
      $DayOfWeek, $Months[$G_Month-1], $G_Day, $G_Year, $BCG);
   printf("Julian    = %s %s %d, %dCEJ\n",
      $DayOfWeek, $Months[$J_Month-1], $J_Day, $J_Year);

   # Now, depending on the history of which calendar was actually IN-USE
   # on the given date, possibly print various warning messages:
   if ($Warnings)
   {
      print_warnings($G_Year, $G_Month, $G_Day, $Julian);
   }

   # We be done, so scram:
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =======================================================================================

sub process_argv ()
{
   my $help   = 0;  # Just print help and exit?
   my @CLArgs = (); # Command-Line Arguments (not including options).

   # Get and process options and arguments.
   # An "option" is "-a" where "a" is any single alphanumeric character,
   # or "--b" where "b" is any cluster of 2-or-more printable characters.
   foreach (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         /^-h$/ || /^--help$/     and $help     = 1;
         /^-j$/ || /^--julian$/   and $Julian   = 1;
         /^-w$/ || /^--warnings$/ and $Warnings = 1;
      }
      else
      {
         push @CLArgs, $_;
      }
   }

   # If user wants help, just print help and bail:
   if ($help) {help_msg(); exit(777);}

   # If number of arguments isn't 3, bail:
   if (3 != scalar(@CLArgs)) {error_msg(); help_msg(); exit(666);}

   # If value of arguments is egregiously invalid, bail:
   if
   (
         $CLArgs[0] < 0                                               # not earlier than 1BCG
      || $CLArgs[1] < 1 || $CLArgs[1] > 12                            # Jan-Dec only
      || $CLArgs[2] < 1                                               # no zero or negative days
      || $CLArgs[2] > days_per_month($CLArgs[0], $CLArgs[1], $Julian) # no invalid days
   )
   {error_msg(); help_msg(); exit(666);}

   # Store arguments in root-level variables:
   $A_Year  = $CLArgs[0];
   $A_Month = $CLArgs[1];
   $A_Day   = $CLArgs[2];

   # We're done processing @ARGV so scram:
   return 1;
} # end sub process_argv()

sub days_per_year ($$)
{
   my $Year   = shift;
   my $Julian = shift;

   my $DaysPerYear = 365;
   if (is_leap_year($Year, $Julian)) {++$DaysPerYear;}
   return $DaysPerYear;
} # end sub days_per_year

sub days_per_month ($$$)
{
   my $Year   = shift;
   my $Month  = shift;
   my $Julian = shift;

   given ($Month)
   {
      when ( 1) {return 31;}
      when ( 2) {return is_leap_year($Year, $Julian) ? 29 : 28;}
      when ( 3) {return 31;}
      when ( 4) {return 30;}
      when ( 5) {return 31;}
      when ( 6) {return 30;}
      when ( 7) {return 31;}
      when ( 8) {return 31;}
      when ( 9) {return 30;}
      when (10) {return 31;}
      when (11) {return 30;}
      when (12) {return 31;}
      default   {die "Illegal month.";}
   }
} # end sub days_per_month

sub is_leap_year ($$)
{
   my $Year   = shift;
   my $Julian = shift;

   if ($Julian)                          # Julian Calendar
   {
      if (0 == $Year%4) {return 1;}
      else              {return 0;}
   }
   else                                  # Gregorian Calendar
   {
      if    ( 0 == $Year%4 && 0 != $Year%100 ) {return 1;}
      elsif ( 0 == $Year%400                 ) {return 1;}
      else                                     {return 0;}
   }
} # end sub is_leap_year

# Calculate days elapsed since Dec 31, 1BC JULIAN through given date.
# Here "days elapsed" means "midnights transitioned-through since
# Dec 31, 1BC Julian = Dec 29, 1BC Gregorian". Hence "days elapsed"
# for Jan 1, 1CE Julian is 1 because only one midnight was transitioned-through
# in order to get from Dec 31, 1BCJ to Jan 1, 1CEJ.
#
# Note that the "zero reference time" is always 23:59:59UTC on
# Dec 31, 1BC Julian, NEVER Gregorian, for the simple reason that
# the Gregorian calendar didn't exist yet, and wouldn't for another
# 1582 years! So when history books say "event x happened on January 1, 1CE",
# that always means Jan 1, 1CE Julian.
sub elapsed_time ($$$$)
{
   my $Year   = shift;
   my $Month  = shift;
   my $Day    = shift;
   my $Julian = shift;

   my $Elapsed = 0;

   # ===================================================================================================================
   # First of all, the incoming date must not be before Jan 1, 1CEJ, as that
   # is the earliest date this program can handle:
   if
   (
      $Julian && 10000*$Year + 100*$Month + $Day < 10101
      ||
     !$Julian && 10000*$Year + 100*$Month + $Day <  1230
   )
   {
      die("Error in elapsed_time:\n".
          "Cannot process dates before Jan 1, 1CEJ = Dec 30, 1BCG.\n");
   }

   # ===================================================================================================================
   # Now for two special cases:

   # Jan 1, 1CEJ = Dec 30, 1BCG:
   if
   (
      $Julian && 10000*$Year + 100*$Month + $Day == 10101
      ||
     !$Julian && 10000*$Year + 100*$Month + $Day ==  1230
   )
   {
      return 1;
   }

   # Jan 2, 1CEJ = Dec 31, 1BCG:
   if
   (
      $Julian && 10000*$Year + 100*$Month + $Day == 10102
      ||
     !$Julian && 10000*$Year + 100*$Month + $Day ==  1231
   )
   {
      return 2;
   }

   # ===================================================================================================================
   # If we get to here, the date is Jan 3, 1CEJ or later.
   # If the given date is Gregorian, add 2 to $Elapsed,
   # because Dec 31, 1BCJ = Dec 29, 1BCG:
   if (!$Julian) {$Elapsed += 2;}

   # ===================================================================================================================
   # Next, add-in days from whole years which have elapsed from Dec 31, 1BCJ
   # up-to (but not including) the current year:

   if ($Year > 1)
   {
      foreach my $PassingYear ( 1 .. $Year - 1 )
      {
         $Elapsed += days_per_year($PassingYear, $Julian);
      }
   }

   # ===================================================================================================================
   # Next, add-in days from whole months which have elapsed this year up to
   # (but not including) the current month:

   if ($Month > 1)
   {
      foreach my $PassingMonth ( 1 .. $Month - 1 )
      {
         $Elapsed += days_per_month($Year, $PassingMonth, $Julian);
      }
   }

   # ===================================================================================================================
   # Finally, add-in days which have elapsed in current month, including today:

   $Elapsed += ($Day);

   # Return elapsed time in days since 12:59:59UTC, Dec 31, 1BCJ:
   return $Elapsed;
} # end sub elapsed_time

# Given elapsed time in days since Dec 31, 1BCJ, derive date as a
# ($Year, $Month, $Day) list (Julian or Gregorian depending on user's request):
sub emit_despale ($$)
{
   my $Elapsed = shift;
   my $Julian  = shift;
   my $Accum   = 0;
   my $DPY     = 0;
   my $DPM     = 0;
   my $Year    = 1;
   my $Month   = 1;
   my $Day     = 1;

   # ===================================================================================================================
   # First of all, if $Elapsed is not a positive integer, that's an error:
   if ($Elapsed < 1)
   {
      die("Error in emit_despale:".
          "This program can only handle dates on or after\n".
          "Jan 1, 1CEJ = Dec 31, 1BCG.\n");
   }

   # ===================================================================================================================
   # Now, two special cases I can't see how to calculate systematically:

   given ($Elapsed)
   {
      # The case of Jan 1, 1CEJ = Dec 30, 1BCJ (elapsed time = 1):
      when (1)
      {
         if ($Julian)
         {
            return (1, 1, 1);
         }
         else
         {
            return (0, 12, 30);
         }
      }

      # The case of Jan 2, 1CEJ = Dec 31, 1BCJ (elapsed time = 2):
      when (2)
      {
         if ($Julian)
         {
            return (1, 1, 2);
         }
         else
         {
            return (0, 12, 31);
         }
      }
   }

   # ===================================================================================================================
   # If we get to here, the date is Jan 3, 1CEJ or more recent.
   # If user requested Gregorian date, add 2 TO $Accum,
   # because Jan 1, 1CEG = Jan 3, 1CEJ:
   if (!$Julian) {$Accum += 2;}


   # ===================================================================================================================
   # Determine year:

   while (1)
   {
      $DPY = days_per_year($Year, $Julian);
      last if $Accum + $DPY >= $Elapsed;
      $Accum += $DPY;
      ++$Year;
   }

   # ===================================================================================================================
   # Determine month:

   while (1)
   {
      $DPM = days_per_month($Year, $Month, $Julian);
      last if $Accum + $DPM >= $Elapsed;
      $Accum += $DPM;
      ++$Month;
   }

   # ===================================================================================================================
   # Determine day:

   while (1)
   {
      last if $Accum + 1 >= $Elapsed;
      $Accum += 1;
      ++$Day;
   }

   return ($Year, $Month, $Day);
} # end sub emit_despale

sub day_of_week ($)
{
   my $Elapsed = shift;

   my $Offset;

   # There are only 7 possible values for "day of week" to correspond to the
   # infinity of all dates. The day-of-week values are cycled-through from
   # left to right, then repeated starting again at left, endlessly. This
   # is a "cyclic Abelian group".

   # Hence the only questions are, what leap-days are we using (Julian or
   # Gregorian), and which group-start-point or "offset" are we using
   # (Julian or Gregorian).

   # This program uses a "base time" of 23:59:59UTC, Fri Dec 31, 1BCJ
   #(which is equivalent to             23:59:59UTC, Fri Dec 29, 1BCG)
   # to calculate all dates, Julian and Gregorian.

   # Jan 1, 1CEJ is a Saturday (index 6), so we need to add an offset of 5
   # to the elapsed days since 23:59:59UTC on Dec 31, 1BCJ:
   $Offset = 5;

   # And that's all we need in order to calculate day-of-week!
   return $DaysOfWeek[($Elapsed + $Offset) % 7];
} # end sub day_of_week

sub print_warnings ($$$$)
{
   my $Year   = shift;
   my $Month  = shift;
   my $Day    = shift;
   my $Julian = shift;

   if
      (
         !$Julian
         &&
         (
            $Year < 1582
            ||
            $Year == 1582 && $Month < 10
            ||
            $Year == 1582 && $Month == 10 && $Day < 15
         )
      )
   {
      print_proleptic();
   }

   if
      (
         !$Julian
         &&
         (
            $Year > 1582
            ||
            $Year == 1582 && $Month > 10
            ||
            $Year == 1582 && $Month == 10 && $Day > 14
         )
         &&
         (
            $Year < 1752
            ||
            $Year == 1752 && $Month < 9
            ||
            $Year == 1752 && $Month == 9 && $Day < 14
         )
      )
   {
      print_english();
   }

   return 1;
} # end sub print_warnings

sub print_proleptic ()
{
print <<'END_OF_PROLEPTIC';
###############################################################################
# WARNING: This program gives day-of-week for Gregorian dates, but the        #
# date you entered is before the Gregorian calendar came into use on          #
# Friday, October 15, 1582. Hence, the day-of-week printed above is a         #
# "proleptic" application of The Gregorian Calendar to a point in time in     #
# which it did not yet exist. Literature of that time used Julian Calendar    #
# dates, which are 11-13 days off from proleptically-applied Gregorian dates. #
###############################################################################
END_OF_PROLEPTIC
return 1;
} # end sub print_proleptic

sub print_english ()
{
print <<'END_OF_ENGLISH';
###############################################################################
# WARNING: This program gives day-of-the-week for Gregorian dates, but the    #
# date you entered is not a date on which the Gregorian calendar was used in  #
# The English-speaking world. Hence, the day-of-week printed above is a       #
# "proleptic" application of The Gregorian Calendar to a point in time in     #
# which it was not actually being used in the English-speaking world, and you #
# should not expect it to correspond to dates recorded in English-language    #
# literature at that time.                                                    #
#                                                                             #
# Although The Gregorian Calendar took effect on Friday October 15, 1582,     #
# The British Empire and it's colonies (including those which later became    #
# USA) didn't adopt The Gregorian calendar until September 14, 1752. Thus     #
# all dates in English-language literature before that date are in            #
# The Julian Calendar, and are 11-to-13 days off from The Gregorian Calendar. #
#                                                                             #
# Furthermore, when The British Empire adopted The Gregorian Calendar on      #
# 1752-09-14, the date jumped from September 2, 1752 to September 14, 1752,   #
# thus seemingly slicing 11 days out of history. The dates from Sep 3, 1752   #
# through Sep 13, 1752 thus DO NOT APPEAR IN ENGLISH-LANGUAGE LITERATURE.     #
# Literature written in countries which adopted The Gregorian Calendar in     #
# 1582 does use the Gregorian dates from late-1582 forward. However, such     #
# literature is mostly written in Spanish, French, or Italian rather than     #
# English.                                                                    #
###############################################################################
END_OF_ENGLISH
return 1;
} # end sub print_english

sub error_msg ()
{
   print ((<<'   END_OF_ERROR') =~ s/^   //gmr);
   Error: day-of-week.pl takes exactly 3 arguments, which must be
   year, month, and day, with the date being no earlier than
   0 12 30 Gregorian or 1 1 1 Julian. Help follows:

   END_OF_ERROR
   return 1;
} # end sub error_msg

sub help_msg ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to Robbie Hatley's nifty "Day Of Week" program. Given a date
   not earlier than January 1 1CE Julian = December 30 1BCE Gregorian,
   this program will tell you what day-of-week (SMTWTFS) that date is.
   The date you give will be assumed to be a Gregorian date unless you
   use a -j or --julian option, in which case it will be assumed to be
   a Julian date.

   Command line:
   day-of-week.pl [-h | --help]
   ...OR...
   day-of-week.pl [-j | --julian] [-w | --warnings] year month day

   If a "-h" or "--help" option is used, then this help message will be printed
   and this application will terminate; any arguments will be ignored.

   Otherwise, this program must be given exactly 3 arguments, which must be
   the year, month, and day for which you want day-of-week. This date must
   be no earlier than Jan 1 1CE Julian = Dec 30 1BCE Gregorian.
   (To enter either of the last two days of 1BCE Gregorian, use "0000" as year.)

   If a "-j" or "--julian" option is used, the date given will be assumed
   to be Julian; otherwise, it will be assumed to be Gregorian.

   If a "-w" or "--warnings" option is used, this program will warn you when you
   request a Gregorian date for a point in time in which the Gregorian calendar
   was either not in use, or not in use in the English-speaking world. Otherwise,
   no warnings will be given.

   Example 1 (Gregorian):
     input:   day-of-week.pl 1954 7 3
     output:  Gregorian = Saturday July 3, 1954CEG
              Julian    = Saturday June 20, 1954CEJ

   Example 2 (Julian):
     input:   day-of-week.pl -j 874 5 8
     output:  Gregorian = Saturday May 12, 874CEG
              Julian    = Saturday May 8, 874CEJ

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help_msg
