#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# text-hashes.pl
# Prints various hashes of the UTF-8 transformations of the Unicode codepoints of incoming text.
#
# Edit history:
# Thu Jan 14, 2021: Wrote it.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
# Thu Nov 25, 2021: Simplified (got rid of unnecessary temp variables). Fixed bug which was causing program to crash
#                   for all codepoints over 255 (the solution was to hash the UTF-8 transformations instead of trying
#                   to hash the raw Unicode codepoints).
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;

use Digest::MD5 qw( md5_hex );
use Digest::SHA qw( sha1_hex sha224_hex sha256_hex sha384_hex sha512_hex );
use Encode 'encode_utf8';

# WOMBAT : What exactly does "hash of text" even MEAN??? We're faced with a pair of quandaries:
# 1. The hashes in Digest::MD5 and Digest::SHA don't take kindly to codepoints over 255; they trigger "wide character in
#    subroutine entry" errors.
# 2. While we know what a "hash" is (in the MD5/SHA sense of the word), what is "text"??? Is it the Unicode codepoints?
#    Or the UTF-8 transformations of the Unicode codepoints? I would argue the former is the correct answer. BUT!!!
#    If we send, say, the 茶 character to the MD5 or SHA subs, we die with "wide character in subroutine entry".
#    So do we sent the UTF-8 transformation of the text coming in via <> ? That would work.
#    Or do we open the files in :raw mode? But that's the same thing, because they're all UTF-8 internally.
#    So I'm electing to just use <>, then encode the text with Encode::encode_utf8 (to compensate for the fact that
#    -CSDA automatically untransforms all UTF-8 back to Unicode inbound). 

say "This program prints various hashes of UTF-8 transformations of incoming text.";
say "(I can't hash raw Unicode because the Digest::* subroutines croak for all";
say "codepoints over 255.)";

my $i = 0;

for (<>)
{
   ++$i;
   s/\s+$//;
   say '';
   my $e = encode_utf8($_);
   say "Text line $i:  \t$_";
   say "UTF-8 version: \t$e";
   say "MD5    = ", md5_hex($e);
   say "SHA001 = ", sha1_hex($e);
   say "SHA224 = ", sha224_hex($e);
   say "SHA256 = ", sha256_hex($e);
   say "SHA384 = ", sha384_hex($e);
   say "SHA512 = ", sha512_hex($e);
}
