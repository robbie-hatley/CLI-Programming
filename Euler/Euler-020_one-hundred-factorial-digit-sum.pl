#!/usr/bin/perl
use v5.022;
use Math::BigInt;
use List::Util 'sum';
say sum split //, Math::BigInt->bfac(100);
