/* Generated by re2c */
/* autogen */
// re2c:define:YYFILL = "{ YYFILL (need); }";
// re2c:define:YYFILL@len = @@;
// re2c:define:YYFILL:naked = 1;


{
	YYCTYPE yych;
	if (YYLIMIT <= YYCURSOR) { YYFILL (need); }
	yych = *YYCURSOR;
	switch (yych) {
	case 'a':	goto yy4;
	default:	goto yy2;
	}
yy2:
	++YYCURSOR;
	{ def }
yy4:
	++YYCURSOR;
	{ code }
}

