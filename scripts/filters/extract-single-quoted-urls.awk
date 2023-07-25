#! /bin/awk -f 

# This is a 120-character-wide Unicode UTF-8 AWK-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

/http/ {
   n = split($0, Words, /'/)
   for (i=1; i<=n; ++i)
   {
      if (match(Words[i], /http/))
      {
         print Words[i]
      }
   }
}
