/* Generated by re2c */
// forbidding to map bottom version to other tag versions is a bad idea:
// example shows exponential growth in the number of DFA states


{
	YYCTYPE yych;
	if ((YYLIMIT - YYCURSOR) < 3) YYFILL(3);
	yych = *YYCURSOR;
	switch (yych) {
	case 'a':	goto yy3;
	case 'b':
		yyt1 = YYCURSOR;
		goto yy4;
	case 'c':
		yyt1 = yyt2 = YYCURSOR;
		goto yy5;
	default:
		yyt1 = yyt2 = yyt3 = YYCURSOR;
		goto yy2;
	}
yy2:
	p = yyt1;
	q = yyt2;
	z = yyt3;
	{}
yy3:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'b':
		yyt1 = NULL;
		goto yy4;
	case 'c':
		yyt1 = NULL;
		yyt2 = YYCURSOR;
		goto yy5;
	default:
		yyt1 = NULL;
		yyt2 = yyt3 = YYCURSOR;
		goto yy2;
	}
yy4:
	yych = *++YYCURSOR;
	switch (yych) {
	case 'c':
		yyt2 = NULL;
		goto yy5;
	default:
		yyt2 = NULL;
		yyt3 = YYCURSOR;
		goto yy2;
	}
yy5:
	++YYCURSOR;
	yyt3 = NULL;
	goto yy2;
}

re2c: warning: line 6: rule matches empty string [-Wmatch-empty-string]
