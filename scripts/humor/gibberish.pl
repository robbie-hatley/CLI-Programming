#!/usr/bin/env -S perl -CSDA

# This is an 120-character-wide UTF-8-encoded Perl script source-code text file.
# ¡Hablo Español!  Говорю Русский.  Björt skjöldur.  麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# /rhe/scripts/util/gibberish.pl
# "gibberish.pl n m" prints n rows by m columns of semi-random gibberish.
# Edit history:
#    Wed Jul 15, 2015 - Wrote it.
#    Fri Jul 17, 2015 - Upgraded for utf8.
#    Sat Mar 26, 2016 - Removed spaces and randomized rows & columns.
#    Sat Apr 02, 2016 - Added in some Kanji characters and Kanji spaces.
#                       Also provided a way to make rows and columns
#                       independently fixed-or-random.
#    Sat Apr 16, 2016 - Now using -CSDA.
#    Mon Dec 18, 2017 - Fixed bug which was preventing '。' from appearing.
#    Wed Dec 20, 2017 - Moved extract_digits to RH::Util; improved comments.
########################################################################################################################

use v5.32;
use strict;
use warnings;
use warnings FATAL => "utf8";
use utf8;

use RH::Util;

# ======= SUBROUTINE PRE-DECLARATIONS: ===============================

sub process_argv        ();
sub rand_txt            ();
sub print_help_message  ();

# ======= VARIABLES: =================================================

# Settings:     # Meaning of setting:   Possible values:
my $Rows = 0;   # Number of rows.       (non-negative integer)
my $Cols = 0;   # Number of columns.    (non-negative integer)

# ======= MAIN BODY OF PROGRAM: ======================================

{ # begin main
   # Process @ARGV:
   process_argv();

   # Print some random gibberish:
   rand_txt;

   # We be done, so scram:
   exit 0;
} # end main

# ======= SUBROUTINE DEFINITIONS: ====================================

sub process_argv ()
{
   my $help   = 0;  # Just print help and exit?
   my @CLArgs = (); # Command-Line Arguments (not including options).

   # Get and process options and arguments.
   # An "option" is "-a" where "a" is any single alphanumeric character,
   # or "--b" where "b" is any cluster of 2-or-more printable characters.
   foreach (@ARGV)
   {
      if (/^-[\pL\pN]{1}$/ || /^--[\pL\pM\pN\pP\pS]{2,}$/)
      {
         /^-h$/ || /^--help$/ and $help = 1 ;
      }
      else
      {
         push @CLArgs, $_;
      }
   }
   if ($help) {help(); exit(777);} # If user wants help, print help and exit.
   if (@CLArgs >= 1) {$Rows = extract_digits($CLArgs[0]);}
   if (@CLArgs >= 2) {$Cols = extract_digits($CLArgs[1]);}
   return 1;
} # end sub process_argv

sub rand_txt ()
{
   my $rows;
   my $rcoerced = '';
   if ($Rows > 0)                  # If user specified number of rows,
   {
      $rows = $Rows;               # use specified number;
      if ($rows > 50)              # but if number is > 50,
      {
         $rows = 50;               # set it to 50.
         $rcoerced = ' (coerced)';
      }
      else
      {
         $rcoerced = ' (user)';
      }

   }
   else                            # Otherwise,
   {
      $rows = rand_int(10,20);     # Use random number of rows from 10 to 20.
      $rcoerced = ' (automatic)';
   }
   say "Rows = $rows$rcoerced";

   my $cols;
   my $ccoerced = '';
   if ($Cols > 0)                  # If user specified number of cols,
   {
      $cols = $Cols;               # use specified number;
      if ($cols > 2000)            # but if number is >2000,
      {
         $cols = 2000;             # set it to 2000.
         $ccoerced = ' (coerced)';
      }
      else
      {
         $ccoerced = ' (user)';
      }
   }
   else                            # Otherwise,
   {
      $cols = rand_int(35,70);     # Use random number of cols from 35 to 70.
      $ccoerced = ' (automatic)';
   }
   say "Cols = $cols$ccoerced";

   my $chars =
   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
   'abcdefghijklmnopqrstuvwxyz'.
   'abcdefghijklmnopqrstuvwxyz'.
   'ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞ'.
   'ßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ'.
   'ßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿ'.
   'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ'.
   'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'.
   'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'.
   '贚婃鯼覉脃特縋潡畴兾坈燥炑箃曕嬣裹俛鱱茚恗誫蚍蕜玔'.
   '耏鷠旭彥募巰欛氹粸邓翶娰卤悮粨譄裶埁猽懳堑嚰尜刌浒'.
   '累慻蚧鹕粯彯呿浠魼睭嚢漡潢鰜俞槮砏踃婨足牞勔貲髯蜰'.
   '粇跏躨擗袆骐恓篔巑憺魉想琘忒瓐甯甬鵠混樘旅慍峲蒞剐卐'.
   '山山川川茶茶茶茶茶金金金人猫猫猫狗猪牛日本日本'.
   '☺♪♫♭♮♯☺♪♫♭♮♯☺♪♫♭♮♯'.
   '☿♀♁♂♃♄♅♆♇☿♀♁♂♃♄♅♆♇'.
   ' ' x 5 .
   '。' x 5;
   for my $r (1..$rows)
   {
      for my $c (1..$cols)
      {
         my $nextchar = substr $chars, int rand length $chars, 1;
         if ($r == $rows && $c == $cols) {print("。")}
         else {print("$nextchar");}
      }
      print("\n");
      if ($cols > 79) {print("\n");}
   }
   return 1;
} # end sub rand_txt

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "gibberish.pl", Robbie Hatley's gibberish-printing Utility.
   This program x lines of y characters each of gibberish (where x and y
   are either the first and second command-line arguments, or semi-random values
   generated by this script if no arguments are given).

   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   DESCRIPTION OF OPTIONS:

   Command line to get this help:
   gibberish.pl [-h|--help]

   All options (arguments starting with '-') other than -h and --help
   will be ignored.

   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   DESCRIPTION OF ARGUMENTS:

   Command line to print gibberish:
   gibberish.pl arg1 arg2

   Description of arguments:
   arg1 = number of rows     (max= 50 ; use 0 or skip for random)
   arg2 = number of columns  (max=2000; use 0 or skip for random)

   If arg1 is 0 or non-numeric or missing, a random number of rows in the
   10-20 range will be printed. If arg1 is > 50, 50 rows will be printed.

   If arg2 is 0 or non-numeric or missing, a random number of columns in the
   35-70 range will be printed. If arg2 is > 2000, 2000 columns will be printed.

   Any argument containing non-digit characters will have its non-digit characters
   stripped out. dkk9s3 will be treated as 93. xnv0tg will be treated as 0.
   'She sells sea shells!' will be treated as 0. -7 will be treated as 7.

   Any arguments beyond the first 2 are simply ignored.

   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   NOTES ON WORD WRAPPING AND PARAGRAPH BREAKS:

   If arg2 is greater than 79, free-form mode will be assumed, and double
   endlines will be printed after each group of arg2 characters.

   For fixed line lengths, I recommed setting arg2 to about 70 so as to avoid
   word-wrapping in command consoles, text editors, etc.

   For free-form paragraphs (wrapping over multiple lines and using the endline
   character as an "end of paragraph mark" instead of as an "end of line mark"),
   I suggest setting arg2 to about 250.

   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   USAGE EXAMPLES:

   gibberish.pl 18 65        # prints 18 rows, 65 cols wide, of gibberish
   gibberish.pl 5 rndm       # prints 5 random-length rows of gibberish
   gibberish.pl 5            # prints 5 random-length rows of gibberish
   gibberish.pl a 17         # prints random number of rows, 17 columns wide
   gibberish.pl 0 0          # rows=random, cols=random
   gibberish.pl asdf         # rows=random, cols=random
   gibberish.pl              # rows=random, cols=random

   Cheers,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help
