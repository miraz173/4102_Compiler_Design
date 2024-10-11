%option noyywrap

%{
	#include "parser.tab.h"
	int lineno = 1; // initialize to 1
	void yyerror();
%}

%%
"//".*		{ printf("//Comment\n");} 
"make"		{printf("\nMAKE "); return MAKE;}
"func"	   {printf("fumc "); return FUNC;}
"main"    {printf("main\n");  return MAIN; }

"func_begin"       {printf("func_begin\n");  return FBegin; }
"func_end"       {printf("func_end\n\n");  return FEnd; }
"visible"       {printf("visible ");  return VISIBLE; }
"design"       {printf("design ");  return DESIGN; }
"intvar"      {printf("intvar ");  return INT; }
"calc"       {printf("calc "); return CALC; }
"to"       {printf("to "); return TO; }
"="       {printf("= "); return ASSIGN; }
"*"       {printf("* "); return MUL; }
";"       {printf(";\n"); return SEMI; }

[a-zA-Z][a-zA-Z_0-9]*        {printf("%s ", yytext); return ID;}
[0-9]+    {printf("%s ", yytext); return ICONST;}
"\n"        { lineno += 1; }
[ \t\r\f]+  {printf("\t");}
.       { yyerror("Unrecognized character at L file"); }
%%