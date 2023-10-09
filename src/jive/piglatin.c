/************************************************************************************************************\
 * file name:  "piglatin.c"
 * source for: "piglatin" or "piglatin.exe"
 * Copyright:  1992 & 1993, The Regents of the University of California. (Lots more legal gobbledygook elided
 *             here; just murder me now be the fuck done with it instead of making me read all that shit.)
 * To make:    Does use "sys/types.h" and "unistd.h", so to make this, you'll need a system that has those.
 * Editor:     This version updated and edited on Sun Oct 8 2023 by Robbie Hatley.
\************************************************************************************************************/

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/types.h>
#include <unistd.h>

int   main    ( int argc, char* argv[] );
void  pigout  ( char* buf, int len     );
void  usage   ( void                   );

int main(int argc, char* argv[]) {
    int   len;
    char  ch;
    char  buf[1024];

    while ((ch = (char)getopt(argc, argv, "")) != EOF)
        switch (ch) {
        case '?':
        default:
            usage();
        }
    argc -= optind;
    argv += optind;

    for (len = 0; (ch = (char)getchar()) != EOF;) {
        if (isalpha(ch)) {
            if (len >= sizeof(buf)) {
                (void)fprintf(stderr, "pig: ate too much!\n");
                exit(1);
            }
            buf[len++] = ch;
            continue;
        }
        if (len != 0) {
            pigout(buf, len);
            len = 0;
        }
        (void)putchar(ch);
    }
    return 0;
}

void pigout (char* buf, int len) {
    int  ch, start;
    int  olen;

    /*
     * If the word starts with a vowel, append "way".  Don't treat 'y'
     * as a vowel if it appears first.
     */
    if (strchr("aeiouAEIOU", buf[0]) != NULL) {
        (void)printf("%.*sway", len, buf);
        return;
    }

    /*
     * Copy leading consonants to the end of the word.  The unit "qu"
     * isn't treated as a vowel.
     */
    for (start = 0, olen = len;
         !strchr("aeiouyAEIOUY", buf[start]) && start < olen;) {
        ch = buf[len++] = buf[start++];
        if ((ch == 'q' || ch == 'Q') && start < olen && (buf[start] == 'u' || buf[start] == 'U'))
            buf[len++] = buf[start++];
    }
    (void)printf("%.*say", olen, buf + start);
    return;
}

void usage (void) {
    (void)fprintf(stderr, "usage: pig\n");
    exit(1);
}
