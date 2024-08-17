#!/usr/bin/env -S perl -C63

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# file-system-type.pl
# Prints the type of the file system on the partition on which the current directory is located.
# Written by Robbie Hatley, date unknown, but probably circa February 2024.
# Edit history:
# Thu Feb 01, 2024: I wrote this file on this date, give-or-take a few years.
# Thu Aug 15, 2024: -C63, width to 110, got rid of unnecessary "use" statements, added colophon, and added
#                   this title card.
##############################################################################################################

use v5.36;
use utf8;
use Encode 'decode_utf8';
use Cwd 'getcwd';
use Filesys::Type 'fstype';

sub help {
   say 'This program prints the file-system type of the current working directory.';
   say 'All arguments are ignored (except for "-h" or "--help", which print this help).';
}

/^-h$|^--help$/ and help and exit 777 for @ARGV;
my $cwd = decode_utf8 getcwd;
say fstype $cwd;
