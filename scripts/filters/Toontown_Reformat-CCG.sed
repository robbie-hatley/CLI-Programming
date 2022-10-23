#! /bin/sed -f 

# This is a 120-character-wide Unicode UTF-8 sed-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

/^V\.P\./{
   s/^V\.P\./VP /
}
/^C\.J\./{
   s/^C\.J\./CJ /
}
s/\.\.\.\./    /g
s/ \.\.\. /    /g
s/\.\.\./    /g
s/\.//
s/ET.*PT/PT/g
s/it    PT/it   PT/
s/ay    PT/ay      PT/
s/rt    PT/rt       PT/
s/am    PT/am        PT/
s/GMT.*$//
s/PT :/PT:/
s/ *$//
s/ *am$/am/
s/ *pm$/pm/
s/NOON/12:00pm/
