/*****************************

Nancy Li	nli006
Vincent Chang	vchan019

To run:

1. ./a.out < (filename)

******************************/


%option yylineno

%{
int pos = 0;
%}

DIGIT [0-9]
ALPHA [A-Za-z]
ALL [A-Za-z0-9]

%%

function	{pos += yyleng; printf("FUNCTION\n");}
beginparams	{pos += yyleng; printf("BEGIN_PARAMS\n");}
endparams	{pos += yyleng; printf("END_PARAMS\n");}
beginlocals	{pos += yyleng; printf("BEGIN_LOCALS\n");}	
endlocals	{pos += yyleng; printf("END_LOCALS\n");}
beginbody	{pos += yyleng; printf("BEGIN_BODY\n");}
endbody		{pos += yyleng; printf("END_BODY\n");}
integer		{pos += yyleng; printf("INTEGER\n");}
array		{pos += yyleng; printf("ARRAY\n");}
of		{pos += yyleng; printf("OF\n");}
if		{pos += yyleng; printf("IF\n", yytext);}
then		{pos += yyleng; printf("THEN\n", yytext);}
endif		{pos += yyleng; printf("ENDIF\n");}
else		{pos += yyleng; printf("ELSE\n");}
while		{pos += yyleng; printf("WHILE\n");}
do		{pos += yyleng; printf("DO\n");}
beginloop	{pos += yyleng; printf("BEGIN_LOOP\n");}
endloop		{pos += yyleng; printf("END_LOOP\n");}
continue	{pos += yyleng; printf("CONTINUE\n");}
read		{pos += yyleng; printf("READ\n");}
write		{pos += yyleng; printf("WRITE\n");}
and		{pos += yyleng; printf("AND\n");}
or		{pos += yyleng; printf("OR\n");}
not		{pos += yyleng; printf("NOT\n");}
true		{pos += yyleng; printf("TRUE\n");}
false		{pos += yyleng; printf("FALSE\n");}
return		{pos += yyleng; printf("RETURN\n");}

\-		{pos += yyleng; printf("SUB\n");}	
\+		{pos += yyleng; printf("ADD\n");}
\*		{pos += yyleng; printf("MULT\n");}
\/		{pos += yyleng; printf("DIV\n");}
\%		{pos += yyleng; printf("MOD\n");}

\=\=		{pos += yyleng; printf("EQ\n");}	
\<\>		{pos += yyleng; printf("NEQ\n");}
\<		{pos += yyleng; printf("LT\n");}
\>		{pos += yyleng; printf("GT\n");}
\<\=		{pos += yyleng; printf("LTE\n");}
\>\=		{pos += yyleng; printf("GTE\n");}

\;		{pos += yyleng; printf("SEMICOLON\n");}		
\:	 	{pos += yyleng; printf("COLON\n");}	
\,		{pos += yyleng; printf("COMMA\n");}
\(		{pos += yyleng; printf("L_PAREN\n");}
\)		{pos += yyleng; printf("R_PAREN\n");}
\[		{pos += yyleng; printf("L_SQUARE_BRACKET\n");}
\]		{pos += yyleng; printf("R_SQUARE_BRACKET\n");}
\:\=		{pos += yyleng; printf("ASSIGN\n");}

"\n" 		{pos = 0;}
\/\/		{pos += yyleng;}
\/\*.+\*\/	{pos += yyleng;}
[ \t]+		{pos += yyleng;}

{DIGIT}+ 	{pos += yyleng; printf("NUMBER\n");}
{ALPHA}({ALL}|_)*_	{printf("Error at line %d, column %d : identifier \"%s\" cannot end with an underscore \n",yylineno, pos, yytext); pos += yyleng;}
_{ALPHA}({ALL}*)	{printf("Error at line %d, column %d : identifier \"%s\" identifier cannot begin with an underscore \n",yylineno, pos, yytext); pos += yyleng;}
{DIGIT}{ALPHA}({ALL}*) {printf("Error at line %d, column %d : identifier \"%s\" must begin with a letter\n",yylineno, pos, yytext); pos += yyleng;}
{ALPHA}({ALL}|_)* {pos += yyleng; printf("INDENTIFIER\n");}
[^{ALL}]		{pos += yyleng; printf("Error at line %d, column %d : unrecognized symbol \"%s\"\n", yylineno, pos, yytext);}

%%

main(int argc, char *argv[]){
    yylex();

}
