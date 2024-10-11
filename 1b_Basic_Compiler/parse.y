%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"
	void yyerror();
	extern int yylex();
	extern int lineno;
%}

%union
{
    char str_val[100];
    int int_val;
}

%token MAKE FUNC MAIN FBegin FEnd VISIBLE DESIGN CALC MUL ADD SEMI ASSIGN TO
%token<str_val> ID
%token<int_val> INT
%token<int_val> ICONST

%type<int_val> DEC EXP EMUL

%start program

%%
program: {gen_code(START, -1);} MAKE FUNC MAIN FBegin statements FEnd {gen_code(HALT, -1);}

statements: DEC statements | EXP statements| VIS statements | ;

DEC: DESIGN INT ID ASSIGN EMUL SEMI //c=9
            {
                insert($3, $2);//variable declare-> int c;

                int address = idcheck($3);//variable value assign-> c=9
                if(address != -1)
                {
                    gen_code(STORE, address);
                }
                else
                    yyerror();

            }
EXP: CALC EMUL TO ID SEMI 
                {
                    int address = idcheck($4);
                    if(address != -1)
                    {
                        gen_code(STORE, address);
                    }
                    else
                        yyerror();
                }
                
EMUL: EMUL MUL EMUL {gen_code(MULTI, -1); }
    | EMUL ADD EMUL {gen_code(ADDI, -1); }
    | ID    {
                int address = idcheck($1);
                if(address != -1)
                {
                    gen_code(LD_VAR, address);
                }
                else
                    yyerror();
            }

    | ICONST {gen_code(LD_INT, $1);}

VIS: VISIBLE ID SEMI
                {
                    int address = idcheck($2);

                    if(address != -1)
                    {
                        gen_code(PRINT_INT_VALUE, address);
                    }
                    else
                        yyerror();
                }

%%


int main()
{
  yyparse();
  printf("Parsing Finished\n"); 

  if(!print_code()){
  printf("IR generated successfully!!!\n");
  }
  
  if(!print_assembly()){
    printf("Assembly generated successfully!\n");
  }
  return 0;
}

void yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}

