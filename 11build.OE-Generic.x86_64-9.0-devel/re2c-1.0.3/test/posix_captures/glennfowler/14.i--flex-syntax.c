/* Generated by re2c */

{
	YYCTYPE yych;
	if ((YYLIMIT - YYCURSOR) < 6) YYFILL(6);
	yych = *YYCURSOR;
	if (yych >= 0x01) {
		yyt1 = YYCURSOR;
		goto yy3;
	}
	yyt1 = yyt2 = yyt3 = YYCURSOR;
yy2:
	yynmatch = 4;
	yypmatch[2] = yyt1;
	yypmatch[4] = yyt2;
	yypmatch[6] = yyt3;
	yypmatch[0] = yyt1;
	yypmatch[1] = YYCURSOR;
	yypmatch[3] = yyt2;
	yypmatch[5] = yyt3;
	yypmatch[7] = YYCURSOR;
	{}
yy3:
	yych = *++YYCURSOR;
	if (yych <= 0x00) {
		yyt2 = yyt3 = YYCURSOR;
		goto yy2;
	}
	yych = *++YYCURSOR;
	if (yych <= 0x00) {
		yyt2 = yyt3 = YYCURSOR;
		goto yy2;
	}
	yyt2 = YYCURSOR;
	yych = *++YYCURSOR;
	if (yych <= 0x00) {
		yyt3 = YYCURSOR;
		goto yy2;
	}
	yych = *++YYCURSOR;
	yyt3 = YYCURSOR;
	if (yych <= 0x00) goto yy2;
	yych = *++YYCURSOR;
	if (yych <= 0x00) goto yy2;
	++YYCURSOR;
	goto yy2;
}

re2c: warning: line 5: rule matches empty string [-Wmatch-empty-string]
re2c: warning: line 6: rule matches empty string [-Wmatch-empty-string]
re2c: warning: line 6: unreachable rule (shadowed by rule at line 5) [-Wunreachable-rules]
