%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "symtab.c"
    #include "codeGen.c"//these are the files manually written

	// void yyerror(const char *s);
	extern void yyerror();
	extern int yylex();
	extern int lineno;
    int varType=10;
    char *strs[10];//maximum number of const strings are 10
    int constStrNum=0;
    int x=0;
    int varPlvl[5] = {0, 0, 0, 0, 0}; // how many vars declared in current LOOP lvl
    int lvl = 0;                      // which LOOP level is being coded
    int z[10]={0};    
    FILE *tokfile; // file pointer to write tokens

%}

%union
{
    char str_val[20];
    int int_val;
}

%token MAKE FUNC MAIN DIVOP LBRACE RBRACE LPAREN RPAREN SCAN PRINT IF ELSE LE GE TAB
%token FBegin FEnd VISIBLE READ DESIGN CALC ADD SUBOP MUL SEMI ASSIGN TO DEFAULT COLON LT GT CHK WHILE EQUOP NL
%token<str_val> ID ISTR
%token<int_val> ICONST DTYPE

%type<int_val> SET DECL EXP if
%left LT GT EQUOP //TAB
%left ADD SUBOP 
%left MUL 
%left ASSIGN//Higher lines = lower precedence; Lower lines = higher precedence
%start program

%%
program: FBegin {gen_code(START, -1);} statements {gen_code(HALT, -1);} FEnd 

statements: statement statements | ;

statement: DECL | SET | IO | COND | LOOP ;

COND: if | else ;

LOOP: whileloop | forloop 

if: CHK EXP COLON {++lvl; z[lvl]=++x;}{gen_code(CHECK, z[lvl]);} statements SEMI {gen_code(SKIP, z[lvl]); {deletevar(varPlvl[lvl]); varPlvl[lvl]=0; lvl--;} }

else: DEFAULT COLON {++lvl; z[lvl]=++x;}{gen_code(DFLT, z[lvl]);} statements SEMI {gen_code(SKIP, z[lvl]); {deletevar(varPlvl[lvl]); varPlvl[lvl]=0; lvl--;} };

whileloop: WHILE {++lvl; z[lvl]=++x;} {gen_code(WHILE_LABEL, z[lvl]);} EXP COLON {gen_code(WHILE_START, z[lvl]);} statements SEMI {gen_code(WHILE_END, z[lvl]); {deletevar(varPlvl[lvl]); varPlvl[lvl]=0; lvl--;} }

forloop: WHILE {++lvl; z[lvl]=++x;} DECL {gen_code(WHILE_LABEL, z[lvl]);} EXP SEMI {gen_code(WHILE_START, z[lvl]);} SET COLON statements SEMI {gen_code(WHILE_END, z[lvl]); {deletevar(varPlvl[lvl]); varPlvl[lvl]=0; lvl--;}}//pre-increment

DECL: DESIGN DTYPE ID ASSIGN EXP SEMI
            {
                insert($3, $2);
                int address = idcheck($3)->address;
                if(address != -1) gen_code(STORE, address);
                else
                {
                    printf("%d %s decl error\n", $2, $3);
                    fflush(stdout);
                    yyerror();
                }
                varPlvl[lvl]++;
            }
    | DESIGN DTYPE ID SEMI{insert($3, $2);}

SET: CALC EXP TO ID SEMI 
                {
                    int address = idcheck($4)->address;

                    if(address != -1)
                    {
                        gen_code(STORE, address);
                    }
                    else{
                        printf("%s set error\n", $4);
                        fflush(stdout);
                        yyerror();
                    }
                }
    | CALC ISTR TO ID SEMI  {//risky approach
            list_t* id = idcheck($4);
            if(id->address != -1 && id->st_type==4) 
            {
                gen_code(LD_STR, id->address); 
            }
            else {
                printf("%s is not a string variable\n", $4);
                fflush(stdout);
                yyerror();
            }
            char* s=(char*)malloc(strlen($2)*sizeof(char)); 
            strcpy(s, $2);
            strs[constStrNum]=s;
            constStrNum++;
            strs[constStrNum]=NULL;
        }
                
EXP: EXP MUL EXP { gen_code(MULTI, -1); }
    | EXP ADD EXP { gen_code(ADDI, -1); }
    | EXP SUBOP EXP { gen_code(SUBS, -1); }
    | EXP GT EXP {gen_code(GT_OP, lineno);}
    | EXP LT EXP {gen_code(LT_OP, lineno);}
    | EXP EQUOP EXP {gen_code(EQ_OP, lineno);}
    | ICONST {gen_code(LD_INT, $1);}
    | ID {
            list_t* id = idcheck($1);
            if(id->address != -1) 
            {
                if(id->st_type==1){
                    gen_code(LD_VAR, id->address);
                    varType=1;
                }
                else if(id->st_type==4){//print string
                    varType=4;
                    gen_code(LD_STR_VAR, id->address);//string address loaded to eax
                }
            }
            else {
                printf("%s exp error\n", $1);
                fflush(stdout);
                yyerror();
            }
        }
      

IO: VISIBLE NL SEMI{
        gen_code(PRINT_NEW_LINE, -1);
    }
    /* | VISIBLE ISTR SEMI{
        gen_code(LD_STR, 0); //ebp-50+8 for assignable strings. ebp-50+0 is for directly printed strings
        gen_code(PRINT_STR_VALUE, -1);
    } */
    | VISIBLE EXP SEMI{
        if(varType==4)gen_code(PRINT_STR_VALUE, -1);
        else gen_code(PRINT_REG_VALUE, -1);
    }
    | READ ID SEMI{
        int address=idcheck($2)->address;//address=allocated space address for that variable
        if(address!=-1) 
        {
            int type=gettype($2);
            if(type==1) gen_code(SCAN_INT_VALUE, address);
            else if(type==3) gen_code(SCAN_CHAR_VALUE, address);
            else if(type==4) gen_code(SCAN_STR_VALUE, address);
            else{printf("%s: %d Datatype Not supported", $2, type);}
        }
        else {
                printf("%s io error\n", $2);
                fflush(stdout);
                yyerror();
            }
    }
    /* | READ STR SEMI{gen_code(SCAN_STR_VALUE, -1);} */
%%



int main()
{
    tokfile = fopen("tokens.txt", "w");
    if (!tokfile) {
        fprintf(stderr, "Cannot open tokens.txt\n");
        exit(1);
    }
  yyparse();
    fclose(tokfile);
  printf("Parsing Finished\n\n");

  print_code();

  print_assembly();

  return 0;
}

void yyerror(const char *s)
{
    fprintf(stderr, "\033[1;31mERROR: In line %2d: error in YACC: %s\033[0m\n", lineno, s);
}
