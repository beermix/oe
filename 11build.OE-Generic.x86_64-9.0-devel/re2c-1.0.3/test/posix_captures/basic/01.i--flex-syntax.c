/* Generated by re2c */

{
	YYCTYPE yych;
	if ((YYLIMIT - YYCURSOR) < 6) YYFILL(6);
	yych = *(YYMARKER = YYCURSOR);
	if (yych >= 0x01) {
		yyt3 = yyt5 = NULL;
		yyt1 = yyt2 = yyt4 = YYCURSOR;
		goto yy3;
	}
	yyt2 = yyt3 = yyt4 = yyt5 = NULL;
	yyt1 = YYCURSOR;
yy2:
	yynmatch = 3;
	yypmatch[0] = yyt1;
	yypmatch[2] = yyt2;
	yypmatch[3] = yyt3;
	yypmatch[4] = yyt4;
	yypmatch[5] = yyt5;
	yypmatch[1] = YYCURSOR;
	{}
yy3:
	yych = *++YYCURSOR;
	if (yych >= 0x01) goto yy5;
	YYCURSOR = YYMARKER;
	yyt2 = yyt3 = yyt4 = yyt5 = NULL;
	yyt1 = YYCURSOR;
	goto yy2;
yy5:
	yych = *++YYCURSOR;
	if (yych <= 0x00) {
		yyt4 = yyt5 = NULL;
		yyt3 = YYCURSOR;
		goto yy2;
	}
	yyt6 = YYCURSOR;
	yych = *++YYCURSOR;
	if (yych <= 0x00) {
		yyt2 = yyt5;
		yyt5 = YYCURSOR;
		goto yy2;
	}
	yych = *++YYCURSOR;
	if (yych <= 0x00) {
		yyt2 = yyt6;
		yyt4 = yyt5 = NULL;
		yyt3 = YYCURSOR;
		goto yy2;
	}
	yyt3 = yyt4 = yyt5 = YYCURSOR;
	yych = *++YYCURSOR;
	if (yych <= 0x00) {
		yyt3 = yyt6;
		yyt4 = yyt6;
		yyt5 = YYCURSOR;
		goto yy2;
	}
yy9:
	++YYCURSOR;
	if (YYLIMIT <= YYCURSOR) YYFILL(1);
	yych = *YYCURSOR;
	if (yych <= 0x00) {
		yyt2 = yyt5;
		yyt4 = yyt5 = NULL;
		yyt3 = YYCURSOR;
		goto yy2;
	}
	yyt2 = YYCURSOR;
	++YYCURSOR;
	if (YYLIMIT <= YYCURSOR) YYFILL(1);
	yych = *YYCURSOR;
	if (yych <= 0x00) {
		yyt2 = yyt6;
		yyt5 = YYCURSOR;
		goto yy2;
	}
	yyt3 = yyt2;
	yyt4 = yyt2;
	yyt6 = yyt5;
	yyt5 = yyt2;
	goto yy9;
}

re2c: warning: line 5: rule matches empty string [-Wmatch-empty-string]
re2c: warning: line 6: rule matches empty string [-Wmatch-empty-string]
re2c: warning: line 6: unreachable rule (shadowed by rule at line 5) [-Wunreachable-rules]
