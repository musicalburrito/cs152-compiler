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

fun:	FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {printf("fun -> FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS decalarations END_PARAMS BEGIN_LOCALS declarations END LOCALS BEGIN_BODY statements END_BODY\n");}
	;

funcs: 	{printf("funcs -> epsilon\n");}
	| fun funcs
	;

id:	IDENTIFIER {printf("id -> IDENTIFIER \n");}
	| IDENTIFIER COMMA id {printf("id -> IDENTIFIER COMMA id\n");}
	;

declaration:	id COLON types
	;

declarations:	{printf("declarations -> epsilon\n");}
	| declaration SEMICOLON declarations {printf("declarations -> declaration SEMICOLON declarations\n");}
	;

comp:	{printf("comp -> epsilon\n");}
	| exp EQ exp {printf("comp -> terminals EQ terminals\n");}
	| exp NEQ exp {printf("comp -> terminals NEQ terminals\n");}
	| exp LT exp {printf("comp -> terminals LT terminals\n");}
	| exp GT exp {printf("comp -> terminals GT terminals\n");}
	| exp LTE exp {printf("comp -> terminals LTE terminals\n");}
	| exp GTE exp {printf("comp -> terminals GTE terminals\n");}
	| TRUE {printf("boolean -> TRUE\n");}
	| FALSE {printf("boolean -> FALSE\n");}
	;

boolean: {printf("boolean -> epsilon\n");}	
	| NOT {printf("boolean -> NOT\n");}
	| OR {printf("boolean -> OR\n");}
	| AND {printf("boolean -> AND\n");}
	;

exp:	terminals
	| function
	| array
	| exp ADD exp
	| exp SUB exp
	| exp MULT exp
	| exp DIV exp
	| exp MOD exp
	| L_PAREN exp R_PAREN
	;

function: id L_PAREN exp R_PAREN
	;

statements: {printf("statements -> epsilon\n");}
	| statements1 statements {printf("statements -> statements1 statements\n");}
	;

statements1: assignStatements SEMICOLON {printf("statements1 -> assignStatements SEMICOLON\n");}
	| READ id SEMICOLON {printf("statements1 -> READ id SEMICOLON\n");}
	| WRITE id SEMICOLON {printf("statements1 -> WRITE id SEMICOLON\n");}
	| returnStatements SEMICOLON {printf("statements1 -> returnStatements SEMICOLON\n");}
	| whileStatements SEMICOLON {printf("statements1 -> whileStatments SEMICOLON\n");}
	| ifStatements SEMICOLON {printf("statements1 -> ifStatement SEMICOLON\n");}
	;

whileStatements: WHILE comp BEGIN_LOOP statements END_LOOP {printf("whileStatements -> WHILE comp BEGIN_LOOP statements END_LOOP\n");}

assignStatements: id ASSIGN exp {printf("assignStatements -> id ASSIGN exp\n");}
	| array ASSIGN exp {printf("assignStatements -> array ASSIGN exp\n");}
	;

returnStatements: RETURN exp {printf("returnStatements -> RETURN exp\n");}
	| RETURN boolean {printf("returnStatements -> RETURN boolean\n");}

ifStatements: IF L_PAREN comp R_PAREN THEN statements ENDIF {printf("ifStatements -> L_PAREN comp BEGIN_LOOP statements END_LOOP SEMICOLON\n");}
	| IF comp THEN statements ENDIF {printf("ifStatements -> comp THEN statements ENDIF\n");}
	| IF L_PAREN comp R_PAREN THEN statements ELSE statements {printf("ifStatements -> IF L_PAREN comp BEGIN_LOOP statements ELSE statement\n");}
	| IF comp THEN statements ELSE statements ENDIF {printf("ifStatements -> IF comp THEN statements ELSE statements ENDIF\n");}
	;

terminals: NUMBER {printf("terminals -> NUMBER\n");}
	| IDENTIFIER {printf("terminals -> IDENTIFIER\n");}
	;

array: ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET {printf("array -> id L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET\n");}
	| id L_SQUARE_BRACKET terminals R_SQUARE_BRACKET

types: INTEGER {printf("types -> INTEGER\n");}
	| array OF INTEGER


%%

int main(int argv, char **argc){
	yyparse();
	return 0;
}

void yyerror(char *s){
	printf("cats are better than dogs: %s", s);
}
