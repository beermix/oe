/* Generated by re2c */

{
	YYCTYPE yych;
	switch (YYGETCONDITION()) {
	case yycc1: goto yyc_c1;
	case yycc2: goto yyc_c2;
	}
/* *********************************** */
yyc_c1:
	goto yy1;
yy2:
	++YYCURSOR;
yy1:
	if (YYLIMIT <= YYCURSOR) YYFILL(1);
	yych = *YYCURSOR;
	goto yy2;
/* *********************************** */
yyc_c2:
	if ((YYLIMIT - YYCURSOR) < 3) YYFILL(3);
	yych = *YYCURSOR;
	switch (yych) {
	case 'd':	goto yy7;
	default:	goto yy6;
	}
yy6:
	YYCURSOR = YYMARKER;
	goto yy8;
yy7:
	yych = *(YYMARKER = ++YYCURSOR);
	switch (yych) {
	case 'd':	goto yy9;
	default:	goto yy8;
	}
yy8:
	{}
yy9:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'd':	goto yy10;
	default:	goto yy6;
	}
yy10:
	++YYCURSOR;
	{}
}

re2c: warning: line 3: unreachable rule in condition 'c1'  [-Wunreachable-rules]
re2c: warning: line 4: unreachable rule in condition 'c1'  [-Wunreachable-rules]
re2c: warning: line 9: control flow in condition 'c2' is undefined for strings that match '[\x0-\x63\x65-\xFF]', use default rule '*' [-Wundefined-control-flow]
