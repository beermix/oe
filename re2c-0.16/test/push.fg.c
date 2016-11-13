/* Generated by re2c */
#line 1 "push.fg.re"
/*
 *  A push-model scanner example for re2c -f
 *  Written Mon Apr 11 2005 by mgix@mgix.com
 *  This file is in the public domain.
 *
 */

// ----------------------------------------------------------------------

#include <fcntl.h>
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#if defined(WIN32)

    typedef signed char     int8_t;
    typedef signed short    int16_t;
    typedef signed int      int32_t;

    typedef unsigned char   uint8_t;
    typedef unsigned short  uint16_t;
    typedef unsigned int    uint32_t;

#else

    #include <stdint.h>
    #include <unistd.h>

    #ifndef O_BINARY
        #define O_BINARY 0
    #endif

#endif

// ----------------------------------------------------------------------
#define TOKENS              \
                            \
    TOK(kEOF)               \
    TOK(kEOL)               \
    TOK(kUnknown)           \
    TOK(kIdentifier)        \
    TOK(kDecimalConstant)   \
                            \
    TOK(kEqual)             \
    TOK(kLeftParen)         \
    TOK(kRightParen)        \
    TOK(kMinus)             \
    TOK(kPlus)              \
    TOK(kStar)              \
    TOK(kSlash)             \
                            \
    TOK(kIf)                \
    TOK(kFor)               \
    TOK(kElse)              \
    TOK(kGoto)              \
    TOK(kBreak)             \
    TOK(kWhile)             \
    TOK(kReturn)            \


// ----------------------------------------------------------------------
static const char *tokenNames[] =
{
    #define TOK(x) #x,
        TOKENS
    #undef TOK
};

// ----------------------------------------------------------------------
class PushScanner
{
public:

    enum Token
    {
        #define TOK(x) x,
            TOKENS
        #undef TOK
    };

private:

    bool        eof;
    int32_t     state;

    uint8_t     *limit;
    uint8_t     *start;
    uint8_t     *cursor;
    uint8_t     *marker;

    uint8_t     *buffer;
    uint8_t     *bufferEnd;

    uint8_t     yych;
    uint32_t    yyaccept;

public:

    // ----------------------------------------------------------------------
    PushScanner()
    {
        limit = 0;
        start = 0;
        state = -1;
        cursor = 0;
        marker = 0;
        buffer = 0;
        eof = false;
        bufferEnd = 0;
    }

    // ----------------------------------------------------------------------
    ~PushScanner()
    {
    }

    // ----------------------------------------------------------------------
    void send(
        Token token
    )
    {
        size_t tokenSize = cursor-start;
        const char *tokenName = tokenNames[token];
        printf(
            "scanner is pushing out a token of type %d (%s)",
            token,
            tokenName
        );

        if(token==kEOF) putchar('\n');
        else
        {
            size_t tokenNameSize = strlen(tokenNames[token]);
            size_t padSize = 20-(20<tokenNameSize ? 20 : tokenNameSize);
            for(size_t i=0; i<padSize; ++i) putchar(' ');
            printf(" : ---->");

            fwrite(
                start,
                tokenSize,
                1,
                stdout
            );

            printf("<----\n");
        }
    }

    // ----------------------------------------------------------------------
    uint32_t push(
        const void  *input,
        ssize_t     inputSize
    )
    {
        printf(
            "scanner is receiving a new data batch of length %d\n"
            "scanner continues with saved state = %d\n",
            inputSize,
            state
        );

        /*
         * Data source is signaling end of file when batch size
         * is less than maxFill. This is slightly annoying because
         * maxFill is a value that can only be known after re2c does
         * its thing. Practically though, maxFill is never bigger than
         * the longest keyword, so given our grammar, 32 is a safe bet.
         */
        uint8_t null[64];
        const ssize_t maxFill = 32;
        if(inputSize<maxFill)
        {
            eof = true;
            input = null;
            inputSize = sizeof(null);
            memset(null, 0, sizeof(null));
        }

        /*
         * When we get here, we have a partially
         * consumed buffer which is in the following state:
         *                                                                last valid char        last valid buffer spot
         *                                                                v                      v
         * +-------------------+-------------+---------------+-------------+----------------------+
         * ^                   ^             ^               ^             ^                      ^
         * buffer              start         marker          cursor        limit                  bufferEnd
         * 
         * We need to stretch the buffer and concatenate the new chunk of input to it
         *
         */
        size_t used = limit-buffer;
        size_t needed = used+inputSize;
        size_t allocated = bufferEnd-buffer;
        if(allocated<needed)
        {
            size_t limitOffset = limit-buffer;
            size_t startOffset = start-buffer;
            size_t markerOffset = marker-buffer;
            size_t cursorOffset = cursor-buffer;

                buffer = (uint8_t*)realloc(buffer, needed);
                bufferEnd = needed+buffer;

            marker = markerOffset + buffer;
            cursor = cursorOffset + buffer;
            start = buffer + startOffset;
            limit = limitOffset + buffer;
        }
        memcpy(limit, input, inputSize);
        limit += inputSize;

        // The scanner starts here
        #define YYLIMIT         limit
        #define YYCURSOR        cursor
        #define YYMARKER        marker
        #define YYCTYPE         uint8_t

        #define SKIP(x)         { start = cursor; goto yy0; }
        #define SEND(x)         { send(x); SKIP();          }
        #define YYFILL(n)       { goto fill;                }

        #define YYGETSTATE()    state
        #define YYSETSTATE(x)   { state = (x);  }

    start:

        
#line 233 "push.fg.c"
{

	static const unsigned char yybm[] = {
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		192, 192, 192, 192, 192, 192, 192, 192, 
		192, 192,   0,   0,   0,   0,   0,   0, 
		  0, 128, 128, 128, 128, 128, 128, 128, 
		128, 128, 128, 128, 128, 128, 128, 128, 
		128, 128, 128, 128, 128, 128, 128, 128, 
		128, 128, 128,   0,   0,   0,   0, 128, 
		  0, 128, 128, 128, 128, 128, 128, 128, 
		128, 128, 128, 128, 128, 128, 128, 128, 
		128, 128, 128, 128, 128, 128, 128, 128, 
		128, 128, 128,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
		  0,   0,   0,   0,   0,   0,   0,   0, 
	};
	switch (YYGETSTATE()) {
	default: goto yy0;
	case 0: goto yyFillLabel0;
	case 1: goto yyFillLabel1;
	case 2: goto yyFillLabel2;
	}
yy0:
	YYSETSTATE(0);
	if ((YYLIMIT - YYCURSOR) < 7) YYFILL(7);
yyFillLabel0:
	yych = *YYCURSOR;
	{
		static void *yytarget[256] = {
			&&yy2,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy6,  &&yy8,  &&yy6,  &&yy6,  &&yy6,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy6,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy10, &&yy12, &&yy14, &&yy16, &&yy4,  &&yy18, &&yy4,  &&yy20,
			&&yy22, &&yy22, &&yy22, &&yy22, &&yy22, &&yy22, &&yy22, &&yy22,
			&&yy22, &&yy22, &&yy4,  &&yy4,  &&yy4,  &&yy25, &&yy4,  &&yy4,
			&&yy4,  &&yy27, &&yy27, &&yy27, &&yy27, &&yy27, &&yy27, &&yy27,
			&&yy27, &&yy27, &&yy27, &&yy27, &&yy27, &&yy27, &&yy27, &&yy27,
			&&yy27, &&yy27, &&yy27, &&yy27, &&yy27, &&yy27, &&yy27, &&yy27,
			&&yy27, &&yy27, &&yy27, &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy27,
			&&yy4,  &&yy27, &&yy30, &&yy27, &&yy27, &&yy31, &&yy32, &&yy33,
			&&yy27, &&yy34, &&yy27, &&yy27, &&yy27, &&yy27, &&yy27, &&yy27,
			&&yy27, &&yy27, &&yy35, &&yy27, &&yy27, &&yy27, &&yy27, &&yy36,
			&&yy27, &&yy27, &&yy27, &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,
			&&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4,  &&yy4
		};
		goto *yytarget[yych];
	}
yy2:
	++YYCURSOR;
#line 259 "push.fg.re"
	{ send(kEOF); return 1;  }
#line 322 "push.fg.c"
yy4:
	++YYCURSOR;
#line 260 "push.fg.re"
	{ SEND(kUnknown);        }
#line 327 "push.fg.c"
yy6:
	++YYCURSOR;
#line 258 "push.fg.re"
	{ SKIP();                }
#line 332 "push.fg.c"
yy8:
	++YYCURSOR;
#line 257 "push.fg.re"
	{ SKIP();                }
#line 337 "push.fg.c"
yy10:
	++YYCURSOR;
#line 250 "push.fg.re"
	{ SEND(kLeftParen);      }
#line 342 "push.fg.c"
yy12:
	++YYCURSOR;
#line 251 "push.fg.re"
	{ SEND(kRightParen);     }
#line 347 "push.fg.c"
yy14:
	++YYCURSOR;
#line 254 "push.fg.re"
	{ SEND(kStar);           }
#line 352 "push.fg.c"
yy16:
	++YYCURSOR;
#line 253 "push.fg.re"
	{ SEND(kPlus);           }
#line 357 "push.fg.c"
yy18:
	++YYCURSOR;
#line 252 "push.fg.re"
	{ SEND(kMinus);          }
#line 362 "push.fg.c"
yy20:
	++YYCURSOR;
#line 255 "push.fg.re"
	{ SEND(kSlash);          }
#line 367 "push.fg.c"
yy22:
	++YYCURSOR;
	YYSETSTATE(1);
	if (YYLIMIT <= YYCURSOR) YYFILL(1);
yyFillLabel1:
	yych = *YYCURSOR;
	if (yybm[0+yych] & 64) {
		goto yy22;
	}
#line 247 "push.fg.re"
	{ SEND(kDecimalConstant);}
#line 379 "push.fg.c"
yy25:
	++YYCURSOR;
#line 249 "push.fg.re"
	{ SEND(kEqual);          }
#line 384 "push.fg.c"
yy27:
	++YYCURSOR;
	YYSETSTATE(2);
	if (YYLIMIT <= YYCURSOR) YYFILL(1);
yyFillLabel2:
	yych = *YYCURSOR;
yy28:
	if (yybm[0+yych] & 128) {
		goto yy27;
	}
#line 246 "push.fg.re"
	{ SEND(kIdentifier);     }
#line 397 "push.fg.c"
yy30:
	yych = *++YYCURSOR;
	if (yych == 'r') goto yy37;
	goto yy28;
yy31:
	yych = *++YYCURSOR;
	if (yych == 'l') goto yy38;
	goto yy28;
yy32:
	yych = *++YYCURSOR;
	if (yych == 'o') goto yy39;
	goto yy28;
yy33:
	yych = *++YYCURSOR;
	if (yych == 'o') goto yy40;
	goto yy28;
yy34:
	yych = *++YYCURSOR;
	if (yych == 'f') goto yy41;
	goto yy28;
yy35:
	yych = *++YYCURSOR;
	if (yych == 'e') goto yy43;
	goto yy28;
yy36:
	yych = *++YYCURSOR;
	if (yych == 'h') goto yy44;
	goto yy28;
yy37:
	yych = *++YYCURSOR;
	if (yych == 'e') goto yy45;
	goto yy28;
yy38:
	yych = *++YYCURSOR;
	if (yych == 's') goto yy46;
	goto yy28;
yy39:
	yych = *++YYCURSOR;
	if (yych == 'r') goto yy47;
	goto yy28;
yy40:
	yych = *++YYCURSOR;
	if (yych == 't') goto yy49;
	goto yy28;
yy41:
	++YYCURSOR;
	if (yybm[0+(yych = *YYCURSOR)] & 128) {
		goto yy27;
	}
#line 239 "push.fg.re"
	{ SEND(kIf);             }
#line 449 "push.fg.c"
yy43:
	yych = *++YYCURSOR;
	if (yych == 't') goto yy50;
	goto yy28;
yy44:
	yych = *++YYCURSOR;
	if (yych == 'i') goto yy51;
	goto yy28;
yy45:
	yych = *++YYCURSOR;
	if (yych == 'a') goto yy52;
	goto yy28;
yy46:
	yych = *++YYCURSOR;
	if (yych == 'e') goto yy53;
	goto yy28;
yy47:
	++YYCURSOR;
	if (yybm[0+(yych = *YYCURSOR)] & 128) {
		goto yy27;
	}
#line 240 "push.fg.re"
	{ SEND(kFor);            }
#line 473 "push.fg.c"
yy49:
	yych = *++YYCURSOR;
	if (yych == 'o') goto yy55;
	goto yy28;
yy50:
	yych = *++YYCURSOR;
	if (yych == 'u') goto yy57;
	goto yy28;
yy51:
	yych = *++YYCURSOR;
	if (yych == 'l') goto yy58;
	goto yy28;
yy52:
	yych = *++YYCURSOR;
	if (yych == 'k') goto yy59;
	goto yy28;
yy53:
	++YYCURSOR;
	if (yybm[0+(yych = *YYCURSOR)] & 128) {
		goto yy27;
	}
#line 241 "push.fg.re"
	{ SEND(kElse);           }
#line 497 "push.fg.c"
yy55:
	++YYCURSOR;
	if (yybm[0+(yych = *YYCURSOR)] & 128) {
		goto yy27;
	}
#line 242 "push.fg.re"
	{ SEND(kGoto);           }
#line 505 "push.fg.c"
yy57:
	yych = *++YYCURSOR;
	if (yych == 'r') goto yy61;
	goto yy28;
yy58:
	yych = *++YYCURSOR;
	if (yych == 'e') goto yy62;
	goto yy28;
yy59:
	++YYCURSOR;
	if (yybm[0+(yych = *YYCURSOR)] & 128) {
		goto yy27;
	}
#line 243 "push.fg.re"
	{ SEND(kBreak);          }
#line 521 "push.fg.c"
yy61:
	yych = *++YYCURSOR;
	if (yych == 'n') goto yy64;
	goto yy28;
yy62:
	++YYCURSOR;
	if (yybm[0+(yych = *YYCURSOR)] & 128) {
		goto yy27;
	}
#line 244 "push.fg.re"
	{ SEND(kWhile);          }
#line 533 "push.fg.c"
yy64:
	++YYCURSOR;
	if (yybm[0+(yych = *YYCURSOR)] & 128) {
		goto yy27;
	}
#line 245 "push.fg.re"
	{ SEND(kReturn);         }
#line 541 "push.fg.c"
}
#line 261 "push.fg.re"


    fill:
        ssize_t unfinishedSize = cursor-start;
        printf(
            "scanner needs a refill. Exiting for now with:\n"
            "    saved fill state = %d\n"
            "    unfinished token size = %d\n",
            state,
            unfinishedSize
        );

        if(0<unfinishedSize && start<limit)
        {
            printf("    unfinished token is :");
            fwrite(start, 1, cursor-start, stdout);
            putchar('\n');
        }
        putchar('\n');

        /*
         * Once we get here, we can get rid of
         * everything before start and after limit.
         */
        if(eof==true) goto start;
        if(buffer<start)
        {
            size_t startOffset = start-buffer;
            memmove(buffer, start, limit-start);
            marker -= startOffset;
            cursor -= startOffset;
            limit -= startOffset;
            start -= startOffset;
        }
        return 0;
    }
};

// ----------------------------------------------------------------------
int main(
    int     argc,
    char    **argv
)
{
    // Parse cmd line
    int input = 0;
    if(1<argc)
    {
        input = open(argv[1], O_RDONLY | O_BINARY);
        if(input<0)
        {
            fprintf(
                stderr,
                "could not open file %s\n",
                argv[1]
            );
            exit(1);
        }
    }

    /*
     * Tokenize input file by pushing batches
     * of data one by one into the scanner.
     */
    const size_t batchSize = 256;
    uint8_t buffer[batchSize];
    PushScanner scanner;
    while(1)
    {
        ssize_t n = read(input, buffer, batchSize);
        scanner.push(buffer, n);
        if(n<batchSize) break;
    }
    scanner.push(0, -1);
    close(input);

    // Done
    return 0;
}

re2c: warning: line 237: column 22: escape has no effect: '\h' [-Wuseless-escape]
