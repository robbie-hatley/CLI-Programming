#! /bin/awk -f 

# This is a 120-character-wide Unicode UTF-8 AWK-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

#Print html-document headers to stdout:
BEGIN {
   print("<html>")
   print("<head>")
   print("<title>Google Images</title>")
   print("</head>")
   print("<body>")
   print("<div><h1 style='text-align: center'>Google Images</h1></div>")
   print("<div>")
}

#Read each line of the input file that has an "http" in it:
/http/ {

   #Split line into array elements, using any question mark, ampersand,
   #space, or tab as a delimitor:
   split($0, Words, /[?&[:blank:]]/)
   
   #iterate through array elements, extracting all lines starting with
   #"imgurl=", removing the "imgurl=" from the beginning, formatting
   #the lines as html "img" elements, and printing them to stdout:
   
   for (i in Words)
   {
      if (match(Words[i], /^imgurl=/))
      {
         sub("imgurl=", "", Words[i]);
         printf("<img src=\"%s\" alt=\"image\" />\n", Words[i]);
      }
   }
}


#Print html-document footers to stdout:
END {
   print("</div>")
   print("</body>")
   print("</html>")
}
