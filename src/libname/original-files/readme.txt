Random Name Generator V1.0
Copyright (c) 1998, Nanosoft, Inc.

There is absolutely NO WARRANTY OF ANY KIND on this code.  Any loss of data,
sleep, memory, or sanity is NOT MY PROBLEM!

This code is provided free, with only a few restrictions:
        1 - IF YOU USE IT, YOU MUST CREDIT ME!!!!!!! (see below).
        2 - If you change the code, you must send me a copy of all
            modifications.
        3 - If you use the Random Name Generator for commercial use, you
            must send me a free licenced copy of your finished product.
            If you do so, you may consider the Random Name Generator to
            be registered for your use with that project.

All this means is that you must take the following (between cut lines)
and put it in a visible place in your documentation, and preferrably on
program load.  I reiterate: VISIBLE.

--------<cut here>--------
Random Name Generator V1.0 provided by Nanosoft, Inc.
-------<stop cutting>-----

Your cooperation is appreciated.  Enjoy the Random Name Generator.


=======================================================================
                  Now for the technical details:
=======================================================================
Compilation.
------------
        Simply type:

MAKE

        It really is as simple as that!

Usage.
------
        Before using the Random Name Generator, you should call srand to seed
the randomizer, as rand is used by the Random Name Generator internally.
        To use, simply #include <namegen.h> and link with -lname.  There is
only one function, getrandomname.  It uses malloc to allocate string storage
and returns a random name.  When you are finished with the name, call free
to release it.  That is all there is to it!


About Contacting Me.
--------------------
        If you use the Random Name Generator, drop me a line and let you know
what you think!  Questions and corrections are always welcome.


                                Luke Bishop (lbishop@calvin.stemnet.nf.ca)
                                CEO, Head Programmer, Nanosoft, Inc.

