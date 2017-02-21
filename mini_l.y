%{
#include <stdio.h>
void yyerror(char *s);
extern int currLine;
extern int currPos;
FILE * yyin;
%}

%union{
    int intVal;
    char* stringVal;
}

%error-verbose
%start S

%token FUNCTION
%token BEGIN_PARAMS
%token END_PARAMS
%token BEGIN_LOCALS
%token END_LOCALS
%token BEGIN_BODY
%token END_BODY
%token ARRAY
%token OF
%token IF
%token THEN
%token ENDIF
%token ELSE
%token WHILE
%token DO
%token BEGIN_LOOP
%token END_LOOP
%token CONTINUE
%token READ
%token WRITE
%token AND
%token OR
%token NOT
%token TRUE
%token FALSE
%token RETURN
%token INTEGER

%left SUB
%left ADD
%left MULT
%left DIV
%left MOD
%left EQ
%left NEQ
%left LT
%left GT
%left LTE
%left GTE

%token SEMICOLON
%token COLON
%token COMMA
%token L_PAREN
%token R_PAREN
%token L_SQUARE_BRACKET
%token R_SQUARE_BRACKET
%token ASSIGN

%token <stringVal> IDENTIFIER
%token <intVal> NUMBER

/* Grammar Rules */
%%

S:	funcs {printf("S -> funcs\n");}
	;

fun:	FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {printf("fun -> whateer this is\n");}
	;

funcs: 	{printf("funcs -> epsilon\n");}
	| fun funcs
	;

ident:	IDENTIFIER {printf("ident -> IDENTIFIER \n");}
	;

//identifiers:	ident {printf("identifiers -> ident \n")}
//	;

declaration:	ident COLON INTEGER
	;

declarations:	{printf("declarations -> epsilon\n");}
	| declaration SEMICOLON declarations {printf("declarations -> declaration SEMICOLON declarations\n");}
	;

comp:	{printf("comp -> epsilon\n")};
	| terminals EQ terminals {printf("comp -> terminals EQ terminals\n");}
	| terminals NEQ terminals {printf("comp -> terminals NEQ terminals\n");}
	| terminals LT terminals {printf("comp -> terminals LT terminals\n");}
	| terminals GT terminals {printf("comp -> terminals GT terminals\n");}
	| terminals LTE terminals {printf("comp -> terminals LTE terminals\n");}
	| terminals GTE terminals {printf("comp -> terminals GTE terminals\n");}
	;

boolean:	TRUE {printf("boolean -> TRUE\n");}
	| FALSE {printf("boolean -> FALSE\n");}
	;

exp:	{printf("exp -> epsilon");}
	| terminals
	| exp ADD exp
	| exp MULT exp
	| exp DIV exp
	| exp MOD exp
	;

statements:	{printf("statements -> epsilon\n");}
	| ident ASSIGN exp SEMICOLON {printf("statement -> ident ASSIGN exp SEMICOLON\n");}
	| READ ident SEMICOLON {printf("statement -> READ ident SEMICOLON\n");}
	| WRITE ident SEMICOLON {printf("statement -> WRITE ident SEMICOLON\n");}
	| RETURN exp SEMICOLON {printf("statement -> RETURN exp SEMICOLON\n");}
	| RETURN boolean SEMICOLON {printf("statement -> RETURN boolean SEMICOLON\n");}
	| IF L_PAREN comp R_PAREN THEN statements
	;

terminals: NUMBER {printf("terminals -> NUMBER\n");}
	| IDENTIFIER {printf("terminals -> IDENTIFIER\n");}
%%

int main(int argv, char **argc){
	yyparse();
	return 0;
}

void yyerror(char *s){
	printf("cats are better than dogs: %s", s);
}
