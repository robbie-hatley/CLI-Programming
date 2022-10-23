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
	char buf[128];

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

# line 16 "jive.l"
			printf(" stash");
break;
case 2:

# line 17 "jive.l"
			printf(" t'row");
break;
case 3:

# line 18 "jive.l"
			printf(" honky code");
break;
case 4:

# line 19 "jive.l"
			printf(" Isaac");
break;
case 5:

# line 20 "jive.l"
			printf(" slow mo-fo");
break;
case 6:

# line 21 "jive.l"
			printf(" that slow mo-fo");
break;
case 7:

# line 22 "jive.l"
			printf(" snatch'd");
break;
case 8:

# line 23 "jive.l"
			printf(" wet-back");
break;
case 9:

# line 24 "jive.l"
			printf(" wet-back");
break;
case 10:

# line 25 "jive.l"
			printf(" greaser");
break;
case 11:

# line 26 "jive.l"
			printf(" greaser");
break;
case 12:

# line 27 "jive.l"
			printf(" snatch");
break;
case 13:

# line 28 "jive.l"
			printf(" duzn't");
break;
case 14:

# line 29 "jive.l"
			printf(" JIBE");
break;
case 15:

# line 30 "jive.l"
			printf(" honkyfool");
break;
case 16:

# line 31 "jive.l"
			printf(" doodad");
break;
case 17:

# line 32 "jive.l"
		printf("e da damn ");
break;
case 18:

# line 33 "jive.l"
		printf("a da damn ");
break;
case 19:

# line 34 "jive.l"
		printf("t da damn ");
break;
case 20:

# line 35 "jive.l"
		printf("d da damn ");
break;
case 21:

# line 36 "jive.l"
                    printf(" dude ");
break;
case 22:

# line 37 "jive.l"
			printf("mama");
break;
case 23:

# line 38 "jive.l"
			printf("goat");
break;
case 24:

# line 39 "jive.l"
		printf("sump'n");
break;
case 25:

# line 40 "jive.l"
		printf(" honky jibe ");
break;
case 26:

# line 41 "jive.l"
                    printf(" -on rebound- ");
break;
case 27:

# line 42 "jive.l"
		printf(" -check y'out latah-");
break;
case 28:

# line 43 "jive.l"
	{ sprintf(buf, "%s Sheeeiit.",yytext); printf(buf); }
break;
case 29:

# line 44 "jive.l"
	{ sprintf(buf, "%s What it is, Mama!",yytext); printf(buf); }
break;
case 30:

# line 45 "jive.l"
	{ sprintf(buf, "%s Ya' know?",yytext); printf(buf); }
break;
case 31:

# line 46 "jive.l"
	{ sprintf(buf, "%s 'S coo', bro.",yytext); printf(buf); }
break;
case 32:

# line 47 "jive.l"
	{ sprintf(buf, "%s Ah be baaad...",yytext); printf(buf); }
break;
case 33:

# line 48 "jive.l"
	{ sprintf(buf, "%s Man!",yytext); printf(buf); }
break;
case 34:

# line 49 "jive.l"
	{ sprintf(buf, "%s Slap mah fro!",yytext); printf(buf); }
break;
case 35:

# line 50 "jive.l"
		printf("Sho' nuff");
break;
case 36:

# line 51 "jive.l"
		printf("sho' nuff");
break;
case 37:

# line 52 "jive.l"
			printf(" git");
break;
case 38:

# line 53 "jive.l"
		printf("gots'ta");
break;
case 39:

# line 54 "jive.l"
			printf("gots'ta ");
break;
case 40:

# line 55 "jive.l"
		printf("gots'ta");
break;
case 41:

# line 56 "jive.l"
			printf("I's gots'ta be");
break;
case 42:

# line 57 "jive.l"
			printf("aint");
break;
case 43:

# line 58 "jive.l"
			printf("aint");
break;
case 44:

# line 59 "jive.l"
			printf("aint");
break;
case 45:

# line 60 "jive.l"
			printf(" is yo'");
break;
case 46:

# line 61 "jive.l"
			printf(" you is");
break;
case 47:

# line 62 "jive.l"
                    printf(" fedora ");
break;
case 48:

# line 63 "jive.l"
                   printf(" kicker");
break;
case 49:

# line 64 "jive.l"
			printf("aint");
break;
case 50:

# line 65 "jive.l"
		printf("gots'ta");
break;
case 51:

# line 66 "jive.l"
			printf("gots'");
break;
case 52:

# line 67 "jive.l"
			printf(" gots'ta");
break;
case 53:

# line 68 "jive.l"
		printf("mosey on down");
break;
case 54:

# line 69 "jive.l"
                   printf(" mosey on down ");
break;
case 55:

# line 70 "jive.l"
                      printf(".  Right On!  ");
break;
case 56:

# line 71 "jive.l"
			printf("steal");
break;
case 57:

# line 72 "jive.l"
                    printf(" wheels ");
break;
case 58:

# line 73 "jive.l"
			printf("roll");
break;
case 59:

# line 74 "jive.l"
                    printf(" feed da bud ");
break;
case 60:

# line 75 "jive.l"
                  printf(" brother ");
break;
case 61:

# line 76 "jive.l"
                  printf(" brother");
break;
case 62:

# line 77 "jive.l"
				printf("honky");
break;
case 63:

# line 78 "jive.l"
                 printf(" gentleman ");
break;
case 64:

# line 79 "jive.l"
			printf("supa' fine");
break;
case 65:

# line 80 "jive.l"
		printf("sucka'");
break;
case 66:

# line 81 "jive.l"
                  printf(" wahtahmellun");
break;
case 67:

# line 82 "jive.l"
				printf("crib");
break;
case 68:

# line 83 "jive.l"
			printf("dojigger");
break;
case 69:

# line 84 "jive.l"
                   printf(" alley");
break;
case 70:

# line 85 "jive.l"
		printf("clunker");
break;
case 71:

# line 86 "jive.l"
			printf("o'");
break;
case 72:

# line 87 "jive.l"
			printf("wasted");
break;
case 73:

# line 88 "jive.l"
		printf("super-dude");
break;
case 74:

# line 89 "jive.l"
	printf("super honcho");
break;
case 75:

# line 90 "jive.l"
			printf("hosed");
break;
case 76:

# line 91 "jive.l"
		printf("guv'ment");
break;
case 77:

# line 92 "jive.l"
			printf("knowed");
break;
case 78:

# line 93 "jive.l"
			printf("a'cuz");
break;
case 79:

# line 94 "jive.l"
			printf("A'cuz");
break;
case 80:

# line 95 "jive.l"
			printf("yo'");
break;
case 81:

# line 96 "jive.l"
			printf("Yo'");
break;
case 82:

# line 97 "jive.l"
			printf("foe");
break;
case 83:

# line 98 "jive.l"
			printf("gots");
break;
case 84:

# line 99 "jive.l"
			printf("ain't");
break;
case 85:

# line 100 "jive.l"
			printf("yung");
break;
case 86:

# line 101 "jive.l"
			printf("ya'");
break;
case 87:

# line 102 "jive.l"
			printf("You's");
break;
case 88:

# line 103 "jive.l"
			printf("fust");
break;
case 89:

# line 104 "jive.l"
			printf("honky pigs");
break;
case 90:

# line 105 "jive.l"
                 printf(" chittlin'");
break;
case 91:

# line 106 "jive.l"
	printf(" eyeball");
break;
case 92:

# line 107 "jive.l"
			printf("scribble");
break;
case 93:

# line 108 "jive.l"
			printf("d");
break;
case 94:

# line 109 "jive.l"
			printf("D");
break;
case 95:

# line 110 "jive.l"
			printf("in'");
break;
case 96:

# line 111 "jive.l"
		printf(" some ");
break;
case 97:

# line 112 "jive.l"
		printf(" t'");
break;
case 98:

# line 113 "jive.l"
			printf("shun");
break;
case 99:

# line 114 "jive.l"
		printf(" mos' ");
break;
case 100:

# line 115 "jive.l"
		printf(" fum");
break;
case 101:

# line 116 "jive.l"
	printf(" cuz' ");
break;
case 102:

# line 117 "jive.l"
	printf("youse");
break;
case 103:

# line 118 "jive.l"
	printf("Youse");
break;
case 104:

# line 119 "jive.l"
		printf("coo'");
break;
case 105:

# line 120 "jive.l"
		printf("coo'");
break;
case 106:

# line 121 "jive.l"
		printf("a' ");
break;
case 107:

# line 122 "jive.l"
		printf("knode");
break;
case 108:

# line 123 "jive.l"
		printf("wants'");
break;
case 109:

# line 124 "jive.l"
		printf("whup'");
break;
case 110:

# line 125 "jive.l"
		printf("'sp");
break;
case 111:

# line 126 "jive.l"
		printf("'s");
break;
case 112:

# line 127 "jive.l"
		printf(" 's");
break;
case 113:

# line 128 "jive.l"
		printf(" 'es");
break;
case 114:

# line 129 "jive.l"
		printf("likes");
break;
case 115:

# line 130 "jive.l"
			printf("dun did");
break;
case 116:

# line 131 "jive.l"
		printf("kind'a");
break;
case 117:

# line 132 "jive.l"
			printf("honky chicks");
break;
case 118:

# line 133 "jive.l"
			printf(" dudes ");
break;
case 119:

# line 134 "jive.l"
		printf(" dudes ");
break;
case 120:

# line 135 "jive.l"
			printf(" dude ");
break;
case 121:

# line 136 "jive.l"
			printf("honky chick");
break;
case 122:

# line 137 "jive.l"
		printf("wasted");
break;
case 123:

# line 138 "jive.l"
		printf("baaaad");
break;
case 124:

# line 139 "jive.l"
			printf("jimmey ");
break;
case 125:

# line 140 "jive.l"
		printf("jimmey'd ");
break;
case 126:

# line 141 "jive.l"
			printf(" real");
break;
case 127:

# line 142 "jive.l"
			printf("puh'");
break;
case 128:

# line 143 "jive.l"
			printf("puh'");
break;
case 129:

# line 144 "jive.l"
			printf("o'");
break;
case 130:

# line 145 "jive.l"
			printf(" kin");
break;
case 131:

# line 146 "jive.l"
			printf("plum ");
break;
case 132:

# line 147 "jive.l"
		printf("Mo-town");
break;
case 133:

# line 148 "jive.l"
	printf("da' cave");
break;
case 134:

# line 149 "jive.l"
		printf(" recon'");
break;
case 135:

# line 150 "jive.l"
	printf("Nap-town");
break;
case 136:

# line 151 "jive.l"
		printf(" Buckwheat");
break;
case 137:

# line 152 "jive.l"
	printf(" Liva' Lips ");
break;
case 138:

# line 153 "jive.l"
	printf(" dat fine soul ");
break;
case 139:

# line 154 "jive.l"
	printf(" Amos ");
break;
case 140:

# line 155 "jive.l"
	printf("Leroy");
break;
case 141:

# line 156 "jive.l"
	printf("dat fine femahnaine ladee");
break;
case 142:

# line 157 "jive.l"
	printf("Raz'tus ");
break;
case 143:

# line 158 "jive.l"
	printf(" Fuh'rina");
break;
case 144:

# line 159 "jive.l"
	printf("Kingfish");
break;
case 145:

# line 160 "jive.l"
	printf("Issac");
break;
case 146:

# line 161 "jive.l"
	printf("Rolo");
break;
case 147:

# line 162 "jive.l"
	printf(" Bo-Jangles ");
break;
case 148:

# line 163 "jive.l"
	printf(" Snow Flake");
break;
case 149:

# line 164 "jive.l"
	printf("Remus");
break;
case 150:

# line 165 "jive.l"
		printf("liva' lips");
break;
case 151:

# line 166 "jive.l"
			printf("wiz'");
break;
case 152:

# line 167 "jive.l"
			printf("wiz'");
break;
case 153:

# line 168 "jive.l"
			printf("dat commie rag");
break;
case 154:

# line 169 "jive.l"
			printf("bugger'd");
break;
case 155:

# line 170 "jive.l"
		printf("funky ");
break;
case 156:

# line 171 "jive.l"
		printf("boogy ");
break;
case 157:

# line 172 "jive.l"
		printf(" crib");
break;
case 158:

# line 173 "jive.l"
			printf("ax'");
break;
case 159:

# line 174 "jive.l"
			printf(" so's ");
break;
case 160:

# line 175 "jive.l"
			printf("'haid");
break;
case 161:

# line 176 "jive.l"
			printf("main man");
break;
case 162:

# line 177 "jive.l"
			printf("mama");
break;
case 163:

# line 178 "jive.l"
			printf("sucka's");
break;
case 164:

# line 179 "jive.l"
			printf("bre'd");
break;
case 165:

# line 180 "jive.l"
	{	*(yytext+1) = ',';
				sprintf(buf, "%s dig dis:",yytext);
				printf(buf);
			}
break;
case 166:

# line 184 "jive.l"
			printf("begina'");
break;
case 167:

# line 185 "jive.l"
				printf("transista'");
break;
case 168:

# line 186 "jive.l"
			printf(" uh ");
break;
case 169:

# line 187 "jive.l"
			printf("whut");
break;
case 170:

# line 188 "jive.l"
			printf("duz");
break;
case 171:

# line 189 "jive.l"
			printf("wuz");
break;
case 172:

# line 190 "jive.l"
			printf(" wuz");
break;
case 173:

# line 191 "jive.l"
		printf("dig it");
break;
case 174:

# line 192 "jive.l"
		printf("dig it");
break;
case 175:

# line 193 "jive.l"
			printf(" mah'");
break;
case 176:

# line 194 "jive.l"
		printf(" ah' ");
break;
case 177:

# line 195 "jive.l"
			printf("meta-fuckin'");
break;
case 178:

# line 196 "jive.l"
		printf("fro");
break;
case 179:

# line 197 "jive.l"
		printf("rap");
break;
case 180:

# line 198 "jive.l"
		printf("beat");
break;
case 181:

# line 199 "jive.l"
	printf("hoop");
break;
case 182:

# line 200 "jive.l"
	printf("ball");
break;
case 183:

# line 201 "jive.l"
	printf("homey");
break;
case 184:

# line 202 "jive.l"
	printf("farm");
break;
case 185:

# line 203 "jive.l"
		printf("Man");
break;
case 186:

# line 204 "jive.l"
	printf("wanna");
break;
case 187:

# line 205 "jive.l"
	printf("be hankerin' aftah");
break;
case 188:

# line 206 "jive.l"
		printf("sheeit");
break;
case 189:

# line 207 "jive.l"
		printf("Sheeit");
break;
case 190:

# line 208 "jive.l"
		printf("big-ass");
break;
case 191:

# line 209 "jive.l"
		printf("bad-ass");
break;
case 192:

# line 210 "jive.l"
		printf("little-ass");
break;
case 193:

# line 211 "jive.l"
	printf("radical");
break;
case 194:

# line 212 "jive.l"
		printf(" be ");
break;
case 195:

# line 213 "jive.l"
		printf("booze");
break;
case 196:

# line 214 "jive.l"
		printf("scribblin'");
break;
case 197:

# line 215 "jive.l"
	printf("issue of GQ");
break;
case 198:

# line 216 "jive.l"
		printf("sheet");
break;
case 199:

# line 217 "jive.l"
		printf("down");
break;
case 200:

# line 218 "jive.l"
		printf("waaay down");
break;
case 201:

# line 219 "jive.l"
		printf("boogie");
break;
case 202:

# line 220 "jive.l"
		printf("'Sup, dude");
break;
case 203:

# line 221 "jive.l"
		printf("pink Cadillac");
break;
case 204:

# line 222 "jive.l"
		printf(yytext);
break;
case 205:

# line 223 "jive.l"
		printf("\n");
break;
case -1:
break;
default:
(void)fprintf(yyout,"bad switch yylook %d",nstr);
} return(0); }
/* end of yylex */

main()
{
	yylex();
}
int yyvstop[] = {
0,

204,
0,

205,
0,

204,
0,

55,
204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

204,
0,

202,
0,

94,
0,

28,
0,

165,
0,

29,
0,

30,
0,

31,
0,

71,
0,

32,
0,

93,
0,

33,
0,

199,
0,

34,
0,

176,
0,

96,
0,

113,
0,

175,
0,

26,
0,

203,
0,

87,
0,

158,
0,

191,
0,

190,
0,

56,
0,

115,
0,

106,
0,

110,
0,

111,
0,

83,
0,

95,
0,

129,
0,

127,
0,

171,
0,

86,
0,

130,
0,

112,
0,

37,
0,

52,
0,

194,
0,

168,
0,

159,
0,

97,
0,

27,
0,

41,
0,

35,
0,

6,
0,

189,
0,

81,
0,

109,
0,

196,
0,

161,
185,
0,

122,
0,

170,
0,

200,
0,

1,
0,

15,
0,

82,
0,

23,
0,

123,
0,

178,
0,

51,
0,

160,
0,

67,
0,

14,
0,

77,
0,

114,
0,

177,
0,

68,
0,

64,
0,

105,
0,

128,
0,

152,
0,

2,
0,

36,
0,

12,
0,

179,
0,

98,
0,

5,
0,

108,
0,

188,
0,

169,
0,

162,
0,

80,
0,

137,
0,

136,
0,

147,
0,

148,
0,

143,
0,

57,
0,

59,
0,

100,
0,

47,
0,

25,
0,

21,
120,
0,

118,
0,

69,
0,

91,
0,

48,
0,

126,
0,

172,
0,

145,
0,

142,
0,

149,
0,

141,
0,

4,
0,

201,
0,

13,
0,

58,
0,

88,
0,

131,
0,

107,
0,

16,
0,

164,
0,

180,
0,

124,
0,

198,
0,

167,
0,

192,
0,

7,
0,

195,
0,

62,
0,

39,
0,

22,
121,
0,

117,
0,

92,
0,

85,
0,

139,
0,

138,
0,

60,
0,

54,
0,

157,
0,

119,
0,

61,
0,

66,
0,

144,
0,

140,
0,

146,
0,

103,
0,

18,
0,

42,
0,

84,
0,

181,
0,

154,
0,

20,
0,

156,
0,

17,
0,

183,
0,

40,
0,

43,
0,

72,
0,

163,
0,

65,
0,

89,
0,

153,
0,

184,
0,

19,
0,

102,
0,

63,
0,

90,
0,

79,
0,

10,
0,

8,
0,

104,
0,

166,
0,

44,
0,

78,
0,

132,
0,

50,
0,

49,
0,

75,
0,

11,
0,

116,
0,

9,
0,

125,
0,

151,
0,

3,
0,

193,
0,

186,
0,

99,
0,

46,
0,

134,
0,

70,
0,

182,
0,

197,
0,

150,
0,

155,
0,

187,
0,

45,
0,

101,
0,

53,
0,

73,
0,

24,
0,

38,
0,

76,
0,

174,
0,

135,
0,

173,
0,

74,
0,

133,
0,
0};
# define YYTYPE int
struct yywork { YYTYPE verify, advance; } yycrank[] = {
0,0,	0,0,	1,3,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	1,4,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	1,5,	1,6,	0,0,	
0,0,	0,0,	50,179,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	1,7,	0,0,	
0,0,	0,0,	0,0,	0,0,	
11,76,	38,148,	43,160,	47,169,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
45,93,	38,93,	19,88,	1,8,	
0,0,	1,9,	0,0,	0,0,	
0,0,	1,10,	1,11,	1,12,	
0,0,	1,13,	1,14,	18,87,	
0,0,	1,3,	27,113,	1,15,	
1,16,	1,17,	1,18,	1,19,	
1,20,	24,93,	1,21,	0,0,	
0,0,	54,185,	27,93,	0,0,	
28,93,	0,0,	1,22,	1,23,	
1,24,	1,25,	1,26,	1,27,	
1,28,	1,29,	1,30,	1,31,	
1,32,	1,33,	1,34,	1,35,	
1,36,	1,37,	1,38,	1,39,	
1,40,	1,41,	1,42,	1,43,	
1,44,	1,45,	1,46,	1,47,	
2,5,	2,6,	7,72,	8,73,	
9,74,	10,75,	11,77,	12,79,	
13,80,	14,81,	15,82,	16,84,	
11,78,	2,7,	17,86,	20,89,	
21,90,	27,116,	24,105,	28,119,	
15,83,	33,93,	49,178,	27,117,	
52,182,	28,120,	27,118,	46,169,	
51,180,	56,190,	53,183,	16,85,	
5,48,	58,194,	35,133,	26,112,	
51,181,	53,184,	59,195,	46,93,	
2,10,	62,199,	32,93,	56,191,	
57,192,	54,186,	35,93,	65,205,	
60,196,	26,113,	22,91,	54,187,	
2,17,	2,18,	2,19,	2,20,	
25,106,	2,21,	61,179,	63,200,	
33,80,	26,93,	60,197,	63,201,	
22,92,	64,203,	5,49,	57,193,	
33,132,	64,204,	2,27,	2,28,	
2,29,	5,50,	5,51,	2,32,	
22,93,	5,52,	66,206,	2,36,	
5,53,	67,207,	25,93,	63,202,	
2,41,	35,138,	2,43,	2,44,	
2,45,	32,130,	2,47,	70,213,	
46,170,	35,139,	32,131,	23,92,	
71,214,	5,54,	5,55,	5,56,	
29,93,	5,57,	5,58,	5,59,	
5,60,	5,61,	5,51,	23,93,	
5,62,	5,63,	5,64,	5,65,	
5,66,	36,93,	5,67,	5,68,	
5,69,	26,114,	5,70,	5,71,	
72,215,	25,107,	37,93,	26,115,	
30,124,	25,108,	22,94,	22,95,	
73,217,	25,109,	31,124,	74,218,	
22,96,	22,97,	22,98,	25,110,	
30,93,	68,208,	25,111,	29,121,	
76,219,	61,198,	31,93,	29,122,	
68,209,	34,133,	23,99,	39,148,	
41,156,	68,210,	23,100,	69,211,	
36,140,	29,123,	23,101,	77,220,	
78,221,	34,93,	69,212,	39,93,	
23,102,	37,144,	36,141,	23,103,	
40,93,	37,145,	23,104,	36,142,	
42,160,	36,143,	79,222,	80,223,	
55,188,	48,48,	41,93,	37,146,	
81,224,	82,225,	37,147,	55,189,	
42,93,	84,228,	55,178,	85,229,	
87,230,	83,226,	72,216,	88,231,	
30,125,	31,128,	44,93,	89,232,	
90,233,	30,126,	30,127,	31,79,	
34,134,	83,227,	39,149,	91,234,	
34,135,	31,129,	39,82,	40,84,	
94,235,	40,150,	95,236,	40,151,	
96,238,	97,239,	34,136,	98,240,	
39,83,	41,157,	101,245,	40,152,	
34,137,	40,153,	104,250,	105,251,	
41,158,	41,159,	40,154,	40,155,	
102,246,	100,243,	99,241,	100,244,	
102,247,	44,163,	106,252,	108,254,	
42,161,	44,164,	42,162,	109,256,	
44,165,	44,166,	48,171,	48,172,	
48,173,	99,242,	48,174,	44,167,	
48,59,	48,175,	44,168,	111,260,	
103,248,	112,261,	108,255,	48,64,	
107,253,	48,176,	110,257,	48,67,	
48,177,	48,69,	103,249,	114,262,	
107,218,	115,263,	116,265,	110,258,	
115,264,	118,269,	119,270,	117,267,	
116,266,	120,271,	121,274,	95,237,	
110,259,	117,268,	120,272,	122,276,	
120,273,	123,277,	125,220,	126,280,	
127,281,	125,278,	128,282,	121,275,	
125,279,	129,283,	130,284,	131,286,	
130,285,	132,288,	134,289,	135,290,	
136,292,	137,295,	138,296,	135,291,	
136,293,	131,287,	139,297,	140,298,	
141,299,	142,300,	136,294,	144,301,	
145,302,	147,307,	146,304,	145,303,	
146,305,	147,308,	146,306,	149,311,	
150,312,	147,309,	151,313,	152,314,	
153,315,	154,317,	155,318,	147,310,	
156,319,	153,316,	157,320,	157,321,	
159,322,	161,323,	163,325,	164,328,	
165,330,	166,332,	161,324,	163,326,	
163,327,	167,334,	164,329,	166,333,	
165,331,	168,335,	170,336,	171,185,	
172,337,	173,338,	174,192,	175,339,	
176,340,	177,208,	178,341,	172,189,	
180,342,	181,343,	182,344,	183,345,	
184,346,	185,185,	186,347,	187,348,	
188,349,	177,210,	189,351,	190,352,	
191,354,	192,355,	193,356,	190,353,	
194,357,	188,350,	195,358,	196,359,	
196,360,	197,361,	198,362,	199,363,	
200,364,	201,365,	203,366,	204,367,	
200,344,	205,368,	206,369,	206,345,	
207,370,	208,371,	209,372,	210,373,	
211,374,	212,375,	213,376,	214,377,	
216,378,	217,379,	218,380,	219,381,	
220,382,	221,383,	222,384,	223,385,	
224,386,	225,387,	226,388,	227,389,	
228,390,	229,391,	230,392,	232,393,	
233,394,	234,396,	235,397,	236,398,	
237,399,	238,400,	240,402,	242,403,	
243,404,	244,405,	246,406,	171,186,	
247,407,	248,408,	249,409,	251,410,	
252,412,	253,413,	254,414,	255,415,	
257,416,	258,417,	259,418,	260,419,	
261,420,	265,421,	251,411,	266,422,	
267,423,	268,425,	269,426,	270,427,	
271,428,	272,429,	273,430,	274,431,	
267,424,	275,432,	276,433,	277,434,	
279,435,	280,436,	281,437,	282,438,	
283,439,	284,440,	285,441,	286,442,	
287,443,	288,444,	289,445,	290,446,	
291,447,	292,448,	293,449,	294,450,	
295,451,	296,452,	297,453,	299,454,	
300,455,	301,456,	302,457,	303,458,	
304,460,	305,461,	306,462,	307,463,	
308,464,	309,465,	310,466,	311,467,	
312,468,	313,469,	314,470,	233,395,	
315,471,	316,472,	317,473,	318,474,	
319,475,	303,459,	320,476,	238,401,	
321,477,	322,478,	323,479,	324,480,	
325,481,	327,482,	328,483,	329,484,	
330,485,	331,486,	332,487,	333,488,	
334,489,	335,491,	336,492,	337,349,	
334,490,	338,353,	339,360,	340,369,	
341,495,	342,496,	343,497,	344,498,	
345,500,	346,501,	347,502,	348,503,	
349,504,	350,505,	351,506,	353,507,	
354,508,	355,509,	357,510,	360,511,	
361,512,	344,499,	363,513,	364,514,	
365,515,	366,517,	367,518,	369,519,	
370,520,	371,521,	373,522,	374,523,	
376,524,	377,525,	379,526,	380,527,	
382,528,	383,529,	384,530,	385,531,	
386,532,	387,533,	388,534,	389,535,	
390,536,	394,537,	396,538,	397,539,	
398,540,	399,541,	400,542,	401,543,	
402,544,	403,545,	405,546,	408,547,	
409,548,	410,549,	411,550,	412,551,	
413,552,	415,553,	417,554,	419,555,	
420,556,	422,557,	424,558,	426,559,	
429,560,	336,493,	430,561,	432,562,	
435,564,	336,494,	436,565,	437,566,	
439,567,	440,568,	441,569,	443,570,	
445,571,	447,572,	448,573,	449,574,	
450,575,	451,576,	455,577,	456,579,	
457,580,	459,581,	460,582,	461,583,	
463,584,	464,585,	465,586,	466,587,	
467,588,	468,589,	470,590,	471,591,	
472,592,	473,593,	475,594,	476,595,	
479,596,	481,597,	482,599,	365,516,	
484,600,	486,601,	488,602,	489,603,	
490,604,	491,605,	492,606,	493,607,	
498,608,	501,609,	502,610,	503,611,	
504,612,	505,613,	506,614,	508,615,	
512,616,	516,617,	517,618,	518,619,	
522,620,	523,621,	526,622,	528,623,	
529,624,	532,625,	533,626,	534,627,	
535,628,	537,629,	538,630,	539,631,	
540,632,	541,633,	542,634,	543,635,	
545,636,	546,637,	548,638,	549,639,	
550,640,	432,563,	551,641,	552,642,	
553,643,	556,644,	558,645,	455,578,	
559,646,	560,647,	561,648,	562,649,	
563,650,	564,651,	565,652,	566,653,	
568,654,	569,655,	571,656,	572,657,	
574,658,	578,659,	580,660,	581,661,	
582,662,	583,663,	584,664,	585,665,	
586,666,	587,667,	589,668,	591,669,	
592,670,	593,671,	594,672,	596,673,	
597,674,	598,675,	600,676,	602,677,	
481,598,	606,678,	610,679,	611,680,	
612,681,	613,682,	619,683,	620,684,	
622,685,	623,686,	624,687,	625,688,	
631,689,	633,690,	634,691,	637,692,	
639,693,	640,694,	643,695,	645,696,	
648,697,	649,698,	650,699,	651,700,	
653,701,	655,702,	656,703,	657,704,	
658,705,	659,706,	663,707,	665,708,	
666,709,	667,710,	669,711,	670,712,	
671,713,	673,714,	674,715,	675,716,	
676,717,	677,718,	679,719,	680,720,	
681,721,	682,722,	686,723,	693,724,	
694,725,	696,726,	697,727,	703,728,	
705,729,	708,730,	709,731,	711,732,	
713,733,	714,734,	716,735,	717,736,	
718,737,	720,738,	721,739,	723,740,	
724,741,	727,742,	730,743,	731,744,	
732,745,	734,746,	736,747,	737,748,	
740,749,	742,750,	744,751,	746,752,	
747,753,	749,754,	751,755,	752,756,	
753,757,	754,758,	755,759,	756,760,	
757,761,	759,762,	760,763,	761,764,	
762,765,	764,766,	766,767,	767,768,	
0,0};
struct yysvf yysvec[] = {
0,	0,	0,
yycrank+-1,	0,		0,	
yycrank+-92,	yysvec+1,	0,	
yycrank+0,	0,		yyvstop+1,
yycrank+0,	0,		yyvstop+3,
yycrank+124,	0,		yyvstop+5,
yycrank+0,	0,		yyvstop+7,
yycrank+15,	0,		yyvstop+10,
yycrank+26,	0,		yyvstop+12,
yycrank+31,	0,		yyvstop+14,
yycrank+24,	0,		yyvstop+16,
yycrank+20,	0,		yyvstop+18,
yycrank+20,	0,		yyvstop+20,
yycrank+35,	0,		yyvstop+22,
yycrank+32,	0,		yyvstop+24,
yycrank+33,	0,		yyvstop+26,
yycrank+38,	0,		yyvstop+28,
yycrank+34,	0,		yyvstop+30,
yycrank+1,	0,		yyvstop+32,
yycrank+1,	0,		yyvstop+34,
yycrank+38,	0,		yyvstop+36,
yycrank+29,	0,		yyvstop+38,
yycrank+142,	0,		yyvstop+40,
yycrank+173,	0,		yyvstop+42,
yycrank+31,	0,		yyvstop+44,
yycrank+148,	0,		yyvstop+46,
yycrank+127,	0,		yyvstop+48,
yycrank+36,	0,		yyvstop+50,
yycrank+38,	0,		yyvstop+52,
yycrank+166,	0,		yyvstop+54,
yycrank+202,	0,		yyvstop+56,
yycrank+208,	0,		yyvstop+58,
yycrank+108,	0,		yyvstop+60,
yycrank+87,	0,		yyvstop+62,
yycrank+223,	0,		yyvstop+64,
yycrank+112,	0,		yyvstop+66,
yycrank+179,	0,		yyvstop+68,
yycrank+188,	0,		yyvstop+70,
yycrank+7,	0,		yyvstop+72,
yycrank+225,	0,		yyvstop+74,
yycrank+230,	0,		yyvstop+76,
yycrank+240,	0,		yyvstop+78,
yycrank+246,	0,		yyvstop+80,
yycrank+8,	yysvec+38,	yyvstop+82,
yycrank+256,	0,		yyvstop+84,
yycrank+6,	0,		yyvstop+86,
yycrank+105,	0,		yyvstop+88,
yycrank+9,	yysvec+38,	yyvstop+90,
yycrank+265,	0,		0,	
yycrank+35,	0,		0,	
yycrank+6,	0,		0,	
yycrank+55,	0,		0,	
yycrank+51,	0,		0,	
yycrank+57,	0,		0,	
yycrank+61,	0,		0,	
yycrank+195,	0,		0,	
yycrank+56,	0,		0,	
yycrank+71,	0,		0,	
yycrank+43,	0,		0,	
yycrank+61,	0,		0,	
yycrank+75,	0,		0,	
yycrank+150,	0,		0,	
yycrank+60,	0,		0,	
yycrank+86,	0,		0,	
yycrank+88,	0,		0,	
yycrank+69,	0,		0,	
yycrank+105,	yysvec+53,	0,	
yycrank+104,	0,		0,	
yycrank+157,	0,		0,	
yycrank+171,	0,		0,	
yycrank+114,	0,		0,	
yycrank+119,	0,		0,	
yycrank+199,	0,		0,	
yycrank+153,	0,		0,	
yycrank+137,	0,		0,	
yycrank+0,	0,		yyvstop+92,
yycrank+167,	0,		0,	
yycrank+179,	0,		0,	
yycrank+183,	0,		0,	
yycrank+190,	0,		0,	
yycrank+181,	0,		0,	
yycrank+180,	0,		0,	
yycrank+204,	0,		0,	
yycrank+211,	0,		0,	
yycrank+195,	0,		0,	
yycrank+193,	0,		0,	
yycrank+0,	0,		yyvstop+94,
yycrank+235,	0,		0,	
yycrank+223,	0,		0,	
yycrank+207,	0,		0,	
yycrank+199,	0,		0,	
yycrank+207,	0,		0,	
yycrank+0,	0,		yyvstop+96,
yycrank+0,	0,		yyvstop+98,
yycrank+214,	0,		0,	
yycrank+298,	0,		0,	
yycrank+231,	0,		0,	
yycrank+226,	0,		0,	
yycrank+227,	0,		0,	
yycrank+250,	0,		0,	
yycrank+252,	0,		0,	
yycrank+235,	0,		0,	
yycrank+237,	0,		0,	
yycrank+271,	0,		0,	
yycrank+221,	0,		0,	
yycrank+234,	0,		0,	
yycrank+238,	0,		0,	
yycrank+266,	0,		0,	
yycrank+258,	0,		0,	
yycrank+259,	0,		0,	
yycrank+277,	0,		0,	
yycrank+266,	0,		0,	
yycrank+257,	0,		0,	
yycrank+0,	0,		yyvstop+100,
yycrank+351,	0,		0,	
yycrank+273,	0,		0,	
yycrank+278,	0,		0,	
yycrank+280,	0,		0,	
yycrank+284,	0,		0,	
yycrank+276,	0,		0,	
yycrank+282,	0,		0,	
yycrank+289,	0,		0,	
yycrank+302,	0,		0,	
yycrank+292,	0,		0,	
yycrank+0,	0,		yyvstop+102,
yycrank+302,	0,		0,	
yycrank+371,	0,		0,	
yycrank+307,	0,		0,	
yycrank+288,	0,		0,	
yycrank+294,	0,		0,	
yycrank+302,	0,		0,	
yycrank+310,	0,		0,	
yycrank+306,	0,		0,	
yycrank+0,	0,		yyvstop+104,
yycrank+311,	0,		0,	
yycrank+299,	0,		0,	
yycrank+316,	0,		0,	
yycrank+302,	0,		0,	
yycrank+309,	0,		0,	
yycrank+323,	0,		0,	
yycrank+309,	0,		0,	
yycrank+327,	0,		0,	
yycrank+324,	0,		0,	
yycrank+0,	0,		yyvstop+106,
yycrank+315,	0,		0,	
yycrank+317,	0,		0,	
yycrank+322,	0,		0,	
yycrank+332,	0,		0,	
yycrank+0,	0,		yyvstop+108,
yycrank+335,	0,		0,	
yycrank+332,	0,		0,	
yycrank+328,	0,		0,	
yycrank+342,	0,		0,	
yycrank+331,	0,		0,	
yycrank+327,	0,		0,	
yycrank+328,	0,		0,	
yycrank+328,	0,		0,	
yycrank+339,	0,		0,	
yycrank+0,	0,		yyvstop+110,
yycrank+337,	0,		0,	
yycrank+0,	0,		yyvstop+112,
yycrank+349,	0,		0,	
yycrank+0,	0,		yyvstop+114,
yycrank+340,	0,		0,	
yycrank+343,	0,		0,	
yycrank+355,	0,		0,	
yycrank+351,	0,		0,	
yycrank+348,	0,		0,	
yycrank+356,	0,		0,	
yycrank+0,	0,		yyvstop+116,
yycrank+345,	0,		0,	
yycrank+431,	0,		0,	
yycrank+363,	0,		0,	
yycrank+368,	yysvec+56,	0,	
yycrank+369,	0,		0,	
yycrank+370,	0,		0,	
yycrank+371,	0,		0,	
yycrank+365,	0,		0,	
yycrank+372,	0,		0,	
yycrank+0,	0,		yyvstop+118,
yycrank+373,	0,		0,	
yycrank+364,	0,		0,	
yycrank+360,	0,		0,	
yycrank+358,	0,		0,	
yycrank+371,	0,		0,	
yycrank+445,	0,		yyvstop+120,
yycrank+369,	0,		0,	
yycrank+378,	0,		0,	
yycrank+381,	0,		0,	
yycrank+385,	0,		0,	
yycrank+373,	0,		0,	
yycrank+375,	0,		0,	
yycrank+369,	0,		0,	
yycrank+387,	0,		yyvstop+122,
yycrank+377,	0,		0,	
yycrank+374,	0,		0,	
yycrank+376,	0,		0,	
yycrank+376,	0,		0,	
yycrank+462,	0,		0,	
yycrank+394,	0,		0,	
yycrank+386,	0,		0,	
yycrank+387,	0,		0,	
yycrank+0,	0,		yyvstop+124,
yycrank+395,	0,		0,	
yycrank+396,	0,		0,	
yycrank+469,	0,		0,	
yycrank+386,	0,		0,	
yycrank+407,	0,		0,	
yycrank+394,	0,		0,	
yycrank+474,	0,		0,	
yycrank+393,	0,		0,	
yycrank+403,	0,		0,	
yycrank+477,	0,		0,	
yycrank+396,	0,		0,	
yycrank+397,	0,		0,	
yycrank+0,	0,		yyvstop+126,
yycrank+467,	0,		0,	
yycrank+416,	0,		0,	
yycrank+409,	0,		0,	
yycrank+406,	0,		0,	
yycrank+411,	0,		0,	
yycrank+409,	0,		0,	
yycrank+408,	0,		0,	
yycrank+405,	0,		0,	
yycrank+415,	0,		0,	
yycrank+418,	0,		0,	
yycrank+421,	0,		0,	
yycrank+426,	0,		0,	
yycrank+424,	0,		0,	
yycrank+424,	0,		0,	
yycrank+438,	0,		0,	
yycrank+0,	0,		yyvstop+128,
yycrank+419,	0,		0,	
yycrank+489,	0,		yyvstop+130,
yycrank+425,	0,		0,	
yycrank+425,	0,		0,	
yycrank+421,	0,		0,	
yycrank+416,	0,		0,	
yycrank+501,	0,		0,	
yycrank+0,	0,		yyvstop+132,
yycrank+437,	0,		0,	
yycrank+0,	0,		yyvstop+134,
yycrank+428,	0,		0,	
yycrank+420,	0,		0,	
yycrank+440,	0,		0,	
yycrank+0,	0,		yyvstop+136,
yycrank+431,	0,		0,	
yycrank+425,	0,		0,	
yycrank+444,	0,		0,	
yycrank+435,	0,		0,	
yycrank+0,	0,		yyvstop+138,
yycrank+442,	0,		0,	
yycrank+440,	0,		0,	
yycrank+446,	0,		0,	
yycrank+446,	0,		0,	
yycrank+433,	0,		0,	
yycrank+0,	0,		yyvstop+140,
yycrank+433,	0,		0,	
yycrank+510,	0,		0,	
yycrank+440,	0,		0,	
yycrank+433,	0,		0,	
yycrank+448,	0,		0,	
yycrank+0,	0,		yyvstop+142,
yycrank+0,	0,		yyvstop+144,
yycrank+0,	0,		yyvstop+146,
yycrank+452,	0,		0,	
yycrank+440,	0,		0,	
yycrank+448,	0,		0,	
yycrank+443,	0,		0,	
yycrank+457,	0,		0,	
yycrank+451,	0,		0,	
yycrank+460,	0,		0,	
yycrank+529,	0,		yyvstop+148,
yycrank+461,	0,		0,	
yycrank+449,	0,		0,	
yycrank+464,	0,		0,	
yycrank+466,	0,		0,	
yycrank+466,	0,		0,	
yycrank+0,	0,		yyvstop+150,
yycrank+451,	0,		0,	
yycrank+459,	0,		0,	
yycrank+462,	0,		0,	
yycrank+470,	0,		0,	
yycrank+456,	0,		0,	
yycrank+465,	0,		0,	
yycrank+474,	0,		0,	
yycrank+456,	0,		0,	
yycrank+457,	0,		0,	
yycrank+476,	0,		0,	
yycrank+481,	0,		0,	
yycrank+482,	0,		0,	
yycrank+475,	0,		0,	
yycrank+480,	0,		0,	
yycrank+485,	0,		0,	
yycrank+482,	0,		0,	
yycrank+479,	0,		0,	
yycrank+484,	0,		0,	
yycrank+485,	0,		0,	
yycrank+0,	0,		yyvstop+152,
yycrank+466,	0,		0,	
yycrank+478,	0,		0,	
yycrank+488,	0,		0,	
yycrank+478,	0,		0,	
yycrank+494,	0,		yyvstop+154,
yycrank+487,	0,		0,	
yycrank+477,	0,		0,	
yycrank+493,	0,		0,	
yycrank+477,	0,		0,	
yycrank+481,	0,		0,	
yycrank+488,	0,		0,	
yycrank+495,	0,		0,	
yycrank+494,	0,		0,	
yycrank+489,	0,		0,	
yycrank+501,	0,		0,	
yycrank+494,	0,		0,	
yycrank+503,	0,		0,	
yycrank+489,	0,		0,	
yycrank+509,	0,		0,	
yycrank+506,	0,		0,	
yycrank+504,	0,		0,	
yycrank+509,	0,		0,	
yycrank+505,	0,		0,	
yycrank+503,	0,		0,	
yycrank+513,	0,		0,	
yycrank+495,	0,		0,	
yycrank+500,	0,		0,	
yycrank+0,	0,		yyvstop+156,
yycrank+516,	0,		0,	
yycrank+510,	0,		0,	
yycrank+503,	0,		0,	
yycrank+504,	0,		0,	
yycrank+505,	0,		0,	
yycrank+521,	0,		0,	
yycrank+515,	0,		0,	
yycrank+527,	0,		0,	
yycrank+509,	0,		0,	
yycrank+587,	0,		yyvstop+158,
yycrank+528,	0,		0,	
yycrank+515,	0,		0,	
yycrank+514,	0,		0,	
yycrank+515,	0,		0,	
yycrank+600,	0,		0,	
yycrank+526,	0,		0,	
yycrank+602,	0,		0,	
yycrank+528,	0,		0,	
yycrank+528,	0,		0,	
yycrank+529,	0,		0,	
yycrank+527,	0,		0,	
yycrank+607,	0,		0,	
yycrank+543,	0,		0,	
yycrank+536,	0,		0,	
yycrank+543,	0,		0,	
yycrank+0,	0,		yyvstop+160,
yycrank+611,	0,		0,	
yycrank+543,	0,		0,	
yycrank+613,	0,		0,	
yycrank+0,	0,		yyvstop+162,
yycrank+537,	0,		0,	
yycrank+0,	0,		yyvstop+164,
yycrank+0,	0,		yyvstop+166,
yycrank+615,	0,		0,	
yycrank+533,	0,		0,	
yycrank+0,	0,		yyvstop+168,
yycrank+618,	0,		0,	
yycrank+619,	0,		0,	
yycrank+620,	0,		0,	
yycrank+539,	0,		0,	
yycrank+551,	0,		0,	
yycrank+0,	0,		yyvstop+170,
yycrank+551,	0,		0,	
yycrank+556,	0,		0,	
yycrank+556,	0,		0,	
yycrank+0,	0,		yyvstop+172,
yycrank+553,	0,		0,	
yycrank+549,	0,		0,	
yycrank+0,	yysvec+212,	yyvstop+174,
yycrank+539,	0,		0,	
yycrank+560,	0,		0,	
yycrank+0,	0,		yyvstop+176,
yycrank+545,	0,		0,	
yycrank+563,	0,		0,	
yycrank+0,	0,		yyvstop+178,
yycrank+567,	0,		0,	
yycrank+560,	0,		0,	
yycrank+634,	0,		0,	
yycrank+546,	0,		0,	
yycrank+569,	0,		0,	
yycrank+572,	0,		0,	
yycrank+556,	0,		0,	
yycrank+563,	0,		0,	
yycrank+551,	0,		0,	
yycrank+0,	0,		yyvstop+180,
yycrank+0,	0,		yyvstop+182,
yycrank+0,	0,		yyvstop+184,
yycrank+559,	0,		0,	
yycrank+0,	0,		yyvstop+186,
yycrank+573,	0,		0,	
yycrank+572,	0,		0,	
yycrank+565,	0,		0,	
yycrank+576,	0,		0,	
yycrank+568,	0,		0,	
yycrank+640,	0,		0,	
yycrank+565,	0,		0,	
yycrank+580,	0,		0,	
yycrank+0,	0,		yyvstop+188,
yycrank+565,	0,		0,	
yycrank+0,	0,		yyvstop+190,
yycrank+0,	0,		yyvstop+192,
yycrank+576,	0,		0,	
yycrank+583,	0,		0,	
yycrank+653,	0,		0,	
yycrank+569,	0,		0,	
yycrank+586,	0,		0,	
yycrank+587,	0,		0,	
yycrank+0,	0,		yyvstop+195,
yycrank+578,	0,		0,	
yycrank+0,	0,		yyvstop+197,
yycrank+574,	0,		0,	
yycrank+0,	0,		yyvstop+199,
yycrank+590,	0,		0,	
yycrank+591,	0,		0,	
yycrank+0,	0,		yyvstop+201,
yycrank+577,	0,		0,	
yycrank+0,	0,		yyvstop+203,
yycrank+596,	0,		0,	
yycrank+0,	0,		yyvstop+205,
yycrank+585,	0,		0,	
yycrank+0,	0,		yyvstop+207,
yycrank+0,	0,		yyvstop+209,
yycrank+580,	0,		0,	
yycrank+584,	0,		0,	
yycrank+0,	0,		yyvstop+211,
yycrank+667,	0,		yyvstop+213,
yycrank+0,	0,		yyvstop+215,
yycrank+0,	0,		yyvstop+217,
yycrank+586,	0,		0,	
yycrank+591,	0,		0,	
yycrank+598,	0,		0,	
yycrank+0,	0,		yyvstop+219,
yycrank+672,	0,		0,	
yycrank+604,	0,		0,	
yycrank+674,	0,		0,	
yycrank+0,	0,		yyvstop+221,
yycrank+597,	0,		0,	
yycrank+0,	0,		yyvstop+223,
yycrank+586,	0,		0,	
yycrank+0,	0,		yyvstop+225,
yycrank+610,	0,		0,	
yycrank+601,	0,		0,	
yycrank+602,	0,		0,	
yycrank+591,	0,		0,	
yycrank+614,	0,		0,	
yycrank+0,	0,		yyvstop+227,
yycrank+0,	0,		yyvstop+229,
yycrank+0,	0,		yyvstop+231,
yycrank+682,	0,		0,	
yycrank+601,	0,		0,	
yycrank+608,	0,		0,	
yycrank+0,	0,		yyvstop+233,
yycrank+606,	0,		0,	
yycrank+619,	0,		0,	
yycrank+614,	0,		0,	
yycrank+0,	0,		yyvstop+235,
yycrank+620,	0,		0,	
yycrank+616,	0,		0,	
yycrank+621,	0,		0,	
yycrank+609,	0,		0,	
yycrank+613,	0,		0,	
yycrank+614,	0,		0,	
yycrank+0,	0,		yyvstop+237,
yycrank+618,	0,		0,	
yycrank+611,	0,		0,	
yycrank+696,	0,		0,	
yycrank+619,	0,		0,	
yycrank+0,	0,		yyvstop+239,
yycrank+629,	0,		0,	
yycrank+616,	0,		yyvstop+241,
yycrank+0,	0,		yyvstop+243,
yycrank+0,	0,		yyvstop+245,
yycrank+618,	0,		0,	
yycrank+0,	0,		yyvstop+247,
yycrank+701,	0,		yyvstop+249,
yycrank+620,	0,		0,	
yycrank+0,	0,		yyvstop+251,
yycrank+635,	0,		0,	
yycrank+0,	0,		yyvstop+253,
yycrank+636,	0,		0,	
yycrank+0,	0,		yyvstop+255,
yycrank+706,	0,		0,	
yycrank+629,	0,		0,	
yycrank+630,	0,		0,	
yycrank+640,	0,		0,	
yycrank+628,	0,		0,	
yycrank+640,	0,		0,	
yycrank+0,	0,		yyvstop+257,
yycrank+0,	0,		yyvstop+259,
yycrank+0,	0,		yyvstop+261,
yycrank+0,	0,		yyvstop+263,
yycrank+712,	0,		0,	
yycrank+0,	0,		yyvstop+265,
yycrank+0,	0,		yyvstop+267,
yycrank+713,	0,		0,	
yycrank+631,	0,		0,	
yycrank+626,	0,		0,	
yycrank+631,	0,		0,	
yycrank+648,	0,		0,	
yycrank+643,	0,		0,	
yycrank+0,	yysvec+353,	yyvstop+269,
yycrank+719,	0,		0,	
yycrank+0,	yysvec+355,	yyvstop+271,
yycrank+0,	0,		yyvstop+273,
yycrank+0,	yysvec+360,	yyvstop+275,
yycrank+651,	0,		0,	
yycrank+0,	0,		yyvstop+277,
yycrank+0,	0,		yyvstop+279,
yycrank+0,	0,		yyvstop+282,
yycrank+721,	0,		0,	
yycrank+643,	0,		0,	
yycrank+654,	0,		0,	
yycrank+0,	0,		yyvstop+284,
yycrank+0,	0,		yyvstop+286,
yycrank+0,	0,		yyvstop+288,
yycrank+646,	0,		0,	
yycrank+654,	0,		0,	
yycrank+0,	0,		yyvstop+290,
yycrank+0,	0,		yyvstop+292,
yycrank+643,	0,		0,	
yycrank+0,	0,		yyvstop+294,
yycrank+649,	0,		0,	
yycrank+663,	0,		0,	
yycrank+0,	0,		yyvstop+296,
yycrank+0,	0,		yyvstop+298,
yycrank+664,	0,		0,	
yycrank+652,	0,		0,	
yycrank+647,	0,		0,	
yycrank+664,	0,		0,	
yycrank+0,	0,		yyvstop+300,
yycrank+664,	0,		0,	
yycrank+734,	0,		0,	
yycrank+663,	0,		0,	
yycrank+652,	0,		0,	
yycrank+652,	0,		0,	
yycrank+659,	0,		0,	
yycrank+655,	0,		0,	
yycrank+0,	0,		yyvstop+302,
yycrank+656,	0,		0,	
yycrank+658,	0,		0,	
yycrank+0,	0,		yyvstop+304,
yycrank+664,	0,		0,	
yycrank+664,	0,		0,	
yycrank+660,	0,		0,	
yycrank+746,	0,		0,	
yycrank+747,	0,		0,	
yycrank+675,	0,		0,	
yycrank+0,	0,		yyvstop+306,
yycrank+0,	0,		yyvstop+308,
yycrank+749,	0,		0,	
yycrank+0,	0,		yyvstop+310,
yycrank+685,	0,		0,	
yycrank+684,	0,		0,	
yycrank+674,	0,		0,	
yycrank+676,	0,		0,	
yycrank+671,	0,		0,	
yycrank+749,	0,		0,	
yycrank+688,	0,		0,	
yycrank+674,	0,		0,	
yycrank+694,	0,		0,	
yycrank+0,	0,		yyvstop+312,
yycrank+692,	0,		0,	
yycrank+682,	0,		0,	
yycrank+0,	0,		yyvstop+314,
yycrank+689,	0,		0,	
yycrank+698,	0,		0,	
yycrank+0,	0,		yyvstop+316,
yycrank+687,	0,		0,	
yycrank+0,	0,		yyvstop+318,
yycrank+0,	0,		yyvstop+320,
yycrank+0,	0,		yyvstop+322,
yycrank+697,	0,		0,	
yycrank+0,	0,		yyvstop+324,
yycrank+697,	0,		0,	
yycrank+689,	0,		0,	
yycrank+699,	0,		0,	
yycrank+699,	0,		0,	
yycrank+705,	0,		0,	
yycrank+703,	0,		0,	
yycrank+772,	0,		0,	
yycrank+708,	0,		0,	
yycrank+0,	0,		yyvstop+326,
yycrank+698,	0,		0,	
yycrank+0,	0,		yyvstop+328,
yycrank+703,	0,		0,	
yycrank+697,	0,		0,	
yycrank+706,	0,		0,	
yycrank+778,	0,		0,	
yycrank+0,	0,		yyvstop+330,
yycrank+696,	0,		0,	
yycrank+696,	0,		0,	
yycrank+781,	0,		0,	
yycrank+0,	0,		yyvstop+332,
yycrank+700,	0,		0,	
yycrank+0,	0,		yyvstop+334,
yycrank+711,	0,		yyvstop+336,
yycrank+0,	0,		yyvstop+338,
yycrank+0,	0,		yyvstop+341,
yycrank+0,	0,		yyvstop+343,
yycrank+716,	0,		0,	
yycrank+0,	0,		yyvstop+345,
yycrank+0,	0,		yyvstop+347,
yycrank+0,	0,		yyvstop+349,
yycrank+702,	0,		0,	
yycrank+708,	0,		0,	
yycrank+705,	0,		0,	
yycrank+703,	0,		0,	
yycrank+0,	0,		yyvstop+351,
yycrank+0,	yysvec+508,	yyvstop+353,
yycrank+0,	0,		yyvstop+355,
yycrank+0,	0,		yyvstop+357,
yycrank+0,	0,		yyvstop+359,
yycrank+708,	0,		0,	
yycrank+720,	0,		0,	
yycrank+0,	0,		yyvstop+361,
yycrank+723,	0,		0,	
yycrank+728,	0,		0,	
yycrank+716,	0,		0,	
yycrank+717,	0,		0,	
yycrank+0,	0,		yyvstop+363,
yycrank+0,	0,		yyvstop+365,
yycrank+0,	0,		yyvstop+367,
yycrank+0,	0,		yyvstop+369,
yycrank+0,	0,		yyvstop+371,
yycrank+712,	0,		0,	
yycrank+0,	0,		yyvstop+373,
yycrank+715,	0,		0,	
yycrank+714,	0,		0,	
yycrank+0,	0,		yyvstop+375,
yycrank+0,	0,		yyvstop+377,
yycrank+730,	0,		0,	
yycrank+0,	0,		yyvstop+379,
yycrank+714,	0,		0,	
yycrank+732,	0,		0,	
yycrank+0,	0,		yyvstop+381,
yycrank+0,	0,		yyvstop+383,
yycrank+718,	0,		0,	
yycrank+0,	0,		yyvstop+385,
yycrank+727,	0,		0,	
yycrank+0,	0,		yyvstop+387,
yycrank+0,	0,		yyvstop+389,
yycrank+727,	0,		0,	
yycrank+726,	0,		0,	
yycrank+722,	0,		0,	
yycrank+739,	0,		0,	
yycrank+0,	0,		yyvstop+391,
yycrank+730,	0,		0,	
yycrank+0,	0,		yyvstop+393,
yycrank+739,	0,		0,	
yycrank+732,	0,		0,	
yycrank+733,	0,		0,	
yycrank+743,	0,		0,	
yycrank+813,	0,		0,	
yycrank+0,	0,		yyvstop+395,
yycrank+0,	0,		yyvstop+397,
yycrank+0,	0,		yyvstop+399,
yycrank+744,	0,		0,	
yycrank+0,	0,		yyvstop+401,
yycrank+746,	0,		0,	
yycrank+739,	0,		0,	
yycrank+740,	0,		0,	
yycrank+0,	0,		yyvstop+403,
yycrank+745,	0,		0,	
yycrank+749,	0,		0,	
yycrank+751,	0,		0,	
yycrank+0,	0,		yyvstop+405,
yycrank+737,	0,		0,	
yycrank+743,	0,		0,	
yycrank+739,	0,		0,	
yycrank+746,	0,		0,	
yycrank+760,	0,		0,	
yycrank+0,	0,		yyvstop+407,
yycrank+826,	0,		0,	
yycrank+742,	0,		0,	
yycrank+759,	0,		0,	
yycrank+760,	0,		0,	
yycrank+0,	0,		yyvstop+409,
yycrank+0,	0,		yyvstop+411,
yycrank+0,	0,		yyvstop+413,
yycrank+750,	0,		0,	
yycrank+0,	0,		yyvstop+415,
yycrank+0,	0,		yyvstop+417,
yycrank+0,	0,		yyvstop+419,
yycrank+0,	0,		yyvstop+421,
yycrank+0,	0,		yyvstop+423,
yycrank+0,	0,		yyvstop+425,
yycrank+762,	0,		0,	
yycrank+750,	0,		0,	
yycrank+0,	0,		yyvstop+427,
yycrank+757,	0,		0,	
yycrank+765,	0,		0,	
yycrank+0,	0,		yyvstop+429,
yycrank+0,	0,		yyvstop+431,
yycrank+0,	0,		yyvstop+433,
yycrank+0,	0,		yyvstop+435,
yycrank+0,	0,		yyvstop+437,
yycrank+766,	0,		0,	
yycrank+0,	0,		yyvstop+439,
yycrank+768,	0,		0,	
yycrank+0,	0,		yyvstop+441,
yycrank+0,	0,		yyvstop+443,
yycrank+759,	0,		0,	
yycrank+765,	0,		0,	
yycrank+0,	0,		yyvstop+445,
yycrank+761,	0,		0,	
yycrank+0,	0,		yyvstop+447,
yycrank+840,	0,		0,	
yycrank+776,	0,		0,	
yycrank+0,	0,		yyvstop+449,
yycrank+763,	0,		0,	
yycrank+843,	0,		0,	
yycrank+758,	0,		0,	
yycrank+0,	yysvec+679,	yyvstop+451,
yycrank+763,	0,		yyvstop+453,
yycrank+846,	0,		0,	
yycrank+0,	0,		yyvstop+455,
yycrank+768,	0,		0,	
yycrank+766,	0,		0,	
yycrank+0,	0,		yyvstop+457,
yycrank+0,	0,		yyvstop+459,
yycrank+771,	0,		0,	
yycrank+0,	0,		yyvstop+461,
yycrank+0,	0,		yyvstop+463,
yycrank+766,	0,		0,	
yycrank+773,	0,		0,	
yycrank+781,	0,		0,	
yycrank+0,	0,		yyvstop+465,
yycrank+775,	0,		0,	
yycrank+0,	0,		yyvstop+467,
yycrank+785,	0,		0,	
yycrank+786,	0,		0,	
yycrank+0,	0,		yyvstop+469,
yycrank+0,	yysvec+721,	yyvstop+471,
yycrank+780,	0,		0,	
yycrank+0,	0,		yyvstop+473,
yycrank+773,	0,		0,	
yycrank+0,	0,		yyvstop+475,
yycrank+785,	0,		0,	
yycrank+0,	0,		yyvstop+477,
yycrank+791,	0,		0,	
yycrank+784,	0,		0,	
yycrank+0,	0,		yyvstop+479,
yycrank+788,	0,		0,	
yycrank+0,	0,		yyvstop+481,
yycrank+779,	0,		0,	
yycrank+863,	0,		yyvstop+483,
yycrank+795,	0,		0,	
yycrank+782,	0,		0,	
yycrank+782,	0,		0,	
yycrank+794,	0,		0,	
yycrank+801,	0,		0,	
yycrank+0,	0,		yyvstop+485,
yycrank+800,	0,		0,	
yycrank+786,	0,		0,	
yycrank+787,	0,		0,	
yycrank+790,	0,		0,	
yycrank+0,	0,		yyvstop+487,
yycrank+791,	0,		0,	
yycrank+0,	0,		yyvstop+489,
yycrank+801,	0,		0,	
yycrank+808,	0,		0,	
yycrank+0,	0,		yyvstop+491,
0,	0,	0};
struct yywork *yytop = yycrank+907;
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
  1,   1,  66,   1,  68,   1,   1,   1, 
  1,  73,  74,   1,  76,  77,   1,   1, 
 80,   1,  82,  83,   1,   1,   1,   1, 
  1,   1,   1,   1,   1,   1,   1,   1, 
  1,  97,  98,  99, 100, 101, 101,  99, 
 99, 105, 106,  99, 108, 109, 110,  99, 
112, 113, 114, 115,  99, 117, 117,  99, 
 99, 121, 121,   1,   1,   1,   1,   1, 
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
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
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
