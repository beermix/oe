/* Generated by re2c */
#line 1 "condtype_forwdecl.cg.re"
enum cond_t : int;

int main ()
{
	cond_t cond;
	char * YYCURSOR;
#define YYGETCONDITION() cond

#line 12 "condtype_forwdecl.cg.c"
{
	unsigned char yych;
	static void *yyctable[2] = {
		&&yyc_a,
		&&yyc_b,
	};
	goto *yyctable[YYGETCONDITION()];
/* *********************************** */
yyc_a:
	yych = *YYCURSOR;
	if (yych == 'a') goto yy4;
yy4:
	++YYCURSOR;
#line 12 "condtype_forwdecl.cg.re"
	{}
#line 28 "condtype_forwdecl.cg.c"
/* *********************************** */
yyc_b:
	yych = *YYCURSOR;
	if (yych == 'b') goto yy9;
yy9:
	++YYCURSOR;
#line 13 "condtype_forwdecl.cg.re"
	{}
#line 37 "condtype_forwdecl.cg.c"
}
#line 14 "condtype_forwdecl.cg.re"

	return 0;
}

#line 44 "condtype_forwdecl.cg.c"

enum cond_t : int {
	yyca,
	yycb,
};

#line 18 "condtype_forwdecl.cg.re"
re2c: warning: line 14: control flow in condition 'a' is undefined for strings that match '[\x0-\x60\x62-\xFF]', use default rule '*' [-Wundefined-control-flow]
re2c: warning: line 14: control flow in condition 'b' is undefined for strings that match '[\x0-\x61\x63-\xFF]', use default rule '*' [-Wundefined-control-flow]
