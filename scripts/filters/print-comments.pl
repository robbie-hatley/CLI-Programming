#!/usr/bin/env -S perl -CSDA
use v5.36;
use utf8;
say for map {s/^.*?#\s*//r} grep {/#/} map {chomp,$_} <>;
