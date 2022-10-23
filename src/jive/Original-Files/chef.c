#include <stdio.h>
# define U(x) x
# define NLSTATE yyprevious=YYNEWLINE
# define BEGIN yybgin = yysvec + 1 +
# define INITIAL 0
# define YYLERR yysvec
# define YYSTATE (yyestate-yysvec-1)
# define YYOPTIM 1
# define YYLMAX BUFSIZ
#ifndef __cplusplus
# define output(c) (void)putc(c,yyout)
#else
# define lex_output(c) (void)putc(c,yyout)
#endif

#if defined(__cplusplus) || defined(__STDC__)

#if defined(__cplusplus) && defined(__EXTERN_C__)
extern "C" {
#endif
	int yyback(int *, int);
	int yyinput(void);
	int yylook(void);
	void yyoutput(int);
	int yyracc(int);
	int yyreject(void);
	void yyunput(int);
	int yylex(void);
#ifdef YYLEX_E
	void yywoutput(wchar_t);
	wchar_t yywinput(void);
#endif
#ifndef yyless
	int yyless(int);
#endif
#ifndef yywrap
	int yywrap(void);
#endif
#ifdef LEXDEBUG
	void allprint(char);
	void sprint(char *);
#endif
#if defined(__cplusplus) && defined(__EXTERN_C__)
}
#endif

#ifdef __cplusplus
extern "C" {
#endif
	void exit(int);
#ifdef __cplusplus
}
#endif

#endif
# define unput(c) {yytchar= (c);if(yytchar=='\n')yylineno--;*yysptr++=yytchar;}
# define yymore() (yymorfg=1)
#ifndef __cplusplus
# define input() (((yytchar=yysptr>yysbuf?U(*--yysptr):getc(yyin))==10?(yylineno++,yytchar):yytchar)==EOF?0:yytchar)
#else
# define lex_input() (((yytchar=yysptr>yysbuf?U(*--yysptr):getc(yyin))==10?(yylineno++,yytchar):yytchar)==EOF?0:yytchar)
#endif
#define ECHO fprintf(yyout, "%s",yytext)
# define REJECT { nstr = yyreject(); goto yyfussy;}
int yyleng;
char yytext[YYLMAX];
int yymorfg;
extern char *yysptr, yysbuf[];
int yytchar;
FILE *yyin = {stdin}, *yyout = {stdout};
extern int yylineno;
struct yysvf { 
	struct yywork *yystoff;
	struct yysvf *yyother;
	int *yystops;};
struct yysvf *yyestate;
extern struct yysvf yysvec[], *yybgin;

# line 3 "chef.l"
/* chef.x - convert English on stdin to Mock Swedish on stdout
 *
 * The WC definition matches any word character, and the NW definition matches
 * any non-word character.  Two start conditions are maintained: INW (in word)
 * and NIW (not in word).  The first rule passes TeX commands without change.
 *
 * HISTORY
 *
 * Apr 26, 1993; John Hagerman: Added ! and ? to the Bork Bork Bork rule.
 *
 * Apr 15, 1992; John Hagerman: Created.
 */

static int i_seen = 0;
# define INW 2
# define NIW 4
# define YYNEWLINE 10
yylex(){
int nstr; extern int yyprevious;
#ifdef __cplusplus
/* to avoid CC and lint complaining yyfussy not being used ...*/
static int __lex_hack = 0;
if (__lex_hack) goto yyfussy;
#endif
while((nstr = yylook()) >= 0)
yyfussy: switch(nstr){
case 0:
if(yywrap()) return(0); break;
case 1:

# line 25 "chef.l"
ECHO;
break;
case 2:

# line 27 "chef.l"
	{ BEGIN NIW; i_seen = 0; ECHO; }
break;
case 3:

# line 28 "chef.l"
	{ BEGIN NIW; i_seen = 0;
		  printf("%c\nBork Bork Bork!",yytext[0]); }
break;
case 4:

# line 31 "chef.l"
ECHO;
break;
case 5:

# line 32 "chef.l"
ECHO;
break;
case 6:

# line 34 "chef.l"
	{ BEGIN INW; printf("un"); }
break;
case 7:

# line 35 "chef.l"
	{ BEGIN INW; printf("Un"); }
break;
case 8:

# line 36 "chef.l"
	{ BEGIN INW; printf("oo"); }
break;
case 9:

# line 37 "chef.l"
	{ BEGIN INW; printf("Oo"); }
break;
case 10:

# line 38 "chef.l"
{ BEGIN INW; printf("e"); }
break;
case 11:

# line 39 "chef.l"
{ BEGIN INW; printf("E"); }
break;
case 12:

# line 40 "chef.l"
{ BEGIN INW; printf("ee"); }
break;
case 13:

# line 41 "chef.l"
{ BEGIN INW; printf("oo"); }
break;
case 14:

# line 42 "chef.l"
{ BEGIN INW; printf("e-a"); }
break;
case 15:

# line 43 "chef.l"
{ BEGIN INW; printf("i"); }
break;
case 16:

# line 44 "chef.l"
{ BEGIN INW; printf("I"); }
break;
case 17:

# line 45 "chef.l"
{ BEGIN INW; printf("ff"); }
break;
case 18:

# line 46 "chef.l"
{ BEGIN INW; printf("ur"); }
break;
case 19:

# line 47 "chef.l"
{ BEGIN INW; printf(i_seen++ ? "i" : "ee"); }
break;
case 20:

# line 48 "chef.l"
{ BEGIN INW; printf("oo"); }
break;
case 21:

# line 49 "chef.l"
{ BEGIN INW; printf("oo"); }
break;
case 22:

# line 50 "chef.l"
{ BEGIN INW; printf("Oo"); }
break;
case 23:

# line 51 "chef.l"
{ BEGIN INW; printf("u"); }
break;
case 24:

# line 52 "chef.l"
	{ BEGIN INW; printf("zee"); }
break;
case 25:

# line 53 "chef.l"
	{ BEGIN INW; printf("Zee"); }
break;
case 26:

# line 54 "chef.l"
{ BEGIN INW; printf("t"); }
break;
case 27:

# line 55 "chef.l"
{ BEGIN INW; printf("shun"); }
break;
case 28:

# line 56 "chef.l"
{ BEGIN INW; printf("oo"); }
break;
case 29:

# line 57 "chef.l"
{ BEGIN INW; printf("Oo"); }
break;
case 30:

# line 58 "chef.l"
	{ BEGIN INW; printf("f"); }
break;
case 31:

# line 59 "chef.l"
	{ BEGIN INW; printf("F"); }
break;
case 32:

# line 60 "chef.l"
	{ BEGIN INW; printf("v"); }
break;
case 33:

# line 61 "chef.l"
	{ BEGIN INW; printf("V"); }
break;
case 34:

# line 63 "chef.l"
	{ BEGIN INW; ECHO; }
break;
case -1:
break;
default:
(void)fprintf(yyout,"bad switch yylook %d",nstr);
} return(0); }
/* end of yylex */
int yyvstop[] = {
0,

2,
34,
0,

2,
0,

2,
34,
-3,
0,

34,
0,

34,
-11,
0,

34,
0,

31,
34,
0,

33,
34,
0,

2,
34,
0,

34,
-10,
0,

34,
0,

34,
0,

30,
34,
0,

32,
34,
0,

29,
34,
0,

34,
-14,
0,

17,
34,
0,

19,
34,
0,

23,
34,
0,

34,
0,

28,
34,
0,

34,
0,

16,
34,
0,

22,
34,
0,

34,
0,

15,
34,
0,

21,
34,
0,

3,
0,

11,
0,

7,
11,
0,

9,
11,
0,

1,
0,

10,
0,

6,
10,
0,

8,
10,
0,

-12,
0,

-26,
0,

14,
0,

13,
0,

18,
0,

20,
0,

25,
0,

12,
0,

26,
0,

24,
0,

27,
0,

-5,
0,

-4,
0,

5,
0,

4,
0,
0};
# define YYTYPE unsigned char
struct yywork { YYTYPE verify, advance; } yycrank[] = {
0,0,	0,0,	1,7,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	1,8,	
9,34,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
15,39,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	15,0,	0,0,	39,0,	
0,0,	1,7,	1,9,	0,0,	
0,0,	0,0,	0,0,	0,0,	
1,10,	0,0,	0,0,	0,0,	
0,0,	0,0,	3,7,	0,0,	
0,0,	0,0,	0,0,	15,0,	
15,39,	39,0,	0,0,	3,8,	
0,0,	0,0,	15,39,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	1,11,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	2,11,	0,0,	0,0,	
0,0,	3,7,	3,9,	0,0,	
0,0,	0,0,	0,0,	0,0,	
3,10,	1,12,	0,0,	1,13,	
1,14,	0,0,	0,0,	0,0,	
2,12,	1,15,	2,13,	2,14,	
0,0,	0,0,	1,16,	0,0,	
2,15,	0,0,	1,17,	0,0,	
0,0,	2,16,	0,0,	0,0,	
0,0,	2,17,	3,11,	0,0,	
0,0,	5,7,	0,0,	0,0,	
0,0,	1,18,	0,0,	1,19,	
1,20,	38,52,	5,8,	12,38,	
2,18,	18,44,	2,19,	2,20,	
57,60,	3,12,	3,21,	3,13,	
3,14,	4,11,	17,43,	24,47,	
28,50,	3,15,	25,48,	26,44,	
26,49,	31,51,	3,16,	49,56,	
5,7,	5,9,	3,22,	3,23,	
50,57,	51,58,	3,24,	5,10,	
4,12,	4,21,	4,13,	4,14,	
3,25,	56,59,	58,61,	0,0,	
4,15,	3,26,	3,27,	3,19,	
3,20,	4,16,	0,0,	0,0,	
0,0,	4,22,	4,23,	0,0,	
0,0,	4,24,	0,0,	0,0,	
0,0,	5,11,	5,28,	4,25,	
0,0,	5,29,	0,0,	0,0,	
4,26,	4,27,	4,19,	4,20,	
0,0,	0,0,	0,0,	5,30,	
0,0,	6,11,	6,28,	0,0,	
5,12,	6,29,	5,13,	5,14,	
0,0,	0,0,	0,0,	0,0,	
5,15,	0,0,	0,0,	6,30,	
0,0,	5,16,	5,31,	0,0,	
6,12,	5,32,	6,13,	6,14,	
0,0,	0,0,	0,0,	0,0,	
6,15,	0,0,	11,35,	5,33,	
0,0,	6,16,	6,31,	0,0,	
5,18,	6,32,	5,19,	5,20,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	6,33,	
0,0,	0,0,	0,0,	0,0,	
6,18,	0,0,	6,19,	6,20,	
11,35,	11,35,	11,35,	11,35,	
11,35,	11,35,	11,35,	11,35,	
11,35,	11,35,	11,35,	11,35,	
11,35,	11,35,	11,35,	11,35,	
11,35,	11,35,	11,35,	11,35,	
11,35,	11,35,	11,35,	11,35,	
11,35,	11,35,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
11,35,	11,35,	11,35,	11,35,	
11,35,	11,35,	11,35,	11,35,	
11,35,	11,35,	11,35,	11,35,	
11,35,	11,36,	11,35,	11,35,	
11,35,	11,35,	11,35,	11,35,	
11,37,	11,35,	11,35,	11,35,	
11,35,	11,35,	16,40,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
16,40,	16,40,	16,40,	16,40,	
16,40,	16,40,	16,40,	16,40,	
16,40,	16,40,	16,40,	16,40,	
16,40,	16,40,	16,40,	16,40,	
16,40,	16,40,	16,40,	16,40,	
16,40,	16,40,	16,40,	16,40,	
16,40,	16,40,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
16,40,	16,40,	16,40,	16,40,	
16,40,	16,40,	16,40,	16,40,	
16,40,	16,40,	16,40,	16,40,	
16,40,	16,41,	16,40,	16,40,	
16,40,	16,40,	16,40,	16,40,	
16,42,	16,40,	16,40,	16,40,	
16,40,	16,40,	22,45,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	22,45,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	22,45,	22,45,	0,0,	
0,0,	0,0,	0,0,	0,0,	
22,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	22,0,	22,0,	
22,0,	22,0,	22,0,	22,0,	
22,0,	22,0,	22,0,	22,0,	
22,0,	22,0,	22,0,	22,0,	
22,0,	22,0,	22,0,	22,0,	
22,0,	22,0,	22,0,	22,0,	
22,0,	22,0,	22,0,	22,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	22,0,	22,0,	
22,0,	22,0,	22,0,	22,0,	
22,0,	22,0,	22,0,	22,0,	
22,0,	22,0,	22,0,	22,43,	
22,0,	22,0,	22,0,	22,0,	
22,0,	22,0,	22,0,	22,0,	
22,46,	22,0,	22,0,	22,0,	
43,53,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	43,53,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	43,53,	
43,53,	0,0,	0,0,	0,0,	
0,0,	0,0,	43,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
43,0,	43,0,	43,0,	43,0,	
43,0,	43,0,	43,0,	43,0,	
43,0,	43,0,	43,0,	43,0,	
43,0,	43,0,	43,0,	43,0,	
43,0,	43,0,	43,0,	43,0,	
43,0,	43,0,	43,0,	43,0,	
43,0,	43,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
43,0,	43,0,	43,0,	43,0,	
43,0,	43,0,	43,0,	43,0,	
43,0,	43,0,	43,0,	43,0,	
43,0,	43,0,	43,0,	43,0,	
43,0,	43,0,	43,0,	43,0,	
43,0,	43,0,	43,0,	43,0,	
43,0,	43,0,	44,54,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	44,54,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	44,54,	44,54,	0,0,	
0,0,	0,0,	0,0,	0,0,	
44,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	44,0,	44,0,	
44,0,	44,0,	44,0,	44,0,	
44,0,	44,0,	44,0,	44,0,	
44,0,	44,0,	44,0,	44,0,	
44,0,	44,0,	44,0,	44,0,	
44,0,	44,0,	44,0,	44,0,	
44,0,	44,0,	44,0,	44,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	44,0,	44,0,	
44,0,	44,0,	44,55,	44,0,	
44,0,	44,0,	44,0,	44,0,	
44,0,	44,0,	44,0,	44,0,	
44,0,	44,0,	44,0,	44,0,	
44,0,	44,0,	44,0,	44,0,	
44,0,	44,0,	44,0,	44,0,	
60,62,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	60,62,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	60,62,	
60,62,	0,0,	0,0,	0,0,	
0,0,	0,0,	60,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
60,0,	60,0,	60,0,	60,0,	
60,0,	60,0,	60,0,	60,0,	
60,0,	60,0,	60,0,	60,0,	
60,0,	60,0,	60,0,	60,0,	
60,0,	60,0,	60,0,	60,0,	
60,0,	60,0,	60,0,	60,0,	
60,0,	60,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
60,0,	60,0,	60,0,	60,0,	
60,0,	60,0,	60,0,	60,0,	
60,0,	60,0,	60,0,	60,0,	
60,0,	60,0,	60,0,	60,0,	
60,0,	60,0,	60,0,	60,0,	
60,0,	60,0,	60,0,	60,0,	
60,0,	60,0,	61,63,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	61,63,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	61,63,	61,63,	0,0,	
0,0,	0,0,	0,0,	0,0,	
61,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	61,0,	61,0,	
61,0,	61,0,	61,0,	61,0,	
61,0,	61,0,	61,0,	61,0,	
61,0,	61,0,	61,0,	61,0,	
61,0,	61,0,	61,0,	61,0,	
61,0,	61,0,	61,0,	61,0,	
61,0,	61,0,	61,0,	61,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	61,0,	61,0,	
61,0,	61,0,	61,0,	61,0,	
61,0,	61,0,	61,0,	61,0,	
61,0,	61,0,	61,0,	61,0,	
61,0,	61,0,	61,0,	61,0,	
61,0,	61,0,	61,0,	61,0,	
61,0,	61,0,	61,0,	61,0,	
0,0};
struct yysvf yysvec[] = {
0,	0,	0,
yycrank+-1,	0,		0,	
yycrank+-8,	yysvec+1,	0,	
yycrank+-45,	0,		0,	
yycrank+-68,	yysvec+3,	0,	
yycrank+-112,	0,		0,	
yycrank+-128,	yysvec+5,	0,	
yycrank+0,	0,		yyvstop+1,
yycrank+0,	0,		yyvstop+4,
yycrank+2,	0,		yyvstop+6,
yycrank+0,	0,		yyvstop+10,
yycrank+183,	0,		yyvstop+12,
yycrank+19,	0,		yyvstop+15,
yycrank+0,	0,		yyvstop+17,
yycrank+0,	0,		yyvstop+20,
yycrank+-19,	0,		yyvstop+23,
yycrank+267,	0,		yyvstop+26,
yycrank+24,	0,		yyvstop+29,
yycrank+21,	0,		yyvstop+31,
yycrank+0,	0,		yyvstop+33,
yycrank+0,	0,		yyvstop+36,
yycrank+0,	0,		yyvstop+39,
yycrank+-389,	0,		yyvstop+42,
yycrank+0,	0,		yyvstop+45,
yycrank+21,	0,		yyvstop+48,
yycrank+19,	0,		yyvstop+51,
yycrank+35,	0,		yyvstop+54,
yycrank+0,	0,		yyvstop+56,
yycrank+25,	0,		yyvstop+59,
yycrank+0,	0,		yyvstop+61,
yycrank+0,	0,		yyvstop+64,
yycrank+30,	0,		yyvstop+67,
yycrank+0,	yysvec+17,	yyvstop+69,
yycrank+0,	0,		yyvstop+72,
yycrank+0,	0,		yyvstop+75,
yycrank+0,	0,		yyvstop+77,
yycrank+0,	0,		yyvstop+79,
yycrank+0,	0,		yyvstop+82,
yycrank+20,	0,		0,	
yycrank+-21,	yysvec+15,	yyvstop+85,
yycrank+0,	0,		yyvstop+87,
yycrank+0,	0,		yyvstop+89,
yycrank+0,	0,		yyvstop+92,
yycrank+-511,	0,		yyvstop+95,
yycrank+-633,	0,		yyvstop+97,
yycrank+0,	0,		yyvstop+99,
yycrank+0,	0,		yyvstop+101,
yycrank+0,	0,		yyvstop+103,
yycrank+0,	0,		yyvstop+105,
yycrank+32,	0,		0,	
yycrank+34,	0,		0,	
yycrank+35,	0,		0,	
yycrank+0,	0,		yyvstop+107,
yycrank+0,	0,		yyvstop+109,
yycrank+0,	0,		yyvstop+111,
yycrank+0,	0,		yyvstop+113,
yycrank+47,	0,		0,	
yycrank+21,	0,		0,	
yycrank+51,	0,		0,	
yycrank+0,	0,		yyvstop+115,
yycrank+-755,	0,		yyvstop+117,
yycrank+-877,	0,		yyvstop+119,
yycrank+0,	0,		yyvstop+121,
yycrank+0,	0,		yyvstop+123,
0,	0,	0};
struct yywork *yytop = yycrank+999;
struct yysvf *yybgin = yysvec+1;
char yymatch[] = {
  0,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,  10,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
 32,  33,   1,   1,   1,   1,   1,  39, 
  1,   1,   1,   1,   1,   1,  33,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,  33, 
  1,  39,  39,  39,  39,  39,  39,  39, 
 39,  39,  39,  39,  39,  39,  39,  39, 
 39,  39,  39,  39,  39,  39,  39,  39, 
 39,  39,  39,   1,   1,   1,   1,   1, 
  1,  39,  39,  39,  39,  39,  39,  39, 
 39,  39,  39,  39,  39,  39,  39,  39, 
 39,  39,  39,  39,  39,  39,  39,  39, 
 39,  39,  39,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
0};
char yyextra[] = {
0,0,0,1,1,1,0,0,
0,0,1,1,1,0,1,0,
0,0,0,0,0,0,0,0,
0,0,1,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0};
/*	Copyright (c) 1989 AT&T	*/
/*	  All Rights Reserved  	*/

/*	THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF AT&T	*/
/*	The copyright notice above does not evidence any   	*/
/*	actual or intended publication of such source code.	*/

#pragma ident	"@(#)ncform	6.8	95/02/11 SMI"

int yylineno =1;
# define YYU(x) x
# define NLSTATE yyprevious=YYNEWLINE
struct yysvf *yylstate [YYLMAX], **yylsp, **yyolsp;
char yysbuf[YYLMAX];
char *yysptr = yysbuf;
int *yyfnd;
extern struct yysvf *yyestate;
int yyprevious = YYNEWLINE;
#if defined(__cplusplus) || defined(__STDC__)
int yylook(void)
#else
yylook()
#endif
{
	register struct yysvf *yystate, **lsp;
	register struct yywork *yyt;
	struct yysvf *yyz;
	int yych, yyfirst;
	struct yywork *yyr;
# ifdef LEXDEBUG
	int debug;
# endif
	char *yylastch;
	/* start off machines */
# ifdef LEXDEBUG
	debug = 0;
# endif
	yyfirst=1;
	if (!yymorfg)
		yylastch = yytext;
	else {
		yymorfg=0;
		yylastch = yytext+yyleng;
		}
	for(;;){
		lsp = yylstate;
		yyestate = yystate = yybgin;
		if (yyprevious==YYNEWLINE) yystate++;
		for (;;){
# ifdef LEXDEBUG
			if(debug)fprintf(yyout,"state %d\n",yystate-yysvec-1);
# endif
			yyt = yystate->yystoff;
			if(yyt == yycrank && !yyfirst){  /* may not be any transitions */
				yyz = yystate->yyother;
				if(yyz == 0)break;
				if(yyz->yystoff == yycrank)break;
				}
#ifndef __cplusplus
			*yylastch++ = yych = input();
#else
			*yylastch++ = yych = lex_input();
#endif
			if(yylastch > &yytext[YYLMAX]) {
				fprintf(yyout,"Input string too long, limit %d\n",YYLMAX);
				exit(1);
			}
			yyfirst=0;
		tryagain:
# ifdef LEXDEBUG
			if(debug){
				fprintf(yyout,"char ");
				allprint(yych);
				putchar('\n');
				}
# endif
			yyr = yyt;
			if ( (int)yyt > (int)yycrank){
				yyt = yyr + yych;
				if (yyt <= yytop && yyt->verify+yysvec == yystate){
					if(yyt->advance+yysvec == YYLERR)	/* error transitions */
						{unput(*--yylastch);break;}
					*lsp++ = yystate = yyt->advance+yysvec;
					if(lsp > &yylstate[YYLMAX]) {
						fprintf(yyout,"Input string too long, limit %d\n",YYLMAX);
						exit(1);
					}
					goto contin;
					}
				}
# ifdef YYOPTIM
			else if((int)yyt < (int)yycrank) {		/* r < yycrank */
				yyt = yyr = yycrank+(yycrank-yyt);
# ifdef LEXDEBUG
				if(debug)fprintf(yyout,"compressed state\n");
# endif
				yyt = yyt + yych;
				if(yyt <= yytop && yyt->verify+yysvec == yystate){
					if(yyt->advance+yysvec == YYLERR)	/* error transitions */
						{unput(*--yylastch);break;}
					*lsp++ = yystate = yyt->advance+yysvec;
					if(lsp > &yylstate[YYLMAX]) {
						fprintf(yyout,"Input string too long, limit %d\n",YYLMAX);
						exit(1);
					}
					goto contin;
					}
				yyt = yyr + YYU(yymatch[yych]);
# ifdef LEXDEBUG
				if(debug){
					fprintf(yyout,"try fall back character ");
					allprint(YYU(yymatch[yych]));
					putchar('\n');
					}
# endif
				if(yyt <= yytop && yyt->verify+yysvec == yystate){
					if(yyt->advance+yysvec == YYLERR)	/* error transition */
						{unput(*--yylastch);break;}
					*lsp++ = yystate = yyt->advance+yysvec;
					if(lsp > &yylstate[YYLMAX]) {
						fprintf(yyout,"Input string too long, limit %d\n",YYLMAX);
						exit(1);
					}
					goto contin;
					}
				}
			if ((yystate = yystate->yyother) && (yyt= yystate->yystoff) != yycrank){
# ifdef LEXDEBUG
				if(debug)fprintf(yyout,"fall back to state %d\n",yystate-yysvec-1);
# endif
				goto tryagain;
				}
# endif
			else
				{unput(*--yylastch);break;}
		contin:
# ifdef LEXDEBUG
			if(debug){
				fprintf(yyout,"state %d char ",yystate-yysvec-1);
				allprint(yych);
				putchar('\n');
				}
# endif
			;
			}
# ifdef LEXDEBUG
		if(debug){
			fprintf(yyout,"stopped at %d with ",*(lsp-1)-yysvec-1);
			allprint(yych);
			putchar('\n');
			}
# endif
		while (lsp-- > yylstate){
			*yylastch-- = 0;
			if (*lsp != 0 && (yyfnd= (*lsp)->yystops) && *yyfnd > 0){
				yyolsp = lsp;
				if(yyextra[*yyfnd]){		/* must backup */
					while(yyback((*lsp)->yystops,-*yyfnd) != 1 && lsp > yylstate){
						lsp--;
						unput(*yylastch--);
						}
					}
				yyprevious = YYU(*yylastch);
				yylsp = lsp;
				yyleng = yylastch-yytext+1;
				yytext[yyleng] = 0;
# ifdef LEXDEBUG
				if(debug){
					fprintf(yyout,"\nmatch ");
					sprint(yytext);
					fprintf(yyout," action %d\n",*yyfnd);
					}
# endif
				return(*yyfnd++);
				}
			unput(*yylastch);
			}
		if (yytext[0] == 0  /* && feof(yyin) */)
			{
			yysptr=yysbuf;
			return(0);
			}
#ifndef __cplusplus
		yyprevious = yytext[0] = input();
		if (yyprevious>0)
			output(yyprevious);
#else
		yyprevious = yytext[0] = lex_input();
		if (yyprevious>0)
			lex_output(yyprevious);
#endif
		yylastch=yytext;
# ifdef LEXDEBUG
		if(debug)putchar('\n');
# endif
		}
	}
#if defined(__cplusplus) || defined(__STDC__)
int yyback(int *p, int m)
#else
yyback(p, m)
	int *p;
#endif
{
	if (p==0) return(0);
	while (*p) {
		if (*p++ == m)
			return(1);
	}
	return(0);
}
	/* the following are only used in the lex library */
#if defined(__cplusplus) || defined(__STDC__)
int yyinput(void)
#else
yyinput()
#endif
{
#ifndef __cplusplus
	return(input());
#else
	return(lex_input());
#endif
	}
#if defined(__cplusplus) || defined(__STDC__)
void yyoutput(int c)
#else
yyoutput(c)
  int c; 
#endif
{
#ifndef __cplusplus
	output(c);
#else
	lex_output(c);
#endif
	}
#if defined(__cplusplus) || defined(__STDC__)
void yyunput(int c)
#else
yyunput(c)
   int c; 
#endif
{
	unput(c);
	}
