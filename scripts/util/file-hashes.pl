#!/usr/bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# file-hashes.pl
# Prints various hashes of the contents of all regular files in current directory (and all subdirectories as
# well, if a -r or --recurse option is used).
# Edit history:
# Thu Jan 14, 2021: Wrote it.
# Sat Nov 13, 2021: Added ARGV processing, recursion, stats, etc.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and
#                   "Sys::Binmode".
# Thu Nov 25, 2021: Simplified: got rid of unnecessary variables and warnings.
# Sun Nov 28, 2021: Added comments, simplified getting file name, and now printing UTF-8 header lines to avoid
#                   text editors mistakenly thinking that index files are ASCII when they're actually UTF-8.
#                   Also now prints name of program and author, and time and date of index-file generation.
# Fri Aug 19, 2022: Changed name from "index.pl" to "file-hashes.pl", which is a much better description.
# Thu Aug 17, 2023: Reduced width from 120 to 110. Upgraded from "v5.32" to "v5.36". No longer using CPAN
#                   module "common::sense" (antiquated). Sub error is now single-purpose (doesn't call
#                   help or exit). Put headings in help. Subs error and help now print initial blank line.
#                   Got rid of all prototypes and now using signatures. Now skips all "meta" files
#                   (hidden, desk, thumbs, browse, id). Updated sub argv to my latest tech.
# Fri Sep 01, 2023: Got rid of $db, -e, --debug (unnecessary). Now using "d getcwd" instead of "cwd_utf8".
#                   Got rid of $Verbose (not necessary). Now always printing entry and exit messages and stats
#                   to STDERR and file header to STDOUT. Fixed some errors in comments and help.
##############################################################################################################

# Pragmas:
use v5.36;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

# CPAN modules:
use Sys::Binmode;
use Cwd;
use Time::HiRes 'time';
use Digest::MD5 qw( md5_hex );
use Digest::SHA qw( sha1_hex sha224_hex sha256_hex sha384_hex sha512_hex );

# Homebrew modules:
use RH::Dir;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ; # Process @ARGV.
sub curdire ; # Process current directory.
sub curfile ; # Process current file.
sub error   ; # Handle errors.
sub help    ; # Print help and exit.

# ======= PAGE-GLOBAL LEXICAL VARIABLES: =====================================================================

# Settings:   Default:     Meaning of setting:       Range:   Meaning of default:
my $Help    = 0        ; # Print help and exit?      0,1      Don't print help.
my $Recurse = 0        ; # Recurse subdirectories?   bool     Don't recurse.
my $RegExp  = qr/^.+$/ ; # Regular Expression.       regexp   Process all file names.

# Counters:
my $direcount = 0; # Count of directories processed by curdire().
my $filecount = 0; # Count of dir entries processed by curfile().
my $hashcount = 0; # Count of files successfully hashed.
my $errocount = 0; # Count of errors encountered.
my $skipcount = 0; # Count of files skipped.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   # Set time, program, and cwd variables:
   my $t0    = time;
   my $pname = get_name_from_path($0);
   my $cwd   = d getcwd;

   # Process arguments:
   argv;

   # Print entry message to STDERR:
   say    STDERR '';
   say    STDERR "Now entering program \"$pname\"." ;
   say    STDERR "\$Recurse = $Recurse"   ;
   say    STDERR "\$RegExp  = $RegExp"    ;

   # Print file header to STDOUT:
   $cwd = d getcwd;
   say STDOUT "File hashes for all non-meta regular files matching regular expression \"$RegExp\"";
   say STDOUT "in directory \"$cwd\".";
   say STDOUT "(And in all subdirectories thereof.)" if $Recurse;
   say STDOUT "This is a UTF-8-transformed Unicode-encoded text file.";
   say STDOUT "This file was generated by program \"$pname\" by Robbie Hatley.";

   # Print hashes of all files in current directory (and its subdirectories if recursing) to STDOUT:
   $Recurse and RecurseDirs {curdire} or curdire;

   # Print exit message to STDERR:
   say    STDERR '';
   say    STDERR "Program \"$pname\" has finished processing this directory tree.";
   say    STDERR "Navigated $direcount directories.";
   say    STDERR "Found $filecount files matching given regular expression.";
   say    STDERR "Skipped $skipcount files which were non-data or meta.";
   say    STDERR "Printed hashes for $hashcount files.";
   say    STDERR "Tried-but-failed to hash $errocount files.";
   say    STDERR "Now exiting program \"$pname\".";
   printf STDERR "Execution time was %.3f seconds.", time - $t0;

   # We're finished, so exit program:
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ============================================================================

sub argv {
   # Get options and arguments:
   my @opts = ();             # options
   my @args = ();             # arguments
   my $end = 0;               # end-of-options flag
   my $s = '[a-zA-Z0-9]';     # single-hyphen allowable chars (English letters, numbers)
   my $d = '[a-zA-Z0-9=.-]';  # double-hyphen allowable chars (English letters, numbers, equal, dot, hyphen)
   for ( @ARGV ) {
      /^--$/                  # "--" = end-of-options marker = construe all further CL items as arguments,
      and $end = 1            # so if we see that, then set the "end-of-options" flag
      and next;               # and skip to next element of @ARGV.
      !$end                   # If we haven't yet reached end-of-options,
      && ( /^-(?!-)$s+$/      # and if we get a valid short option
      ||   /^--(?!-)$d+$/ )   # or a valid long option,
      and push @opts, $_      # then push item to @opts
      or  push @args, $_;     # else push item to @args.
   }

   # Process options:
   for ( @opts ) {
      /^-$s*h/ || /^--help$/    and help and exit 777;
      /^-$s*r/ || /^--recurse$/ and $Recurse = 1;
   }

   # Set $RegExp to first arg (if there is one), and ignore remaining args (if any):
   @args and $RegExp = qr/$args[0]/;

   # Return success code 1 to caller:
   return 1;
} # end sub argv

sub curdire {
   # Increment directory counter:
   ++$direcount;

   # Get and announce current working directory:
   my $cwd = d getcwd;
   say "\nDirectory # $direcount: $cwd";

   # Get list of all regular-file entries in $cwd:
   my @paths = glob_regexp_utf8($cwd, 'F', $RegExp);

   # Send data-file paths to curfile(), and increment skip counter for non-data-file paths:
   foreach my $path (@paths) {
      unless (is_data_file($path)) {++$skipcount;next;} # Skip all but existing non-d non-l regular files.
      if     (is_meta_file($path)) {++$skipcount;next;} # Skip hidden, desk, thumbs, browse, id.
      curfile($path);
   }
   return 1;
} # end sub curdire

# Process current file:
sub curfile ($path) {                          # Enter subroutine "curfile".
   ++$filecount;                               # Increment file counter.
   my $name = get_name_from_path($path);       # Get name of current file.
   my   $fh = undef;                           # File handle (initially undefined).
   local $/ = undef;                           # Set "input record separator" to EOF.
   open($fh, '< :raw', e $path)                # Try to open the file for reading in "raw" mode.
   or warn "Error: couldn't open \"$name\".\n" # If file-open failed, warn user
   and ++$errocount                            # and increment error counter
   and return 0;                               # and return failure code.
   my $data = <$fh>;                           # Slurp file into $data as one big string of unprocessed bytes.
   defined $data                               # Test if $data is defined.
   or warn "Error: couldn't read \"$name\".\n" # If file-read failed, warn user
   and ++$errocount                            # and increment error counter
   and return 0;                               # and return failure code.
   close($fh);                                 # Close file.
   my $size = length($data);                   # Get size of data in bytes.
   say '';                                     # Print blank line.
   say "File   = $name";                       # Print name of file.
   say "Size   = ", $size;                     # Print size of data.
   say "MD5    = ", md5_hex($data);            # Print MD5    hash of data.
   say "SHA1   = ", sha1_hex($data);           # Print SHA1   hash of data.
   say "SHA224 = ", sha224_hex($data);         # Print SHA224 hash of data.
   say "SHA256 = ", sha256_hex($data);         # Print SHA256 hash of data.
   say "SHA384 = ", sha384_hex($data);         # Print SHA384 hash of data.
   say "SHA512 = ", sha512_hex($data);         # Print SHA512 hash of data.
   ++$hashcount;                               # Increment success counter.
   return 1;                                   # Return success code.
} # end sub curfile ($path)                    # Finished with current file.

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   -------------------------------------------------------------------------------
   Intro:

   Welcome to "file-hashes.pl". This program prints various hashes of the contents
   of all regular files in the current directory (and all subdirectories if a -r
   or --recurse option is used), except for "meta" files (hidden, desktop,
   thumbnails, browse, or id-token).

   The primary purpose of this program is to generate index files for image
   collections, but it can also be used to generate hashes for any other types
   of data files which one wants to hash.

   -------------------------------------------------------------------------------
   Command lines:

   file-hashes.pl -h | --help              (to print help and exit)
   file-hashes.pl [options] [arguments]    (to print data hashes  )

   -------------------------------------------------------------------------------
   Description of options:

   Option:               Meaning:
   -h or --help          Print help and exit.
   -r or --recurse       Recurse subdirectories. (Default is "local only".)

   All other options are ignored.

   -------------------------------------------------------------------------------
   Description of arguments:

   In addition to options, this program can take one optional argument which, if
   present, must be a Perl-Compliant Regular Expression specifying which files to
   hash. To specify multiple patterns, use the | alternation operator.
   To apply pattern modifier letters, use one of the four appropriate Extended
   Regexp Sequences: (?letters) (?^letters) (?letters:regexp) (?^letters:regexp)
   For example, if you want to search for items with names containing "cat",
   "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else your shell may replace
   it with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   All arguments after the first one are ignored.

   Happy file hashing!

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
__END__
