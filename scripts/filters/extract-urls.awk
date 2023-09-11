#!/usr/bin/awk -f

# This is a 120-character-wide Unicode UTF-8 AWK-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# extract-urls.awk
# Extracts urls from a file.

# For each line of the input file which contains "http":
/http/ {

   # Split the line into words delimited by spaces or URL-illegal chars.:
   split($0, Words, /[[:blank:]<>\(\)\{\}\\^~\]\[`'"]/)

   # For each word, print only the URL part (if any), on it's own line:
   for (i in Words)
   {
      if (match(Words[i], /s?https?:\/\/[[:graph:]]+/))
      {
         print(substr(Words[i], RSTART, RLENGTH))
      }
   }
}
