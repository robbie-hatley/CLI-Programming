#!/usr/bin/env -S perl -CSDA
# file-system-type.pl
use v5.36;
use utf8;
use Encode 'decode_utf8';
use Cwd 'cwd';
use Filesys::Type 'fstype';
sub help {
   say 'This program prints the file-system type of the current working directory.';
   say 'All arguments are ignored (except for "-h" or "--help", which print this help).';
}
/^-h$|^--help$/ and help and exit 777 for @ARGV;
my $cwd = decode_utf8(cwd);
say fstype($cwd);
