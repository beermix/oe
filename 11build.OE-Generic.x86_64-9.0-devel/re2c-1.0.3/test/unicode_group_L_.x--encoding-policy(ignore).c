/* Generated by re2c */
#line 1 "unicode_group_L_.x--encoding-policy(ignore).re"
#include <stdio.h>
#include "utf16.h"
#define YYCTYPE unsigned short
bool scan(const YYCTYPE * start, const YYCTYPE * const limit)
{
	__attribute__((unused)) const YYCTYPE * YYMARKER; // silence compiler warnings when YYMARKER is not used
#	define YYCURSOR start
L_:
	
#line 13 "unicode_group_L_.x--encoding-policy(ignore).c"
{
	YYCTYPE yych;
	yych = *YYCURSOR;
	if (yych <= 0x1FC5) {
		if (yych <= 0x0481) {
			if (yych <= 0x0293) {
				if (yych <= 0x00BA) {
					if (yych <= 0x00A9) {
						if (yych <= 'Z') {
							if (yych >= 'A') goto yy4;
						} else {
							if (yych <= '`') goto yy2;
							if (yych <= 'z') goto yy4;
						}
					} else {
						if (yych <= 0x00B4) {
							if (yych <= 0x00AA) goto yy4;
						} else {
							if (yych <= 0x00B5) goto yy4;
							if (yych >= 0x00BA) goto yy4;
						}
					}
				} else {
					if (yych <= 0x00F7) {
						if (yych <= 0x00D6) {
							if (yych >= 0x00C0) goto yy4;
						} else {
							if (yych <= 0x00D7) goto yy2;
							if (yych <= 0x00F6) goto yy4;
						}
					} else {
						if (yych <= 0x01BB) {
							if (yych <= 0x01BA) goto yy4;
						} else {
							if (yych <= 0x01BF) goto yy4;
							if (yych >= 0x01C4) goto yy4;
						}
					}
				}
			} else {
				if (yych <= 0x0386) {
					if (yych <= 0x0375) {
						if (yych <= 0x02AF) {
							if (yych >= 0x0295) goto yy4;
						} else {
							if (yych <= 0x036F) goto yy2;
							if (yych <= 0x0373) goto yy4;
						}
					} else {
						if (yych <= 0x037A) {
							if (yych <= 0x0377) goto yy4;
						} else {
							if (yych <= 0x037D) goto yy4;
							if (yych >= 0x0386) goto yy4;
						}
					}
				} else {
					if (yych <= 0x038D) {
						if (yych <= 0x038A) {
							if (yych >= 0x0388) goto yy4;
						} else {
							if (yych == 0x038C) goto yy4;
						}
					} else {
						if (yych <= 0x03A2) {
							if (yych <= 0x03A1) goto yy4;
						} else {
							if (yych != 0x03F6) goto yy4;
						}
					}
				}
			}
		} else {
			if (yych <= 0x1F45) {
				if (yych <= 0x1D2B) {
					if (yych <= 0x0560) {
						if (yych <= 0x0527) {
							if (yych >= 0x048A) goto yy4;
						} else {
							if (yych <= 0x0530) goto yy2;
							if (yych <= 0x0556) goto yy4;
						}
					} else {
						if (yych <= 0x109F) {
							if (yych <= 0x0587) goto yy4;
						} else {
							if (yych <= 0x10C5) goto yy4;
							if (yych >= 0x1D00) goto yy4;
						}
					}
				} else {
					if (yych <= 0x1DFF) {
						if (yych <= 0x1D77) {
							if (yych >= 0x1D62) goto yy4;
						} else {
							if (yych <= 0x1D78) goto yy2;
							if (yych <= 0x1D9A) goto yy4;
						}
					} else {
						if (yych <= 0x1F17) {
							if (yych <= 0x1F15) goto yy4;
						} else {
							if (yych <= 0x1F1D) goto yy4;
							if (yych >= 0x1F20) goto yy4;
						}
					}
				}
			} else {
				if (yych <= 0x1F5D) {
					if (yych <= 0x1F58) {
						if (yych <= 0x1F4D) {
							if (yych >= 0x1F48) goto yy4;
						} else {
							if (yych <= 0x1F4F) goto yy2;
							if (yych <= 0x1F57) goto yy4;
						}
					} else {
						if (yych <= 0x1F5A) {
							if (yych <= 0x1F59) goto yy4;
						} else {
							if (yych != 0x1F5C) goto yy4;
						}
					}
				} else {
					if (yych <= 0x1FB5) {
						if (yych <= 0x1F7D) {
							if (yych >= 0x1F5F) goto yy4;
						} else {
							if (yych <= 0x1F7F) goto yy2;
							if (yych <= 0x1FB4) goto yy4;
						}
					} else {
						if (yych <= 0x1FBE) {
							if (yych != 0x1FBD) goto yy4;
						} else {
							if (yych <= 0x1FC1) goto yy2;
							if (yych <= 0x1FC4) goto yy4;
						}
					}
				}
			}
		}
	} else {
		if (yych <= 0x2184) {
			if (yych <= 0x2118) {
				if (yych <= 0x1FF5) {
					if (yych <= 0x1FDB) {
						if (yych <= 0x1FCF) {
							if (yych <= 0x1FCC) goto yy4;
						} else {
							if (yych <= 0x1FD3) goto yy4;
							if (yych >= 0x1FD6) goto yy4;
						}
					} else {
						if (yych <= 0x1FEC) {
							if (yych >= 0x1FE0) goto yy4;
						} else {
							if (yych <= 0x1FF1) goto yy2;
							if (yych <= 0x1FF4) goto yy4;
						}
					}
				} else {
					if (yych <= 0x2107) {
						if (yych <= 0x2101) {
							if (yych <= 0x1FFC) goto yy4;
						} else {
							if (yych <= 0x2102) goto yy4;
							if (yych >= 0x2107) goto yy4;
						}
					} else {
						if (yych <= 0x2113) {
							if (yych >= 0x210A) goto yy4;
						} else {
							if (yych == 0x2115) goto yy4;
						}
					}
				}
			} else {
				if (yych <= 0x212E) {
					if (yych <= 0x2126) {
						if (yych <= 0x2123) {
							if (yych <= 0x211D) goto yy4;
						} else {
							if (yych != 0x2125) goto yy4;
						}
					} else {
						if (yych <= 0x2128) {
							if (yych >= 0x2128) goto yy4;
						} else {
							if (yych <= 0x2129) goto yy2;
							if (yych <= 0x212D) goto yy4;
						}
					}
				} else {
					if (yych <= 0x213F) {
						if (yych <= 0x2138) {
							if (yych <= 0x2134) goto yy4;
						} else {
							if (yych <= 0x2139) goto yy4;
							if (yych >= 0x213C) goto yy4;
						}
					} else {
						if (yych <= 0x214D) {
							if (yych <= 0x2144) goto yy2;
							if (yych <= 0x2149) goto yy4;
						} else {
							if (yych <= 0x214E) goto yy4;
							if (yych >= 0x2183) goto yy4;
						}
					}
				}
			}
		} else {
			if (yych <= 0xA787) {
				if (yych <= 0x2CEE) {
					if (yych <= 0x2C5F) {
						if (yych <= 0x2C2E) {
							if (yych >= 0x2C00) goto yy4;
						} else {
							if (yych <= 0x2C2F) goto yy2;
							if (yych <= 0x2C5E) goto yy4;
						}
					} else {
						if (yych <= 0x2C7D) {
							if (yych <= 0x2C7C) goto yy4;
						} else {
							if (yych <= 0x2CE4) goto yy4;
							if (yych >= 0x2CEB) goto yy4;
						}
					}
				} else {
					if (yych <= 0xA67F) {
						if (yych <= 0x2D25) {
							if (yych >= 0x2D00) goto yy4;
						} else {
							if (yych <= 0xA63F) goto yy2;
							if (yych <= 0xA66D) goto yy4;
						}
					} else {
						if (yych <= 0xA721) {
							if (yych <= 0xA697) goto yy4;
						} else {
							if (yych != 0xA770) goto yy4;
						}
					}
				}
			} else {
				if (yych <= 0xD801) {
					if (yych <= 0xA79F) {
						if (yych <= 0xA78E) {
							if (yych >= 0xA78B) goto yy4;
						} else {
							if (yych <= 0xA78F) goto yy2;
							if (yych <= 0xA791) goto yy4;
						}
					} else {
						if (yych <= 0xA7F9) {
							if (yych <= 0xA7A9) goto yy4;
						} else {
							if (yych <= 0xA7FA) goto yy4;
							if (yych >= 0xD801) goto yy6;
						}
					}
				} else {
					if (yych <= 0xFB12) {
						if (yych <= 0xD835) {
							if (yych >= 0xD835) goto yy7;
						} else {
							if (yych <= 0xFAFF) goto yy2;
							if (yych <= 0xFB06) goto yy4;
						}
					} else {
						if (yych <= 0xFF3A) {
							if (yych <= 0xFB17) goto yy4;
							if (yych >= 0xFF21) goto yy4;
						} else {
							if (yych <= 0xFF40) goto yy2;
							if (yych <= 0xFF5A) goto yy4;
						}
					}
				}
			}
		}
	}
yy2:
	++YYCURSOR;
yy3:
#line 13 "unicode_group_L_.x--encoding-policy(ignore).re"
	{ return YYCURSOR == limit; }
#line 303 "unicode_group_L_.x--encoding-policy(ignore).c"
yy4:
	++YYCURSOR;
#line 12 "unicode_group_L_.x--encoding-policy(ignore).re"
	{ goto L_; }
#line 308 "unicode_group_L_.x--encoding-policy(ignore).c"
yy6:
	yych = *++YYCURSOR;
	if (yych <= 0xDBFF) goto yy3;
	if (yych <= 0xDC4F) goto yy4;
	goto yy3;
yy7:
	yych = *++YYCURSOR;
	if (yych <= 0xDD3E) {
		if (yych <= 0xDCBA) {
			if (yych <= 0xDCA1) {
				if (yych <= 0xDC55) {
					if (yych <= 0xDBFF) goto yy3;
					if (yych <= 0xDC54) goto yy4;
					goto yy3;
				} else {
					if (yych == 0xDC9D) goto yy3;
					if (yych <= 0xDC9F) goto yy4;
					goto yy3;
				}
			} else {
				if (yych <= 0xDCA8) {
					if (yych <= 0xDCA2) goto yy4;
					if (yych <= 0xDCA4) goto yy3;
					if (yych <= 0xDCA6) goto yy4;
					goto yy3;
				} else {
					if (yych == 0xDCAD) goto yy3;
					if (yych <= 0xDCB9) goto yy4;
					goto yy3;
				}
			}
		} else {
			if (yych <= 0xDD0A) {
				if (yych <= 0xDCC3) {
					if (yych == 0xDCBC) goto yy3;
					goto yy4;
				} else {
					if (yych <= 0xDCC4) goto yy3;
					if (yych == 0xDD06) goto yy3;
					goto yy4;
				}
			} else {
				if (yych <= 0xDD1C) {
					if (yych <= 0xDD0C) goto yy3;
					if (yych == 0xDD15) goto yy3;
					goto yy4;
				} else {
					if (yych <= 0xDD1D) goto yy3;
					if (yych == 0xDD3A) goto yy3;
					goto yy4;
				}
			}
		}
	} else {
		if (yych <= 0xDEFB) {
			if (yych <= 0xDD51) {
				if (yych <= 0xDD45) {
					if (yych <= 0xDD3F) goto yy3;
					if (yych <= 0xDD44) goto yy4;
					goto yy3;
				} else {
					if (yych <= 0xDD46) goto yy4;
					if (yych <= 0xDD49) goto yy3;
					if (yych <= 0xDD50) goto yy4;
					goto yy3;
				}
			} else {
				if (yych <= 0xDEC1) {
					if (yych <= 0xDEA5) goto yy4;
					if (yych <= 0xDEA7) goto yy3;
					if (yych <= 0xDEC0) goto yy4;
					goto yy3;
				} else {
					if (yych == 0xDEDB) goto yy3;
					if (yych <= 0xDEFA) goto yy4;
					goto yy3;
				}
			}
		} else {
			if (yych <= 0xDF6F) {
				if (yych <= 0xDF35) {
					if (yych == 0xDF15) goto yy3;
					if (yych <= 0xDF34) goto yy4;
					goto yy3;
				} else {
					if (yych == 0xDF4F) goto yy3;
					if (yych <= 0xDF6E) goto yy4;
					goto yy3;
				}
			} else {
				if (yych <= 0xDFA9) {
					if (yych == 0xDF89) goto yy3;
					if (yych <= 0xDFA8) goto yy4;
					goto yy3;
				} else {
					if (yych == 0xDFC3) goto yy3;
					if (yych <= 0xDFCB) goto yy4;
					goto yy3;
				}
			}
		}
	}
}
#line 14 "unicode_group_L_.x--encoding-policy(ignore).re"

}
static const unsigned int chars_L_ [] = {0x41,0x5a,  0x61,0x7a,  0xaa,0xaa,  0xb5,0xb5,  0xba,0xba,  0xc0,0xd6,  0xd8,0xf6,  0xf8,0x1ba,  0x1bc,0x1bf,  0x1c4,0x293,  0x295,0x2af,  0x370,0x373,  0x376,0x377,  0x37b,0x37d,  0x386,0x386,  0x388,0x38a,  0x38c,0x38c,  0x38e,0x3a1,  0x3a3,0x3f5,  0x3f7,0x481,  0x48a,0x527,  0x531,0x556,  0x561,0x587,  0x10a0,0x10c5,  0x1d00,0x1d2b,  0x1d62,0x1d77,  0x1d79,0x1d9a,  0x1e00,0x1f15,  0x1f18,0x1f1d,  0x1f20,0x1f45,  0x1f48,0x1f4d,  0x1f50,0x1f57,  0x1f59,0x1f59,  0x1f5b,0x1f5b,  0x1f5d,0x1f5d,  0x1f5f,0x1f7d,  0x1f80,0x1fb4,  0x1fb6,0x1fbc,  0x1fbe,0x1fbe,  0x1fc2,0x1fc4,  0x1fc6,0x1fcc,  0x1fd0,0x1fd3,  0x1fd6,0x1fdb,  0x1fe0,0x1fec,  0x1ff2,0x1ff4,  0x1ff6,0x1ffc,  0x2102,0x2102,  0x2107,0x2107,  0x210a,0x2113,  0x2115,0x2115,  0x2119,0x211d,  0x2124,0x2124,  0x2126,0x2126,  0x2128,0x2128,  0x212a,0x212d,  0x212f,0x2134,  0x2139,0x2139,  0x213c,0x213f,  0x2145,0x2149,  0x214e,0x214e,  0x2183,0x2184,  0x2c00,0x2c2e,  0x2c30,0x2c5e,  0x2c60,0x2c7c,  0x2c7e,0x2ce4,  0x2ceb,0x2cee,  0x2d00,0x2d25,  0xa640,0xa66d,  0xa680,0xa697,  0xa722,0xa76f,  0xa771,0xa787,  0xa78b,0xa78e,  0xa790,0xa791,  0xa7a0,0xa7a9,  0xa7fa,0xa7fa,  0xfb00,0xfb06,  0xfb13,0xfb17,  0xff21,0xff3a,  0xff41,0xff5a,  0x10400,0x1044f,  0x1d400,0x1d454,  0x1d456,0x1d49c,  0x1d49e,0x1d49f,  0x1d4a2,0x1d4a2,  0x1d4a5,0x1d4a6,  0x1d4a9,0x1d4ac,  0x1d4ae,0x1d4b9,  0x1d4bb,0x1d4bb,  0x1d4bd,0x1d4c3,  0x1d4c5,0x1d505,  0x1d507,0x1d50a,  0x1d50d,0x1d514,  0x1d516,0x1d51c,  0x1d51e,0x1d539,  0x1d53b,0x1d53e,  0x1d540,0x1d544,  0x1d546,0x1d546,  0x1d54a,0x1d550,  0x1d552,0x1d6a5,  0x1d6a8,0x1d6c0,  0x1d6c2,0x1d6da,  0x1d6dc,0x1d6fa,  0x1d6fc,0x1d714,  0x1d716,0x1d734,  0x1d736,0x1d74e,  0x1d750,0x1d76e,  0x1d770,0x1d788,  0x1d78a,0x1d7a8,  0x1d7aa,0x1d7c2,  0x1d7c4,0x1d7cb,  0x0,0x0};
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
	YYCTYPE * buffer_L_ = new YYCTYPE [6454];
	unsigned int buffer_len = encode_utf16 (chars_L_, sizeof (chars_L_) / sizeof (unsigned int), buffer_L_);
	if (!scan (reinterpret_cast<const YYCTYPE *> (buffer_L_), reinterpret_cast<const YYCTYPE *> (buffer_L_ + buffer_len)))
		printf("test 'L_' failed\n");
	delete [] buffer_L_;
	return 0;
}
