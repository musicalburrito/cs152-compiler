%option yylineno

%{
#include "y.tab.h"
#include <string.h>
int pos = 0;
int line = 1;
%}

DIGIT [0-9]
ALPHA [A-Za-z]
ALL [A-Za-z0-9]

%%

function	{pos += yyleng; return FUNCTION;}
beginparams	{pos += yyleng; return BEGIN_PARAMS;}
endparams	{pos += yyleng; return END_PARAMS;}
beginlocals	{pos += yyleng; return BEGIN_LOCALS;}
endlocals	{pos += yyleng; return END_LOCALS;}
beginbody	{pos += yyleng; return BEGIN_BODY;}
endbody		{pos += yyleng; return END_BODY;}
integer		{pos += yyleng; return INTEGER;}
array		{pos += yyleng; return ARRAY;}
of		{pos += yyleng; return OF;}
if		{pos += yyleng; return IF;}
then		{pos += yyleng; return THEN;}
endif		{pos += yyleng; return ENDIF;}
else		{pos += yyleng; return ELSE;}
while		{pos += yyleng; return WHILE;}
do		{pos += yyleng; return DO;}
beginloop	{pos += yyleng; return BEGIN_LOOP;}
endloop		{pos += yyleng; return END_LOOP;}
continue	{pos += yyleng; return CONTINUE;}
read		{pos += yyleng; return READ;}
write		{pos += yyleng; return WRITE;}
and		{pos += yyleng; return AND;}
or		{pos += yyleng; return OR;}
not		{pos += yyleng; return NOT;}
true		{pos += yyleng; return TRUE;}
false		{pos += yyleng; return FALSE;}
return		{pos += yyleng; return RETURN;}

\-		{pos += yyleng; return SUB;}
\+		{pos += yyleng; return ADD;}
\*		{pos += yyleng; return MULT;}
\/		{pos += yyleng; return DIV;}
\%		{pos += yyleng; return MOD;}

\=\=		{pos += yyleng; return EQ;}
\<\>		{pos += yyleng; return NEQ;}
\<		{pos += yyleng; return LT;}
\>		{pos += yyleng; return GT;}
\<\=		{pos += yyleng; return LTE;}
\>\=		{pos += yyleng; return GTE;}

\;		{pos += yyleng; return SEMICOLON;}
\:	 	{pos += yyleng; return COLON;}
\,		{pos += yyleng; return COMMA;}
\(		{pos += yyleng; return L_PAREN;}
\)		{pos += yyleng; return R_PAREN;}
\[		{pos += yyleng; return L_SQUARE_BRACKET;}
\]		{pos += yyleng; return R_SQUARE_BRACKET;}
\:\=		{pos += yyleng; return ASSIGN;}

"\n" 		{pos = 0; line += 1;}
\/\/		{pos += yyleng;}
\/\*.+\*\/	{pos += yyleng;}
[ \t]+		{pos += yyleng;}
##(.)*		{pos += yyleng;}

{DIGIT}+ 	{pos += yyleng; yylval.intVal = atoi(yytext); return NUMBER;}
{ALPHA}({ALL}|_)*_	{printf("Error at line %d, column %d : identifier \"%s\" cannot end with an underscore \n",yylineno, pos, yytext); pos += yyleng;}
_{ALPHA}({ALL}*)	{printf("Error at line %d, column %d : identifier \"%s\" identifier cannot begin with an underscore \n",yylineno, pos, yytext); pos += yyleng;}
{DIGIT}{ALPHA}({ALL}*) {printf("Error at line %d, column %d : identifier \"%s\" must begin with a letter\n",yylineno, pos, yytext); pos += yyleng;}
{ALPHA}({ALL}|_)* {pos += yyleng; strcpy(yylval.stringVal,yytext); return IDENTIFIER;}
[^{ALL}]		{pos += yyleng; printf("Error at line %d, column %d : unrecognized symbol \"%s\"\n", yylineno, pos, yytext);}

%%

/*
main(int argc, char *argv[]){
    yylex();

}*/
