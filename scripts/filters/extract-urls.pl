#!/usr/bin/env -S perl -CSDA
# extract-urls.pl
use v5.36;
use utf8;
for (<>){
   s/\s+$//;
   my @words = split /[\s<>\(\)\[\]\{\}\\^~`'"]+/;
   for (@words) {
      say if /^http/;
   }
}
