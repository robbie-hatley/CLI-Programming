#!/usr/bin/env -S perl -CSDA

# This is an 78-character-wide Unicode UTF-8 Perl-source-code text file.
# ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|========

# "tea.pl"

use v5.32;
use strict;
use warnings;
use warnings FATAL => "utf8";
use utf8;

while (<>)                   # Get a line.
{
   s/[\x0a\x0d]+$//;         # Get rid of newline (whether win, mac, or unix).
   s/[[:alpha:]]/\x{8336}/g; # Change each letter to 茶.
   say;                      # Print altered line, followed by unix newline.
}

=pod

A pretty ridiculous program, but I find it amusing. Replaces each :alpha:
character received via STDIN into a 茶 (cha) character, which is Chinese and
Japanese for "tea".

Example:

Input:
Hello there! How are you doing today?
I'm doing fine, myself.

Output:
茶茶茶茶茶 茶茶茶茶茶! 茶茶茶 茶茶茶 茶茶茶 茶茶茶茶茶 茶茶茶茶茶?
茶'茶 茶茶茶茶茶 茶茶茶茶, 茶茶茶茶茶茶.

=cut

