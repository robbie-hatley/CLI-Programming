#! /bin/sed -f 

# This is a 120-character-wide Unicode UTF-8 sed-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

#free-form.sed

#Converts text file with fixed-line lines (usually 60-80 chars) and a
#newline character at the end of every line, into "free-form" text files with
#newline characters only at the ends of paragraphs.

#Slurp the entire file into the pattern space:
:top
$!{
   N
   b top
}

#Turn any oddball control characters into newlines:
s/\r/\n/g
s/\v/\n/g
s/\f/\n\n/g

#Get rid of any leading blanks (spaces or tabs) at the beginning of the pattern space:
s/^[[:blank:]]\+//

#Get rid of any trailing blanks at the end of the pattern space:
s/[[:blank:]]\+$//

#Get rid of any blanks before or after newlines:
s/[[:blank:]]*\n[[:blank:]]*/\n/g

#Consolidate any mid-line multiple spaces (due to proportional spacing) 
#to single spaces:
s/  \+/ /g

#Close-up line-end hyphens:
s/\([[:graph:]]\)-\n/\1-/g

#Open-out line-end dashes:
s/\([[:graph:]]\) -\n/\1 - /g

#Turn any double newlines into temporary paragraph markers:
s/\n\n/<PARAGRAPH>/g

#Convert each remaining newline into a single space:
s/\n/ /g

#Finally, convert paragraph markers into (space-newline) pairs:
s/<PARAGRAPH>/ \n \n/g
