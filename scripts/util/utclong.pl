#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# utclong.pl
# Prints current UTC time and date in "04:36:43, Friday February  5, 2021, UTC" format.
# Written by Robbie Hatley.
#
# Edit history:
# Tue Apr 19, 2016: Wrote "date.pl", which seems to be the basis of all my time & date scripts.
# Wed Sep 16, 2020: Wrote this version. Now using strftime.
# Tue Sep 22, 2020: Changed name of this version from "date.pl" to "utclong.pl".
# Thu Feb 04, 2021: Fixed "no newline at end" bug and cleaned-up comments and formatting.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use POSIX 'strftime';

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime;

print POSIX::strftime("%T, %A %B %e, %Y, UTC",$sec,$min,$hour,$mday,$mon,$year);

print "\n";
