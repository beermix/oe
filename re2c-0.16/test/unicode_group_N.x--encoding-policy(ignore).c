/* Generated by re2c */
#line 1 "unicode_group_N.x--encoding-policy(ignore).re"
#include <stdio.h>
#include "utf16.h"
#define YYCTYPE unsigned short
bool scan(const YYCTYPE * start, const YYCTYPE * const limit)
{
	__attribute__((unused)) const YYCTYPE * YYMARKER; // silence compiler warnings when YYMARKER is not used
#	define YYCURSOR start
N:
	
#line 13 "unicode_group_N.x--encoding-policy(ignore).c"
{
	YYCTYPE yych;
	yych = *YYCURSOR;
	if (yych <= 0x1BB9) {
		if (yych <= 0x0CE5) {
			if (yych <= 0x09E5) {
				if (yych <= 0x00BE) {
					if (yych <= 0x00B3) {
						if (yych <= '/') goto yy2;
						if (yych <= '9') goto yy4;
						if (yych >= 0x00B2) goto yy4;
					} else {
						if (yych == 0x00B9) goto yy4;
						if (yych >= 0x00BC) goto yy4;
					}
				} else {
					if (yych <= 0x06F9) {
						if (yych <= 0x065F) goto yy2;
						if (yych <= 0x0669) goto yy4;
						if (yych >= 0x06F0) goto yy4;
					} else {
						if (yych <= 0x07C9) {
							if (yych >= 0x07C0) goto yy4;
						} else {
							if (yych <= 0x0965) goto yy2;
							if (yych <= 0x096F) goto yy4;
						}
					}
				}
			} else {
				if (yych <= 0x0B6F) {
					if (yych <= 0x0A65) {
						if (yych <= 0x09EF) goto yy4;
						if (yych <= 0x09F3) goto yy2;
						if (yych <= 0x09F9) goto yy4;
					} else {
						if (yych <= 0x0AE5) {
							if (yych <= 0x0A6F) goto yy4;
						} else {
							if (yych <= 0x0AEF) goto yy4;
							if (yych >= 0x0B66) goto yy4;
						}
					}
				} else {
					if (yych <= 0x0BF2) {
						if (yych <= 0x0B71) goto yy2;
						if (yych <= 0x0B77) goto yy4;
						if (yych >= 0x0BE6) goto yy4;
					} else {
						if (yych <= 0x0C6F) {
							if (yych >= 0x0C66) goto yy4;
						} else {
							if (yych <= 0x0C77) goto yy2;
							if (yych <= 0x0C7E) goto yy4;
						}
					}
				}
			}
		} else {
			if (yych <= 0x16F0) {
				if (yych <= 0x0F1F) {
					if (yych <= 0x0E4F) {
						if (yych <= 0x0CEF) goto yy4;
						if (yych <= 0x0D65) goto yy2;
						if (yych <= 0x0D75) goto yy4;
					} else {
						if (yych <= 0x0E59) goto yy4;
						if (yych <= 0x0ECF) goto yy2;
						if (yych <= 0x0ED9) goto yy4;
					}
				} else {
					if (yych <= 0x108F) {
						if (yych <= 0x0F33) goto yy4;
						if (yych <= 0x103F) goto yy2;
						if (yych <= 0x1049) goto yy4;
					} else {
						if (yych <= 0x1368) {
							if (yych <= 0x1099) goto yy4;
						} else {
							if (yych <= 0x137C) goto yy4;
							if (yych >= 0x16EE) goto yy4;
						}
					}
				}
			} else {
				if (yych <= 0x19CF) {
					if (yych <= 0x17F9) {
						if (yych <= 0x17DF) goto yy2;
						if (yych <= 0x17E9) goto yy4;
						if (yych >= 0x17F0) goto yy4;
					} else {
						if (yych <= 0x1819) {
							if (yych >= 0x1810) goto yy4;
						} else {
							if (yych <= 0x1945) goto yy2;
							if (yych <= 0x194F) goto yy4;
						}
					}
				} else {
					if (yych <= 0x1A8F) {
						if (yych <= 0x19DA) goto yy4;
						if (yych <= 0x1A7F) goto yy2;
						if (yych <= 0x1A89) goto yy4;
					} else {
						if (yych <= 0x1B4F) {
							if (yych <= 0x1A99) goto yy4;
						} else {
							if (yych <= 0x1B59) goto yy4;
							if (yych >= 0x1BB0) goto yy4;
						}
					}
				}
			}
		}
	} else {
		if (yych <= 0x327F) {
			if (yych <= 0x24E9) {
				if (yych <= 0x2079) {
					if (yych <= 0x1C59) {
						if (yych <= 0x1C3F) goto yy2;
						if (yych <= 0x1C49) goto yy4;
						if (yych >= 0x1C50) goto yy4;
					} else {
						if (yych == 0x2070) goto yy4;
						if (yych >= 0x2074) goto yy4;
					}
				} else {
					if (yych <= 0x2182) {
						if (yych <= 0x207F) goto yy2;
						if (yych <= 0x2089) goto yy4;
						if (yych >= 0x2150) goto yy4;
					} else {
						if (yych <= 0x2189) {
							if (yych >= 0x2185) goto yy4;
						} else {
							if (yych <= 0x245F) goto yy2;
							if (yych <= 0x249B) goto yy4;
						}
					}
				}
			} else {
				if (yych <= 0x3029) {
					if (yych <= 0x2CFC) {
						if (yych <= 0x24FF) goto yy4;
						if (yych <= 0x2775) goto yy2;
						if (yych <= 0x2793) goto yy4;
					} else {
						if (yych <= 0x3006) {
							if (yych <= 0x2CFD) goto yy4;
						} else {
							if (yych <= 0x3007) goto yy4;
							if (yych >= 0x3021) goto yy4;
						}
					}
				} else {
					if (yych <= 0x3195) {
						if (yych <= 0x3037) goto yy2;
						if (yych <= 0x303A) goto yy4;
						if (yych >= 0x3192) goto yy4;
					} else {
						if (yych <= 0x3229) {
							if (yych >= 0x3220) goto yy4;
						} else {
							if (yych <= 0x3250) goto yy2;
							if (yych <= 0x325F) goto yy4;
						}
					}
				}
			}
		} else {
			if (yych <= 0xAA59) {
				if (yych <= 0xA82F) {
					if (yych <= 0xA61F) {
						if (yych <= 0x3289) goto yy4;
						if (yych <= 0x32B0) goto yy2;
						if (yych <= 0x32BF) goto yy4;
					} else {
						if (yych <= 0xA629) goto yy4;
						if (yych <= 0xA6E5) goto yy2;
						if (yych <= 0xA6EF) goto yy4;
					}
				} else {
					if (yych <= 0xA8FF) {
						if (yych <= 0xA835) goto yy4;
						if (yych <= 0xA8CF) goto yy2;
						if (yych <= 0xA8D9) goto yy4;
					} else {
						if (yych <= 0xA9CF) {
							if (yych <= 0xA909) goto yy4;
						} else {
							if (yych <= 0xA9D9) goto yy4;
							if (yych >= 0xAA50) goto yy4;
						}
					}
				}
			} else {
				if (yych <= 0xD808) {
					if (yych <= 0xD800) {
						if (yych <= 0xABEF) goto yy2;
						if (yych <= 0xABF9) goto yy4;
						if (yych >= 0xD800) goto yy6;
					} else {
						if (yych <= 0xD802) {
							if (yych <= 0xD801) goto yy7;
							goto yy8;
						} else {
							if (yych <= 0xD803) goto yy9;
							if (yych <= 0xD804) goto yy10;
						}
					}
				} else {
					if (yych <= 0xD835) {
						if (yych <= 0xD809) goto yy11;
						if (yych <= 0xD833) goto yy2;
						if (yych <= 0xD834) goto yy12;
						goto yy13;
					} else {
						if (yych <= 0xD83C) {
							if (yych >= 0xD83C) goto yy14;
						} else {
							if (yych <= 0xFF0F) goto yy2;
							if (yych <= 0xFF19) goto yy4;
						}
					}
				}
			}
		}
	}
yy2:
	++YYCURSOR;
yy3:
#line 13 "unicode_group_N.x--encoding-policy(ignore).re"
	{ return YYCURSOR == limit; }
#line 247 "unicode_group_N.x--encoding-policy(ignore).c"
yy4:
	++YYCURSOR;
#line 12 "unicode_group_N.x--encoding-policy(ignore).re"
	{ goto N; }
#line 252 "unicode_group_N.x--encoding-policy(ignore).c"
yy6:
	yych = *++YYCURSOR;
	if (yych <= 0xDF1F) {
		if (yych <= 0xDD3F) {
			if (yych <= 0xDD06) goto yy3;
			if (yych <= 0xDD33) goto yy4;
			goto yy3;
		} else {
			if (yych <= 0xDD78) goto yy4;
			if (yych == 0xDD8A) goto yy4;
			goto yy3;
		}
	} else {
		if (yych <= 0xDF49) {
			if (yych <= 0xDF23) goto yy4;
			if (yych == 0xDF41) goto yy4;
			goto yy3;
		} else {
			if (yych <= 0xDF4A) goto yy4;
			if (yych <= 0xDFD0) goto yy3;
			if (yych <= 0xDFD5) goto yy4;
			goto yy3;
		}
	}
yy7:
	yych = *++YYCURSOR;
	if (yych <= 0xDC9F) goto yy3;
	if (yych <= 0xDCA9) goto yy4;
	goto yy3;
yy8:
	yych = *++YYCURSOR;
	if (yych <= 0xDE47) {
		if (yych <= 0xDD15) {
			if (yych <= 0xDC57) goto yy3;
			if (yych <= 0xDC5F) goto yy4;
			goto yy3;
		} else {
			if (yych <= 0xDD1B) goto yy4;
			if (yych <= 0xDE3F) goto yy3;
			goto yy4;
		}
	} else {
		if (yych <= 0xDF57) {
			if (yych <= 0xDE7C) goto yy3;
			if (yych <= 0xDE7E) goto yy4;
			goto yy3;
		} else {
			if (yych <= 0xDF5F) goto yy4;
			if (yych <= 0xDF77) goto yy3;
			if (yych <= 0xDF7F) goto yy4;
			goto yy3;
		}
	}
yy9:
	yych = *++YYCURSOR;
	if (yych <= 0xDE5F) goto yy3;
	if (yych <= 0xDE7E) goto yy4;
	goto yy3;
yy10:
	yych = *++YYCURSOR;
	if (yych <= 0xDC51) goto yy3;
	if (yych <= 0xDC6F) goto yy4;
	goto yy3;
yy11:
	yych = *++YYCURSOR;
	if (yych <= 0xDBFF) goto yy3;
	if (yych <= 0xDC62) goto yy4;
	goto yy3;
yy12:
	yych = *++YYCURSOR;
	if (yych <= 0xDF5F) goto yy3;
	if (yych <= 0xDF71) goto yy4;
	goto yy3;
yy13:
	yych = *++YYCURSOR;
	if (yych <= 0xDFCD) goto yy3;
	if (yych <= 0xDFFF) goto yy4;
	goto yy3;
yy14:
	++YYCURSOR;
	if ((yych = *YYCURSOR) <= 0xDCFF) goto yy3;
	if (yych <= 0xDD0A) goto yy4;
	goto yy3;
}
#line 14 "unicode_group_N.x--encoding-policy(ignore).re"

}
static const unsigned int chars_N [] = {0x30,0x39,  0xb2,0xb3,  0xb9,0xb9,  0xbc,0xbe,  0x660,0x669,  0x6f0,0x6f9,  0x7c0,0x7c9,  0x966,0x96f,  0x9e6,0x9ef,  0x9f4,0x9f9,  0xa66,0xa6f,  0xae6,0xaef,  0xb66,0xb6f,  0xb72,0xb77,  0xbe6,0xbf2,  0xc66,0xc6f,  0xc78,0xc7e,  0xce6,0xcef,  0xd66,0xd75,  0xe50,0xe59,  0xed0,0xed9,  0xf20,0xf33,  0x1040,0x1049,  0x1090,0x1099,  0x1369,0x137c,  0x16ee,0x16f0,  0x17e0,0x17e9,  0x17f0,0x17f9,  0x1810,0x1819,  0x1946,0x194f,  0x19d0,0x19da,  0x1a80,0x1a89,  0x1a90,0x1a99,  0x1b50,0x1b59,  0x1bb0,0x1bb9,  0x1c40,0x1c49,  0x1c50,0x1c59,  0x2070,0x2070,  0x2074,0x2079,  0x2080,0x2089,  0x2150,0x2182,  0x2185,0x2189,  0x2460,0x249b,  0x24ea,0x24ff,  0x2776,0x2793,  0x2cfd,0x2cfd,  0x3007,0x3007,  0x3021,0x3029,  0x3038,0x303a,  0x3192,0x3195,  0x3220,0x3229,  0x3251,0x325f,  0x3280,0x3289,  0x32b1,0x32bf,  0xa620,0xa629,  0xa6e6,0xa6ef,  0xa830,0xa835,  0xa8d0,0xa8d9,  0xa900,0xa909,  0xa9d0,0xa9d9,  0xaa50,0xaa59,  0xabf0,0xabf9,  0xff10,0xff19,  0x10107,0x10133,  0x10140,0x10178,  0x1018a,0x1018a,  0x10320,0x10323,  0x10341,0x10341,  0x1034a,0x1034a,  0x103d1,0x103d5,  0x104a0,0x104a9,  0x10858,0x1085f,  0x10916,0x1091b,  0x10a40,0x10a47,  0x10a7d,0x10a7e,  0x10b58,0x10b5f,  0x10b78,0x10b7f,  0x10e60,0x10e7e,  0x11052,0x1106f,  0x12400,0x12462,  0x1d360,0x1d371,  0x1d7ce,0x1d7ff,  0x1f100,0x1f10a,  0x0,0x0};
static unsigned int encode_utf16 (const unsigned int * ranges, unsigned int ranges_count, unsigned short * s)
{
	unsigned short * const s_start = s;
	for (unsigned int i = 0; i < ranges_count; i += 2)
		for (unsigned int j = ranges[i]; j <= ranges[i + 1]; ++j)
		{
			if (j <= re2c::utf16::MAX_1WORD_RUNE)
				*s++ = j;
			else
			{
				*s++ = re2c::utf16::lead_surr(j);
				*s++ = re2c::utf16::trail_surr(j);
			}
		}
	return s - s_start;
}

int main ()
{
	YYCTYPE * buffer_N = new YYCTYPE [2202];
	unsigned int buffer_len = encode_utf16 (chars_N, sizeof (chars_N) / sizeof (unsigned int), buffer_N);
	if (!scan (reinterpret_cast<const YYCTYPE *> (buffer_N), reinterpret_cast<const YYCTYPE *> (buffer_N + buffer_len)))
		printf("test 'N' failed\n");
	delete [] buffer_N;
	return 0;
}
