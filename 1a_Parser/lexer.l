%option noyywrap

%{
	#include "parser.tab.h"
	int lineno = 1; // show line umber at IR
	void yyerror();
%}

%%
"\n"		{ lineno += 1; }
"//".*		{ } 
"make"		{return MAKE;}
"func"		{ return FUNC;}
"main"		{ return MAIN; }

"func_begin"		{ return FBegin; }
"func_end"		{ return FEnd; }
"visible"		{  return VISIBLE; }
"design"		{  return DESIGN; }
"intvar"		{  return INT; }
"calc"		{ return CALC; }
"to"		{ return TO; }
"="		{ return ASSIGN; }
"*"		{ return MUL; }
";"		{ return SEMI; }

[0-9]+		{return ICONST;}
[a-zA-Z][a-zA-Z_0-9]*		{ return ID;}
[ \t\r\f]+		{}
.		{ yyerror("Unrecognized character at L file"); }
%%