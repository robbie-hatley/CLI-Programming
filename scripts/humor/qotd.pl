#!/usr/bin/env -S perl -CSDA

# This is an 78-character-wide Unicode UTF-8 Perl-source-code text file.
# ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|========

# "qotd.pl"

use v5.32;
use strict;
use warnings;
use warnings FATAL => "utf8";
use utf8;

use charnames qw( :full :short );

sub rand_quote();

our @Quotes;

#main
{
   $/ = '$';
   my $hndl;
   open($hndl, '<', '/cygdrive/d/rhe/scripts/humor/qotd.txt')
      or die "Couldn't open file \"/cygdrive/d/rhe/scripts/humor/qotd.txt\".\n";
   @Quotes = map { s/\r\n/\n/r =~ s/\$$//r } <$hndl>;
   close $hndl;
   for (1..13) {rand_quote();}
   exit 0;
}

sub rand_quote()
{
   say $Quotes[int rand scalar @Quotes];
}
