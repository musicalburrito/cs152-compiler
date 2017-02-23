/**********************

Phase 2

**********************/

%{
#include <stdio.h>
void yyerror(char *s);
extern int line;
extern int pos;
FILE * yyin;
%}

%union{
    int intVal;
    char* stringVal;
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
	| PROGRAM Function {}
	;

Function: FUNCTION IDENTIFIER SEMICOLON FirstDeclaration SecondDeclaration BEGIN_BODY StatementLoop END_BODY {printf("FUNCTION IDENTIFIER SEMICOLON BEGIN_PARAMS Declaration SEMICOLON END_PARAMS BEGIN_LOCALS Declaration SEMICOLON END_LOCALS BEGIN_BODY Statement SEMICOLON END_BODY\n");}
	;

Declaration2: IdLoop1 COLON Declaration1
	;

Declaration: Declaration2
	| Declaration SEMICOLON Declaration2

FirstDeclaration: BEGIN_PARAMS Declaration SEMICOLON END_PARAMS
	| BEGIN_PARAMS END_PARAMS

SecondDeclaration: BEGIN_LOCALS Declaration SEMICOLON END_LOCALS
	| BEGIN_LOCALS END_LOCALS

Declaration1: INTEGER
	| ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER
	;

IdLoop1: IDENTIFIER
	| IdLoop1 COMMA IDENTIFIER
	;

Statement1: Statement SEMICOLON
	;

Statement: Var ASSIGN Expression
	| READ VarLoop
	| WRITE VarLoop
	| CONTINUE
	| RETURN Expression
	| If ENDIF
	| While
	| Do
	;

While: WHILE BoolExpr BEGIN_LOOP StatementLoop END_LOOP
	;

Do: DO BEGIN_LOOP StatementLoop END_LOOP WHILE BoolExpr
	;

If: IF BoolExpr THEN StatementLoop
	| If ELSE StatementLoop
	;

BoolExpr: RAE
	| BoolExpr OR RAE
	;

RAE:	RE
	| RAE AND RE
	;

RE: NOT RE1
	| RE1
	;

RE1: Expression Comp Expression
	| TRUE
	| FALSE
	| L_PAREN BoolExpr R_PAREN
	;

Comp: EQ
	| NEQ
	| LT
	| GT
	| GTE
	| LTE
	;

StatementLoop: Statement1
	| StatementLoop Statement1
	;

VarLoop: Var
	| VarLoop COMMA Var
	;

Var: IDENTIFIER {printf("Var -> IDENTIFIER\n");}
	| IDENTIFIER L_SQUARE_BRACKET Expression R_SQUARE_BRACKET
	;

//Var2: {printf("Var2 -> epsilon\n");}
//	| L_SQUARE_BRACKET Expression R_SQUARE_BRACKET {printf("Var2 -> L_SQUARE_BRACKET Expression R_SQUARE_BRACKET\n");}
//	;

Expression: MultiplicativeExpr
	| Expression ADD MultiplicativeExpr
	| Expression SUB MultiplicativeExpr
	;

MultiplicativeExpr: Term {printf("Multiplcative-Expr -> Term\n");}
	| MultiplicativeExpr MultMultExpr {printf("MultiplicativeExpr -> MULT MultiplicativeExpr\n");}
	| MultiplicativeExpr MultDiv {printf("MultiplicativeExpr -> DIV MultiplicativeExpr\n");}
	| MultiplicativeExpr MultMod {printf("MultiplicativeExpr -> MOD MultplicativeExpr\n");}
	;

MultMultExpr: MULT Term
	;

MultDiv: DIV Term
	;

MultMod: MOD Term
	;

Term: SUB Term2
	| Term2
	| IDENTIFIER L_PAREN R_PAREN
	| IDENTIFIER L_PAREN Term3 R_PAREN
	;

Term2: Var
	| NUMBER
	| L_PAREN Expression R_PAREN
	;

Term3: Expression
	| Term3 Term3a
	;

Term3a: COMMA Expression
	;

//Term4: R_PAREN


%%

int main(int argv, char **argc){
	yyparse();
	return 0;
}

void yyerror(char *s){
	printf("Error: %s \nAt position: %d \nAt line: %d \n", s, pos, line);
	return;
}
