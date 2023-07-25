#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file.
# ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# copy-move-tests.pl
# Tests these subs in RH::Dir: "copy_file", "copy_file_unique", "move_file", "move_file_unique".
#
# Edit history:
#    Thu Dec 31, 2020: Wrote it.
########################################################################################################################

use v5.32;
use strict;
use warnings;
use warnings FATAL => "utf8";
use utf8;
use RH::Dir;

copy_file         "c1.txt", "d01-none";
copy_file         "c1.txt", "d02-identical";
copy_file         "c1.txt", "d03-altered";
copy_file_unique  "c1.txt", "d04-none";
copy_file_unique  "c1.txt", "d05-identical";
copy_file_unique  "c1.txt", "d06-altered";
move_file         "c2.txt", "d07-none";
move_file         "c3.txt", "d08-identical";
move_file         "c4.txt", "d09-altered";
move_file_unique  "c5.txt", "d10-none";
move_file_unique  "c6.txt", "d11-identical";
move_file_unique  "c7.txt", "d12-altered";

# Test rejection of non-existent source:
copy_file         "c8.txt", "d14";
copy_file_unique  "c8.txt", "d14";
move_file         "c8.txt", "d14";
move_file_unique  "c8.txt", "d14";

# Test rejection of non-existent directory:
copy_file         "c1.txt", "d13";
copy_file_unique  "c1.txt", "d13";
move_file         "c1.txt", "d13";
move_file_unique  "c1.txt", "d13";


