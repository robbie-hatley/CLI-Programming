#! /usr/bin/perl
# lbe.pl
use v5.36; 
sub ext ($line){
   my $di = rindex $line, '.';
   return '' if -1 == $di;
   return substr $line, $di+1}
my %exts;
for (<>){
   chomp;
   next if $_ =~ m/^total/;      # Line starting with "total"      is not a regular file.
   next if $_ =~ m/^d[rwx-]{9}/; # Line starting with "drwxrwxr-x" is not a regular file.
   my $ext = ext($_);            # Get the file-name extension.
   $exts{$_}=$ext}               # Store extension in hash.
my @files = sort {$exts{$a} cmp $exts{$b}} keys %exts;
say for @files