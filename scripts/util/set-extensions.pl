#! /bin/perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# set-extenstions.pl
# Sets file name extensions on files, based on scrutiny of file contents.
#
# Edit history:
# Mon May 04, 2015: Wrote first draft.
# Wed May 13, 2015: Updated and changed Help to "Here Document" format.
# Fri Jul 17, 2015: Upgraded for utf8.
# Sun Feb 07, 2015: Made minor improvements.
# Sat Apr 16, 2016: Now using -CSDA.
# Tue Dec 19, 2017: Adjusted formatting, comments, err_msg, help_msg.
# Sun Jan 03, 2021: Edited.
# Sat Nov 20, 2021: Refreshed shebang, colophon, titlecard, and boilerplate; using "common::sense" and "Sys::Binmode".
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Time::HiRes 'time';

use File::Type;

use RH::Util;
use RH::Dir;

use constant BUFFER_SIZE => 1048576;

# ======= SUBROUTINE PRE-DECLARATIONS: =================================================================================

sub argv    ();
sub curdire ();
sub curfile ($);
sub stats   ();
sub error   ($);
sub help    ();

# ======= PAGE-GLOBAL LEXICAL VARIABLES: ===============================================================================

# Debug?
my $db = 0;

# File typing:
my $FileTyper  = File::Type->new(); # File-typing functor.

# Settings:                Meaning:                  Range:   Default:
my $RegExp    = '^.+$';  # Regular expression.       regexp   '^.+$'
my $Recurse   = 0;       # Recurse subdirectories?   bool     0

# Event counters:
my $direcount = 0; # Count of directories processed.
my $filecount = 0; # Count of files processed.
my $tinycount = 0; # Count of files bypassed because their size was less than 50 bytes.
my $frercount = 0; # Count of file-read errors suffered.
my $typecount = 0; # Count of files of known type.
my $unkncount = 0; # Count of files of UNknown type.
my $samecount = 0; # Count of files bypassed because new name same as old.
my $renacount = 0; # Count of files successfully renamed.
my $failcount = 0; # Count of failed file-rename attempts.

# ======= MAIN BODY OF PROGRAM: ========================================================================================

{ # begin main
   say "\nNow entering program \"" . get_name_from_path($0) . "\".";
   my $t0 = time;
   argv;
   say "RegExp  = $RegExp";
   say "Recurse = $Recurse";
   $Recurse and RecurseDirs {curdire} or curdire;
   stats;
   my $t1 = time; my $te = $t1 - $t0;
   say "\nNow exiting program \"" . get_name_from_path($0) . "\". Execution time was $te seconds.";
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS =======================================================================================

sub argv ()
{
   for ( my $i = 0 ; $i < @ARGV ; ++$i )
   {
      $_ = $ARGV[$i];
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         if ( /^-h$/ || /^--help$/    ) { help; exit 777 ; }
         if ( /^-r$/ || /^--recurse$/ ) { $Recurse = 1   ; }
         splice @ARGV, $i, 1; # Remove option from @ARGV.
         --$i; # Move index 1-left, so that the "++$i" above moves index back to current spot, with new item.
      }
   }
   my $NA = scalar(@ARGV);
   given ($NA)
   {
      when (0)
      {
         ; # Do nothing.
      }
      when (1)
      {
         $RegExp = $ARGV[0];
      }
      default
      {
         error($NA);
      }
   }
   return 1;
} # end sub argv ()

sub curdire ()
{
   ++$direcount;
   my $curdir = cwd_utf8;
   say "\nDirectory # $direcount: $curdir\n";
   my @paths = glob_regexp_utf8($curdir, 'F', $RegExp);
   for my $path (@paths)
   {
      next if ! is_data_file($path);
      curfile $path;
   }
   return 1;
} # end sub curdire ()

sub curfile ($)
{
   ++$filecount;
   my $cwd      = cwd_utf8;
   my $old_path = shift;
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

   if ($db)
   {
      print "\nIn sxt, in curfile(), near top. \n",
            "\$filecount = \"$filecount\". \n",
            "\$old_path  = \"$old_path\".  \n",
            "\$old_name  = \"$old_name\".  \n",
            "\$old_pref  = \"$old_pref\".  \n",
            "\$old_suff  = \"$old_suff\".  \n",
            "\$type      = \"$type\".      \n",
            "\$new_suff  = \"$new_suff\".  \n",
            "\$new_pref  = \"$new_pref\".  \n",
            "\$new_name  = \"$new_name\".  \n",
            "\$new_path  = \"$new_path\".  \n";
   }

   # If "checktype_filename" from CPAN module "File::Type" was unable to determine the type of this file,
   # resort to opening the file and searching the first 50 bytes for clues:
   if ($new_suff eq '.unk')
   {
      if ($db) {say 'In sxt, in curfile(), in if(unk), at top.';}
      if ( ( -s e $old_path ) < 50 )
      {
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

      if ( $bytes < 50 )
      {
         say "Warning: read fewer than 50 bytes from this file:";
         say "$old_name";
         say "Continuing with next file.";
         ++$frercount;
         return 0;
      }

      if ($buffer =~ m<Content-Type: application/javascript> 
       || $buffer =~ m<Content-Type: application/x-javascript>){$new_suff = '.js'  ;}# JS
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
             m<^/\*!CK:\d{8,10}!\*//\*\d{8,10},\*/>)           {$new_suff = '.fbc' ;}# FBC
      elsif (is_ascii($buffer))                                {$new_suff = '.txt' ;}# TXT
      elsif (is_iso_8859_1($buffer))                           {$new_suff = '.txt' ;}# TXT
      else                                                     {$new_suff = '.unk' ;}# unknown file type
      if ($db)
      {
         say "In sxt, in curfile, in if(unk), at bottom;";
         say "new suffix = \"$new_suff\".";
      }
   } # end if $new_suff eq '.unk'

   # If this file's type is STILL unknown, increment $unkncount:
   if ($new_suff eq '.unk')
   {
      ++$unkncount;
   }

   # Otherwise, increment $typecount:
   else
   {
      ++$typecount;
   }

   # Make new name and path:
   my $new_name = $new_pref . $new_suff;
   my $new_path = path($cwd, $new_name);

   # Bail if new same as old:
   if ($new_name eq $old_name)
   {
      ++$samecount; 
      return 1;
   }

   if ($db)
   {
      print "\nIn sxt, in curfile(), about to attempt rename. \n",
            "\$old_name  = \"$old_name\".  \n",
            "\$old_path  = \"$old_path\".  \n",
            "\$new_name  = \"$new_name\".  \n",
            "\$new_path  = \"$new_path\".  \n";
   }

   # Attempt rename:
   $success = rename_file($old_path, $new_path);
   if ($success)
   {
      ++$renacount;
      say "Renamed: \"$old_name\" => \"$new_name\"";
      return 1;
   }
   else
   {
      ++$failcount;
      say "Failed: \"$old_name\" => \"$new_name\"";
      return 0;
   }
} # end sub process_current_file ($)

sub stats ()
{
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
} # end sub stats ()

sub error ($)
{
   my $NA = shift;
   print STDERR "Error in \"$0\": This program takes 0 or 1 arguments,\n",
                "but you typed $NA. Help follows:\n\n";
   help;
   exit(666);
} # end sub error ($)

sub help ()
{
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
} # end sub help ()
