#!/usr/bin/env -S perl -CSDA

# This is a 120-character-wide UTF-8-encoded Perl source-code text file with hard Unix line breaks ("\x{0A}").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# erase-small-images.pl
# Erases all images in current directory only which have height or width less than 201px.
# (Ignores all files that aren't pictures.)
#
# Written by Robbie Hatley.
#
# Edit history:
# Fri Nov 19, 2021: Refreshed shebang, colophon, titlecard, and boilerplate. Corrected Unicode issues.
# Sat Nov 20, 2021: Now using "common::sense" and "Sys::Binmode".
# Thu Nov 25, 2021: Added help, and put main body of program in a block.
# Sun Dec 25, 2022: Corrected comments and changed min size from 175x175 to 201x201.
########################################################################################################################

use v5.36;
use common::sense;
use Sys::Binmode;

use File::Type;
use Image::Size;

use RH::Dir;

sub help ();

{ # begin main
   if (@ARGV > 0 && ($ARGV[0] eq '-h' || $ARGV[0] eq '--help')) {help;exit(777);}
   my $typer = File::Type->new();
   my $curdir = cwd_utf8;                                    # MUST encode here
   my @paths = glob_regexp_utf8($curdir, 'F');               # MUST encode here
   foreach my $path (@paths)
   {
      # Skip this file if it's not an image file:
      next if $typer->checktype_filename($path) !~ m/image/; # NO need to encode here

      # Get image width and height:
      my ($x, $y) = imgsize($path);                          # NO need to encode here

      # Erase if width or height is under 201 pixels (seeing as how, in 2022, many thumbnails are 200x200):
      if ($x < 201 || $y < 201)
      {
         say "Erasing \"$path\" ($x x $y)";
         unlink_utf8 $path;                                  # MUST encode here
      }
   }
   exit 0;
} # end main

sub help ()
{
   print ((<<'   END_OF_HELP') =~ s/^   //gmr);
   Welcome to "erase-small-images.pl". This program erases all image files in the
   current directory which have width or height less than 201 pixels.
   Other than "-h" or "--help" (which cause this program to print this help then
   exit), all options and arguments are ignored.

   Happy small image erasing!
   Cheer,
   Robbie Hatley,
   programmer.
   END_OF_HELP
   return 1;
} # end sub help ()

