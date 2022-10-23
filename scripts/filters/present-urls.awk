#! /bin/awk -f 

# This is a 120-character-wide Unicode UTF-8 AWK-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

#present-urls.awk
#This script creates a new HTML file.  It begins the file with a header block,
#then it starts reading its input file.  For each line of the input file,
#if the line does NOT contain "http", the whole line is printed to the HTML
#file unexpurgated.  If the line DOES contain "http", any valid urls are
#extracted, and each such valid url is written to the HTML file on its own 
#line, formatted as a hyperlink.  When the script finishes reading the input 
#file, it prints a footer block to the HTML file, writes and closes the HTML
#file, and exits.


#Print html-document headers to stdout:
BEGIN {
   print("<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>")
   print("<!DOCTYPE html ")
   print("     PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"")
   print("     \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">")
   print("")
   print("<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">")
   print("")
   print("<head>")
   print("")
   print("<meta http-equiv=\"Content-Type\" content=\"text/html;charset=iso-8859-1\" />")
   print("<meta http-equiv=\"Content-Style-Type\" content=\"text/css\" />")
   print("")
   print("<link href=\"main.css\"   rel=\"stylesheet\" type=\"text/css\" />")
   print("<link href=\"brown.css\"  rel=\"stylesheet\" type=\"text/css\" />")
   print("")
   print("<title></title>")
   print("")
   print("</head>")
   print("")
   print("<body style = \"background-image: url(tan-paper.jpg); ")
   print("               background-attachment: scroll\">")
   print("")
   print("<div id=\"main-division\">")
}

#Now we enter the main loop.  The commands from here to END are executed
#for each line of the input file.

#If the current line of the input file that does NOT have an "http" in it,
#print it in an HMTL "p" element:
!/http/ {
   printf("%s%s%s\n", "<p>", $0, "</p>");
}

#If the current line of the input file that DOES have an "http" in it,
#print each URL as an HTML "a" element on its own line, ending with "<br />":
/http/ {
   
   #Split the line into words delimited by spaces or URL-illegal chars.:
   split($0, Words, /[[:blank:]<>\(\)\{\}\\^~\]\[`'"]/)
   
   #iterate through array elements, extracting all URLs and formatting
   #them as http hyperlinks and printing them to stdout as we go:
   for (i in Words)
   {
      if (match(Words[i], /s?https?:\/\/[[:graph:]]+/))
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
