#! /usr/bin/perl

# This is a 120-character-wide UTF-8 Unicode Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# Dir.pm
# Robbie Hatley's Directory Tools Module
# Written by Robbie Hatley, starting 2015-03-24
# Contains various utilities for working with directories and files.
# Edit history:
# Tue Jan 23, 2015: Started writing it.
# Fri Jul 10, 2015: Upgraded for utf8.
# Wed Jul 19, 2017: Disallowed case-change rename, and updated comments.
# Mon Dec 18, 2017: Improved comments in RecurseDirs.
# Mon Dec 25, 2017: use 5.026_001, and shortened many lines and comments.
# Sun Dec 31, 2017: Now using Exporter.
# Tue Jun 05, 2018: use v5.20
# Sun Mar 08, 2020: use v5.30.3, and added sub "clone_file".
# Wed Aug 05, 2020: Did minor cleanup of some formatting (line lengths);
#                   also added some comments; also v5.30.3.
# Tue Sep 15, 2020: Clarified comments in GetFiles about the return values from glob_utf8(). Also replaced
#                   "copy" with "cp" in clone_file() as copy was smashing timestamps.
# Tue Oct 27, 2020: Added subs random_name and find_available_random.
# Thu Dec 31, 2020: Increased width of this file to 110 characters. Got rid of subs "copy_wide_jpgs",
#                   "directory_exists", "aggregate_file", "clone_file", and "merge_file". Added subs
#                   "copy_large_images_verbatim", "copy_large_images_sha1", "is_large_image", "copy_file",
#                   "copy_file_unique", "move_file", "move_file_unique".
# Fri Jan 01, 2021: Got rid of subs "copy_file_unique" and "move_file_unique". Instead, I changed subs
#                   "copy_file" and "move_file" to have prototype ($$;@) so that they can take unlimited
#                   additional arguments. They're now looking for 'unique', 'rename', and 'sha1', and I can
#                   add additional functionality at any time without breaking backwards compatibility by
#                   simply checking for more arguments.
# Sun Jan 03, 2021: Added sub "get_suffix_from_type".
# Mon Jan 11, 2021: Added sub "sha1".
# Sat Feb 13, 2021: Fixed some bugs in "glob_regexp_utf8": removed globbing and decoding of directory, which
#                   were causing trouble; this function now requires that the directory input already be
#                   decoded from (whatever) to raw Unicode. This shouldn't be a problem if cwd_utf8 is used;
#                   however, using glob() or <* .*> as source for directory will cause trouble.
# Tue Feb 16, 2021: Completely re-wrote GetFiles() to use glob_regexp_utf8. Refactored both subs to require
#                   a fully-qualified directory (starting with '/') as their first argument.
# Sat Jul 24, 2021: Merged all 6 of my hash subs into a single sub named "hash" to get rid of massive duplication.
# Wed Nov 16, 2021: Re-arranged order of UTF-8-related subs, putting the simple ones on-top. Added warning text
#                   regarding bareword file handles. Also, now using "use common::sense;".
# Sat Nov 20, 2021: use v5.32. Renewed colophon. Revamped pragmas & encodings.
# Sun Nov 21, 2021: Changed name of "find_available_name" to "find_avail_enum_name", and fixed bug which was causing
#                   "enumerate-file-names.pl" to DENUMERATE file names, due to sub "find_available_name" returning the
#                   denumerated version of a file name if that was available for use. That is stupid, because for
#                   "enumerate-file-names.pl" to work right, sub find_available_name MUST return an enumerated name!
# Mon Nov 22, 2021: Changed name of "find_available_random" to "find_avail_rand_name".
#                   Changed name of "copy_large_images" to "copy_files" and widened its scope of usefulness.
#                   Changed name of "move_large_images" to "move_files" and widened its scope of usefulness.
#                   Massively refactored multiple subs. Fixed many errors which I'd introduced in the process.
# Fri Nov 26, 2021: Clarified some comments.
# Fri Aug 19, 2022: Got rid of "#use Win32API::File;" as my scripts are all now dual-OS (Linux+Windows).
# Sun Feb 19, 2023: Added "is_valid_qual_dir".
# Sat Mar 11, 2023: Made MANY changes, mostly relating to skipping problematic directories in both Windows and Linux.
########################################################################################################################

# ======= PACKAGE: =====================================================================================================

package RH::Dir;

# ======= PRAGMAS: =====================================================================================================

# Boilerplate:
use v5.32;
use strict;
use warnings;
use experimental 'switch';
use utf8;
use warnings FATAL => 'utf8';

# Encodings:
use open ':std', IN  => ':encoding(UTF-8)';
use open ':std', OUT => ':encoding(UTF-8)';
use open         IN  => ':encoding(UTF-8)';
use open         OUT => ':encoding(UTF-8)';
# NOTE: these may be over-ridden later. Eg, "open($fh, '< :raw', e $path)".

# CPAN modules:
use Sys::Binmode;
use parent 'Exporter';
use POSIX 'floor', 'ceil', 'strftime';
use Cwd;
use Digest::MD5 qw( md5_hex );
use Digest::SHA qw( sha1_hex sha224_hex sha256_hex sha384_hex sha512_hex );
use Encode qw( :DEFAULT encode decode :fallbacks :fallback_all );
use File::Type;
use File::Copy;
use Image::Size;
use List::Util qw( sum0 );
use Time::HiRes qw( time );
#use Filesys::Type qw( fstype );

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

# Section 1, Major Subroutines (code is long and complex):
sub GetFiles               (;$$$) ; # Get array of filerecords.
sub GetRegularFilesBySize  (;$)   ; # Get hash of arrays of same-size filerecords.
sub FilesAreIdentical      ($$)   ; # Are two files identical?
sub RecurseDirs            (&)    ; # Recursively walk directory tree.
sub copy_file              ($$;@) ; # Copy a file from a source path to a destination directory.
sub move_file              ($$;@) ; # Move a file from a source path to a destination directory.
sub copy_files             ($$;@) ; # Copy files  from a source directory to a destination directory.
sub move_files             ($$;@) ; # Move files  from a source directory to a destination directory.

# Section 2, Private subroutines (NOT exported):
sub rand_int               ($$)   ; # Get a random integer in closed interval [arg1, arg2].
sub random_name            ()     ; # Get a random string of 8 lower-case English letters.
sub is_ascii               ($)    ; # Is a given text string pure ASCII?

# Section 3, UTF-8-related subroutines:
sub d                             ; # utf8-decode.
sub e                             ; # utf8-encode.
sub chdir_utf8             ($)    ; # utf8 version of "chdir".
sub cwd_utf8               ()     ; # utf8 version of "get curr dir".
sub glob_utf8              ($)    ; # utf8 version of "glob".
sub link_utf8              ($$)   ; # utf8 version of "unlink".
sub mkdir_utf8             ($)    ; # utf8 version of "mkdir".
sub open_utf8              ($$$)  ; # utf8 version of "open". WOMBAT: Won't work with bareword filehandles.
sub opendir_utf8           ($$)   ; # utf8 version of "opendir".
sub readdir_utf8           ($)    ; # utf8 version of "readdir".
sub readlink_utf8          ($)    ; # utf8 version of "unlink".
sub rmdir_utf8             ($)    ; # utf8 version of "rmdir".
sub symlink_utf8           ($$)   ; # utf8 version of "unlink".
sub unlink_utf8            ($)    ; # utf8 version of "unlink".
sub glob_regexp_utf8       (;$$$) ; # Regexp file globber using readdir_utf8.

# Section 4, Minor Subroutines (code is (relatively) short and simple):
sub rename_file            ($$)   ; # Rename a file, taking precautions.
sub time_from_mtime        ($)    ; # Get time from mtime.
sub date_from_mtime        ($)    ; # Get date from mtime.
sub get_prefix             ($)    ; # Get prefix from file name.
sub get_suffix             ($)    ; # Get suffix from file name.
sub get_dir_from_path      ($)    ; # Get dir  from file path.
sub get_name_from_path     ($)    ; # Get name from file path.
sub denumerate_file_name   ($)    ; # Remove all numerators from a file name.
sub enumerate_file_name    ($)    ; # Add a random numerator to a file name.
sub annotate_file_name     ($$)   ; # Annotate a file name (with a note).
sub find_avail_enum_name   ($;$)  ; # Find available enumerated file name for given name root and directory.
sub find_avail_rand_name   ($$$)  ; # Find available   random   file name for given dir & suffix.
sub is_large_image         ($)    ; # Does a file contain a large image?
sub get_suffix_from_type   ($)    ; # Return file-name suffix for a given file type.
sub cyg2win                ($)    ; # Convert Cygwin  path to Windows path.
sub win2cyg                ($)    ; # Convert Windows path to Cygwin  path.
sub hash                   ($$;$) ; # Return hash or hash-based file-name of a file.
sub shorten_sl_names       ($$$$) ; # Shorten directory and file names for Spotlight.
sub is_data_file           ($)    ; # Return 1 if a given string is a path to a non-link non-directory regular file.
sub is_valid_qual_dir      ($)    ; # Is a given string a fully-qualified path to an existing directory?

# ======= VARIABLES: ===================================================================================================

# Symbols exported by default:
our @EXPORT =
   qw
   (
      GetFiles                GetRegularFilesBySize   FilesAreIdentical
      RecurseDirs             copy_file               move_file
      copy_files              move_files

      d                       e                       chdir_utf8
      cwd_utf8                glob_utf8               link_utf8
      mkdir_utf8              open_utf8               opendir_utf8
      readdir_utf8            readlink_utf8           rmdir_utf8
      symlink_utf8            unlink_utf8             glob_regexp_utf8

      rename_file             time_from_mtime         date_from_mtime
      get_prefix              get_suffix              get_dir_from_path
      get_name_from_path      path                    denumerate_file_name
      enumerate_file_name     annotate_file_name      find_avail_enum_name
      find_avail_rand_name    is_large_image          get_suffix_from_type
      cyg2win                 win2cyg                 hash
      shorten_sl_names        is_data_file            is_valid_qual_dir
   );

# Symbols which it is OK to export by request:
our @EXPORT_OK =
   qw
   (
      $totfcount $noexcount $ottycount $cspccount $bspccount
      $sockcount $pipecount $slkdcount $linkcount $multcount
      $sdircount $hlnkcount $regfcount $unkncount
   );

# Turn on debugging?
my $db = 0; # Set to 1 for debugging, 0 for no debugging.

# Global counters in namespace "RH", used by subs GetFiles and
# GetRegularFilesBySize. NOTE: These are all reset to 0 EVERY time one of those
# two subs runs, so if you want to accumulate counts of events over multiple
# entries to those subs, you need to store those accumulations in separate
# variables.
our $totfcount = 0; # Count of all directory entities seen, of all types.
our $noexcount = 0; # Count of all errors encountered.
our $ottycount = 0; # Count of all tty files.
our $cspccount = 0; # Count of all character special files.
our $bspccount = 0; # Count of all block special files.
our $sockcount = 0; # Count of all sockets.
our $pipecount = 0; # Count of all pipes.
our $slkdcount = 0; # Count of all symbolic links to directories.
our $linkcount = 0; # Count of all symbolic links to non-directories.
our $multcount = 0; # Count of all directories with multiple hard links.
our $sdircount = 0; # Count of all directories.
our $hlnkcount = 0; # Count of all regular files with multiple hard links.
our $regfcount = 0; # Count of all regular files.
our $unkncount = 0; # Count of all unknown files.

# ======= SECTION 1, MAJOR SUBROUTINES: ================================================================================

# GetFiles returns a reference to an array of filerecords for all files in a user-specified directory.
# Optionally, user can also specify a regular expression to match names against and a single-letter "target"
# specifying which types of directory entries to process (files, dirs, both, or all).
#
# First argument is mandatory and must be a fully-qualified directory, starting with a '/' character.
#
# Second argument, if present, must be a Perl-Compliant Regular Expression to match directory entries against.
#
# Third argument, if present, must be one of the following letters:
# F = regular Files only
# D = Directories only (but not SYMLINKDs).
# B = Both regular files and directories (but not SYMLINKDs).
# A = All files (regular, directories, links, SYMLINKDs, pipes, etc, etc, etc)
sub GetFiles (;$$$)
{
   my $dir    = @_ ? shift(@_) : cwd_utf8; # What directory does user want a list of file-info packets for?
   my $target = @_ ? shift(@_) : 'A';      # 'F' = 'Files'; 'D' = 'Directories'; 'B' = 'Both'; 'A' = 'All'.
   my $regexp = @_ ? shift(@_) : '^.+$';   # What regular expression should we use for selecting files?

   if ($db)
   {
      say "IN GetFiles. \$dir    = $dir";
      say "IN GetFiles. \$target = $target";
      say "IN GetFiles. \$regexp = $regexp";
   }

   if ($dir !~ m/^\//)
   {
      die "Error in GetFiles: directory must start with \"/\".\n".
          "To use \".\", use \"GetFiles cwd_utf8\".\n".
          "To use \"..\", use \"chdir '..'; GetFiles cwd_utf8\".\n";
   }

   # Zero all RH::Dir counters here. You should save a copy in main:: if you want to keep this info, because it gets
   # zeroed each time GetFiles or GetRegularFilesBySize are run. These are "per directory info fetch" only.
   $totfcount = 0; # Count of all directory entities seen, of all types.
   $noexcount = 0; # Count of all errors encountered.
   $ottycount = 0; # Count of all tty files.
   $cspccount = 0; # Count of all character special files.
   $bspccount = 0; # Count of all block special files.
   $sockcount = 0; # Count of all sockets.
   $pipecount = 0; # Count of all pipes.
   $slkdcount = 0; # Count of all symbolic links to directories.
   $linkcount = 0; # Count of all symbolic links to non-directories.
   $multcount = 0; # Count of all directories with multiple hard links.
   $sdircount = 0; # Count of all directories.
   $hlnkcount = 0; # Count of all regular files with multiple hard links.
   $regfcount = 0; # Count of all regular files.
   $unkncount = 0; # Count of all unknown files.

   # Get fully-qualified paths of all entries (except for '.' and '..') in directory "$dir" which match
   # regular expression $regexp and target $target:
   my @paths = glob_regexp_utf8($dir, $target, $regexp);
   if ($db)
   {
      say 'IN GetFiles. Raw paths from glob_regexp_utf8:';
      say for @paths;
   }

   # Iterate through file paths, collecting info on files and pushing that hashes of that info onto
   # @filerecords, then returning a ref to @filerecords after the loop:
   my @filerecords = ();
   for my $path (@paths)
   {
      # Increment $totfcount as our first act inside the @filepaths loop, because this should be a count of
      # "all directory entries seen in this directory"; whether any such objects actually exist or are
      # regular files or not is not relevant to "totfcount":
      ++$totfcount;

      # Get the name of this directory entry from its path:
      my $name = get_name_from_path($path);

      # What type of thing is at $path? Categorize as exactly 1 type, to reduce complexity and confusion.
      # Start by determinnig if $path is non-existent. If existent, try to ascertain if it's one of the
      # more rare and dangerous types. Then work down to commonplace objects such as "directories" and
      # "regular files". If all tests fail, mark it 'U' for "unknown".
      #
      # NOTE: the -t test differs from all the others in that its argument defaults to STDIN instead of $_.
      #
      # NOTE: The only way I've been able to find to detect "files with multiple hard links" is to use
      # the "nlinks" returned by stat; if it's >1 then the file is a hard link to an inode which has multiple
      # hard links pointing to it.

      # Type of file:
      my $type;

      # Target of file (for links):
      my $l_targ;

      # Stats of file:
      my ($Ldev, $Linode, $Lmode, $Lnlink, $Luid, $Lgid, $Lrdev, $Lsize, $Latime, $Lmtime, $Lctime);

      # Non-existent paths require special handling because stat or lstat returns undef values:
      if ( ! -e e $path ) # if path does NOT exist...
      {
         $type = 'N' ;  # $type = nonexistent
         ++$noexcount;  # increment noex counter
                        # Set all of our stats to 0:
         ($Ldev, $Linode, $Lmode, $Lnlink, $Luid, $Lgid, $Lrdev, $Lsize, $Latime, $Lmtime, $Lctime)
         = (0,0,0,0,0,0,0,0,0,0,0);
         $l_targ = 'NONEXISTENT FILE';
         warn "Warning from GetFiles: Path \"$path\" in directory \"$dir\" does not exist.\n";
      } # end if path does NOT exist

      # Then handle existent paths:
      else # else if path DOES exist...
      {
         # Do an lstat before using any file-test operators, so that they can save time by
         # testing "_" instead of "$path":
         ($Ldev, $Linode, $Lmode, $Lnlink, $Luid, $Lgid, $Lrdev, $Lsize, $Latime, $Lmtime, $Lctime)
         = lstat e $path;
         my $ml = $Lnlink > 1 ? 1 : 0;                   # Do multiple incoming hard links exist to this inode?
         $l_targ = 'NO TARGET';                          # Assume for now that no outgoing link target exists.
         if    ( -t _ )     {$type = 'T'; ++$ottycount;} # Opened to tty.
         elsif ( -c _ )     {$type = 'Y'; ++$cspccount;} # Character special file.
         elsif ( -b _ )     {$type = 'X'; ++$bspccount;} # Block special file.
         elsif ( -S _ )     {$type = 'O'; ++$sockcount;} # Socket.
         elsif ( -p _ )     {$type = 'P'; ++$pipecount;} # Pipe.
         # WOMBAT RH 2022-07-30: I'm commenting-out the following PERMANENTLY because it's a misguided historical relic;
         # in Linux, EVERY directory has many hard links to it because of "." and ".." in each subdir,
         # so this would only work in Windows, and I'm phasing Windows out of my life:
        #elsif ( -d _ )
        #{
        #   if ($ml)        {$type = 'M'; ++$multcount;} # Directory with multiple hard links.
        #   else            {$type = 'D'; ++$sdircount;} # Regular directory.
        #}
         elsif ( -d _ )     {$type = 'D'; ++$sdircount;} # Directory.
         elsif ( -l _ )                                  # Symbolic link to something.
         {
            if (-d  _ )     {$type = 'S'; ++$slkdcount;} # Symbolic link to directory.
            else            {$type = 'L'; ++$linkcount;} # Symbolic link to file.
            $l_targ = readlink_utf8 $path;
            if (not defined $l_targ)
            {
               $l_targ = 'UNDEFINED TARGET';
            }
         }
         elsif ( -f _ )                                  # File.
         {
            if ($ml)        {$type = 'H'; ++$hlnkcount;} # File with multiple hard links.
            else            {$type = 'F'; ++$regfcount;} # Regular file.
         }
         else               {$type = 'U'; ++$unkncount;} # Object of unknown type.
      } # end else if path DOES exist

      # Get date and time from Lmtime:
      my @LocalTimeFields = localtime($Lmtime);
      my $date = strftime('%F',   @LocalTimeFields);
      my $time = strftime("%T%Z", @LocalTimeFields);

      # Push file info record for this file onto array:
      push @filerecords,
      {
         'Path'   => $path,   # path to file
         'Name'   => $name,   # name of file
         'Type'   => $type,   # type of file
         'Date'   => $date,   # mod-date of file
         'Time'   => $time,   # mod-time of file
         'Dev'    => $Ldev,   # lstat[ 0]
         'Inode'  => $Linode, # lstat[ 1]
         'Mode'   => $Lmode,  # lstat[ 2]
         'Nlink'  => $Lnlink, # lstat[ 3]
         'UID'    => $Luid,   # lstat[ 4]
         'GID'    => $Lgid,   # lstat[ 5]
         'Rdev'   => $Lrdev,  # lstat[ 6]
         'Size'   => $Lsize,  # lstat[ 7]
         'Atime'  => $Latime, # lstat[ 8]
         'Mtime'  => $Lmtime, # lstat[ 9]
         'Ctime'  => $Lctime, # lstat[10]
         'Target' => $l_targ, # link target (or "NO TARGET" if not link, or "UNDEFINED TARGET" if bad link)
      };
   }; # end foreach (@filepaths)
   return \@filerecords;
} # end sub GetFiles (;$$)

# GetRegularFilesBySize returns a reference to a hash of arrays of same-size file records for all regular files in the
# current directory, with the outer hash keyed by file size. This sub can take one optional argument which, if present,
# must be a regular expression specifying which regular files to get records for. This sub is especially useful for
# programs which compare regular files for identicalness, preperatory to making decisions regarding copying or deleting
# of files. To make such comparisons FAST, this sub stores files records in same-file-size arrays and does not collect
# any stats other than $totfcount and $regfcount (which will be equal).
sub GetRegularFilesBySize (;$)
{
   my $cwd    = cwd_utf8                                   ; # Current Working Directory.
   my $target = 'F'                                        ; # Target is "regular files only".
   my $regexp = @_ ? shift(@_) : '^.+$'                    ; # Regexp.
   my $path   = ''                                         ; # Path for a file.
   my $name   = ''                                         ; # Name for a file.
   my @filepaths   = ()                                    ; # Array of file paths.
   my %filerecords = ()                                    ; # Hash of file records keyed by size.

   if ($db)
   {
      warn "\nAt top of GetRegularFilesBySize.\n",
           "Current directory = \"$cwd\".",
           "Target = \"$target\".",
           "RegExp = \"$regexp\".";
   }

   @filepaths = glob_regexp_utf8($cwd, $target, $regexp);
   # ZEBRA : The following line is wrong! It's not an error to receive no files! Some directories are empty!
   # or die "Can't read  directory \"$cwd\"\n$!\n";

   # Zero all RH::Dir counters here. You should save a copy in main:: if you want to keep this info, because it gets
   # zeroed each time GetFiles or GetRegularFilesBySize are run. These are "per directory info fetch" only.
   $totfcount = 0; # Count of all directory entities seen, of all types.
   $noexcount = 0; # Count of all errors encountered.
   $ottycount = 0; # Count of all tty files.
   $cspccount = 0; # Count of all character special files.
   $bspccount = 0; # Count of all block special files.
   $sockcount = 0; # Count of all sockets.
   $pipecount = 0; # Count of all pipes.
   $slkdcount = 0; # Count of all symbolic links to directories.
   $linkcount = 0; # Count of all symbolic links to non-directories.
   $multcount = 0; # Count of all directories with multiple hard links.
   $sdircount = 0; # Count of all directories.
   $hlnkcount = 0; # Count of all regular files with multiple hard links.
   $regfcount = 0; # Count of all regular files.
   $unkncount = 0; # Count of all unknown files.

   # Iterate through current directory, collecting info on all "regular" files:
   for $path (@filepaths)
   {
      # Increment $totfcount and $regfcount here. The glob_regexp_utf8 call above will ensure that every $path we see
      # here is the fully-qualified path of an existing regular file in the current working directory, so these two
      # counts will always be equal:
      ++$totfcount;
      ++$regfcount;

      # Get the name of this file from its path:
      $name = get_name_from_path($path);

      # Get stats for this path:
      my ($Ldev, $Linode, $Lmode, $Lnlink, $Luid, $Lgid, $Lrdev, $Lsize, $Latime, $Lmtime, $Lctime) = lstat e $path;

      # Get date and time from Lmtime:
      my @LocalTimeFields = localtime($Lmtime);
      my $zone = $LocalTimeFields[8] ? 'PDT' : 'PST';
      my $date = strftime('%F',   @LocalTimeFields);
      my $time = strftime("%T%Z", @LocalTimeFields);

      # Store file info record for this file in a ref to a hash of refs to arrays of refs to hashes of
      # file-info records, with outer hash keyed by size. Each new file size found autovivifies a new
      # "size => array-of-hashes" key/value pair in %filerecords for that file size.
      push @{$filerecords{$Lsize}},
      {
         'Path'   => $path,       # path to file
         'Name'   => $name,       # name of file
         'Type'   => 'F',         # always 'F' because regular file
         'Date'   => $date,       # mod-date of file
         'Time'   => $time,       # mod-time of file
         'Dev'    => $Ldev,       # lstat[ 0]
         'Inode'  => $Linode,     # lstat[ 1]
         'Mode'   => $Lmode,      # lstat[ 2]
         'Nlink'  => $Lnlink,     #  stat[ 3]
         'UID'    => $Luid,       # lstat[ 4]
         'GID'    => $Lgid,       # lstat[ 5]
         'Rdev'   => $Lrdev,      # lstat[ 6]
         'Size'   => $Lsize,      # lstat[ 7]
         'Atime'  => $Latime,     # lstat[ 8]
         'Mtime'  => $Lmtime,     # lstat[ 9]
         'Ctime'  => $Lctime,     # lstat[10]
         'Target' => 'NO TARGET', # always 'NO TARGET' because regular file
      }; # end push @{$filerecords{$Lsize}},
   } # end for (@filepaths)
   return \%filerecords;
} # end sub GetRegularFilesBySize ()

# Compare the contents of two files;
# return 1 if files are identical;
# return 0 if files are different.
sub FilesAreIdentical ($$)
{
   # Get path of first file, make sure it exists, get its stats, make sure it's a regular file, and get its size:
   my $filepath1 = shift;
   if ( ! -e e $filepath1 )
   {
      warn "Error in FilesAreIdentical: \"$filepath1\" does not exist.\n";
      return 0;
   }
   if ( ! -f e $filepath1 )
   {
      warn "Error in FilesAreIdentical: \"$filepath1\" is not a regular file.\n";
      return 0;
   }
   my $size1 = -s e $filepath1;

   # Get path of second file, make sure it exists, get its stats, make sure it's a regular file, and get its size:
   my $filepath2 = shift;
   if ( ! -e e $filepath2 )
   {
      warn "Error in FilesAreIdentical: \"$filepath2\" does not exist.\n";
      return 0;
   }
   if ( ! -f e $filepath2 )
   {
      warn "Error in FilesAreIdentical: \"$filepath2\" is not regular file.\n";
      return 0;
   }
   my $size2 = -s e $filepath2;

   # If these files have different sizes, they can't be identical, so return 0:
   if ($size1 != $size2) {return 0;}

   # If both files are emtpy, they are identical, so return 1:
   if (0 == $size1 && 0 == $size2) {return 1 ;}

   # Try to open both files here, shortly before entering buffer loop.
   # They will both be closed immediately after exiting buffer loop.

   open (my $filehandle1, "< :raw", e($filepath1))
   or warn "Error in FilesAreIdentical: Couldn't open \"$filepath1\".\n"
   and return 0;

   open (my $filehandle2, "< :raw", e($filepath2))
   or warn "Error in FilesAreIdentical: Couldn't open \"$filepath2\".\n"
   and return 0;

   # Before entering buffer loop, seek both files to position 0.
   # (This is probably not necessary, but I'm electing to play it safe,
   # because having the two files out of synch would be disastrous and
   # very hard to troubleshoot.)
   seek($filehandle1, 0, 0);
   seek($filehandle2, 0, 0);

   # Create a difference flag and set it to 0:
   my $different = 0;

   # BUFFER LOOP: Read data from first and second files, in buffers of
   # 1 MiB, and compare first buffer to second buffer. If a difference is
   # found, mark files as "different" and exit loop; else continue
   # reading the files until out of data:
   BUFFER: while (1)
   {
      my $buffer1 = '';
      my $buffer2 = '';
      # Attempt to read 1MiB of data from first file:
      my $read_result1 = read($filehandle1, $buffer1, 1048576);

      # Abort subroutine if we failed to read from first file:
      if (not defined $read_result1)
      {
         warn "Error in FilesAreIdentical: Can't read first file\n";
         warn "$filepath1\n";
         warn "$!\n";
         return 0;
      }

      # Attempt to read 1MiB of data from second file:
      my $read_result2 = read($filehandle2, $buffer2, 1048576);

      # Abort execution if we failed to read from second file:
      if (not defined $read_result2)
      {
         warn "Error in FilesAreIdentical: Can't read second file\n";
         warn "$filepath2\n";
         warn "$!\n";
         return 0;
      }

      # If the two read results are defined but not equal, print sync-failure
      # message and abort program execution, because these two files are *supposed* to be
      # of equal size according to the directory, so if they don't reach EOF
      # simultaneously, the directory may be corrupt:
      if ($read_result1 != $read_result2)
      {
         die
         "Fatal Error in FilesAreIdentical: ".
         "Size difference found between these two files,\n".
         "which are supposedly the same size:\n".
         "$filepath1\n".
         "$filepath2\n".
         "Aborting program execution.\n".
         "Check integrity of directory!\n".
         "$!\n";
      }

      # If either read result is 0, then both are, and we're at EOF for both files,
      # and no difference has been found, so exit buffer loop, leaving $different set at 0:
      last BUFFER if 0 == $read_result1;

      # If buffers contain identical strings, read next buffers:
      next BUFFER if $buffer1 eq $buffer2;

      # Otherwise, set difference flag and exit buffer loop:
      $different = 1;
      last BUFFER;
   } # End BUFFER loop.

   # Close both files:
   close($filehandle1);
   close($filehandle2);

   # If $different is 1, return 0 ("no,  files AREN'T identical").
   # If $different is 0, return 1 ("yes, files  ARE   identical").
   return !$different;
} # end sub FilesAreIdentical

# Navigate a directory tree recursively, applying code at each node on the tree:
sub RecurseDirs (&)
{
   # This is a recursive function, being used in a chaotic and unpredictable environment (an unknown computer file
   # system, EEEK!!!), so it is VERY possible for runaway recursion to occur. So, to keep track of recursion, we
   # use this variable, which is initialized to zero once only, the first time this function is called during this
   # run of this program; this will be incremented before recursing and checked to make sure it never exceeds 50:
   state $recursion = 0;

   # Store incoming code reference in variable $f:
   my $f = \&{shift @_};

   # Die if f is not a ref to some code (block or sub):
   if ('CODE' ne ref $f)
   {
      die '\nFatal error in RecurseDirs: This subroutine takes 1 argument which must be a\n'.
          '{code block} or a reference to a subroutine.\n\n';
   }

   # Get current directory:
   my $curdir = d getcwd;

   # If we FAILED to get current working directory, something is very wrong!!!
   if ( ! defined $curdir ){die "Fatal error in RecurseDirs: Can't get current directory!\n$!\n"}

   #my $fst = fstype($curdir);

   # If $curdir is (or is in) a critical Linux system directory, die:
   if
   (
         $curdir eq '/'
      || $curdir =~ m#^/dev#
      || $curdir =~ m#^/lost+found#
      || $curdir =~ m#^/proc#
      || $curdir =~ m#^/srv#
      || $curdir =~ m#^/sys#
      || $curdir =~ m#^/tmp#
   )
   {
      warn "Error in RecurseDirs:\n"
         . "Can't operate in critical Linux directory \"$curdir\".\n"
         . "Aborting program.\n";
      chdir '~';
      return 1;
   }

   # Try to open current directory; if that fails, print warning and return 1:
   my $dh = undef;
   opendir $dh, e $curdir;
   if ( ! defined $dh )
   {
      warn "Warning from RecurseDirs: Couldn't open directory \"$curdir\".\n".
           "Moving on to next directory.";
      return 1; # This allows directory-tree-walking to continue.
   }

   # Try to read current directory; if that fails, print warning and return 1:
   my @subdirs = d readdir $dh;
   if ( scalar(@subdirs) < 2 )
   {
      warn "Warning from RecurseDirs: Couldn't read directory \"$curdir\".\n".
           "Moving on to next directory.";
      closedir $dh or die "Fatal error in RecurseDirs: Couldn't close directory \"$curdir\".\n$!\n";
      return 1; # This allows directory-tree-walking to continue.
   }

   # Try to close current directory; if that fails, abort program:
   if ( ! closedir $dh )
   {
      die "Fatal error in RecurseDirs: Couldn't close directory \"$curdir\".\n$!\n";
   }

   # Navigate immediate subdirs (if any) of this instance's current directory:
   SUBDIR: foreach my $subdir (@subdirs)
   {
      # ========== SUBDIR NAME CHECKS: =================================================================================

      # Avoid certain specific miscellaneous problematic directories:
      next SUBDIR if $subdir eq '.';                            # Windows/Linux/Cygwin: Hard link to self.
      next SUBDIR if $subdir eq '..';                           # Windows/Linux/Cygwin: Hard link to parent.
      next SUBDIR if $subdir eq 'System Volume Information';    # Windows: System volume information.
      next SUBDIR if $subdir eq 'MapData';                      # Windows: Microsoft Maps Data.
      next SUBDIR if $subdir eq 'lost+found';                   # Linux: Lost & Found Dept.

      # Avoid rooting in trash bins:
      next SUBDIR if $subdir =~ m/^.Recycle$/i;                 # Windows trash bins.
      next SUBDIR if $subdir =~ m/^\$Recycle.Bin$/i;            # Windows trash bins.
      next SUBDIR if $subdir =~ m/^Recyler$/i;                  # Windows trash bins.
      next SUBDIR if $subdir eq 'Trash';                        # Linux trash bins.
      next SUBDIR if $subdir =~ m/^\.Trash/;                    # Linux trash bins.

      # Don't try to navigate troublesome Linux or Cygwin subdirectories of root:
      next SUBDIR if $curdir eq '/' && $subdir eq 'dev';        # Linux/Cygwin: Devices.
      next SUBDIR if $curdir eq '/' && $subdir eq 'proc';       # Linux/Cygwin: Processes.
      next SUBDIR if $curdir eq '/' && $subdir eq 'srv';        # Linux/Cygwin: Services.
      next SUBDIR if $curdir eq '/' && $subdir eq 'sys';        # Linux/Cygwin: System.
      next SUBDIR if $curdir eq '/' && $subdir eq 'tmp';        # Linux/Cygwin: Temporary files.

      # Don't mess with the private files of certain Windows users:
      if
      (
            $curdir eq '/home/aragorn/net/KE/Valinor/Users'
         || $curdir eq '/home/aragorn/net/SR/Imladris/Users'
         || $curdir eq '/cygdrive/c/Users'
         || $curdir eq '/cygdrive/n/Users'
      )
      {
         next SUBDIR if $subdir eq 'Administrator';             # Microsoft Windows: Problematic account.
         next SUBDIR if $subdir eq 'Default';                   # Microsoft Windows: Problematic account.
         next SUBDIR if $subdir eq 'Default User';              # Microsoft Windows: Problematic account.
         next SUBDIR if $subdir eq 'Public';                    # Microsoft Windows: Problematic account.
         next SUBDIR if $subdir eq 'All Users';                 # Microsoft Windows: Problematic account.
      }

      # Avoid problematic subdirectories of bootable Windows partitions:
      if
      (
            $curdir =~ m[^/home/aragorn/net/KE/Valinor] 
         || $curdir =~ m[^/home/aragorn/net/SR/Imladris]
         || $curdir =~ m[^/cygdrive/c]
         || $curdir =~ m[^/cygdrive/n]
      )
      {
         next SUBDIR if $subdir =~ m/^\$/;                      # Microsoft Windows: System directories.
         next SUBDIR if $subdir =~ m/^cygwin/i;                 # Microsoft Windows: Cygwin
         next SUBDIR if $subdir eq 'Application Data';          # Microsoft Windows: OLD LINK: Application Data.
         next SUBDIR if $subdir eq 'Documents and Settings';    # Microsoft Windows: OLD LINK: Documents and Settings.
         next SUBDIR if $subdir eq 'Local Settings';            # Microsoft Windows: OLD LINK: Local Settings.
         next SUBDIR if $subdir eq 'My Documents';              # Microsoft Windows: OLD LINK: My Documents.
         next SUBDIR if $subdir eq 'My Music';                  # Microsoft Windows: OLD LINK: My Music.
         next SUBDIR if $subdir eq 'My Pictures';               # Microsoft Windows: OLD LINK: My Pictures.
         next SUBDIR if $subdir eq 'My Videos';                 # Microsoft Windows: OLD LINK: My Videos.
         next SUBDIR if $subdir eq 'NetHood';                   # Microsoft Windows: Networks.
         next SUBDIR if $subdir eq 'PrintHood';                 # Microsoft Windows: Printers.
         next SUBDIR if $subdir eq 'PerfLogs';                  # Microsoft Windows: Performance Logs.
         next SUBDIR if $subdir eq 'ProgramData';               # Microsoft Windows: Program Data.
         next SUBDIR if $subdir eq 'Program Files';             # Microsoft Windows: Program Files (64bit).
         next SUBDIR if $subdir eq 'Program Files (x86)';       # Microsoft Windows: Program Files (32bit).
         next SUBDIR if $subdir eq 'Recovery';                  # Microsoft Windows: System Recovery Files.
         next SUBDIR if $subdir eq 'SendTo';                    # Microsoft Windows: Send To.
         next SUBDIR if $subdir eq 'Start Menu';                # Microsoft Windows: Start Menu.
         next SUBDIR if $subdir eq 'Temp';                      # Microsoft Windows: Temporary Files.
         next SUBDIR if $subdir eq 'Temporary Internet Files';  # Microsoft Windows: Temporary Internet Files.
         next SUBDIR if $subdir eq 'Windows';                   # Microsoft Windows: Windows operating system.
      }

      # ========== SUBDIR STATS CHECKS: ================================================================================

      # Now that we've ascertained that $subdir doesn't name a known directory that we specifically want to avoid,
      # lets examine the statistics of the referent to which label $subdir refers.
      # Start by making sure that $subdir is the name of something that actually exists:
      next SUBDIR if ! -e e $subdir;                            # Something that doesn't exist.

      # Now that we know that $subdir exists, store dir stats for subdir in _ :
      lstat e $subdir;

      # Skip this path if it's not a directory:
      next SUBDIR if ! -d _ ;                                   # Not a directory.

      # Skip this path if it's a symbolic link:
      next SUBDIR if -l _ ;                                     # Symbolic link.

      # Skip this directory if we don't have permission to interact with it:
      next SUBDIR if ! -r _ ;                                   # We can't read file names in this subdir!
      next SUBDIR if ! -x _ ;                                   # We can't read file info  in this subdir!

      # Try to chdir to $subdir; if that fails, try to cd back to $curdir (or die if that fails),
      # then move on to next subdirectory:
      if ( ! chdir e $subdir )
      {
         warn "Warning from RecurseDirs: Couldn't cd to subdir \"$subdir\"!\n";
         chdir e $curdir or die "Fatal error in RecurseDirs: Couldn't cd back to curdir \"$curdir\"!\n";
         next SUBDIR;
      }

      # Try to recurse:
      ++$recursion;
      die "Fatal error in RecurseDirs: More than 50 levels of recursion!\nCWD = \"$curdir\"\n$!\n" if $recursion > 50;
      RecurseDirs(\&{$f}) or die "Fatal error in RecurseDirs: Couldn't recurse!\n";
      --$recursion;

      # Try to cd back to $curdir (and die if that fails):
      chdir e $curdir or die "Fatal error in RecurseDirs: Couldn't cd back to previous directory!\n";

   } # end foreach my $subdir (@subdirs)

   # Execute f only at the tail end of SubDirs; that way if f renames immediate subdirectories of the
   # current directory (for example, f is RenameFiles running in directories mode), that's no problem,
   # because all navigation of subdirectories of the current directory is complete before f is executed.
   # In other words, each instance of RecurseDirs is only allowed to fulfill its primary task after its
   # children have all died of old age, having fulfilled their tasks.
   if ( ! $f->() )
   {
      warn "Warning from RecurseDirs: Couldn't apply function in directory $curdir!\n";
   }

   # If we get to here, we've succeeded, so return 1:
   return 1;
} # end sub RecurseDirs (&)

# Copy a file from a given path to a given directory.
# Mandatory arguments:
#    path of original file
#    path of destination directory
# Optional arguments:
#    'rename=newname'  =>  Set copied file's name to newname in destination directory.
#    'sha1'            =>  Set copy's name root to SHA1 hash of file. (Doesn't change file name extension.)
#    'sl'              =>  Shorten names for Spotlight image processing.
# All other arguments are ignored.
# Note: if contradictory arguments are given (eg, 'sha1', 'rename=Fred'), later arguments override previous.
# Returns 0 for error, 1 for success, 2 for "skipped file because duplicate exists in destination".
sub copy_file ($$;@)
{
   my $spath    = shift;                      # Path of   source    file, full  version.
   my $dpath    = '';                         # Path of destination file, full  version.
   my $src      = get_dir_from_path ($spath); # Directory of   source    file.
   my $dst      = shift;                      # Directory of destination file.
   my $sname    = get_name_from_path($spath); #   Name    of   source    file.
   my $dname    = '';                         #   Name    of destination file. (Defaults to $sname.)
   my $mode     = 'reg';                      # Naming Mode: nrm = normal, sha = sha1, ren = rename.
   my $sl       = 0;                          # Shorten names for Spotlight image processing?

   if ($db)
   {
      warn
      (
         "\n",
         "In copy_file, at top.  \n",
         "\$spath = \"$spath\"   \n",
         "\$dst   = \"$dst\"     \n",
         "\@_     =              \n",
         join("\n", @_)    .    "\n",
         "\n"
      );
   }

   # Bail if $spath is not a path to an existing regular file:
   if ( ! -e e $spath || ! -f e $spath )
   {
      warn
      (
         "\n",
         "Error in copy_file: Given path is not a path to an existing regular file:\n",
         "$spath\n",
         "File was not copied.\n",
         "\n"
      );
      return 0;
   }

   # Bail if destination directory doesn't exist or isn't a directory:
   if ( ! -e e $dst || ! -d e $dst )
   {
      warn
      (
         "\n",
         "Error in copy_file: Given destination directory does not exist:\n",
         "$dst\n",
         "File was not copied.\n",
         "\n"
      );
      return 0;
   }

   # Process remaining arguments:
   foreach (@_)
   {
      if ( $_ eq 'sha1' )        # if SHA1-ing file
      {
         $mode   = 'sha';        # set $mode to 'sha' (SHA-1 Mode)
      }
      elsif ( m/^rename=(.+)$/ ) # elsif renaming file,
      {
         $mode   = 'ren';        # set $mode to 'ren' (Rename Mode)
      }
      elsif ( $_ eq 'sl' )       # elsif Spotlight,
      {
         $sl     =  1;           # set $sl     to 1
      }
   }

   if ($db)
   {
      warn
      (
         "\n",
         "In copy_file, after processing arguments.\n",
         "\$mode = \"$mode\"  \n",
         "\$sl   = \"$sl\"    \n",
         "\n"
      );
   }

   # Take different actions depending on naming mode:
   given ($mode)
   {
      # Rename Naming Mode:
      when ('ren')
      {
         # Set destination name to name user provided:
         $dname = $1;
      }

      # SHA-1 Naming Mode:
      when ('sha')
      {
         # Set $dname to SHA1-hash-based file name:
         $dname = hash($spath, 'sha1', 'name');

         # If $dname is now '***ERROR***', set $dname to $sname and warn user:
         if ($dname eq '***ERROR***')
         {
            $dname = $sname;
            warn
            (
               "\n",
               "Warning from copy_file(): bad hash.\n",
               "Retaining original file name.\n",
               "\n"
            );
         }
      }

      # Normal Naming Mode:
      default
      {
         # Set destination name equal to source name:
         $dname = $sname;
      }
   }

   if ($db)
   {
      warn
      (
         "\n",
         "In copy_file, after given(\$mode).\n",
         "\$dname = \"$dname\".\n",
         "\n"
      );
   }

   # Regardless of what Naming Mode we just used, if $dname already exists in $dst,
   # we'll have to come up with a new name! Let's try enumerating:
   if ( -e e "$dst/$dname" )
   {
      $dname = find_avail_enum_name($dname,$dst);
   }

   # If, for whateve reason, $dname is now '***ERROR***', warn user and return "0" to indicate failure:
   if ( $dname eq '***ERROR***' )
   {
      warn
      (
         "\n",
         "Error in copy_file: Couldn't find available name for this name and directory:\n",
         "Name:      $dname     \n",
         "Directory: $dst       \n",
         "File was not copied.  \n",
         "\n"
      );
      return 0;
   }

   # Otherwise, set $dpath from $dst and $dname:
   else
   {
      $dpath = path($dst, $dname);
   }

   # Make "display" versions of directory and file names:
   my $srcdsh = $src;   #   Source    directory, short version. (Defaults to $src.)
   my $srcfsh = $sname; #   Source      file,    short version. (Defaults to $sname.)
   my $dstdsh = $dst;   # Destination directory, short version. (Defaults to $dst.)
   my $dstfsh = $dname; # Destination   file,    short version. (Defaults to $dname.)

   # If user specified 'sl', shorten directory and file names for Spotlight use:
   if ($sl)
   {
      ($srcdsh, $srcfsh, $dstdsh, $dstfsh) = shorten_sl_names($srcdsh, $srcfsh, $dstdsh, $dstfsh);
   }

   # Make "display" versions of the file paths:
   my $srcpsh = path($srcdsh, $srcfsh); #   Source    path (short version)
   my $dstpsh = path($dstdsh, $dstfsh); # Destination path (short version)

   # Attempt to copy the file:
   my $success  = ! system(e "cp --preserve=timestamps '$spath' '$dpath'");
   if ($success)
   {
      print "Copied \"$srcpsh\" to \"$dstpsh\"\n";
      return 1;
   }
   else
   {
      warn
      (
         "\n",
         "Error in copy_file: couldn't copy this file:\n",
         "Src: \"$srcpsh\"  \n",
         "Dst: \"$dstpsh\"  \n",
         "$!\n",
         "\n"
      );
      return 0;
   }
} # end sub copy_file

# Move a file from a given path to a given directory.
# Mandatory arguments: path of original file, followed by path of destination directory.
# Optional arguments:
#    'rename=newname'  =>  Set file's name to newname in destination directory.
#    'sha1'            =>  Set file's name root to SHA1 hash of file. (Doesn't change file name extension.)
#    'sl'              =>  Shorten names for Spotlight image processing.
# All other arguments are ignored.
# Note: if contradictory arguments are given (eg, 'sha1', 'rename=Fred'), later arguments override previous.
# Returns 0 for error, 1 for success, 2 for "skipped file because duplicate exists in destination".
sub move_file ($$;@)
{
   my $spath    = shift;                      # Path of   source    file, full  version.
   my $dpath    = '';                         # Path of destination file, full  version.
   my $src      = get_dir_from_path ($spath); # Directory of   source    file.
   my $dst      = shift;                      # Directory of destination file.
   my $sname    = get_name_from_path($spath); #   Name    of   source    file.
   my $dname    = '';                         #   Name    of destination file. (Defaults to $sname.)
   my $mode     = 'reg';                      # Naming Mode: nrm = normal, sha = sha1, ren = rename.
   my $sl       = 0;                          # Shorten names for Spotlight image processing?

   if ($db)
   {
      warn
      (
         "\n",
         "In move_file, at top.  \n",
         "\$spath = \"$spath\"   \n",
         "\$dst   = \"$dst\"     \n",
         "\@_     =              \n",
         join("\n", @_)    .    "\n",
         "\n"
      );
   }

   # Bail if $spath is not a path to an existing regular file:
   if ( ! -e e $spath || ! -f e $spath )
   {
      warn
      (
         "\n",
         "Error in move_file: Given path is not a path to an existing regular file:\n",
         "$spath\n",
         "File was not moved.\n",
         "\n"
      );
      return 0;
   }

   # Bail if destination directory doesn't exist or isn't a directory:
   if ( ! -e e $dst || ! -d e $dst )
   {
      warn
      (
         "\n",
         "Error in move_file: Given destination directory does not exist:\n",
         "$dst\n",
         "File was not moved.\n",
         "\n"
      );
      return 0;
   }

   # Process remaining arguments:
   foreach (@_)
   {
      if ( $_ eq 'sha1' )        # if SHA1-ing file
      {
         $mode   = 'sha';        # set $mode to 'sha' (SHA-1 Mode)
      }
      elsif ( m/^rename=(.+)$/ ) # elsif renaming file,
      {
         $mode   = 'ren';        # set $mode to 'ren' (Rename Mode)
      }
      elsif ( $_ eq 'sl' )       # elsif Spotlight,
      {
         $sl     =  1;           # set $sl     to 1
      }
   }

   if ($db)
   {
      warn
      (
         "\n",
         "In move_file, after processing arguments.\n",
         "\$mode = \"$mode\"  \n",
         "\$sl   = \"$sl\"    \n",
         "\n"
      );
   }

   # Take different actions depending on naming mode:
   given ($mode)
   {
      # Rename Naming Mode:
      when ('ren')
      {
         # Set destination name to name user provided:
         $dname = $1;
      }

      # SHA-1 Naming Mode:
      when ('sha')
      {
         # Set $dname to SHA1-hash-based file name:
         $dname = hash($spath, 'sha1', 'name');

         # If $dname is now '***ERROR***', set $dname to $sname and warn user:
         if ($dname eq '***ERROR***')
         {
            $dname = $sname;
            warn
            (
               "\n",
               "Warning from move_file: bad hash for this file:\n",
               "$sname\n",
               "Retaining original file name.\n",
               "\n"
            );
         }
      }

      # Normal Naming Mode:
      default
      {
         # Set destination name equal to source name:
         $dname = $sname;
      }
   }

   if ($db)
   {
      warn
      (
         "\n",
         "In move_file, after given(\$mode).\n",
         "\$dname = \"$dname\".\n",
         "\n"
      );
   }

   # Regardless of what Naming Mode we just used, if $dname already exists in $dst,
   # we'll have to come up with a new name! Let's try enumerating:
   if ( -e e "$dst/$dname" )
   {
      $dname = find_avail_enum_name($dname,$dst);
   }

   # If, for whateve reason, $dname is now '***ERROR***', warn user and return "0" to indicate failure:
   if ( $dname eq '***ERROR***' )
   {
      warn
      (
         "\n",
         "Error in move_file: Couldn't find available name for this name and directory:\n",
         "Name:      $dname    \n",
         "Directory: $dst      \n",
         "File was not moved.  \n",
         "\n"
      );
      return 0;
   }

   # Otherwise, set $dpath from $dst and $dname:
   else
   {
      $dpath = path($dst, $dname);
   }

   # Make "display" versions of directory and file names:
   my $srcdsh = $src;   #   Source    directory, short version. (Defaults to $src.)
   my $srcfsh = $sname; #   Source      file,    short version. (Defaults to $sname.)
   my $dstdsh = $dst;   # Destination directory, short version. (Defaults to $dst.)
   my $dstfsh = $dname; # Destination   file,    short version. (Defaults to $dname.)

   # If user specified 'sl', shorten directory and file names for Spotlight use:
   if ($sl)
   {
      ($srcdsh, $srcfsh, $dstdsh, $dstfsh) = shorten_sl_names($srcdsh, $srcfsh, $dstdsh, $dstfsh);
   }

   # Make "display" versions of the file paths:
   my $srcpsh = path($srcdsh, $srcfsh); #   Source    path (short version)
   my $dstpsh = path($dstdsh, $dstfsh); # Destination path (short version)

   # Attempt to move the file:
   if ( ! system(e("mv -n '$spath' '$dpath'")) )
   {
      say "Moved \"$srcpsh\" to \"$dstpsh\"";
      return 1;
   }
   else
   {
      warn
      (
         "\n",
         "Error in move_file: Couldn't perform this file move:\n",
         "Src: \"$srcpsh\"  \n",
         "Dst: \"$dstpsh\"  \n",
         "\n"
      );
      return 0;
   }
} # end sub move_file

# Copy files from one directory to another.
# Mandatory arguments:
#    Source            (Directory to copy files from.)
#    Destination       (Directory to copy files to.)
# Optional arguments:
#    sl                (Shorten names for when processing Windows Spotlight images.)
#    unique            (Don't copy files for which duplicates exist in destition.)
#    large             (Copy only image files which are at least 1200px wide and 600px tall.)
#    sha1              (Use the SHA-1 hash of each source file as its destination name root.)
# All arguments will also be passed-on to copy_file(), which may take further actions based on them.
sub copy_files ($$;@)
{
   # Settings:
   my $src      = shift                 ; # $src      = source directory
   my $dst      = shift                 ; # $dst      = destination directory
   my $target   = 'F'                   ; # $target   = target (always "regular Files only")
   my $regexp   = '^.+$'                ; # $regexp   = regular expression
   my $sl       = 0                     ; # $sl       = Shorten names for Spotlight?
   my $unique   = 0                     ; # $unique   = Are we being unique?
   my $large    = 0                     ; # $large    = Are we copying only large images (W=1200+, H=600+)?
   my $both     = 0                     ; # $both     = Do files of a given size exist in both directories?

   # Arrays:
   my @sfiles   = ()                    ; # @sfiles   = Array of same-size files in   source    directory.
   my @dfiles   = ()                    ; # @dfiles   = Array of same-size files in destination directory.

   # Counters:
   my $err_cnt  = 0                     ; # $err_cnt  = count of errors
   my $cpy_cnt  = 0                     ; # $cpy_cnt  = count of files copied to $dst
   my $skp_cnt  = 0                     ; # $skp_cnt  = count of files skipped because not large images
   my $byp_cnt  = 0                     ; # $byp_cnt  = count of files bypassed because of dup in dest

   if ($db)
   {
      warn "\nJust entered sub \"copy_files\".\n",
           "Src dir = \"$src\".   \n",
           "Dst dir = \"$dst\".   \n",
           "Target  = \"$target\".\n",
           "Args    =             \n",
           join "\n", @_             ,
           "\n";
   }

   # Process only those arguments we need (some will be simply passed-on to copy_file):
   foreach (@_)
   {
         if (/^regexp=(.+)$/) {$regexp = $1 ;} # Copy only files matching regexp.
      elsif (/^sl$/         ) {$sl     = 1  ;} # Shorten names for Spotlight.
      elsif (/^unique$/     ) {$unique = 1  ;} # Copy only files for which duplicates don't exist in destination.
      elsif (/^large$/      ) {$large  = 1  ;} # Copy only large image files (W=1200+, H=600+).
   }

   if ($db)
   {
      warn "\nIn middle of sub \"copy_files\".\n",
           "RegExp  = \"$regexp\".\n",
           "SL      = \"$sl\".    \n",
           "Unique  = \"$unique\".\n",
           "Large   = \"$large\". \n";
   }

   # Create variables for the "display" versions of the directories:
   my $srcdsh = $src;   #   Source    directory, short version. (Defaults to $src.)
   my $dstdsh = $dst;   # Destination directory, short version. (Defaults to $dst.)

   # If user specified 'sl', shorten directory and file names for Spotlight use:
   if ($sl)
   {
      my $s1 = '/cygdrive/c/Users';
      my $s2 = '/AppData/Local/Packages';
      my $s3 = '/Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy';
      my $s4 = '/LocalState/Assets';
      my $s5 = '/cygdrive/d/sl';
      my $u1 = '/Aragorn';
      my $u2 = '/Urgabor';
      my $u3 = '/Zebulon';
      my $u4 = '/Administrator';
      $srcdsh =~ s%$s1$u1$s2$s3$s4%/usl1%;
      $srcdsh =~ s%$s1$u2$s2$s3$s4%/usl2%;
      $srcdsh =~ s%$s1$u3$s2$s3$s4%/usl3%;
      $srcdsh =~ s%$s1$u4$s2$s3$s4%/usl4%;
      $dstdsh =~ s%$s5%/sl%;
   }

   # If being unique, don't copy files from source which have duplicates in destination:
   if ($unique)
   {
      say "\nJust entered \"if (\$unique)\"; about to get src & dst file hashes." if $db;

      # Note starting directory:
      my $startdir = cwd_utf8;

      # cd to source directory and get hash-by-size of files there:
      chdir_utf8($src) or die "Couldn't cd to \"$src\".\n";
      $src = cwd_utf8;
      my $ssizes = GetRegularFilesBySize($regexp);

      # cd back to starting directory:
      chdir_utf8($startdir) or die "Couldn't cd to \"$startdir\".\n";

      # cd to destination directory and get hash-by-size of files there:
      chdir_utf8($dst) or die "Couldn't cd to \"$dst\".\n";
      $dst = cwd_utf8;
      my $dsizes = GetRegularFilesBySize($regexp);

      # cd back to starting directory:
      chdir_utf8($startdir) or die "Couldn't cd to \"$startdir\".\n";

      # For each size of source file, copy each file of that size to destination if-and-only-if no identical
      # file exists in destination:
      SIZE: foreach my $ssize (keys %{$ssizes})
      {
         say "\nProcessing size group \"$ssize\"." if $db;

         # Get array of file records for this size:
         @sfiles = @{$ssizes->{$ssize}};

         # Do any files of this size exist in the destination directory?
         if (exists $dsizes->{$ssize})
         {
            @dfiles = @{$dsizes->{$ssize}};
            #  Set  the "files of this size exist in both directories" flag:
            $both = 1;
         }
         else
         {
            # Reset the "files of this size exist in both directories" flag:
            $both = 0;
         }

         # Iterate through the source file records for this size:
         SFILE: foreach my $sfile (@sfiles)
         {
            say "\nProcessing src file \"$sfile->{Name}\"." if $db;

            # If in "large" mode, skip this file if it's not a large image:
            if ( $large && ! is_large_image($sfile->{Path}) )
            {
               say "\nSkipping \"$sfile->{Name}\" because it's not a large image." if $db;
               ++$skp_cnt;
               next SFILE;
            }

            # Bypass this file if it has a duplicate in destination:
            if ($both) # Do files of this size exist in both directories?
            {
               DFILE: foreach my $dfile (@dfiles)
               {
                  if (FilesAreIdentical($sfile->{Path}, $dfile->{Path}))
                  {
                     say "\nBypassing \"$sfile->{Name}\" because it has a dup in dst." if $db;
                     ++$byp_cnt;
                     next SFILE;
                  }
               }
            }

            # Attempt to copy this file from $src to $dst:
            my $result = copy_file($sfile->{Path}, $dst, @_);
            if (0 == $result) {++$err_cnt;}
            if (1 == $result) {++$cpy_cnt;}
         } # end foreach file in current size group
      } # end foreach $size
   } # end if ($unique)

   else # if NOT ($unique)
   {
      # Get list of paths of existing regular files in source folder:
      my @spaths = glob_regexp_utf8($src, $target, $regexp);
      SOURCE: foreach my $spath (@spaths)
      {
         my $sname = get_name_from_path($spath) if $db;
         say "\nProcessing src file \"$sname\"." if $db;

         # If in "large" mode, skip this file if it's not a large image:
         if ( $large && ! is_large_image($spath) )
         {
            say "\nSkipping \"$sname\" because it's not a large image." if $db;
            ++$skp_cnt;
            next SOURCE;
         }

         # Attempt to copy this file from $src to $dst:
         copy_file($spath, $dst, @_) and ++$cpy_cnt or  ++$err_cnt;
      } # end for each path in source directory
   } # end else if (!$unique)
   say "Copied $cpy_cnt files from \"$srcdsh\" to \"$dstdsh\".";
   if ($large) {say "Skipped $skp_cnt files because they weren't large images.";}
   if ($unique) {say "Bypassed $byp_cnt files because of identical files in destination.";}
   say "Suffered $err_cnt errors.";
   return 1;
} # end sub copy_files

# Move files from one directory to another.
# Mandatory arguments:
#    Source            (Directory to move files from.)
#    Destination       (Directory to move files to.)
# Optional arguments:
#    sl                (Shorten names for when processing Windows Spotlight images.)
#    unique            (Don't move files for which duplicates exist in destition.)
#    large             (Move only image files which are at least 1200px wide and 600px tall.)
#    sha1              (Use the SHA-1 hash of each source file as its destination name root.)
# All arguments will also be passed-on to move_file(), which may take further actions based on them.
sub move_files ($$;@)
{
   # Settings:
   my $src      = shift                 ; # $src      = source directory
   my $dst      = shift                 ; # $dst      = destination directory
   my $target   = 'F'                   ; # $target   = target (always "regular Files only")
   my $regexp   = '^.+$'                ; # $regexp   = regular expression
   my $sl       = 0                     ; # $sl       = shorten names for Spotlight?
   my $unique   = 0                     ; # $unique   = are we being unique?
   my $large    = 0                     ; # $large    = Are we moving only large images?
   my $both     = 0                     ; # $both     = Do files of a given size exist in both directories?

   # Arrays:
   my @sfiles   = ()                    ; # @sfiles   = Array of same-size files in   source    directory.
   my @dfiles   = ()                    ; # @dfiles   = Array of same-size files in destination directory.

   # Counters:
   my $err_cnt  = 0                     ; # $err_cnt  = count of errors
   my $mov_cnt  = 0                     ; # $mov_cnt  = count of files moved to $dst
   my $skp_cnt  = 0                     ; # $skp_cnt  = count of files skipped because not large images
   my $byp_cnt  = 0                     ; # $byp_cnt  = count of files bypassed because of dup in dest

   if ($db)
   {
      warn "\nJust entered sub \"move_files\".\n",
           "Src dir = \"$src\".   \n",
           "Dst dir = \"$dst\".   \n",
           "Target  = \"$target\".\n",
           "Args    =             \n",
           join "\n", @_             ,
           "\n";
   }

   # Process only those arguments we need (most will be simply passed-on to move_file):
   foreach (@_)
   {
         if (/^regexp=(.+)$/) {$regexp = $1 ;} # Move only files matching regexp.
      elsif (/^sl$/         ) {$sl     = 1  ;} # Shorten names for Spotlight.
      elsif (/^unique$/     ) {$unique = 1  ;} # Move only files for which duplicates don't exist in destination.
      elsif (/^large$/      ) {$large  = 1  ;} # Move only large image files (W=1200+, H=600+).
   }

   if ($db)
   {
      warn "\nIn middle of sub \"move_files\".\n",
           "RegExp  = \"$regexp\".\n",
           "SL      = \"$sl\".    \n",
           "Unique  = \"$unique\".\n",
           "Large   = \"$large\". \n";
   }

   # Create variables for the "display" versions of the directories:
   my $srcdsh = $src;   #   Source    directory, short version. (Defaults to $src.)
   my $dstdsh = $dst;   # Destination directory, short version. (Defaults to $dst.)

   # If user specified 'sl', shorten directory and file names for Spotlight use:
   if ($sl)
   {
      my $s1 = '/cygdrive/c/Users';
      my $s2 = '/AppData/Local/Packages';
      my $s3 = '/Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy';
      my $s4 = '/LocalState/Assets';
      my $s5 = '/cygdrive/d/sl';
      my $u1 = '/Aragorn';
      my $u2 = '/Urgabor';
      my $u3 = '/Zebulon';
      my $u4 = '/Administrator';
      $srcdsh =~ s%$s1$u1$s2$s3$s4%/usl1%;
      $srcdsh =~ s%$s1$u2$s2$s3$s4%/usl2%;
      $srcdsh =~ s%$s1$u3$s2$s3$s4%/usl3%;
      $srcdsh =~ s%$s1$u4$s2$s3$s4%/usl4%;
      $dstdsh =~ s%$s5%/sl%;
   }

   # If being unique, don't move files from source which have duplicates in destination:
   if ($unique)
   {
      say "\nJust entered \"if (\$unique)\"; about to get src & dst file hashes." if $db;

      # Note starting directory:
      my $startdir = cwd_utf8;

      # cd to source directory and get hash-by-size of files there:
      chdir_utf8($src) or die "Couldn't cd to \"$src\".\n";
      $src = cwd_utf8;
      my $ssizes = GetRegularFilesBySize($regexp);

      # cd back to starting directory:
      chdir_utf8($startdir) or die "Couldn't cd to \"$startdir\".\n";

      # cd to destination directory and get hash-by-size of files there:
      chdir_utf8($dst) or die "Couldn't cd to \"$dst\".\n";
      $dst = cwd_utf8;
      my $dsizes = GetRegularFilesBySize($regexp);

      # cd back to starting directory:
      chdir_utf8($startdir) or die "Couldn't cd to \"$startdir\".\n";

      # For each size of source file, copy each file of that size to destination if-and-only-if no identical
      # file exists in destination:
      SIZE: foreach my $ssize (keys %{$ssizes})
      {
         say "\nProcessing size group \"$ssize\"." if $db;

         # Get array of file records for this size:
         @sfiles = @{$ssizes->{$ssize}};

         # Do any files of this size exist in the destination directory?
         if (exists $dsizes->{$ssize})
         {
            @dfiles = @{$dsizes->{$ssize}};
            #  Set  the "files of this size exist in both directories" flag:
            $both = 1;
         }
         else
         {
            # Reset the "files of this size exist in both directories" flag:
            $both = 0;
         }

         # Iterate through the source file records for this size:
         SFILE: foreach my $sfile (@sfiles)
         {
            say "\nProcessing src file \"$sfile->{Name}\"." if $db;

            # If in "large" mode, skip this file if it's not a large image:
            if ( $large && ! is_large_image($sfile->{Path}) )
            {
               say "\nSkipping \"$sfile->{Name}\" because it's not a large image." if $db;
               ++$skp_cnt;
               next SFILE;
            }

            # Bypass this file if it has a duplicate in destination:
            if ($both) # Do files of this size exist in both directories?
            {
               DFILE: foreach my $dfile (@dfiles)
               {
                  if (FilesAreIdentical($sfile->{Path}, $dfile->{Path}))
                  {
                     say "\nBypassing \"$sfile->{Name}\" because it has a dup in dst." if $db;
                     ++$byp_cnt;
                     next SFILE;
                  }
               }
            }
            # Attempt to move this file from $src to $dst:
            my $result = move_file($sfile->{Path}, $dst, @_);
            if (0 == $result) {++$err_cnt;}
            if (1 == $result) {++$mov_cnt;}
         } # end foreach file in current size group
      } # end foreach $size
   } # end if ($unique)

   else # if NOT ($unique)
   {
      # Get list of paths of existing regular files in source folder:
      my @spaths = glob_regexp_utf8($src, $target, $regexp);
      SOURCE: foreach my $spath (@spaths)
      {
         my $sname = get_name_from_path($spath) if $db;
         say "\nProcessing src file \"$sname\"." if $db;

         # If in "large" mode, skip this file if it's not a large image:
         if ( $large && ! is_large_image($spath) )
         {
            say "\nSkipping \"$sname\" because it's not a large image." if $db;
            ++$skp_cnt;
            next SOURCE;
         }

         # Attempt to move this file from $src to $dst:
         my $result = move_file($spath, $dst, @_);
         if (0 == $result) {++$err_cnt;}
         if (1 == $result) {++$mov_cnt;}
      } # end for each path in source directory
   } # end else if (!$unique)
   say "Moved    $mov_cnt files from \"$srcdsh\" to \"$dstdsh\".";
   if ($large)  {say "Skipped  $skp_cnt files because they weren't large images.";}
   if ($unique) {say "Bypassed $byp_cnt files because of identical files in destination.";}
   say "Suffered $err_cnt errors.";
   return 1;
} # end sub move_files

# ======= SECTION 2, PRIVATE SUBROUTINES: ==============================================================================

# Subroutine rand_int returns a random integer in the range [m,n] inclusive,
# where n and m are any two integers with n > m, and with n and m being greater
# than -1e190,000,000,000,000,000,000 and less than +1,000,000,000,000,000,000.
# This subroutine insures that the probability of the two end points (m and n)
# to occur is the same as the probability of any of the intermediate integers
# to occur.
sub rand_int ($$)
{
   my $min = shift;
   my $max = shift;

   $min =~ m/^-?\d+$/
   or die "Error in rand_int: first argument not integer.\n";

   $max =~ m/^-?\d+$/
   or die "Error in rand_int: second argument not integer.\n";

   $min > -9.223e+18 && $min < 1.844e+19
   or die "Error in rand_int: first argument out-of-range.\n";

   $max > -9.223e+18 && $max < 1.844e+19
   or die "Error in rand_int: second argument out-of-range.\n";

   $min < $max
   or die "Error in rand_int: second argument not greater than first.\n";

   return floor($min+rand($max-$min+1));
} # end sub rand_int

# Return a string of 8 random lower-case English letters:
sub random_name ()
{
   my $chrs = 'abcdefghijklmnopqrstuvwxyz';
   my $name = "";
   for ( my $i = 1 ; $i <= 8 ; ++$i )
   {
      $name = $name . substr($chrs, rand_int(0, 25),1);
   }
   return $name;
}

# Is a referred-to text encoded in ASCII?
sub is_ascii ($)
{
   my $text = shift;
   foreach my $ord (map {ord} split //, $text)
   {
      next if (  9 == $ord ); # HT
      next if ( 10 == $ord ); # LF
      next if ( 11 == $ord ); # VT
      next if ( 13 == $ord ); # CR
      next if ( 32 == $ord ); # SP
      next if ( $ord >=  33
             && $ord <= 126); # ASCII glyph
      # If we get to here, all of the above tests failed, which means that
      # our current character is neither commonly-used ASCII whitespace
      # nor an ASCII glyphical character, so return 0:
      return 0;
   }
   # If we get to here, all characters are either ASCII whitespace or
   # ASCII glyphs, so return 1:
   return 1;
} # end sub is_ascii

# ======= SECTION 3, UTF-8 SUBROUTINES: ================================================================================

# Prepare constant "EFLAGS" which contains bitwise-OR'd flags for Encode::encode and Encode::decode :
use constant EFLAGS => RETURN_ON_ERR | WARN_ON_ERR | LEAVE_SRC;

# Decode from UTF-8 to Unicode:
sub d
{
      if (0 == scalar @_) {return Encode::decode('UTF-8', $_,    EFLAGS);}
   elsif (1 == scalar @_) {return Encode::decode('UTF-8', $_[0], EFLAGS);}
   else              {return map {Encode::decode('UTF-8', $_,    EFLAGS)} @_ };
} # end sub d

# Encode from Unicode to UTF-8:
sub e
{
      if (0 == scalar @_) {return Encode::encode('UTF-8', $_,    EFLAGS);}
   elsif (1 == scalar @_) {return Encode::encode('UTF-8', $_[0], EFLAGS);}
   else              {return map {Encode::encode('UTF-8', $_,    EFLAGS)} @_ };
} # end sub e

# chdir, but using UTF-8:
sub chdir_utf8 ($)
{
   return chdir(e($_[0]));
}

# cwd, but using UTF-8:
sub cwd_utf8 ()
{
   return d(getcwd());
}

# file glob, but using UTF-8:
sub glob_utf8 ($)
{
   my $wc = shift;
   if (wantarray) {return map {d($_)} glob(e($wc));}
   else           {return d(glob(e($wc)));         }
}

# UTF-8 version of link:
sub link_utf8 ($$)
{
   return link(e($_[0]), e($_[1]));
}

# mkdir, but using UTF-8:
sub mkdir_utf8 ($)
{
   return mkdir(e($_[0]));
}

# utf8 version of open:
# WOMBAT : won't work with bareword handles;
# for those, use this instead: open(HND, '<', e $filepath);
# WOMBAT : Only works with 3-arg version of open.
sub open_utf8 ($$$)
{
   return open($_[0], $_[1], e($_[2]));
}

# opendir, but using UTF-8:
# WOMBAT : won't work with bareword handles;
# for those, use this instead: opendir(HND, e $dirpath);
# WOMBAT : only works with 2-arg version of opendir.
sub opendir_utf8 ($$)
{
   return opendir($_[0], e($_[1]));
}

# readdir, but using UTF-8:
sub readdir_utf8 ($)
{
   my $dh = shift;
   if (wantarray) {return map {d($_)} readdir($dh);}
   else           {return d(readdir($dh));         }
}

# UTF-8 version of readlink:
sub readlink_utf8 ($)
{
   return d(readlink(e($_[0])));
}

# rmdir, but using UTF-8:
sub rmdir_utf8 ($)
{
   return rmdir(e($_[0]));
}

# UTF-8 version of symlink:
sub symlink_utf8 ($$)
{
   return symlink(e($_[0]), e($_[1]));
}

# UTF-8 version of unlink:
sub unlink_utf8 ($)
{
   return unlink(e($_[0]));
}

sub glob_regexp_utf8 (;$$$)
{
   # This sub is like glob(), but using UTF-8, a given directory, a target type, and a regular expression
   # instead of a csh-style wildcard as input, and returning matching fully-qualified paths as output, with
   # '.' and '..' stripped-out.

   # VITALLY IMPORTANT: THE "DIRECTORY" ARGUMENT MUST ALREADY BE DECODED FROM UTF-8 INTO RAW UNICODE,
   # OTHERWISE THIS FUNCTION WILL GENERATE "WIDE CHARACTER" ERRORS AND CRASH THE CALLING PROGRAM.
   # THIS SHOULD AUTOMATICALLY BE DONE FOR YOU IF YOU USE MY "cwd_utf8" FUNCTION TO PROVIDE THE DIRECTORY.
   # USING RAW "glob()" OR "<* .*>" OR "readdir", HOWEVER, WILL CAUSE MANY ERRORS ON WINDOWS+NTFS+CYGWIN
   # IF THE CALLING PROGRAM ATTEMPTS TO PROCESS FILE NAMES IN ANY LANGUAGE OTHER THAN ENGLISH.
   # (NAMES SUCH AS "Говорю Русский", "ॐ नमो भगवते वासुदेवाय", "看的星星，知道你是爱。" WOULD CRASH HORRIBLY.)

   my $dir    = @_ ? shift(@_) : cwd_utf8;
   my $target = @_ ? shift(@_) : 'A';
   my $regex  = @_ ? shift(@_) : '^.+$';
   my $re     = qr/$regex/o;

   # If debugging, announce inputs:
   if ($db)
   {
      say "IN glob_regexp_utf8. \$dir    = $dir";
      say "IN glob_regexp_utf8. \$target = $target";
      say "IN glob_regexp_utf8. \$regex  = $regex";
   }

   # Make sure that $dir starts with '/':
   # WOMBAT RH 2023-03-11: Why? I don't see why $dir can't be a relative directory, so comment this out for now:
   # if ($dir !~ m/^\//)
   #    {die "Fatal error in glob_regexp_utf8: directory must start with \"/\".\n";}

   # Try to open $dir; if that fails, print warning and return empty path list:
   my $dh = undef;
   if ( ! opendir $dh, e $dir )
   {
      warn "Warning from glob_regexp_utf8: Couldn't open  directory \"$dir\".\n".
           "Returning empty path list.";
      return ();
   }

   # Try to read $dir into @names; @names should now contain at least 2 entries ('.' and '..');
   # if it doesn't, then something went very wrong!!!
   my @names = d readdir $dh;
   if ( scalar(@names) < 2 )
   {
      warn "Warning from glob_regexp_utf8: Couldn't read  directory \"$dir\".\n".
           "Returning empty path list.";
      closedir $dh or die "Fatal Error in glob_regexp_utf8: Couldn't close directory \"$dir\".\n$!\n";
      return ();
   }

   # Try to close $dir; if that fails, abort program:
   closedir $dh or die "Error in RecurseDirs: Couldn't close directory \"$dir\".\n$!\n";

   # Riffle through @names. Skip '.', '..', and names not matching $regex, construct paths from names, skip paths that
   # don't exist if target is F or D or B, skip paths to objects of types not matching target, and push remaining paths
   # onto @paths:
   my @paths;
   my $path;
   foreach my $name (@names)
   {
      say "IN glob_regexp_utf8. NAME FROM readdir_utf8: $name" if $db;
      next if $name eq '.';
      next if $name eq '..';
      next if $name !~ m/$re/;

      # Construct fully-qualified path from $dir and $name:
      if ($dir eq '/')  {$path = "/$name";}
      else              {$path = "$dir/$name";}
      say "IN glob_regexp_utf8. CONSTRUCTED PATH: $path" if $db;

      # Don't test for existence here unless target is 'F', 'D', or 'B'. For target 'A',we want GetFiles
      # (or other caller) to be able to note any non-existent directory entries and flag them "noex":
      if    ($target eq 'F') {next if ! -e e $path; lstat e $path; next if ! -f _           }
      elsif ($target eq 'D') {next if ! -e e $path; lstat e $path; next if           ! -d _ }
      elsif ($target eq 'B') {next if ! -e e $path; lstat e $path; next if ! -f _ && ! -d _ }
      else {;} # Else do nothing.
      push @paths, $path;
   }

   if ($db)
   {
      say '';
      say "IN glob_regexp_utf8 AT END. \@paths:";
      say for @paths;
      say '';
   }
   return @paths;
} # end sub glob_regexp_utf8 (;$$$)

# ======= SECTION 4, MINOR SUBROUTINES: ================================================================================

# Rename a file, with more error-checking than unwrapped rename() :
sub rename_file ($$)
{
   my $OldPath = shift;
   my $NewPath = shift;
   my $OldName = get_name_from_path($OldPath);
   my $NewName = get_name_from_path($NewPath);
   my $OldDir  = get_dir_from_path($OldPath);
   my $NewDir  = get_dir_from_path($NewPath);

   # Make sure old path exists:
   if ( ! -e e($OldPath) )
   {
      warn
      (
         "Error in rename_file: file \"$OldPath\" does not exist.\n"
      );
      return 0;
   }

   # Disallow renaming to exact same path:
   if ($NewPath eq $OldPath)
   {
      warn
      (
         "Error in rename_file: new file name is same as old:\n".
         "old name: $OldPath\n".
         "new name: $NewPath\n"
      );
      return 0;
   }

   # Disallow renaming to a name that already exists, but allow case changes.
   # This is tricky, because file systems can be:
   # 1. case-nonpreserving (everything is stored as upper-case, as in FAT16)
   # 2. case-preserving and case-sensitive (file names are stored as-is; eg, Unix, Linux)
   # 3. case-preserving and case-insensitive (file names must differ in more than case; eg, FAT32, NTFS)

   # For the purpose of this subroutine, I'm assuming that the user is using Windows 10, Cygwin, and NTFS,
   # which puts us in case 3 above. But if any of these assumptions are NOT true, this subroutine may need
   # to be altered accordingly for it to work right.

   # Disallow existing $NewPath unless this is just a case change:
   if ( -e e($NewPath) )
   {
      unless ( fc($OldPath) eq fc($NewPath) )
      {
         warn
         (
            "Error in \"rename_file\" in \"RH::Dir.pm\":\n".
            "file at path \"$NewPath\" already exists.\n"
         );
         return 0;
      }
   }

   # Attempt to rename the file, and return the result code (which will be 1 for success, 0 for failure):
   return rename(e($OldPath), e($NewPath));
} # end sub rename_file

sub time_from_mtime ($)
{
   my $TimeDate = scalar localtime shift;
   my $Time = substr ($TimeDate, 11, 8);
   return $Time;
} # end sub time_from_mtime

sub date_from_mtime ($)
{
   my $TimeDate = scalar localtime shift;
   my $Date = substr ($TimeDate, 0, 10) . ', ' . substr ($TimeDate, 20, 4);
   return $Date;
} # end sub date_from_mtime

# Given any string, return all characters before last dot:
sub get_prefix ($)
{
   my $string = shift;
   my $dotindex = rindex($string, '.');
   return $string if -1 == $dotindex;
   return ''      if  0 == $dotindex;
   return substr($string, 0, $dotindex);
} # end sub get_prefix

# Given any string, return last dot and following characters:
sub get_suffix ($)
{
   my $string = shift;
   my $dotindex = rindex($string, '.');
   return ''      if -1 == $dotindex;
   return $string if  0 == $dotindex;
   return substr($string, $dotindex);
} # end sub get_suffix

# Return the directory part of a file path:
sub get_dir_from_path ($)
{
   my $path = shift;

   # If $path contains no "/", we have no idea of what directory we're in, so return an empty string:
   if (-1 == rindex($path,'/'))
   {
      return '';
   }

   # Else if right-most "/" in $path is at index 0, assume $path is the path of a file in the root directory,
   # so return '/':
   elsif (0 == rindex($path,'/'))
   {
      return '/';
   }

   # Otherwise return the part of $path to the left of the right-most "/", whether it starts with '/' or not:
   else
   {
      return substr($path, 0, rindex($path,'/'));
   }
} # end sub get_dir_from_path

# Return the name part of a file path:
sub get_name_from_path ($)
{
   my $path = shift;

   # If $path does not contain "/", then consider $path to be an unqualified
   # file name, so return $path:
   if (-1 == rindex($path,'/'))
   {
      return $path;
   }

   # Else if the right-most "/" of $path is to the left of the final character,
   # return the substring of $path to the right of the right-most "/":
   elsif (rindex($path,'/') < length($path)-1)
   {
      return substr($path, rindex($path,'/') + 1);
   }

   # Else "/" is the final character of $path, so this $path contains no
   # file name, so return an empty string:
   else
   {
      return '';
   }
} # end sub get_name_from_path

# Paste-together dir & name to get path, while watching out for root and current:
sub path ($$)
{
   my $dir  = shift;
   my $nam  = shift;
   my $path = undef;

   # If $dir is '/', then the path is just the name with '/' appended to its left:
   if ( $dir eq '/' )
   {
      $path = "/$nam";
   }

   # Else if $dir is '', assume that '' means "current working directory", so set $path to $nam:
   elsif ( $dir eq '' )
   {
      $path = "$nam";
   }

   # Otherwise, set path to "$dir/$nam":
   else
   {
      $path = "$dir/$nam";
   }

   # Return $path:
   return $path;
}

sub denumerate_file_name ($)
{
   my $name = shift;
   my $prefix = get_prefix($name);
   my $suffix = get_suffix($name);
   $prefix =~ s/-\(\d\d\d\d\)//g;
   return $prefix . $suffix;
} # end sub denumerate_file_name

sub enumerate_file_name ($)
{
   my $name = shift;
   my $prefix = get_prefix($name);
   my $suffix = get_suffix($name);
   $prefix =~ s/-\(\d\d\d\d\)$//g;
   my $numerator = sprintf("-(%04d)", rand_int(0,9999));
   $prefix = $prefix . $numerator;
   return $prefix . $suffix;
} # end sub enumerate_file_name

# Annotate a file's name (with a parenthetical note):
sub annotate_file_name ($$)
{
   my $oldname = shift;  # Original file name.
   my $note    = shift;  # Note to be appended (NOT including the (parentheses)!).
   my $oldpref = get_prefix($oldname);
   my $oldsuff = get_suffix($oldname);
   return $oldpref . '(' . $note . ')' . $oldsuff;
} # end sub annotate_file_name

# Find an enumerated version of a file name which is NOT the name of any file in a given directory:
sub find_avail_enum_name ($;$)
{
   my $name = shift                    ; # A valid file name.
   my $dir  = @_ ? shift : cwd_utf8    ; # An existing directory, defaulting to current directory.
   my $prefix    =  get_prefix($name)  ; # Prefix of name.
      $prefix    =~ s/-\(\d\d\d\d\)//g ; # Denumerate prefix in-situ.
   my $suffix    =  get_suffix($name)  ; # Suffix of name.
   my $numerator =  ''                 ; # 4-digit numerator.
   my $tryname   =  ''                 ; # Trial file name.

   # Make sure the given directory actually does exist, and actually is a directory:
   if ( ! -e e $dir || ! -d e $dir )
   {
      warn "\nError in find_avail_enum_name:\n",
           "No such directory as \"$dir\".\n",
           "$!\n";
      return '***ERROR***';
   }

   # First try up to 20 different random numerators:
   RAN: for ( 1 .. 20 )
   {
      $numerator = sprintf("-(%04d)", rand_int(0,9999));
      $tryname   = $prefix . $numerator . $suffix;
      if ( ! -e e path($dir, $tryname) )
      {
         if ($db) {say "Random enumeration succeeded on attempt # $_.";}
         return $tryname;
      }
   } # Stop trying random numerators.

   # If we get to here, random enumeration failed all 20 times,
   # so try sequential enumeration instead:
   SEQ: for ( 0 .. 9999 )
   {
      $numerator = sprintf("-(%04d)", $_);
      $tryname = $prefix . $numerator . $suffix;
      if ( ! -e e path($dir, $tryname) )
      {
         if ($db) {say "Sequential enumeration succeeded on attempt # $_.";}
         return $tryname;
      }
   } # Stop trying sequential numeration.

   # If we get to here, NOTHING worked, so return error code:
   return '***ERROR***';
} # end sub find_avail_enum_name

# Make up to 100 attempts to find an available random name in given directory with given prefix and suffix:
sub find_avail_rand_name ($$$)
{
   # Get file info:
   my $dir           = shift;
   my $prefix        = shift;
   my $suffix        = shift;
   my $random        = '';
   my $new_name      = '';
   my $attempts      = 0;
   my $name_success  = 0;

   # Make up to 100 attempts to find a random file name with given prefix
   # and suffix that doesn't already exist in given directory:
   for ( $attempts = 0, $name_success = 0 ; $attempts < 100 ; ++$attempts )
   {
      $random = random_name();
      $new_name   = $prefix . $random . $suffix;
      if ( ! -e e path($dir, $new_name) )
      {
         $name_success = 1;
         last;
      }
   }
   if ($name_success)
   {
      return $new_name;
   }
   else
   {
      return '***ERROR***';
   }
} # sub find_avail_rand_name ($$$)

# Is a given path a path to a file containing a large image?
sub is_large_image ($)
{
   my $path = shift;

   # File-typing variables:
   my $FileTyper = File::Type->new(); # File-typing functor.
   my $FileType  = '';                # File type.

   # Return 0 if no object exists at path $path:
   if ( ! -e e $path ) {return 0 ;}

   # Return 0 if object at path $path is not a regular file:
   if ( ! -f e $path ) {return 0 ;}

   my $suffix = get_suffix($path);

   # Return 0 if this file is not an image file:
   $FileType = $FileTyper->checktype_filename($path);
   if ($db) {warn "In is_large_image. File type = \"$FileType\".\n";}
   return 0 if $FileType ne 'image/bmp'
            && $FileType ne 'image/gif'
            && $FileType ne 'image/jpeg'
            && $FileType ne 'image/png'
            && $FileType ne 'image/tiff'
           #&& $FileType ne 'image/webp' # Nope, this type returns "Application/Octet-Stream".
            && $suffix   ne '.webp';

   # Return 0 if this file doesn't contain an image which is at least 1200px wide and 600px tall:
   my ($x, $y) = imgsize($path);
   return 0 if $x < 1200 || $y < 600;

   # If we get to here, this file contains a large image, so return 1:
   return 1;
} # end sub is_large_image

sub get_suffix_from_type ($)
{
   my $type = shift;
   if ( ! defined $type ) {return '.unk';}
   if ($type eq 'video/x-msvideo'                                ) {return '.avi' ;}
   if ($type eq 'image/bmp'                                      ) {return '.bmp' ;}
   if ($type eq 'application/x-freearc'                          ) {return '.arc' ;}
   if ($type eq 'text/css'                                       ) {return '.css' ;}
   if ($type eq 'text/csv'                                       ) {return '.csv' ;}
   if ($type eq 'application/msword'                             ) {return '.doc' ;}
   if ($type eq 'application/epub+zip'                           ) {return '.epub';}
   if ($type eq 'image/gif'                                      ) {return '.gif' ;}
   if ($type eq 'text/html'                                      ) {return '.html';}
   if ($type eq 'image/vnd.microsoft.icon'                       ) {return '.ico' ;}
   if ($type eq 'application/java-archive'                       ) {return '.jar' ;}
   if ($type eq 'image/jpeg'                                     ) {return '.jpg' ;}
   if ($type eq 'text/javascript'                                ) {return '.js'  ;}
   if ($type eq 'application/json'                               ) {return '.json';}
   if ($type eq 'audio/midi'                                     ) {return '.mid' ;}
   if ($type eq 'audio/x-midi'                                   ) {return '.mid' ;}
   if ($type eq 'audio/mpeg'                                     ) {return '.mp3' ;}
   if ($type eq 'video/mpeg'                                     ) {return '.mpg' ;}
   if ($type eq 'application/vnd.oasis.opendocument.presentation') {return '.odp' ;}
   if ($type eq 'application/vnd.oasis.opendocument.spreadsheet' ) {return '.ods' ;}
   if ($type eq 'application/vnd.oasis.opendocument.text'        ) {return '.odt' ;}
   if ($type eq 'audio/ogg'                                      ) {return '.ogg' ;}
   if ($type eq 'font/otf'                                       ) {return '.otf' ;}
   if ($type eq 'image/png'                                      ) {return '.png' ;}
   if ($type eq 'application/pdf'                                ) {return '.pdf' ;}
   if ($type eq 'application/x-httpd-php'                        ) {return '.php' ;}
   if ($type eq 'application/vnd.ms-powerpoint'                  ) {return '.ppt' ;}
   if ($type eq 'application/vnd.rar'                            ) {return '.rar' ;}
   if ($type eq 'application/rtf'                                ) {return '.rtf' ;}
   if ($type eq 'application/x-sh'                               ) {return '.sh'  ;}
   if ($type eq 'image/svg+xml'                                  ) {return '.svg' ;}
   if ($type eq 'application/x-tar'                              ) {return '.tar' ;}
   if ($type eq 'image/tiff'                                     ) {return '.tiff';}
   if ($type eq 'font/ttf'                                       ) {return '.ttf' ;}
   if ($type eq 'text/plain'                                     ) {return '.txt' ;}
   if ($type eq 'audio/wav'                                      ) {return '.wav' ;}
   if ($type eq 'audio/webm'                                     ) {return '.weba';}
   if ($type eq 'video/webm'                                     ) {return '.webm';}
   if ($type eq 'image/webp'                                     ) {return '.webp';}
   if ($type eq 'application/vnd.ms-excel'                       ) {return '.xls' ;}
   if ($type eq 'text/xml'                                       ) {return '.xml' ;}
   if ($type eq 'application/vnd.mozilla.xul+xml'                ) {return '.xul' ;}
   if ($type eq 'application/zip'                                ) {return '.zip' ;}
   if ($type eq 'application/x-7z-compressed'                    ) {return '.7z'  ;}
   return '.unk';
} # end sub get_suffix_from_type ($)

# Convert a fully-qualified Cygwin path to Windows:
sub cyg2win ($)
{
   my $path = shift;
   $path =~ s#^/cygdrive/(\p{Ll})#\U$1\E:#;
   $path =~ s#/#\\#g;
   return $path;
} # end sub cyg2win ($)

# Convert a fully-qualified Windows path to Cygwin:
sub win2cyg ($)
{
   my $path = shift;
   $path =~ s#^(\p{Lu}):#/cygdrive/\L$1\E#;
   $path =~ s#\\#/#g;
   return $path;
} # end sub win2cyg ($)

# Get a hash or hash-based file name for a file.
# Mandatory arguments:
#    $path   (Path of file to make hash for. Eg: /home/Bob/myfile.txt)
#    $type   (Type of hash to generate. Options are: md5 sha1 sha224 sha256 sha384 sha512)
# Optional argument:
#    $mode   (Options are: "name" (hash-based file name, eg "9e5a...b071.txt") or "hash" (default: just the hash).)
sub hash($$;$)
{
   my $path = shift;                                                  # Path to source file.
   my $type = shift;                                                  # What type of hash?
   my $mode = @_ ? shift : 'hash';                                    # Return raw hash, or hash-based file name?
   my $name = get_name_from_path($path);                              # Get name        of source file.
   my $suff = get_suffix($name);                                      # Get suffix      of source file.
   my $fh;                                                            # File handle (initially undefined).
   my $hash;                                                          # Hash of file contents
   my $FileTyper = File::Type->new();                                 # File-typing functor.
   my $FileType  = '';                                                # File type.
   local $/ = undef;                                                  # Local undef sets input record separator to EOF.
   open($fh, '< :raw', e($path))                                      # Try to open the file for reading;
   or warn "Error in sub \"hash()\" in module \"Dir.pm\":\n".         # if file-open failed for any reason,
           "Couldn't open file \"$path\" for reading.\n"              # warn user
   and return '***ERROR***';                                          # and return '***ERROR***'.
   my $data = <$fh>;                                                  # Slurrrp file into $data as one big string.
   defined $data                                                      # Test if $data is defined.
   or warn "Error in sub \"hash()\" in module \"Dir.pm\":\n".         # If file-read failed for any reason
           "Couldn't read data from file \"$path\".\n"                # warn user
   and return '***ERROR***';                                          # and return '***ERROR***'.
   close($fh);                                                        # Close file.
   given ($type)                                                      # Depending on which hash type user requested,
   {                                                                  # set $hash to the appropriate hash.
      when ('md5')
      {
         $hash = md5_hex($data);                                      # Get MD-5 file hash.
      }
      when ('sha1')
      {
         $hash = sha1_hex($data);                                     # Get SHA-1 file hash.
      }
      when ('sha224')
      {
         $hash = sha224_hex($data);                                   # Get SHA-224 file hash.
      }
      when ('sha256')
      {
         $hash = sha256_hex($data);                                   # Get SHA-256 file hash.
      }
      when ('sha384')
      {
         $hash = sha384_hex($data);                                   # Get SHA-384 file hash.
      }
      when ('sha512')
      {
         $hash = sha512_hex($data);                                   # Get SHA-512 file hash.
      }
      default
      {
         return '***ERROR***';                                        # Return '***ERROR***'.
      }
   } # end given ($type)
   given ($mode)
   {
      when ('hash')
      {
         return $hash;
      }
      when ('name')
      {
         if ('' eq $suff)                                             # If suffix is blank,
         {
            $FileType = $FileTyper->checktype_filename($path);        # get mime type of original file,
            $suff = get_suffix_from_type($FileType);                  # then get suffix from type.
         }
         return $hash . $suff;                                        # Return hash with suffix tacked on.
      }
      default
      {
         return '***ERROR***';
      }
   } # end given ($mode)
   say "And he tapped with his whip on the shutters,";                # We can't possibly get here. But if we do,
   say "but all was locked and barred.";                              # then print some cryptic shit
   return 'We\'re in the fucking Twilight Zone, baby.';               # and return suitable error message.
} # end sub hash($$;$)

# Shorten directory and file names for Spotlight:
sub shorten_sl_names ($$$$)
{
   my $src_dir = shift;
   my $src_fil = shift;
   my $dst_dir = shift;
   my $dst_fil = shift;

   my $s1 = '/cygdrive/c/Users';
   my $s2 = '/AppData/Local/Packages';
   my $s3 = '/Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy';
   my $s4 = '/LocalState/Assets';
   my $s5 = '/cygdrive/d/sl';
   my $u1 = '/Aragorn';
   my $u2 = '/Urgabor';
   my $u3 = '/Zebulon';
   my $u4 = '/Administrator';

   $src_dir =~ s%$s1$u1$s2$s3$s4%/usl1%;
   $src_dir =~ s%$s1$u2$s2$s3$s4%/usl2%;
   $src_dir =~ s%$s1$u3$s2$s3$s4%/usl3%;
   $src_dir =~ s%$s1$u4$s2$s3$s4%/usl4%;

   $src_fil =~ s%^.{8}\K.{4,}$%...%;

   $dst_dir =~ s%$s5%/sl%;

   $dst_fil =~ s%^.{8}\K.{4,}$%...%;

   return ($src_dir, $src_fil, $dst_dir, $dst_fil);
} # end sub shorten_sl_names ($$$$)

# Return 1 if-and-only-if a given string is a path to a data file (a regular file that is not a link or directory).
sub is_data_file ($)
{
   my $path = shift;
   my $name = get_name_from_path($path);
   return 0 if $name eq '.';
   return 0 if $name eq '..';
   return 0 if $name =~ m/^\.sync.ffs_db/;
   return 0 if $name =~ m/^\.directory/;
   return 0 if $name =~ m/^desktop.*\.ini$/i;
   return 0 if $name =~ m/^thumbs.*\.db$/i;
   return 0 if $name =~ m/^pspbrwse.*\.jbf$/i;
   return 0 if $name =~ m/ID-Token/i;
   return 0 if ! -e e $path;
   lstat e $path;
   return 0 if ! -f _ ;
   return 0 if   -l _ ;
   return 0 if   -d _ ;
   return 1;
} # end sub is_data_file ($)

# Return 1 if-and-only-if a given string is a fully-qualified path to a valid directory.
sub is_valid_qual_dir ($)
{
   my $path  = shift;
   my $valid = 1;
   if ( !defined($path) )
   {
      print STDERR "\nWarning from \"is_valid_qual_dir\": path is not defined.\n";
      $valid = 0;
   }
   elsif ( length($path) < 1 )
   {
      print STDERR "\nWarning from \"is_valid_qual_dir\": path is zero-length.\n";
      $valid = 0;
   }
   elsif ( substr($path,0,1) ne '/' )
   {
      print STDERR "\nWarning from \"is_valid_qual_dir\": path does not start with a slash:\n$path\n";
      $valid = 0;
   }
   elsif ( ! -e e $path )
   {
      print STDERR "\nWarning from \"is_valid_qual_dir\": path does not exist:\n$path\n";
      $valid = 0;
   }
   elsif ( ! -d e $path )
   {
      print STDERR "\nWarning from \"is_valid_qual_dir\": path is not a directory:\n$path\n";
      $valid = 0;
   }
   return $valid;
} # end sub is_valid_qual_dir ($)

1;
