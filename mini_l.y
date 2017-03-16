/**********************

Phase 2

**********************/

%{
#include <stdlib.h>
#include <stdio.h>
void yyerror(char *s);
extern int line;
extern int pos;
FILE * yyin;
%}

%union{
    int intVal;
    char stringVal[256];
}

%error-verbose
%start PROGRAM

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

PROGRAM: Function {printf("PROGRAM -> Function\n");}
	| PROGRAM Function {printf("PROGRAM -> PROGRAM Function\n");}
	;

Function: FUNCTION IDENTIFIER SEMICOLON FirstDeclaration SecondDeclaration BEGIN_BODY StatementLoop END_BODY {printf("FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS Declaration SEMICOLON END_PARAMS BEGIN_LOCALS Declaration SEMICOLON END_LOCALS BEGIN_BODY Statement SEMICOLON END_BODY\n");}
	;

Declaration2: IdLoop1 COLON Declaration1 {printf("Declaration2 -> IdLoop1 COLON Declaration1\n");}
	;

Declaration: Declaration2  {printf("Declaration -> Declaration2\n");}
	| Declaration SEMICOLON Declaration2 {printf("Declaration -> Declaration SEMICOLON Declaration2\n");}
		

FirstDeclaration: BEGIN_PARAMS Declaration SEMICOLON END_PARAMS  {printf("FirstDeclaration -> BEGIN_PARAMS Declaration SEMICOLON END_PARAMS\n");}
	| BEGIN_PARAMS END_PARAMS {printf("FirstDeclaration -> BEGIN_PARAMS END_PARAMS\n");}


SecondDeclaration: BEGIN_LOCALS Declaration SEMICOLON END_LOCALS  {printf("SecondDeclaration -> BEGIN_LOCALS Declaration SEMICOLON END_LOCALS\n");}
	| BEGIN_LOCALS END_LOCALS  {printf("SecondDeclaration -> BEGIN_LOCALS END_LOCALS\n");}


Declaration1: INTEGER  {printf("Declaration1 -> INTEGER\n");}
	| ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("Declaration1 -> ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n");}
	;

IdLoop1: IDENTIFIER {printf("IdLoop1 -> IDENTIFIER %s\n", $1);}
	| IdLoop1 COMMA IDENTIFIER {printf("IdLoop1 -> IdLoop1 COMMA IDENTIFIER\n");}
	;

Statement1: Statement SEMICOLON  {printf("Statement1 -> Statement SEMICOLON\n");}
	;

Statement: Var ASSIGN Expression {printf("Statement -> Var ASSIGN Expression\n");}
	| READ VarLoop  {printf("Statement -> READ VarLoop\n");}
	| WRITE VarLoop {printf("Statement -> WRITE VarLoop\n");}
	| CONTINUE  {printf("Statement -> Continue\n");}
	| RETURN Expression {printf("Statement -> RETURN Expression\n");}
	| If ENDIF  {printf("Statement -> If ENDIF\n");}
	| While  {printf("Statement -> While\n");}
	| Do {printf("Statement -> Do\n");}
	;

While: WHILE BoolExpr BEGIN_LOOP StatementLoop END_LOOP {printf("While -> WHILE BoolExpr BEGIN_LOOP StatementLoop END_LOOP\n");}
	;

Do: DO BEGIN_LOOP StatementLoop END_LOOP WHILE BoolExpr {printf("Do -> DO BEGIN_LOOP StatementLoop END_LOOP WHILE BoolExpr\n");}
	;

If: IF BoolExpr THEN StatementLoop {printf("If -> IF BoolExpr THEN StatementLoop\n");}
	| If ELSE StatementLoop {printf("If -> If ELSE StatementLoop\n");}
	;

BoolExpr: RAE {printf("BoolExpr -> RAE\n");}
	| BoolExpr OR RAE {printf("BoolExpr -> BoolExpr OR RAE\n");}
	;

RAE:	RE {printf("RAE -> RE\n");}
	| RAE AND RE {printf("RAE -> RAE AND RE\n");}
	;

RE: NOT RE1  {printf("RE -> NOT RE1\n");}
	| RE1 {printf("RE -> RE1\n");}
	;

RE1: Expression Comp Expression {printf("RE1 -> Expression Comp Expression\n");}
	| TRUE {printf("RE1 -> TRUE\n");}
	| FALSE {printf("RE1 -> FALSE\n");}
	| L_PAREN BoolExpr R_PAREN {printf("RE1 -> L_PAREN BoolExpr R_PAREN\n");}
	;

Comp: EQ {printf("Comp -> EQ\n");}
	| NEQ {printf("Comp -> NEQ\n");}
	| LT  {printf("Comp -> LT\n");}
	| GT {printf("Comp -> GT\n");}
	| GTE {printf("Comp -> GTE\n");}
	| LTE {printf("Comp -> LTE\n");}
	;

StatementLoop: Statement1 {printf("StatementLoop -> Statement1\n");}
	| StatementLoop Statement1 {printf("StatementLoop -> StatementLoop Statement1\n");}
	;

VarLoop: Var  {printf("VarLoop -> Var\n");}
	| VarLoop COMMA Var {printf("VarLoop -> VarLoop COMMA Var\n");}
	;

Var: IDENTIFIER {printf("Var -> IDENTIFIER %s\n", $1);}
	| IDENTIFIER L_SQUARE_BRACKET Expression R_SQUARE_BRACKET {printf("Var -> IDENTIFIER L_SQUARE_BRACKET Expression R_SQUARE_BRACKET\n");}
	;


Expression: MultiplicativeExpr {printf("Expression -> MultiplicativeExpr\n");}
	| Expression ADD MultiplicativeExpr {printf("Expression -> Expression ADD MultiplicativeExpr\n");}
	| Expression SUB MultiplicativeExpr {printf("Expression -> Expression SUB MultiplicativeExpr\n");}
	;

MultiplicativeExpr: Term {printf("Multiplcative-Expr -> Term\n");}
	| MultiplicativeExpr MultMultExpr {printf("MultiplicativeExpr -> MULT MultiplicativeExpr\n");}
	| MultiplicativeExpr MultDiv {printf("MultiplicativeExpr -> DIV MultiplicativeExpr\n");}
	| MultiplicativeExpr MultMod {printf("MultiplicativeExpr -> MOD MultplicativeExpr\n");}
	;

MultMultExpr: MULT Term {printf("MultMultExpr -> MULT Term\n");}
	;

MultDiv: DIV Term {printf("MultDiv -> DIV Term\n");}
	;

MultMod: MOD Term {printf("MultMod -> MOD Term\n");}
	;

Term: SUB Term2 {printf("Term -> SUB Term2\n");}
	| Term2 {printf("Term -> Term2\n");}
	| IDENTIFIER L_PAREN R_PAREN {printf("Term -> IDENTIFIER L_PAREN R_PAREN\n");}
	| IDENTIFIER L_PAREN Term3 R_PAREN {printf("Term -> IDENTIFIER L_PAREN Term3 R_PAREN\n");}
	;

Term2: Var  {printf("Term2 -> Var\n");}
	| NUMBER {printf("Term2 -> NUMBER %i\n", $1);}
	| L_PAREN Expression R_PAREN {printf("Term2 -> L_PAREN\n");}
	;

Term3: Expression  {printf("Term3 -> Expression\n");}
	| Term3 Term3a {printf("Term3 -> Term3 Term3a\n");}
	;

Term3a: COMMA Expression {printf("Term3a -> COMMA Expression\n");}
	;



%%

int main(int argv, char **argc){
	yyparse();
	return 0;
}

void yyerror(char *s){
	printf("Error: %s \nAt position: %d \nAt line: %d \n", s, pos, line);
	return;
}
