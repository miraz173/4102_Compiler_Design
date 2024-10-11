%{
	#include <stdio.h>
	void yyerror();
	extern int lineno;
	extern int yylex();
%}

%token MAKE FUNC MAIN FBegin FEnd VISIBLE DESIGN INT CALC MUL SEMI ASSIGN TO ID ICONST

%start program

%%
program: MAKE FUNC MAIN FBegin statements FEnd

statements: DEC statements | EXP statements| VIS statements | ;

DEC: DESIGN INT ID ASSIGN ICONST SEMI
EXP: CALC ID MUL ID TO ID SEMI
VIS: VISIBLE ID SEMI

%%



int main()
{
  yyparse();
  printf("Parsing Finished");
  return 0;
}

void yyerror(char *s)
{
    fprintf(stderr, "Y file got error: %s\n", s);
}
