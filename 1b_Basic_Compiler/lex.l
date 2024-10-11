%option noyywrap

%{
	#include "parse.tab.h"
	
	int lineno = 1; // initialize to 1
	void yyerror();
%}

digit [0-9]
number ({digit}+)

%%
"//".*        { } 
"make"		{return MAKE;}
"func"	   {return FUNC;}
"main"    { return MAIN; }

"func_begin"  { return FBegin; }
"func_end"    { return FEnd; }
"visible"  { return VISIBLE; }
"design"   { return DESIGN; }
"calc"     { return CALC; }
"*"        { return MUL; }
"+"			{return ADD;}
";"        { return SEMI; }
"="        { return ASSIGN; }
"to"       { return TO; }

[ \t\r\f]+  {}
"\n"        { lineno += 1; }
"intvar"   {yylval.int_val=1; return INT; }
{number}    {yylval.int_val = atoi(yytext); return ICONST;}
[a-zA-Z][a-zA-Z_0-9]*    {strcpy(yylval.str_val, yytext); return ID;}
.       {printf("- %s -", yytext); yyerror("Unrecognized character"); }
%%