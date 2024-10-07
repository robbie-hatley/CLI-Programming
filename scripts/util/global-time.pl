#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# global-time.pl
# Displays current time at various locations in any of several formats.
# Written by Robbie Hatley.
#
# Edit history:
# Sun May 03, 2015: Wrote first draft.
# Fri Jul 17, 2015: Made some minor improvements.
# Sat Apr 16, 2016: Converted from ASCII to UTF-8, and now using -CSDA.
# Sun Dec 31, 2017: Wrote help().
# Thu Feb 04, 2021: Changed name of this file to "global-time.pl".
# Mon Feb 15, 2021: Pulled all time-related subs from RH::Util and dropped them in here instead, as they're
#                   highly-experimental and they're ONLY being used here.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Thu Oct 03, 2024: Got rid of Sys::Binmode and common::sense; added "use utf8".
########################################################################################################################

use v5.32;
use utf8;

use RH::Util;

sub process_argv  ()      ;
sub is_leap_year  ($)     ;
sub days_in_month ($$)    ;
sub format_time   (;$$$$) ;
sub help          ()      ;

my $db      = 0;
my $Zone    = 'pacific';
my $Style   = 'ampm';
my $Length  = 'short';

{ # begin main
   process_argv();
   say scalar format_time(time, $Zone, $Style, $Length);
   exit 0;
} # end main

sub process_argv ()
{
   my $help;
   my @CLArgs;
   for (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         if ('-h' eq $_ || '--help'          eq $_) {$help   =  1        ;}
         if ('-p' eq $_ || '--zone=pacific'  eq $_) {$Zone   = 'pacific' ;}
         if ('-m' eq $_ || '--zone=mountain' eq $_) {$Zone   = 'mountain';}
         if ('-c' eq $_ || '--zone=central'  eq $_) {$Zone   = 'central' ;}
         if ('-e' eq $_ || '--zone=eastern'  eq $_) {$Zone   = 'eastern' ;}
         if ('-u' eq $_ || '--zone=utc'      eq $_) {$Zone   = 'utc'     ;}
         if ('-a' eq $_ || '--style=ampm'    eq $_) {$Style  = 'ampm'    ;}
         if ('-t' eq $_ || '--style=24h'     eq $_) {$Style  = '24h'     ;}
         if ('-l' eq $_ || '--length=long'   eq $_) {$Length = 'long'    ;}
         if ('-s' eq $_ || '--length=short'  eq $_) {$Length = 'short'   ;}
         if ('-u' eq $_ || '--length=micro'  eq $_) {$Length = 'micro'   ;}
      }
      else {push @CLArgs, $_;}
   }
   if ($help) {help(); exit 777;}
   return 1;
} # end sub process_argv ()

sub is_leap_year ($)
{
   my $Year = shift;
   my $Leap = (0 == $Year % 4 && 0 != $Year % 100) || (0 == $Year % 400);
   return $Leap;
} # end is_leap_year ($)


sub days_in_month ($$)
{
   my $Year  = shift;
   my $Month = shift;
   my $Last = 31;
   given ($Month)
   {
      $Last = 31 when  0;
      $Last = 31 when  2;
      $Last = 30 when  3;
      $Last = 31 when  4;
      $Last = 30 when  5;
      $Last = 31 when  6;
      $Last = 31 when  7;
      $Last = 30 when  8;
      $Last = 31 when  9;
      $Last = 30 when 10;
      $Last = 31 when 11;
      # February needs special handling:
      when (1)
      {
         if (is_leap_year($Year)) {$Last = 29;}
         else                     {$Last = 28;}
      }
   }
   return $Last;
} # end sub days_in_month ($$)

# Sub "format_time", given an epoch time (seconds since midnight on
# Jan 1, 1970), gives a nicely-formated human-readable time string,
# controlled by 3 additonal inputs: location, style, and length.
# All 4 inputs are optional:
# epoch_time defaults to current time.
# location   defaults to UTC   (ie, London, England)
# style      defaults to 24H   (eg, "eighteen hundred hours" instead of "6PM")
# length     defaults to short (eg, "3:50:46 PM PST, Thu Dec 28, 2017")
# valid values of "epoch_time" are integers 0 through 9223372036854775807.
# valid values of "location"   are:
#    "pacific", "mountain", "central", "eastern", and "utc".
# valid values of "style"      are "ampm" and "24H".
# valid values of "length"     are "micro", "short", and "long".
sub format_time (;$$$$)
{
   my $epoch_time  = time    ; $epoch_time = shift if @_;
   my $location    = 'utc'   ; $location   = shift if @_;
   my $style       = '24h'   ; $style      = shift if @_;
   my $length      = 'short' ; $length     = shift if @_;
   my $db          = 0       ; # Turn on debug?
   say "Debug msg from format_time: \$epoch_time = $epoch_time" if $db;
   say "Debug msg from format_time: \$location   = $location"   if $db;
   say "Debug msg from format_time: \$style      = $style"      if $db;
   say "Debug msg from format_time: \$length     = $length"     if $db;

   my ($gt_second,       $gt_minute,      $gt_hour,
       $gt_day_of_month, $gt_month,       $gt_year,
       $gt_day_of_week,  $gt_day_of_year, $gt_is_dst)
      = gmtime($epoch_time);

   my ($lt_second,       $lt_minute,      $lt_hour,
       $lt_day_of_month, $lt_month,       $lt_year,
       $lt_day_of_week,  $lt_day_of_year, $lt_is_dst)
      = localtime($epoch_time);

   my ($zt_second,       $zt_minute,      $zt_hour,
       $zt_day_of_month, $zt_month,       $zt_year,
       $zt_day_of_week,  $zt_day_of_year, $zt_is_dst)
      =
      ($gt_second,       $gt_minute,      $gt_hour,
       $gt_day_of_month, $gt_month,       $gt_year,
       $gt_day_of_week,  $gt_day_of_year, $lt_is_dst);

   # ========== SET ACRONYM AND OFFSET FOR TIME ZONE: ==========
   my $zone;         # three-letter zone acronym
   my $time_format;  # format string for printf
   my $offset;       # ZoneTime - UtcTime

   given ($location) # Where in The World are we???
   {
      when (m/pacific/i)                          # Pacific Time Zone
      {
         $zone   = $lt_is_dst ? 'PDT' : 'PST';
         $offset = $lt_is_dst ?  -7   :  -8  ;
      }
      when (m/mountain/i)                         # Mountain Time Zone
      {
         $zone   = $lt_is_dst ? 'MDT' : 'MST';
         $offset = $lt_is_dst ?  -6   :  -7  ;
      }
      when (m/central/i)                          # Central Time Zone
      {
         $zone   = $lt_is_dst ? 'CDT' : 'CST';
         $offset = $lt_is_dst ?  -5   :  -6  ;
      }
      when (m/eastern/i)                          # Eastern Time Zone
      {
         $zone   = $lt_is_dst ? 'EDT' : 'EST';
         $offset = $lt_is_dst ?  -4   :  -5  ;
      }
      when (m/utc/i)                              # UTC
      {
         $zone = 'UTC';
         $offset = 0;
      }
      default                                     # unknown
      {
         die 'Unknown time zone.';
      }
   }
   say "Debug msg from format_time: \$zone   = $zone"   if $db;
   say "Debug msg from format_time: \$offset = $offset" if $db;

   # ========== APPLY OFFSET AND HANDLE NEGATIVE HOURS: ==========
   $zt_hour = $gt_hour + $offset;
   if ($zt_hour < 0)               # if this zone is previous day relative to London
   {
      say 'ARGLE' if $db;
      $zt_hour += 24;              #    add 24 to hour
      --$zt_day_of_week;           #    subtract 1 from day-of-week
      if ($zt_day_of_week == -1)   #    if DOW == -1,
      {
         say 'BARGLE' if $db;
         $zt_day_of_week = 6;      #       set DOW to 6.
      }
      --$zt_day_of_month;          #    subtract 1 from day-of-month
      if ($zt_day_of_month == 0)   #    if DOM == 0,
      {
         say 'FARGLE' if $db;
         --$zt_month;              #       subtract 1 from month
         if ($zt_month == -1)      #       if month is -1,
         {
            say 'GARGLE' if $db;
            $zt_month = 11;        #          set month to 11
            --$zt_year;            #          and subtract 1 from year
         }
         $zt_day_of_month = days_in_month($zt_year,$zt_month);
      }
   }

   my $hour;
   my $minu = $zt_minute;
   my $seco = $zt_second;
   my $meri;

   if ($style =~ m/ampm/i)                        # AM/PM
   {
      $hour = ($zt_hour + 11) % 12 + 1;
      $meri = ($zt_hour > 11 ? 'P' : 'A').'M';
      $time_format = "%d:%02d:%02d %s %s";
   }
   else                                           # 24H
   {
      $hour = $zt_hour;
      $meri = '';
      $time_format = "%02d:%02d:%02d%s%s";
   }

   my $time = sprintf("$time_format", $hour, $minu, $seco, $meri, $zone);

   # ========== DATE: ==========
   my $year = 1900 + $zt_year;
   my $dom = $zt_day_of_month;
   my $date;
   if ($length =~ m/micro/i)
   {
      my $month = $zt_month + 1;
      $date = sprintf("%-4d-%02d-%02d", $year, $month, $dom);
   }
   elsif ($length =~ m/long/i)
   {
      my @months   = qw( January February March     April     May      June
                         July    August   September October   November December );
      my $month = $months[$zt_month];
      my @weekdays = qw( Sunday Monday Tuesday Wednesday Thursday Friday Saturday );
      my $dow = $weekdays[$zt_day_of_week];
      $date = sprintf("%s %s %d, %d", $dow, $month, $dom, $year);
   }
   else # default to 'short', a happy medium between 'micro' and 'long'
   {
      my @months = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
      my $month = $months[$zt_month];
      my @weekdays = qw( Sun Mon Tue Wed Thu Fri Sat );
      my $dow = $weekdays[$zt_day_of_week];
      $date = sprintf("%s %s %02d, %d", $dow, $month, $dom, $year);
   }

   # ========== RETURN RESULT: ==========
   if (wantarray)
   {
      return ($date, $time);
   }
   else
   {
      return $time . ', ' . $date;
   }
} # end sub format_time (;$$$$)

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "global-time.pl", Robbie Hatley's nifty time & date program.
   This program prints the current time and date at any of various locations,
   nicely-formatted as a human-readable string in any of several formats,
   controlled by the following options:

   Option:                  Meaning:
   -h or --help             Print this help and exit
   -p or --zone=pacific     Location  = 'pacific'
   -m or --zone=mountain    Location  = 'mountain'
   -c or --zone=central     Location  = 'central'
   -e or --zone=eastern     Location  = 'eastern'
   -u or --zone=utc         Location  = 'utc'
         --zone=[+|-]##     Location  = UTC[+|-]##  (eg, -10 for Hawaii)
   -a or --style=ampm       Style     = 'ampm'
   -t or --style=24h        Style     = '24h'
   -l or --length=long      Length    = 'long'
   -s or --length=short     Length    = 'short'
   -m or --length=micro     Length    = 'micro'

   Any combination of these options may be used in a command line.

   If two options contradict, the right-most over-rides the other.

   Default Location is "pacific"
   Default Style    is "ampm"
   Default Length   is "short"

   Note: The only time zones I currently have written into this program
   are Pacific, Mountain, Central, Eastern, and UTC. Standard Time or
   Daylight Saving Time is automatically selected, and should be correct
   for all parts of the contiguous 48 states of continental USA except for
   non-reservation portions of Arizona, for which the times given will be
   incorrect. (Use PDT for non-reservation Arizona when the rest of the
   country is on daylight saving time. It will give the same time as MST
   would have; just replace the letters "PDT" with "MST" in your mind.)

   Maybe someday if I get bored, I'll put all of Earth's time zones in here.
   But that day is not today.

   Cheers,
   Robbie Hatley,
   Programmer.
   END_OF_HELP
   return 1;
} # end sub help ()
