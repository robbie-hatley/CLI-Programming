#! /bin/perl -CSDA

# This is a 110-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय. 看的星星，知道你是爱。麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

##############################################################################################################
# get.pl
# Gets file name extensions on files, based on File::Type and on scrutiny of file contents.
# Written by Robbie Hatley.
# Edit history:
# Sat Aug 12, 2023: Wrote it. (STUBB!!!)
##############################################################################################################

use v5.38;
use strict;
use warnings;
use utf8;
use warnings FATAL => 'utf8';

use Sys::Binmode;
use Time::HiRes 'time';
use File::Type;

use RH::Util;
use RH::Dir;

use constant BUFFER_SIZE => 1048576;

# ======= SUBROUTINE PRE-DECLARATIONS: =======================================================================

sub argv    ;
sub curdire ;
sub curfile ;
sub stats   ;
sub error   ;
sub help    ;

# ======= PAGE-GLOBAL LEXICAL VARIABLES: =====================================================================

# Debug?
my $db = 1;

# File typing:
my $FileTyper  = File::Type->new(); # File-typing functor.

# Settings:                   Meaning of setting:         Range:    Meaning of default:
my $RegExp    = qr/^.+$/o;  # Process which file names?   regexp    Process files of all names.
my $Recurse   = 0;          # Recurse subdirectories?     bool      Don't recurse subdirectories.

# Event counters:
my $direcount = 0; # Count of directories processed.
my $filecount = 0; # Count of files processed.
my $tinycount = 0; # Count of files bypassed because their size was less than 50 bytes.
my $frercount = 0; # Count of file-read errors suffered.
my $typecount = 0; # Count of files of known type.
my $unkncount = 0; # Count of files of unknown type.
my $samecount = 0; # Count of files bypassed because new name same as old.
my $renacount = 0; # Count of files successfully renamed.
my $failcount = 0; # Count of failed file-rename attempts.

# ======= MAIN BODY OF PROGRAM: ==============================================================================

{ # begin main
   my $t0 = time;
   argv;
   my $pname = get_name_from_path($0);
   say STDERR "\nNow entering program \"$pname\".";
   say "RegExp  = $RegExp";
   say "Recurse = $Recurse";
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $ms = 1000 * (time - $t0);
   printf STDERR "\nNow exiting program \"%s\". Execution time was %.3fms.", $pname, $ms;
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =============================================================================

sub argv {
   # Get options and arguments:
   my @opts = (); my @args = (); my $end_of_options = 0;
   for ( @ARGV ) {
      /^--$/ and $end_of_options = 1 and next;
      !$end_of_options && /^-\pL*$|^--.+$/ and push @opts, $_ or push @args, $_;
   }

   # Process options:
   for ( @opts ) {
      /^-\pL*h|^--help$/     and help and exit 777 ;
      /^-\pL*e|^--debug$/    and $db      =  1     ;
      /^-\pL*r|^--recurse$/  and $Recurse =  1     ;
   }
   $db and say STDERR "opts = (@opts)\nargs = (@args)";

   # Count args:
   my $NA = scalar @args;

   # Take various actions depending on $NA:
                                                     # If $NA == 0, do nothing
   $NA == 1 and $RegExp = $ARGV[0];                  # If $NA == 1, set $RegExp.
   $NA  > 1 and error($NA) and help and exit 666;    # If $NA  > 1, print error and help and exit 666.

   # Return success code 1 to caller:
   return 1;
} # end sub argv ()

sub curdire {
   ++$direcount;
   my $curdir = cwd_utf8;
   say "\nDirectory # $direcount: $curdir\n";
   my @paths = glob_regexp_utf8($curdir, 'F', $RegExp);
   for my $path (@paths) {
      next if ! is_data_file($path);
      curfile $path;
   }
   return 1;
} # end sub curdire ()

sub curfile ($old_path) {
   ++$filecount;
   my $cwd      = cwd_utf8;
   my $old_name = get_name_from_path($old_path);
   my $old_pref = get_prefix($old_name);
   my $old_suff = get_suffix($old_name);
   my $type     = $FileTyper->checktype_filename($old_name);
   my $new_suff = get_suffix_from_type($type);
   my $new_pref = $old_pref;
   my $new_name = '';
   my $new_path = '';
   my $fh       = undef;
   my $buffer   = '';
   my $bytes    = 0;
   my $success  = 0;

   if ($db) {
      print STDERR "                                  \n",
                   "In sxt, in curfile(), near top.   \n",
                   "\$filecount = \"$filecount\".     \n",
                   "\$old_path  = \"$old_path\".      \n",
                   "\$old_name  = \"$old_name\".      \n",
                   "\$old_pref  = \"$old_pref\".      \n",
                   "\$old_suff  = \"$old_suff\".      \n",
                   "\$type      = \"$type\".          \n",
                   "\$new_suff  = \"$new_suff\".      \n",
                   "\$new_pref  = \"$new_pref\".      \n",
                   "\$new_name  = \"$new_name\".      \n",
                   "\$new_path  = \"$new_path\".      \n";
   }

   # If "checktype_filename" from CPAN module "File::Type" was unable to determine the type of this file,
   # resort to opening the file and searching the first 50 bytes for clues:
   if ($new_suff eq '.unk') {
      if ($db) {say 'In sxt, in curfile(), in if(unk), at top.';}
      if ( ( -s e $old_path ) < 50 ) {
         ++$tinycount;
         say "Bypassed (under 50 bytes): \"$old_name\"";
         return 1;
      }
      $fh = undef;
      $buffer = '';
      open($fh, '< :raw', e $old_path)
         or ++$frercount
         and warn "Error: Couldn't open file $old_name\n"
         and return 0;

      read($fh, $buffer, BUFFER_SIZE)
         or ++$frercount
         and warn "Error: Couldn't read file $old_name\n"
         and return 0;

      close($fh)
         or ++$frercount
         and warn "Error: Couldn't close file $old_name\n"
         and return 0;

      $bytes = length($buffer);

      if ($db) {say "In sxt, in curfile(), in if(unk), loaded $bytes bytes into buffer.";}

      if ( $bytes < 50 ) {
         say "Warning: read fewer than 50 bytes from this file:";
         say "$old_name";
         say "Continuing with next file.";
         ++$frercount;
         return 0;
      }

      if ($buffer =~ m%Content-Type: application/javascript%
       || $buffer =~ m%Content-Type: application/x-javascript%){$new_suff = '.js'  ;}# JS
      elsif ("AVI" eq substr($buffer, 8, 3))                   {$new_suff = '.avi' ;}# AVI
      elsif (pack('C4',195,202,4,193) eq substr($buffer,0,4))  {$new_suff = '.ccf' ;}# CCF (Chrome Cache File)
      elsif ('CWS' eq substr($buffer,0,3) )                    {$new_suff = '.cws' ;}# CWS
      elsif ('fLaC' eq substr($buffer,0,4) )                   {$new_suff = '.flac';}# FLAC
      elsif ('FLV' eq substr($buffer,0,3) )                    {$new_suff = '.flv' ;}# FLV (FLash Video)
      elsif ('GIF' eq substr($buffer,0,3) )                    {$new_suff = '.gif' ;}# GIF
      elsif ($buffer =~ m/^<!DOCTYPE HTML/ )                   {$new_suff = '.html';}# HTML
      elsif ('FWS' eq substr($buffer,0,3) )                    {$new_suff = '.fws' ;}# FWS
      elsif (pack('C3',255,216,255) eq substr($buffer,0,3))    {$new_suff = '.jpg' ;}# JPG
      elsif ('ftypmp4' eq substr($buffer,4,7))                 {$new_suff = '.mp4' ;}# MP4
      elsif ('PAR2' eq substr($buffer,0,4))                    {$new_suff = '.par2';}# PAR2
      elsif ('PDF' eq substr($buffer,1,3))                     {$new_suff = '.pdf' ;}# PDF
      elsif ('PNG' eq substr($buffer,1,3))                     {$new_suff = '.png' ;}# PNG
      elsif ('PK' eq substr($buffer,0,2))                      {$new_suff = '.pk'  ;}# PK
      elsif ('Rar' eq substr($buffer,0,3))                     {$new_suff = '.rar' ;}# RAR
      elsif ('WAVEfmt' eq substr($buffer,8,7))                 {$new_suff = '.wav' ;}# WAV
      elsif (pack('C[16]', 48, 38,178,117,142,102,207, 17,
                          166,217,  0,170,  0, 98,206,108)
                          eq substr($buffer,0,16))             {$new_suff = '.wma' ;}# WMA
      elsif ($buffer =~
             m%^/\*!CK:\d{8,10}!\*//\*\d{8,10},\*/%)           {$new_suff = '.fbc' ;}# FBC
      elsif (is_ascii($buffer))                                {$new_suff = '.txt' ;}# TXT
      elsif (is_iso_8859_1($buffer))                           {$new_suff = '.txt' ;}# TXT
      else                                                     {$new_suff = '.unk' ;}# unknown file type
      if ($db) {
         say "In sxt, in curfile, in if(unk), at bottom;";
         say "new suffix = \"$new_suff\".";
      }
   } # end if $new_suff eq '.unk'

   # If this file's type is STILL unknown, increment $unkncount:
   if ($new_suff eq '.unk') {
      ++$unkncount;
   }

   # Otherwise, increment $typecount:
   else {
      ++$typecount;
   }

   # Make new name and path:
   my $new_name = $new_pref . $new_suff;
   my $new_path = path($cwd, $new_name);

   # Bail if new same as old:
   if ($new_name eq $old_name) {
      ++$samecount;
      return 1;
   }

   if ($db) {
      print "\nIn sxt, in curfile(), about to attempt rename. \n",
            "\$old_name  = \"$old_name\".  \n",
            "\$old_path  = \"$old_path\".  \n",
            "\$new_name  = \"$new_name\".  \n",
            "\$new_path  = \"$new_path\".  \n";
   }

   # Attempt rename:
   $success = rename_file($old_path, $new_path);
   if ($success) {
      ++$renacount;
      say "Renamed: \"$old_name\" => \"$new_name\"";
      return 1;
   }
   else {
      ++$failcount;
      say "Failed: \"$old_name\" => \"$new_name\"";
      return 0;
   }
} # end sub curfile ($old_path)

sub stats {
   print("\nStats for \"set-extensions.pl\":\n");
   say "Navigated $direcount directories.";
   say "Encountered $filecount files.";
   say "Bypassed $tinycount files because they were under 50 bytes.";
   say "Suffered $frercount file-read errors.";
   say "Found $typecount files of known type.";
   say "Found $unkncount files of unknown type.";
   say "Bypassed $samecount files because new name same as old.";
   say "Successfully renamed $renacount files.";
   say "Tried but failed to rename $failcount files.";
   return 1;
} # end sub stats

# Handle errors:
sub error ($NA) {
   print ((<<"   END_OF_ERROR") =~ s/^   //gmr);

   Error: you typed $NA arguments, but this program takes at most
   one argument, which, if present, must be a regular expression describing
   which items to process. Help follows:
   END_OF_ERROR
   return 1;
} # end sub error ($NA)

sub help {
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);

   Welcome to "set-extensions.pl" (suggested BASH alias "sxt"), Robbie Hatley's
   nifty file name extension setter. sxt determines the types of the files in the
   current directory (and all subdirectories if a -r or --recurse option is used)
   and sets their file name extensions accordingly. For example, if sxt finds a
   file named "cat.txt" which is actually a jpg image file, sxt will rename the
   file to "cat.jpg".

   Command line:
   set-extensions.pl [options] [argument]

   Description of options:
   Option:                  Meaning:
   "-h" or "--help"         Print this help and exit.
   "-r" or "--recurse"      Recurse subdirectories (but not SYMLINKDs).

   Description of arguments:
   In addition to options, this program can take one optional argument which, if
   present, must be a Perl-Compliant Regular Expression specifying which items to
   process. To specify multiple patterns, use the | alternation operator.
   To apply pattern modifier letters, use an Extended RegExp Sequence.
   For example, if you want to search for items with names containing "cat",
   "dog", or "horse", title-cased or not, you could use this regexp:
   '(?i:c)at|(?i:d)og|(?i:h)orse'
   Be sure to enclose your regexp in 'single quotes', else BASH may replace it
   with matching names of entities in the current directory and send THOSE to
   this program, whereas this program needs the raw regexp instead.

   Happy extension setting!

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
