/* Generated by re2c */

{
	YYCTYPE yych;
	if ((YYLIMIT - YYCURSOR) < 2) YYFILL(2);
	yych = *YYCURSOR;
	switch (yych) {
	case 'y':
		yyt1 = YYCURSOR;
		goto yy3;
	default:
		yyt1 = yyt2 = YYCURSOR;
		goto yy2;
	}
yy2:
	yynmatch = 2;
	yypmatch[0] = yyt1;
	yypmatch[2] = yyt2;
	yypmatch[1] = YYCURSOR;
	yypmatch[3] = YYCURSOR;
	{}
yy3:
	yych = *++YYCURSOR;
	yyt2 = YYCURSOR;
	switch (yych) {
	case 'y':	goto yy4;
	default:	goto yy2;
	}
yy4:
	++YYCURSOR;
	goto yy2;
}

re2c: warning: line 5: rule matches empty string [-Wmatch-empty-string]
re2c: warning: line 6: rule matches empty string [-Wmatch-empty-string]
re2c: warning: line 6: unreachable rule (shadowed by rule at line 5) [-Wunreachable-rules]
