%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"

	void yyerror();
	extern int yylex();
	extern int lineno;
    int x=0;
    int varPlvl[5] = {0, 0, 0, 0, 0}; // how many vars declared in current LOOP lvl
    int lvl = 0;                      // which LOOP level is being coded
    int z[10]={0};
%}

%union
{
    char str_val[100];
    int int_val;
}

%token MAKE FUNC MAIN DIVOP LBRACE RBRACE LPAREN RPAREN SCAN PRINT IF ELSE LE GE
%token FBegin FEnd VISIBLE READ DESIGN CALC ADD SUBOP MUL SEMI ASSIGN TO DEFAULT COLON LT GT CHK TAB WHILE STR EQUOP
%token<str_val> ID
%token<int_val> ICONST DTYPE

%type<int_val> SET DECL EXP if

%left TAB ICONST ID MUL ADD SUBOP LT GT EQUOP
%start program

%%
program: FBegin {gen_code(START, -1);} statements {gen_code(HALT, -1);} FEnd 

statements: statement statements | ;

statement: DECL | SET | IO | COND | LOOP ;

COND: if | else ;

LOOP: whileloop | forloop 

if: CHK EXP COLON {++lvl; z[lvl]=++x;}{gen_code(CHECK, z[lvl]);} TABstatements SEMI {gen_code(SKIP, z[lvl]); {deletevar(varPlvl[lvl]); varPlvl[lvl]=0; lvl--;} }

else: DEFAULT COLON {++lvl; z[lvl]=++x;}{gen_code(DFLT, z[lvl]);} TABstatements SEMI {gen_code(SKIP, z[lvl]); {deletevar(varPlvl[lvl]); varPlvl[lvl]=0; lvl--;} };

whileloop: WHILE {++lvl; z[lvl]=++x;} {gen_code(WHILE_LABEL, z[lvl]);} EXP COLON {gen_code(WHILE_START, z[lvl]);} TABstatements SEMI {gen_code(WHILE_END, z[lvl]); {deletevar(varPlvl[lvl]); varPlvl[lvl]=0; lvl--;} }

forloop: WHILE {++lvl; z[lvl]=++x;} DECL {gen_code(WHILE_LABEL, z[lvl]);} EXP SEMI {gen_code(WHILE_START, z[lvl]);} SET COLON TABstatements SEMI {gen_code(WHILE_END, z[lvl]); {deletevar(varPlvl[lvl]); varPlvl[lvl]=0; lvl--;}}//pre-increment

TABstatements: TAB statement TABstatements | ;

DECL: DESIGN DTYPE ID ASSIGN EXP SEMI
            {
                insert($3, $2);
                int address = idcheck($3);
                if(address != -1)   gen_code(STORE, address);
                else    yyerror();
                //
                varPlvl[lvl]++;
            }
    | DESIGN DTYPE ID SEMI{insert($3, $2);}

SET: CALC EXP TO ID SEMI 
                {
                    int address = idcheck($4);

                    if(address != -1)
                    {
                        gen_code(STORE, address);
                    }
                    else
                        yyerror();
                }
                
EXP: EXP MUL EXP { gen_code(MULTI, -1); }
    | EXP ADD EXP { gen_code(ADDI, -1); }
    | EXP SUBOP EXP { gen_code(SUBS, -1); }
    | EXP GT EXP {gen_code(GT_OP, lineno);}
    | EXP LT EXP {gen_code(LT_OP, lineno);}
    | EXP EQUOP EXP {gen_code(EQ_OP, lineno);}
    | ICONST {gen_code(LD_INT, $1);}
    | ID {
            int address = idcheck($1);
            if(address != -1) gen_code(LD_VAR, address);
            else yyerror();
        }
      

IO: VISIBLE EXP SEMI { gen_code(PRINT_REG_VALUE, -1); }
    | READ ID SEMI{
        int address=idcheck($2);
        if(address!=-1) 
        {
            if(gettype($2)==1) gen_code(SCAN_INT_VALUE, address);
            else gen_code(SCAN_CHAR_VALUE, address);
        }
        else yyerror();
    }
    | READ STR SEMI{gen_code(SCAN_STR_VALUE, -1);}
%%



int main()
{
  yyparse();
  printf("Parsing Finished\n\n");

  print_code();

  print_assembly();

  return 0;
}

void yyerror(char *s)
{
    fprintf(stderr, "In line %2d: error in YACC: %s\n", lineno, s);
}
