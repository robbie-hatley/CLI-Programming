#! /bin/perl -CSDA
# lstat-test-2.pl
use v5.32;
use utf8;
use Cwd;
use Encode;
use Sys::Binmode;
my $dir = decode_utf8 getcwd;
my $dh  = undef;
opendir($dh, encode_utf8($dir)) or die "Can't open dir!";
my @names = map {decode_utf8($_)} readdir $dh;
foreach my $name (@names)
{
   if ( ! -e encode_utf8 $name ) {say "$name does not exist."; next;}
   lstat(encode_utf8 $name);
   if ( -f _ ) {say "$name is a file.";}
   if ( -d _ ) {say "$name is a directory.";}
}
closedir $dh;
