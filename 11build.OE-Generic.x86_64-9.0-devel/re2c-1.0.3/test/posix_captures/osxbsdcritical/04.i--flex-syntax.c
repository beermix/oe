/* Generated by re2c */

{
	YYCTYPE yych;
	if ((YYLIMIT - YYCURSOR) < 2) YYFILL(2);
	yych = *(YYMARKER = YYCURSOR);
	switch (yych) {
	case 0x00:	goto yy2;
	case 'b':
		yyt1 = yyt2 = YYCURSOR;
		goto yy5;
	default:
		yyt1 = YYCURSOR;
		goto yy3;
	}
yy2:
	yynmatch = 1;
	yypmatch[0] = YYCURSOR;
	yypmatch[1] = YYCURSOR;
	{}
yy3:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'b':
		yyt2 = NULL;
		goto yy7;
	default:	goto yy4;
	}
yy4:
	YYCURSOR = YYMARKER;
	goto yy2;
yy5:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'b':
		yyt2 = NULL;
		goto yy7;
	default:	goto yy6;
	}
yy6:
	yynmatch = 4;
	yypmatch[2] = yyt1;
	yypmatch[4] = yyt2;
	yypmatch[5] = yyt2;
	yypmatch[0] = yyt1;
	yypmatch[1] = YYCURSOR;
	yypmatch[3] = YYCURSOR - 1;
	yypmatch[6] = YYCURSOR - 1;
	yypmatch[7] = YYCURSOR;
	{}
yy7:
	++YYCURSOR;
	goto yy6;
}

re2c: warning: line 6: rule matches empty string [-Wmatch-empty-string]
