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

# line 6 "valspeak.l"
		printf(" mean");
break;
case 2:

# line 7 "valspeak.l"
		printf(" bitchin' ");
break;
case 3:

# line 8 "valspeak.l"
	printf(" bitchin'est");
break;
case 4:

# line 9 "valspeak.l"
		printf(" bod");
break;
case 5:

# line 10 "valspeak.l"
		printf(" drag");
break;
case 6:

# line 11 "valspeak.l"
		printf(" rod ");
break;
case 7:

# line 12 "valspeak.l"
	printf(" grodie");
break;
case 8:

# line 13 "valspeak.l"
	printf(" grodie to thuh max");
break;
case 9:

# line 14 "valspeak.l"
		printf(" munchies");
break;
case 10:

# line 15 "valspeak.l"
		printf(" chick");
break;
case 11:

# line 16 "valspeak.l"
		printf(" bitchin'");
break;
case 12:

# line 17 "valspeak.l"
	printf(" awesum");
break;
case 13:

# line 18 "valspeak.l"
	printf(" grodie");
break;
case 14:

# line 19 "valspeak.l"
		printf(" dude");
break;
case 15:

# line 20 "valspeak.l"
		printf(" that chick ");
break;
case 16:

# line 21 "valspeak.l"
		printf(" that chick.");
break;
case 17:

# line 22 "valspeak.l"
		printf(" that dude ");
break;
case 18:

# line 23 "valspeak.l"
		printf(" that dude.");
break;
case 19:

# line 24 "valspeak.l"
	case 20:

# line 25 "valspeak.l"
	case 21:

# line 26 "valspeak.l"
case 22:

# line 27 "valspeak.l"
case 23:

# line 28 "valspeak.l"
	case 24:

# line 29 "valspeak.l"
case 25:

# line 30 "valspeak.l"
		case 26:

# line 31 "valspeak.l"
	case 27:

# line 32 "valspeak.l"
	case 28:

# line 33 "valspeak.l"
	case 29:

# line 34 "valspeak.l"
	{
			ECHO;
			switch(rand() % 6)
			{
			case 0:
				printf("like, ya know, "); break;
			case 1:
				printf(""); break;
			case 2:
				printf("like wow! "); break;
			case 3:
				printf("ya know, like, "); break;
			case 4:
				printf(""); break;
			case 5:
				printf(""); break;
			}
		}
break;
case 30:

# line 52 "valspeak.l"
	printf(" pad");
break;
case 31:

# line 53 "valspeak.l"
	printf(" cool");
break;
case 32:

# line 54 "valspeak.l"
	printf(" awesum");
break;
case 33:

# line 55 "valspeak.l"
	printf(" blow");
break;
case 34:

# line 56 "valspeak.l"
		printf(" nerd ");
break;
case 35:

# line 57 "valspeak.l"
{
			switch(rand() % 6)
			{
			case 0:
				printf(" if you're a Pisces "); break;
			case 1:
				printf(" if the moon is full "); break;
			case 2:
				printf(" if the vibes are right "); break;
			case 3:
				printf(" when you get the feeling "); break;
			case 4:
				printf(" maybe "); break;
			case 5:
				printf(" maybe "); break;
			}
		}
break;
case 36:

# line 74 "valspeak.l"
	printf(" party");
break;
case 37:

# line 75 "valspeak.l"
	printf(" flick");
break;
case 38:

# line 76 "valspeak.l"
	printf(" tunes ");
break;
case 39:

# line 77 "valspeak.l"
		printf(" keen");
break;
case 40:

# line 78 "valspeak.l"
		printf(" class");
break;
case 41:

# line 79 "valspeak.l"
	printf(" just no way");
break;
case 42:

# line 80 "valspeak.l"
	printf(" guys");
break;
case 43:

# line 81 "valspeak.l"
	printf(" totally");
break;
case 44:

# line 82 "valspeak.l"
	printf(" freaky");
break;
case 45:

# line 83 "valspeak.l"
		printf(" thuh ");
break;
case 46:

# line 84 "valspeak.l"
		printf(" super");
break;
case 47:

# line 85 "valspeak.l"
		printf(" want");
break;
case 48:

# line 86 "valspeak.l"
	printf(" far out");
break;
case 49:

# line 87 "valspeak.l"
		printf(" fer shure");
break;
case 50:

# line 88 "valspeak.l"
		printf("Man, ");
break;
case 51:

# line 89 "valspeak.l"
		printf("That dude ");
break;
case 52:

# line 90 "valspeak.l"
	printf("I can dig");
break;
case 53:

# line 91 "valspeak.l"
		printf("Like, no way,");
break;
case 54:

# line 92 "valspeak.l"
		printf("Man");
break;
case 55:

# line 93 "valspeak.l"
		printf("That fox ");
break;
case 56:

# line 94 "valspeak.l"
		printf("Like, ya know, this");
break;
case 57:

# line 95 "valspeak.l"
		printf("Like, there");
break;
case 58:

# line 96 "valspeak.l"
		printf("Us guys ");
break;
case 59:

# line 97 "valspeak.l"
		printf("Like,");
break;
case 60:

# line 98 "valspeak.l"
	{
			switch(rand() % 6)
			{
			case 0:
				printf(", like, "); break;
			case 1:
				printf(", fer shure, "); break;
			case 2:
				printf(", like, wow, "); break;
			case 3:
				printf(", oh, baby, "); break;
			case 4:
				printf(", man, "); break;
			case 5:
				printf(", mostly, "); break;
			}
		}
break;
case 61:

# line 115 "valspeak.l"
	{
			switch(rand() % 3)
			{
			case 0:
				printf("!  Gag me with a SPOOOOON!"); break;
			case 1:
				printf("!  Gag me with a pitchfork!"); break;
			case 2:
				printf("!  Oh, wow!");
			}
		}
break;
case 62:

# line 127 "valspeak.l"
		printf("in'");
break;
case 63:

# line 128 "valspeak.l"
		ECHO;
break;
case -1:
break;
default:
(void)fprintf(yyout,"bad switch yylook %d",nstr);
} return(0); }
/* end of yylex */

main()
{
	srand(getpid());
	yylex();
}
int yyvstop[] = {
0,

63,
0,

63,
0,

61,
63,
0,

63,
0,

63,
0,

63,
0,

63,
0,

63,
0,

63,
0,

63,
0,

63,
0,

63,
0,

63,
0,

60,
0,

51,
0,

53,
0,

54,
0,

58,
0,

62,
0,

1,
0,

14,
0,

29,
0,

49,
0,

50,
0,

55,
0,

56,
0,

59,
0,

2,
0,

4,
0,

5,
0,

6,
0,

9,
0,

10,
0,

11,
0,

15,
0,

16,
0,

17,
0,

18,
0,

34,
0,

39,
0,

40,
0,

45,
0,

46,
0,

47,
0,

25,
0,

57,
0,

7,
0,

12,
0,

13,
0,

30,
0,

32,
0,

33,
0,

37,
0,

48,
0,

52,
0,

8,
0,

35,
0,

38,
0,

41,
0,

42,
0,

43,
0,

3,
0,

19,
0,

36,
0,

44,
0,

26,
0,

27,
0,

20,
0,

28,
0,

23,
0,

31,
0,

24,
0,

21,
0,

22,
0,
0};
# define YYTYPE int
struct yywork { YYTYPE verify, advance; } yycrank[] = {
0,0,	0,0,	1,3,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	1,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	2,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	1,4,	1,5,	6,33,	
9,36,	35,81,	41,88,	59,109,	
68,119,	2,4,	2,5,	80,132,	
84,134,	1,6,	37,83,	89,137,	
95,142,	96,144,	105,152,	106,154,	
112,160,	2,6,	124,172,	95,143,	
130,179,	176,202,	178,204,	184,209,	
193,212,	196,214,	205,222,	208,224,	
105,153,	106,155,	220,231,	1,7,	
0,0,	232,239,	234,241,	0,0,	
0,0,	1,8,	1,9,	2,7,	
229,238,	240,246,	243,248,	1,10,	
245,250,	2,8,	2,9,	252,255,	
1,11,	1,12,	256,259,	2,10,	
1,13,	262,264,	1,14,	265,267,	
2,11,	2,12,	270,271,	0,0,	
2,13,	0,0,	2,14,	17,47,	
61,111,	44,91,	8,35,	13,41,	
14,42,	12,40,	1,15,	11,38,	
11,39,	18,48,	26,69,	4,16,	
4,17,	4,18,	2,15,	4,19,	
4,20,	4,21,	4,22,	7,34,	
10,37,	4,23,	4,24,	4,25,	
15,43,	4,26,	27,70,	4,27,	
4,28,	4,29,	16,44,	4,30,	
4,31,	19,49,	4,32,	22,58,	
20,51,	21,55,	16,45,	19,50,	
22,59,	21,56,	20,52,	29,73,	
16,46,	20,53,	23,60,	21,57,	
20,54,	24,62,	23,61,	25,66,	
28,71,	24,63,	30,74,	25,67,	
32,79,	34,80,	31,75,	36,82,	
38,84,	25,68,	31,76,	24,64,	
28,72,	39,85,	31,77,	40,86,	
42,89,	24,65,	43,90,	40,87,	
31,78,	45,92,	46,93,	47,95,	
48,97,	49,98,	50,99,	47,96,	
51,100,	52,101,	53,102,	54,104,	
55,105,	56,106,	57,107,	58,108,	
46,94,	60,110,	62,112,	63,114,	
53,103,	64,115,	65,116,	66,117,	
67,118,	69,120,	70,121,	71,122,	
72,123,	62,113,	73,124,	74,125,	
75,126,	76,128,	77,129,	78,130,	
79,131,	75,127,	82,133,	86,135,	
87,136,	92,138,	93,140,	94,141,	
97,145,	98,146,	99,147,	100,148,	
101,149,	102,150,	103,151,	107,156,	
108,157,	110,158,	111,159,	113,161,	
114,162,	115,163,	116,164,	117,165,	
118,166,	119,167,	120,168,	121,169,	
122,170,	123,171,	125,173,	126,174,	
127,175,	128,177,	129,178,	133,180,	
135,181,	139,182,	142,183,	143,184,	
145,185,	146,186,	150,187,	151,188,	
156,189,	157,190,	158,191,	159,192,	
161,193,	162,194,	163,195,	164,196,	
167,197,	168,198,	169,199,	170,200,	
171,201,	177,203,	179,205,	180,206,	
182,207,	183,208,	186,210,	190,211,	
194,213,	197,215,	198,216,	199,217,	
200,218,	201,219,	202,220,	204,221,	
207,223,	209,225,	211,226,	213,227,	
92,139,	218,228,	219,230,	221,232,	
222,233,	225,234,	226,235,	228,236,	
233,240,	235,242,	236,243,	237,244,	
238,245,	228,237,	242,247,	244,249,	
247,251,	249,252,	250,253,	253,256,	
254,257,	255,258,	257,260,	258,261,	
250,254,	260,262,	261,263,	263,265,	
264,266,	266,268,	268,269,	269,270,	
0,0,	0,0,	127,176,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	218,229,	
0,0};
struct yysvf yysvec[] = {
0,	0,	0,
yycrank+-1,	0,		0,	
yycrank+-9,	yysvec+1,	0,	
yycrank+0,	0,		yyvstop+1,
yycrank+13,	0,		yyvstop+3,
yycrank+0,	0,		yyvstop+5,
yycrank+3,	0,		yyvstop+8,
yycrank+2,	0,		yyvstop+10,
yycrank+1,	0,		yyvstop+12,
yycrank+4,	0,		yyvstop+14,
yycrank+9,	0,		yyvstop+16,
yycrank+3,	0,		yyvstop+18,
yycrank+1,	0,		yyvstop+20,
yycrank+2,	0,		yyvstop+22,
yycrank+3,	0,		yyvstop+24,
yycrank+14,	0,		yyvstop+26,
yycrank+33,	0,		0,	
yycrank+2,	0,		0,	
yycrank+4,	0,		0,	
yycrank+28,	0,		0,	
yycrank+31,	0,		0,	
yycrank+36,	0,		0,	
yycrank+25,	0,		0,	
yycrank+49,	0,		0,	
yycrank+52,	0,		0,	
yycrank+50,	0,		0,	
yycrank+9,	0,		0,	
yycrank+25,	0,		0,	
yycrank+48,	0,		0,	
yycrank+39,	0,		0,	
yycrank+53,	0,		0,	
yycrank+61,	0,		0,	
yycrank+55,	0,		0,	
yycrank+0,	0,		yyvstop+28,
yycrank+41,	0,		0,	
yycrank+5,	0,		0,	
yycrank+51,	0,		0,	
yycrank+2,	0,		0,	
yycrank+59,	0,		0,	
yycrank+51,	0,		0,	
yycrank+66,	0,		0,	
yycrank+6,	0,		0,	
yycrank+53,	0,		0,	
yycrank+67,	0,		0,	
yycrank+1,	0,		0,	
yycrank+70,	0,		0,	
yycrank+74,	0,		0,	
yycrank+65,	0,		0,	
yycrank+62,	0,		0,	
yycrank+69,	0,		0,	
yycrank+67,	0,		0,	
yycrank+66,	0,		0,	
yycrank+70,	0,		0,	
yycrank+81,	0,		0,	
yycrank+62,	0,		0,	
yycrank+70,	0,		0,	
yycrank+76,	0,		0,	
yycrank+69,	0,		0,	
yycrank+71,	0,		0,	
yycrank+7,	0,		0,	
yycrank+75,	0,		0,	
yycrank+3,	0,		0,	
yycrank+80,	0,		0,	
yycrank+90,	0,		0,	
yycrank+75,	0,		0,	
yycrank+79,	0,		0,	
yycrank+98,	0,		0,	
yycrank+97,	0,		0,	
yycrank+8,	0,		0,	
yycrank+86,	0,		0,	
yycrank+101,	0,		0,	
yycrank+88,	0,		0,	
yycrank+86,	0,		0,	
yycrank+101,	0,		0,	
yycrank+89,	0,		0,	
yycrank+94,	0,		0,	
yycrank+100,	0,		0,	
yycrank+98,	0,		0,	
yycrank+97,	0,		0,	
yycrank+93,	0,		0,	
yycrank+11,	0,		0,	
yycrank+0,	0,		yyvstop+30,
yycrank+105,	0,		0,	
yycrank+0,	0,		yyvstop+32,
yycrank+12,	0,		0,	
yycrank+0,	0,		yyvstop+34,
yycrank+97,	0,		0,	
yycrank+97,	0,		0,	
yycrank+0,	0,		yyvstop+36,
yycrank+3,	0,		0,	
yycrank+0,	0,		yyvstop+38,
yycrank+0,	0,		yyvstop+40,
yycrank+181,	0,		0,	
yycrank+93,	0,		0,	
yycrank+114,	0,		0,	
yycrank+16,	0,		0,	
yycrank+17,	0,		0,	
yycrank+100,	0,		0,	
yycrank+101,	0,		0,	
yycrank+118,	0,		0,	
yycrank+111,	0,		0,	
yycrank+120,	0,		0,	
yycrank+124,	0,		0,	
yycrank+107,	0,		0,	
yycrank+0,	0,		yyvstop+42,
yycrank+18,	0,		0,	
yycrank+19,	0,		0,	
yycrank+108,	0,		0,	
yycrank+123,	0,		0,	
yycrank+0,	0,		yyvstop+44,
yycrank+122,	0,		0,	
yycrank+108,	0,		0,	
yycrank+20,	0,		0,	
yycrank+129,	0,		0,	
yycrank+112,	0,		0,	
yycrank+124,	0,		0,	
yycrank+125,	0,		0,	
yycrank+115,	0,		0,	
yycrank+131,	0,		0,	
yycrank+114,	0,		0,	
yycrank+122,	0,		0,	
yycrank+127,	0,		0,	
yycrank+119,	0,		0,	
yycrank+140,	0,		0,	
yycrank+22,	0,		0,	
yycrank+117,	0,		0,	
yycrank+123,	0,		0,	
yycrank+208,	0,		0,	
yycrank+127,	0,		0,	
yycrank+134,	0,		0,	
yycrank+17,	0,		0,	
yycrank+0,	0,		yyvstop+46,
yycrank+0,	0,		yyvstop+48,
yycrank+136,	0,		0,	
yycrank+0,	0,		yyvstop+50,
yycrank+143,	0,		0,	
yycrank+0,	0,		yyvstop+52,
yycrank+0,	0,		yyvstop+54,
yycrank+0,	0,		yyvstop+56,
yycrank+144,	0,		0,	
yycrank+0,	0,		yyvstop+58,
yycrank+0,	0,		yyvstop+60,
yycrank+148,	0,		0,	
yycrank+131,	0,		0,	
yycrank+0,	0,		yyvstop+62,
yycrank+127,	0,		0,	
yycrank+145,	0,		0,	
yycrank+0,	0,		yyvstop+64,
yycrank+0,	0,		yyvstop+66,
yycrank+0,	0,		yyvstop+68,
yycrank+134,	0,		0,	
yycrank+136,	0,		0,	
yycrank+0,	0,		yyvstop+70,
yycrank+0,	0,		yyvstop+72,
yycrank+0,	0,		yyvstop+74,
yycrank+0,	0,		yyvstop+76,
yycrank+151,	0,		0,	
yycrank+139,	0,		0,	
yycrank+153,	0,		0,	
yycrank+154,	0,		0,	
yycrank+0,	0,		yyvstop+78,
yycrank+155,	0,		0,	
yycrank+152,	0,		0,	
yycrank+157,	0,		0,	
yycrank+160,	0,		0,	
yycrank+0,	0,		yyvstop+80,
yycrank+0,	0,		yyvstop+82,
yycrank+163,	0,		0,	
yycrank+153,	0,		0,	
yycrank+154,	0,		0,	
yycrank+155,	0,		0,	
yycrank+154,	0,		0,	
yycrank+0,	0,		yyvstop+84,
yycrank+0,	0,		yyvstop+86,
yycrank+0,	0,		yyvstop+88,
yycrank+0,	0,		yyvstop+90,
yycrank+18,	0,		0,	
yycrank+165,	0,		0,	
yycrank+26,	0,		0,	
yycrank+150,	0,		0,	
yycrank+166,	0,		0,	
yycrank+0,	0,		yyvstop+92,
yycrank+153,	0,		0,	
yycrank+168,	0,		0,	
yycrank+27,	0,		0,	
yycrank+0,	0,		yyvstop+94,
yycrank+149,	0,		0,	
yycrank+0,	0,		yyvstop+96,
yycrank+0,	0,		yyvstop+98,
yycrank+0,	0,		yyvstop+100,
yycrank+170,	0,		0,	
yycrank+0,	0,		yyvstop+102,
yycrank+0,	0,		yyvstop+104,
yycrank+28,	0,		0,	
yycrank+162,	0,		0,	
yycrank+0,	0,		yyvstop+106,
yycrank+29,	0,		0,	
yycrank+152,	0,		0,	
yycrank+173,	0,		0,	
yycrank+154,	0,		0,	
yycrank+176,	0,		0,	
yycrank+174,	0,		0,	
yycrank+162,	0,		0,	
yycrank+0,	0,		yyvstop+108,
yycrank+181,	0,		0,	
yycrank+30,	0,		0,	
yycrank+0,	0,		yyvstop+110,
yycrank+164,	0,		0,	
yycrank+31,	0,		0,	
yycrank+183,	0,		0,	
yycrank+0,	0,		yyvstop+112,
yycrank+167,	0,		0,	
yycrank+0,	0,		yyvstop+114,
yycrank+180,	0,		0,	
yycrank+0,	0,		yyvstop+116,
yycrank+0,	0,		yyvstop+118,
yycrank+0,	0,		yyvstop+120,
yycrank+0,	0,		yyvstop+122,
yycrank+253,	0,		0,	
yycrank+185,	0,		0,	
yycrank+34,	0,		0,	
yycrank+186,	0,		0,	
yycrank+190,	0,		0,	
yycrank+0,	0,		yyvstop+124,
yycrank+0,	0,		yyvstop+126,
yycrank+188,	0,		0,	
yycrank+174,	0,		0,	
yycrank+0,	0,		yyvstop+128,
yycrank+193,	0,		0,	
yycrank+37,	0,		0,	
yycrank+0,	0,		yyvstop+130,
yycrank+0,	0,		yyvstop+132,
yycrank+37,	0,		0,	
yycrank+191,	0,		0,	
yycrank+38,	0,		0,	
yycrank+188,	0,		0,	
yycrank+193,	0,		0,	
yycrank+198,	0,		0,	
yycrank+180,	0,		0,	
yycrank+0,	0,		yyvstop+134,
yycrank+45,	0,		0,	
yycrank+0,	0,		yyvstop+136,
yycrank+188,	0,		0,	
yycrank+46,	0,		0,	
yycrank+181,	0,		0,	
yycrank+48,	0,		0,	
yycrank+0,	0,		yyvstop+138,
yycrank+197,	0,		0,	
yycrank+0,	0,		yyvstop+140,
yycrank+200,	0,		0,	
yycrank+204,	0,		0,	
yycrank+0,	0,		yyvstop+142,
yycrank+51,	0,		0,	
yycrank+202,	0,		0,	
yycrank+207,	0,		0,	
yycrank+207,	0,		0,	
yycrank+54,	0,		0,	
yycrank+188,	0,		0,	
yycrank+206,	0,		0,	
yycrank+0,	0,		yyvstop+144,
yycrank+208,	0,		0,	
yycrank+209,	0,		0,	
yycrank+57,	0,		0,	
yycrank+201,	0,		0,	
yycrank+214,	0,		0,	
yycrank+59,	0,		0,	
yycrank+212,	0,		0,	
yycrank+0,	0,		yyvstop+146,
yycrank+213,	0,		0,	
yycrank+205,	0,		0,	
yycrank+62,	0,		0,	
yycrank+0,	0,		yyvstop+148,
0,	0,	0};
struct yywork *yytop = yycrank+363;
struct yysvf *yybgin = yysvec+1;
char yymatch[] = {
  0,   1,   1,   1,   1,   1,   1,   1, 
  1,   1,  10,   1,   1,   1,   1,   1, 
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
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
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
