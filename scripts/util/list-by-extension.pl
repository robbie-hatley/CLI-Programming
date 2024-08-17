#!/usr/bin/env -S perl -C63

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# list-by-extension.pl
# Prints list of regular files in current directory sorted by name extension.
# Written by Robbie Hatley at unknown date, maybe in 2022.
# Edit history:
# Sun Jun 05, 2022: Wrote this file on this date (give or take a few years).
# Thu Sep 07, 2023: Now prints the "ls -l" list of all regular files in the current directory,
#                   grouped by extension and case-insensitively sorted within each group.
# Thu Aug 15, 2024: -C63; got rid of unnecessary "use" statements.
##############################################################################################################

use v5.36;
use utf8;

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
   $line =~ s/[\p{Zs}\p{Cc}]+$//g; # Trim whitespace and control characters (eg, newlines) from line ends.
   next if $line =~ m/^total/;     # Skip "total" line.
   next if $line =~ m/^d/;         # Skip directory lines.
   next if $line =~ m/^l/;         # Skip link lines.
   push @{$exts{ext(name($line))}}, $line; # Store line in hash.
}

# Print "ls -l" list of regular files in current directory grouped by extension and case-insensitively sorted:
for my $ext ( sort keys %exts ) {
   say '';
   say "Files with extension \"$ext\":";
   say for sort {fc(name($a)) cmp fc(name($b))} @{$exts{$ext}};
}
