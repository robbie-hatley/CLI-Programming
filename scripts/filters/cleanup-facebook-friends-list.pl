#! /bin/perl -CSDA

# This is a 120-character-wide Unicode UTF-8 Perl-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

########################################################################################################################
# cleanup-facebook-friends-list.pl
# Cleans up raw Facebook friends-list files.
#
# Written by Robbie Hatley on Monday April 14, 2015.
#
# Edit history:
# Mon Apr 14, 2015: Wrote it.
# Fri Jul 17, 2015: Upgraded for utf8.
# Thu Mar 10, 2016: Cleaned up a few things.
# Sat Apr 16, 2016: Now using -CSDA.
# Tue Nov 09, 2021: Refreshed shebang, colophon, and boilerplate.
# Wed Dec 08, 2021: Reformatted titlecard.
########################################################################################################################

use v5.32;
use common::sense;
use Sys::Binmode;
use Unicode::Collate;
use RH::WinChomp;

# main
{
   my @unsorted;
   my @sorted;

   # Input and process text, reject some lines, clean and store others:
   LINE: while (<>)
   {
      # Remove BOM (if any) from beginning of current line:
      remove_bom;

      # Remove endline from end of current line:
      winchomp;

      # Remove any vertical whitespace anywhere on current line:
      s/\v//g;

      # Remove any horizontal whitespace from end of current line:
      s/\s+$//;

      # Skip current line if it doesn't start with 4 or 8 spaces,
      # followed by 1 or more non-space characters:
      next LINE if !(m/^ {4}\S/ || m/^ {8}\S/);

      # Lines which start with 8 spaces are workplaces or homelands,
      # so append these to previous line, after changing spaces to ', ',
      # or skip if no previous,:
      if (m/^ {8}\S+/)
      {
         if (scalar(@unsorted) > 0)
         {
            s/^ {8}/, /;
            my $previous = pop(@unsorted);
            $previous .= $_;
            push @unsorted, $previous;
         }
         else
         {
            warn 
               "Discarding this \"homeland\" / \"workplace\" line,\n".
               "because there is no previous line to append it to:\n".
               "$_\n";
         }
         next LINE;
      }

      # If we get here, this line was not a "workplace" or "homeland" line,
      # so we can get rid of any remaining leading whitespace:
      s/^\s+//;

      # Remaining lines should now all be one of the following 7 forms:

      # Friend
      # Close Friend
      # Friends
      # 1 friend
      # 713 friends
      # 12 mutual friends
      # Ian Baltazar

      # Lets skip this line if it's anything but a friend name:
      next LINE if m/^Friend$/;
      next LINE if m/^Close Friend$/;
      next LINE if m/^Friends$/;
      next LINE if m/^[\d,]+ friends$/;
      next LINE if m/^1 friend$/;
      next LINE if m/^[\d,]+ mutual friends$/;

      # If we get to here, lets assume this line is a friend name
      # and push it onto the right end of our array of unsorted names:
      push @unsorted, $_;
   }

   # Make collator:
   my $collator = Unicode::Collate->new();

   # Sort array:
   @sorted = $collator->sort(@unsorted);

   # Print result:
   say for @sorted;

   # We be done, so scram:
   exit 0;
} # end main
