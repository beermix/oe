/* Generated by re2c */
#line 1 "ctx.s.re"
#include <cstring>
#include <iostream>

struct Scanner
{
	Scanner(char *txt)
		: cur(txt), lim(txt + strlen(txt))
	{
	}
	
	char    *cur;
	char    *lim;
	char	*ptr;
	char	*ctx;
	char    *tok;
};

#define	YYCTYPE		char
#define	YYCURSOR	s.cur
#define	YYLIMIT		s.lim
#define	YYMARKER	s.ptr
#define	YYCTXMARKER	s.ctx
#define	YYFILL(n)	

enum What
{
	UNEXPECTED,
	KEYWORD,
	NUMBER,
	EOI
};

char * tokens[] = { "UNEXPECTED", "KEYWORD", "NUMBER", "EOI" };


int scan(Scanner &s)
{
	YYCTYPE *cursor = s.cur;

	if(cursor == s.lim)
		return EOI;
	
std:
	s.tok = cursor;


#line 50 "ctx.s.c"
{
	YYCTYPE yych;
	if ((YYLIMIT - YYCURSOR) < 3) YYFILL(3);
	yych = *YYCURSOR;
	if (yych <= ' ') {
		if (yych <= 0x08) goto yy2;
		if (yych <= '\n') goto yy4;
		if (yych >= ' ') goto yy4;
	} else {
		if (yych <= '9') {
			if (yych >= '0') goto yy6;
		} else {
			if (yych <= '`') goto yy2;
			if (yych <= 'b') goto yy9;
		}
	}
yy2:
	++YYCURSOR;
yy3:
#line 60 "ctx.s.re"
	{
		return UNEXPECTED;
	}
#line 74 "ctx.s.c"
yy4:
	++YYCURSOR;
#line 53 "ctx.s.re"
	{
		if(s.cur == s.lim)
			return EOI;
		cursor = s.cur;
		goto std;
	}
#line 84 "ctx.s.c"
yy6:
	++YYCURSOR;
	if (YYLIMIT <= YYCURSOR) YYFILL(1);
	yych = *YYCURSOR;
	if (yych <= '/') goto yy8;
	if (yych <= '9') goto yy6;
yy8:
#line 50 "ctx.s.re"
	{ return NUMBER;  }
#line 94 "ctx.s.c"
yy9:
	yych = *++YYCURSOR;
	if (yych <= '/') goto yy3;
	if (yych == '1') {
		YYCTXMARKER = YYCURSOR;
		goto yy13;
	}
	if (yych >= ':') goto yy3;
	YYCTXMARKER = YYCURSOR;
yy10:
	++YYCURSOR;
	if (YYLIMIT <= YYCURSOR) YYFILL(1);
	yych = *YYCURSOR;
	if (yych <= '/') goto yy12;
	if (yych <= '9') goto yy10;
yy12:
	YYCURSOR = YYCTXMARKER;
#line 49 "ctx.s.re"
	{ return KEYWORD; }
#line 114 "ctx.s.c"
yy13:
	yych = *++YYCURSOR;
	if (yych <= '/') goto yy14;
	if (yych <= '9') goto yy10;
yy14:
	YYCURSOR -= 1;
#line 48 "ctx.s.re"
	{ return KEYWORD; }
#line 123 "ctx.s.c"
}
#line 63 "ctx.s.re"

}

#define YYMAXFILL 3


int main(int,char**)
{
	Scanner s("a77 a1 b8 b1");
	
	int t, n = 0;
	while ((t = scan(s)) != EOI)
	{
		std::cout << (++n) << ": " << tokens[t] << " = \""; std::cout.write(s.tok, s.cur-s.tok); std::cout << "\"" << std::endl;
	}
}
