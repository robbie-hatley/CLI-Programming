#!/usr/bin/awk -f
# /rhe/scripts/util/present-jpg-urls.awk

# This is a 120-character-wide Unicode UTF-8 AWK-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# NOTE: This script isn't very useful, being halfway in between
# "present-urls" (presents all hyperlinks from a document,
# one link per line), and "present-jpg-images", which not only
# extracts jpg links (as this script does) but presents them as
# HTML "img" elements, so that the actual images will autoload
# when the html file is loaded in a browser.

# Print html-document headers to stdout:
BEGIN {
   print("<html>")
   print("<head>")
   print("<title>URLs</title>")
   print("</head>")
   print("<body>")
   print("<div><h1 style=\"text-align: center\">URLs</h1></div>")
   print("<div>")
}

# Read each line of the input file that has an "http://" in it:
/http/ {

   #Split the line into words delimited by spaces or URL-illegal chars.:
   split($0, Words, /[[:blank:]<>\(\)\{\}\\^~\]\[`'"]/)

   #iterate through array elements, extracting all URLs and formatting
   #them as http hyperlinks and printing them to stdout as we go:
   for (i in Words)
   {
      if (match(Words[i], /s?https?:\/\/[[:graph:]]+\.[jJ][pP][gG]/))
      {
         Extract = substr(Words[i], RSTART, RLENGTH)
         printf("<a href=\"%s\">%s</a><br />\n", Extract, Extract);
      }
   }
}

#print html-document footers to stdout:
END {
   print("</div>")
   print("</body>")
   print("</html>")
}
