#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# copy-listed-files.pl
# Copies all files from the __DATA__ section below to the directory given by $ARGV[0].
# Written by Robbie Hatley.
# Edit history:
# Wed Dec 22, 2021: Wrote it.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';
use RH::Dir;
use RH::WinChomp;

if (scalar(@ARGV) != 1) {die "Must have 1 argument, which must be a directory.\n$!\n";}
if ( ! -e $ARGV[0]    ) {die "Must have 1 argument, which must be a directory.\n$!\n";}
if ( ! -d $ARGV[0]    ) {die "Must have 1 argument, which must be a directory.\n$!\n";}

for (<main::DATA>)
{
   winchomp;
   copy_file($_, $ARGV[0]);
}

__DATA__
file name 1
file name 2
file name 3
