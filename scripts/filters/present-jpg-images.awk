#!/usr/bin/awk -f
# /rhe/scripts/util/present-jpg-images.awk

# This is a 120-character-wide Unicode UTF-8 AWK-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# Main template for various "present-xxxxx-jpg-images.awk" scripts.
# Extracts all URLs (any site) for single JPG images (not folders,
# galleries, or albums), and writes the found URLS to an HTML file as
# img elements, so that the actual images themselves will autoload into
# the page when it is loaded into a browser.

# Print html-document headers to stdout:
BEGIN {
   print("<html>")
   print("<!-- This file is roughly compliant with HTML 4.01. -->")
   print("<!-- This is NOT an xhtml-compliant file.           -->")
   print("<head>")
   print("<title>Jpeg Images</title>")
   print("</head>")
   print("<body>")
   print("<div><h1 style=\"text-align: center\">Jpeg Images</h1></div>")
   print("<div>")
}

# Read each line of the input file that has an "http" in it:
/http/ {

   # Split the line into words delimited by spaces or URL-illegal chars.:
   split($0, Words, /[[:blank:]<>\(\)\{\}\\^~\]\[`'"]/)

   # Iterate through array elements, extracting all URLs, regardless
   # of website, and formatting them as src attributes of img elements
   # and printing them to stdout as we go:
   for (i in Words)
   {
      if (match(Words[i], /s?https?:\/\/[[:graph:]]+\.[jJ][pP][gG]/))
      {
         JPG_URL = substr(Words[i], RSTART, RLENGTH)
         printf("<img src=\"%s\"><br>\n", JPG_URL);
      }
   }
}

# Print html-document footers to stdout:
END {
   print("</div>")
   print("</body>")
   print("</html>")
}
