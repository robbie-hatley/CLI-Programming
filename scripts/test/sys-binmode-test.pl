#! /bin/perl -CSDA
# sys-binmode-test.pl
use v5.32;
use strict;
use warnings;
use utf8;
use warnings FATAL => "utf8";
use Encode;
use Sys::Binmode;
use RH::Dir;
chdir_utf8('/cygdrive/d/test-range/unicode-test');
my $txt_raw = "é";
$txt_raw .= "Ā";
chop $txt_raw;
my $txt_enc = encode('UTF-8', $txt_raw, Encode::WARN_ON_ERR|Encode::LEAVE_SRC);
say '';
say 'Ordinals for raw text:';
printf("%X\n", $_) for map {ord($_)} $txt_raw;
say '';
say 'Ordinals for enc text:';
printf("%X\n", $_) for map {ord($_)} $txt_enc;
say '';
say 'Saying raw text:';
say $txt_raw;
say '';
say 'Saying enc text:';
say $txt_enc;
say '';
say 'Echoing raw text:';
system('echo', $txt_raw);
say '';
say 'Echoing enc text:';
system('echo', $txt_enc);
say '';
