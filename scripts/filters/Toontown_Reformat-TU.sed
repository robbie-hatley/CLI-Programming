#! /bin/sed -f 

# This is a 120-character-wide Unicode UTF-8 sed-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

/^VP:/{
   s/^VP:/VP :/
}
/^CJ:/{
   s/^CJ:/CJ :/
}
s/^ //g
s/ $//g
s/: .*Mountain ~ /: /
s/: \([[:digit:]]\):/:  \1:/
s/Pacific.*GMT$/Pacific/
s/ NOON/pm/
