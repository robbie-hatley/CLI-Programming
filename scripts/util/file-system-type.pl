#!/usr/bin/perl
use v5.32;
use Cwd 'getcwd';
use Filesys::Type qw( fstype );

my $cwd = getcwd;
say fstype($cwd);
