#! /bin/perl -CSDA

# This is a 110-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# utclong.pl
# Prints current UTC time and date in "04:36:43, Friday February  5, 2021, UTC" format.
# Written by Robbie Hatley.
#
# Edit history:
# Tue Apr 19, 2016: Wrote "date.pl", which seems to be the basis of all my time & date scripts.
# Wed Sep 16, 2020: Wrote this version. Now using strftime.
# Tue Sep 22, 2020: Changed name of this version from "date.pl" to "utclong.pl".
# Thu Feb 04, 2021: Fixed "no newline at end" bug and cleaned-up comments and formatting.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Wed Aug 09, 2023: Upgraded from "v5.32" to "v5.36". Got rid of "common::sense" (antiquated). Reduced width
#                   from 120 to 110. Added strict, warnings, etc, to boilerplate.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use utf8;
use Sys::Binmode;
use POSIX 'strftime';

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime;
say POSIX::strftime("%T, %A %B %e, %Y, UTC",$sec,$min,$hour,$mday,$mon,$year);
