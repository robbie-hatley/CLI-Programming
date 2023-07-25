#! /bin/sed -nf 

# This is a 120-character-wide Unicode UTF-8 sed-source-code text file with hard Unix line breaks ("\x0A").
# ¡Hablo Español! Говорю Русский. Björt skjöldur. ॐ नमो भगवते वासुदेवाय.    看的星星，知道你是爱。 麦藁雪、富士川町、山梨県。
# =======|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|=========|

# Print only lines which consist purely of graphical (glyphical, visible) characters:
/^[[:graph:]]\+$/p
