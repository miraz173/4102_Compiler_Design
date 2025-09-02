%option noyywrap

%{
    #define UNDEF_TYPE 0
    #define INT_TYPE 1
    #define REAL_TYPE 2
    #define CHAR_TYPE 3
    #define STR_TYPE 4
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "parse.tab.h"
    
    int lineno = 1; // initialize to 1
    void yyerror();

    extern FILE *tokfile; // file pointer to write tokens
%}

alpha     [a-zA-Z]
digit     [0-9]
alnum     {alpha}|{digit}
ID        {alpha}{alnum}*
ICONST    {digit}+

%%

"//".*        { } //comments discarded
[\t]+         { fprintf(tokfile,"\t");} //ignore tabs
"    "+       { fprintf(tokfile,"\t");} //ignore spaces
"nl"          { fprintf(tokfile,"NL "); return NL; }

"intvar"      { yylval.int_val = INT_TYPE; fprintf(tokfile,"DTYPE(INT) "); return DTYPE; }
"floatvar"    { yylval.int_val = REAL_TYPE; fprintf(tokfile,"DTYPE(REAL) "); return DTYPE; }
"charvar"     { yylval.int_val = CHAR_TYPE; fprintf(tokfile,"DTYPE(CHAR) "); return DTYPE; }
"strvar"      { yylval.int_val = STR_TYPE; fprintf(tokfile,"DTYPE(STR) "); return DTYPE; }

"calc"        { fprintf(tokfile,"CALC "); return CALC; }
"to"          { fprintf(tokfile,"TO "); return TO; }
"visible"     { fprintf(tokfile,"VISIBLE "); return VISIBLE; }
"read"        { fprintf(tokfile,"READ "); return READ; }
"default"     { fprintf(tokfile,"DEFAULT "); return DEFAULT; }
"func_begin"  { fprintf(tokfile,"FBegin "); return FBegin; }
"design"      { fprintf(tokfile,"DESIGN "); return DESIGN; }
"func_end"    { fprintf(tokfile,"FEnd "); return FEnd; }
"check"       { fprintf(tokfile,"CHK "); return CHK; }

"+"           { fprintf(tokfile,"ADD "); return ADD; }
"-"           { fprintf(tokfile,"SUBOP "); return SUBOP; }
"*"           { fprintf(tokfile,"MUL "); return MUL; }
"/"           { fprintf(tokfile,"DIVOP "); return DIVOP; }
"=="          { fprintf(tokfile,"EQUOP "); return EQUOP; }
">"           { fprintf(tokfile,"GT "); return GT; }
"<"           { fprintf(tokfile,"LT "); return LT; }
">="          { fprintf(tokfile,"GE "); return GE; }
"<="          { fprintf(tokfile,"LE "); return LE; }
":"           { fprintf(tokfile,"COLON "); return COLON; }
"("           { fprintf(tokfile,"LPAREN "); return LPAREN; }
")"           { fprintf(tokfile,"RPAREN "); return RPAREN; }
"{"           { fprintf(tokfile,"LBRACE "); return LBRACE; }
"}"           { fprintf(tokfile,"RBRACE "); return RBRACE; }
";"           { fprintf(tokfile,"SEMI "); return SEMI; }
"="           { fprintf(tokfile,"ASSIGN "); return ASSIGN; }
"print"       { fprintf(tokfile,"PRINT "); return PRINT; }
"scan"        { fprintf(tokfile,"SCAN "); return SCAN; }
"if"          { fprintf(tokfile,"IF "); return IF; }
"else"        { fprintf(tokfile,"ELSE "); return ELSE; }
"while"       { fprintf(tokfile,"WHILE "); return WHILE; }

{ID}          { strcpy(yylval.str_val, yytext); fprintf(tokfile,"ID(%s) ", yytext); return ID; }
{ICONST}      { yylval.int_val = atoi(yytext); fprintf(tokfile,"ICONST(%d) ", yylval.int_val); return ICONST; }

\"[ -~]+\"    { strncpy(yylval.str_val, yytext+1, yyleng-2); yylval.str_val[yyleng-2]='\0'; 
                fprintf(tokfile,"ISTR(%s) ", yylval.str_val); return ISTR; }

"\n"          { lineno++; fprintf(tokfile,"\n"); }
[ \r\f]+      { } //ignore other whitespace

.             { fprintf(tokfile,"UNKNOWN(%s) ", yytext); yyerror("Unrecognized character. "); }

%%

/* int main() {
    tokfile = fopen("tokens.txt", "w ");
    if (!tokfile) {
        fprintf(stderr, "Cannot open tokens.txt ");
        exit(1);
    }
    yylex();  // start scanning
    fclose(tokfile);
    return 0;
} */
