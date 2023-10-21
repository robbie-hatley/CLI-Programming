#!/usr/bin/env -S perl -CSDA

##############################################################################################################
# list-by-extension.pl
# Written by Robbie Hatley.
# Edit history:
# Xxx Xxx ##, ####: Wrote it on an unknown date.
# Thu Sep 07, 2023: Now prints the "ls -l" list of all regular files in the current directory,
#                   grouped by extension and case-insensitively sorted within each group.
##############################################################################################################

use v5.36;
use strict;
use warnings;
use Sys::Binmode;

# Extract the name of a file from its "ls -l" directory listing:
sub name ( $line ) {
   return ($line =~ s/^(.+)( [A-Z][a-z]{2} )([ 123][0-9] )( \d{4} )(.+)$/$5/r); # Trim-off all but file name.
}

# Get the "extension" part of a file name:
sub ext ( $name ) {
   my $di = rindex $name, '.';
   return '' if -1 == $di;
   return substr $name, $di+1;
}

# Git "ls -l" listing of current directory:
my @dir_lines = `/usr/bin/ls -l`;

# Make hash of directory lines for regular files only, keyed by file-name extension:
my %exts;
for my $line ( @dir_lines ) {
   s/\s+$//;                               # Trim newline from each line.
   next if $_ =~ m/^total/;                # Skip "total" line.
   next if $_ =~ m/^d/;                    # Skip directory lines.
   next if $_ =~ m/^l/;                    # Skip link lines.
   push @{$exts{ext(name($line))}}, $line; # Store line in hash.
}

# Print "ls -l" list of regular files in current directory grouped by extension and case-insensitively sorted:
for my $ext ( sort keys %exts ) {
   say '';
   say for sort {fc(name($a)) cmp fc(name($b))} @{$exts{$ext}};
}
