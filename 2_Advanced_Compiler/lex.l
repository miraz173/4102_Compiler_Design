%option noyywrap

%{
	#define UNDEF_TYPE 0
	#define INT_TYPE 1
	#define REAL_TYPE 2
	#define CHAR_TYPE 3
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "parse.tab.h"
	
	int lineno = 1; // initialize to 1
	void yyerror();
%}

alpha     [a-zA-Z]
digit     [0-9]
alnum     {alpha}|{digit}

ID        {alpha}{alnum}*
ICONST    [0-9]{digit}*

%%
"//".*        { } 
[\t]+		{ return TAB;}
"    "+		{ return TAB;}
"intvar"     { yylval.int_val = INT_TYPE; return DTYPE; }
"floatvar"   { yylval.int_val = REAL_TYPE; return DTYPE; }
"charvar"    { yylval.int_val = CHAR_TYPE; return DTYPE; }
"calc"          {return CALC;}
"to"            {return TO;}
"visible"       {return VISIBLE;}
"read"		{return READ;}
"default"      {return DEFAULT;}
"func_begin" {return FBegin;}
"design"	   {return DESIGN;}
"func_end"  {return FEnd;}
"check"		{return CHK;}
"+"       { return ADD; }
"-"       { return SUBOP; }
"*"       { return MUL; }
"/"       { return DIVOP; }
"=="      { return EQUOP; }
">"       { return GT; }
"<"       { return LT; }
">="      { return GE; }
"<="      { return LE; }
":"		  { return COLON;}
"("       { return LPAREN; }
")"       { return RPAREN; }
"{"       { return LBRACE; }
"}"       { return RBRACE; }
";"       { return SEMI; }
"="       { return ASSIGN; }
"print"       { return PRINT; }
"scan"       { return SCAN; }
"if"		{return IF;}
"else"	   {return ELSE;}
"while"    { return WHILE; }
\"[ -~]+\"	{ return STR;}
{ID}        {strcpy(yylval.str_val, yytext); return ID;}
{ICONST}    {yylval.int_val=atoi(yytext); return ICONST;}
"\n"        { lineno += 1; }
[ \r\f]+  {}

.       {printf("%s :", yytext); yyerror("Unrecognized character."); }
