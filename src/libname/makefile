all : /usr/include/namegen.h /usr/lib/libname.a
/usr/include/namegen.h: namegen.h
	cp namegen.h /usr/include/namegen.h
/usr/lib/libname.a : namegen.o usename.o
	ar -rU /usr/lib/libname.a namegen.o usename.o
	rm namegen.o
	rm usename.o
namegen.o : namegen.c
	gcc -std=gnu11 -Wall -pedantic -c namegen.c -O2
usename.o : usename.c
	gcc -std=gnu11 -Wall -pedantic -c usename.c -O2
