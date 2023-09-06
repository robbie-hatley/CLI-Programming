#!/bin/perl
# This is a 85-character-wide ASCII Perl source-code text file with Unix line breaks.
#####################################################################################
# make-month-dirs.pl                                                                #
# Written at an unknown time by Robbie Hatley.                                      #
# Edit history:                                                                     #
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate;        #
#                   using "common::sense" and "Sys::Binmode".                       #
# Wed Sep 06, 2023: Upgraded from "v5.23" to "v5.36". Got rid of "common::sense"    #
#                   (antiquated). Downgraded encoding to ASCII. Width now 85.       #
#####################################################################################
for (1..12)
{
   my $month = sprintf "%02d", $_ ;
   mkdir "$month";
}
