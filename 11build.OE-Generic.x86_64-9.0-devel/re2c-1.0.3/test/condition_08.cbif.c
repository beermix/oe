/* Generated by re2c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define	BSIZE	8192

enum ScanContition {
	EStateNormal,
	EStateComment,
	EStateSkiptoeol,
	EStateString,
};


typedef struct Scanner
{
	FILE			    *fp;
	unsigned char	    *cur, *tok, *lim, *eof;
	unsigned char 	    buffer[BSIZE];
	unsigned char       yych;
	enum ScanContition  cond;
	int                 state;
} Scanner;

int fill(Scanner *s, int len)
{
	if (!len)
	{
		s->cur = s->tok = s->lim = s->buffer;
		s->eof = 0;
	}
	if (!s->eof)
	{
		int got, cnt = s->tok - s->buffer;

		if (cnt > 0)
		{
			memcpy(s->buffer, s->tok, s->lim - s->tok);
			s->tok -= cnt;
			s->cur -= cnt;
			s->lim -= cnt;
		}
		cnt = BSIZE - cnt;
		if ((got = fread(s->lim, 1, cnt, s->fp)) != cnt)
		{
			s->eof = &s->lim[got];
		}
		s->lim += got;
	}
	else if (s->cur + len > s->eof)
	{
		return 0; /* not enough input data */
	}
	return -1;
}

void fputl(const char *s, size_t len, FILE *stream)
{
	while(len-- > 0)
	{
		fputc(*s++, stream);
	}
}

void scan(Scanner *s)
{
	fill(s, 0);

	for(;;)
	{
		s->tok = s->cur;


		switch (s->state) {
		default: goto yy0;
		case 0: goto yyFillLabel0;
		case 1: goto yyFillLabel1;
		case 2: goto yyFillLabel2;
		case 3: goto yyFillLabel3;
		}
yy0:
		if (s->cond < 2) {
			if (s->cond < 1) {
				goto yyc_Normal;
			} else {
				goto yyc_Comment;
			}
		} else {
			if (s->cond < 3) {
				goto yyc_Skiptoeol;
			} else {
				goto yyc_String;
			}
		}
/* *********************************** */
yyc_Normal:
		s->state = 0;(0);
		if ((s->lim - s->cur) < 4) if(fill(s, 4) >= 0) break;
yyFillLabel0:
		s->yych = *s->cur;
		if (s->yych <= '\'') {
			if (s->yych == '"') goto yy5;
			if (s->yych >= '\'') goto yy7;
		} else {
			if (s->yych <= '/') {
				if (s->yych >= '/') goto yy8;
			} else {
				if (s->yych == '?') goto yy9;
			}
		}
		++s->cur;
yy4:
		{
				fputc(*s->tok, stdout);
				continue;
			}
yy5:
		++s->cur;
		{
				fputc(*s->tok, stdout);
				s->state = EStateString;
				continue;
			}
yy7:
		s->yych = *(s->tok = ++s->cur);
		if (s->yych == '"') goto yy10;
		if (s->yych == '\\') goto yy12;
		goto yy4;
yy8:
		s->yych = *++s->cur;
		if (s->yych == '*') goto yy13;
		if (s->yych == '/') goto yy15;
		goto yy4;
yy9:
		s->yych = *(s->tok = ++s->cur);
		if (s->yych == '?') goto yy17;
		goto yy4;
yy10:
		s->yych = *++s->cur;
		if (s->yych == '\'') goto yy18;
yy11:
		s->cur = s->tok;
		goto yy4;
yy12:
		s->yych = *++s->cur;
		if (s->yych == '"') goto yy10;
		goto yy11;
yy13:
		++s->cur;
		{
				s->cond = EStateComment;
				goto yyc_Comment;
			}
yy15:
		++s->cur;
		{
				s->cond = EStateSkiptoeol;
				goto yyc_Skiptoeol;
			}
yy17:
		s->yych = *++s->cur;
		switch (s->yych) {
		case '!':	goto yy20;
		case '\'':	goto yy22;
		case '(':	goto yy24;
		case ')':	goto yy26;
		case '-':	goto yy28;
		case '/':	goto yy30;
		case '<':	goto yy32;
		case '=':	goto yy34;
		case '>':	goto yy36;
		default:	goto yy11;
		}
yy18:
		++s->cur;
		{
				fputl("'\"'", 3, stdout);
				continue;
			}
yy20:
		++s->cur;
		{
				fputc('|', stdout);
				continue;
			}
yy22:
		++s->cur;
		{
				fputc('^', stdout);
				continue;
			}
yy24:
		++s->cur;
		{
				fputc('[', stdout);
				continue;
			}
yy26:
		++s->cur;
		{
				fputc(']', stdout);
				continue;
			}
yy28:
		++s->cur;
		{
				fputc('~', stdout);
				continue;
			}
yy30:
		++s->cur;
		{
				fputc('\\', stdout);
				continue;
			}
yy32:
		++s->cur;
		{
				fputc('{', stdout);
				continue;
			}
yy34:
		++s->cur;
		{
				fputc('#', stdout);
				continue;
			}
yy36:
		++s->cur;
		{
				fputc('}', stdout);
				continue;
			}
/* *********************************** */
yyc_Comment:
		s->state = 1;(1);
		if ((s->lim - s->cur) < 2) if(fill(s, 2) >= 0) break;
yyFillLabel1:
		s->yych = *s->cur;
		if (s->yych == '*') goto yy42;
		++s->cur;
yy41:
		{
				goto yyc_Comment;
			}
yy42:
		s->yych = *++s->cur;
		if (s->yych != '/') goto yy41;
		++s->cur;
		{
				s->cond = EStateNormal;
				continue;
			}
/* *********************************** */
yyc_Skiptoeol:
		s->state = 2;(2);
		if ((s->lim - s->cur) < 5) if(fill(s, 5) >= 0) break;
yyFillLabel2:
		s->yych = *s->cur;
		if (s->yych <= '>') {
			if (s->yych == '\n') goto yy49;
		} else {
			if (s->yych <= '?') goto yy51;
			if (s->yych == '\\') goto yy52;
		}
		++s->cur;
yy48:
		{
				goto yyc_Skiptoeol;
			}
yy49:
		++s->cur;
		{
				s->cond = EStateNormal;
				continue;
			}
yy51:
		s->yych = *(s->tok = ++s->cur);
		if (s->yych == '?') goto yy53;
		goto yy48;
yy52:
		s->yych = *(s->tok = ++s->cur);
		if (s->yych == '\n') goto yy55;
		if (s->yych == '\r') goto yy57;
		goto yy48;
yy53:
		s->yych = *++s->cur;
		if (s->yych == '/') goto yy58;
yy54:
		s->cur = s->tok;
		goto yy48;
yy55:
		++s->cur;
		{
				goto yyc_Skiptoeol;
			}
yy57:
		s->yych = *++s->cur;
		if (s->yych == '\n') goto yy55;
		goto yy54;
yy58:
		s->yych = *++s->cur;
		if (s->yych == '\n') goto yy59;
		if (s->yych == '\r') goto yy61;
		goto yy54;
yy59:
		++s->cur;
		{
				goto yyc_Skiptoeol;
			}
yy61:
		s->yych = *++s->cur;
		if (s->yych == '\n') goto yy59;
		goto yy54;
/* *********************************** */
yyc_String:
		s->state = 3;(3);
		if ((s->lim - s->cur) < 2) if(fill(s, 2) >= 0) break;
yyFillLabel3:
		s->yych = *s->cur;
		if (s->yych == '"') goto yy66;
		if (s->yych == '\\') goto yy68;
		++s->cur;
yy65:
		{
				fputc(*s->tok, stdout);
				continue;
			}
yy66:
		++s->cur;
		{
				fputc(*s->tok, stdout);
				s->cond = EStateNormal;
				continue;
			}
yy68:
		s->yych = *++s->cur;
		if (s->yych == '\n') goto yy65;
		++s->cur;
		{
				fputl((const char*)s->tok, 2, stdout);
				continue;
			}

	}
}

int main(int argc, char **argv)
{
	Scanner in;
	char c;

	if (argc != 2)
	{
		fprintf(stderr, "%s <file>\n", argv[0]);
		return 1;;
	}

	memset((char*) &in, 0, sizeof(in));

	if (!strcmp(argv[1], "-"))
	{
		in.fp = stdin;
	}
	else if ((in.fp = fopen(argv[1], "r")) == NULL)
	{
		fprintf(stderr, "Cannot open file '%s'\n", argv[1]);
		return 1;
	}

 	in.cond = EStateNormal;
 	scan(&in);

	if (in.fp != stdin)
	{
		fclose(in.fp);
	}
	return 0;
}
