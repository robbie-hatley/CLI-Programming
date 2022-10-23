
ALL= piglatin chef jive valspeak

all: $(ALL)

piglatin: piglatin.c
	$(CC) -o piglatin piglatin.c

.c: $*
	$(CC) -o $* $*.c -ll

.l.c: $*.l
	lex $*.l
	mv lex.yy.c $*.c

clean:	
	rm -f $(ALL)

clobber: clean
	rm -f chef.c jive.c valspeak.c

chef.c: chef.l
jive.c: jive.l
valspeak.c: valspeak.l



