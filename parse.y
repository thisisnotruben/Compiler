%{

#include <stdio.h>

#define YDEBUG 0

#define Y_DEBUG_PRINT(x) \
	if (YDEBUG) \
		printf("Yout %s \n ",x)

#ifndef YDEBUG
	#undef Y_DEBUG_PRINT(x)
	#define Y_DEBUG_PRINT(x)
#endif // YDEBUG

void yyerror(char const *);
void warn(char const *s);

extern int yylex(void);
extern char the_token[];
extern int input_line_nbr;
extern char *full_line;
extern int lex_state;

%}

%token STRINGCON CHARCON INTCON EQUALS NOTEQU GREEQU LESEQU GREATE LESSTH
%token ANDCOM ORCOMP SEMIC COMMA LPARN RPARN LBRAC RBRAC LCURL RCURL ABANG
%token EQUAL ADD SUB MUL DIV ID EXTERN FOR WHILE RETURN IF ELSE
%token VOID CHAR INT OTHER

%nonassoc PREC_LOWER_THAN_ELSE
%nonassoc ELSE
%nonassoc PREC_LOGOP
%nonassoc PREC_RELOP
%nonassoc PREC_BINOP

%left ORCOMP
%left ANDCOM
%left EQUALS NOTEQU
%left LESSTH GREATE LESEQU GREEQU
%left ADD SUB
%left MUL DIV
%right UMINUS
%right ABANG

%%

Prog
	: 						{ Y_DEBUG_PRINT("Prog-1 EMPTY"); }
	| StmtRep				{ Y_DEBUG_PRINT("Prog-2 -> StmtRep"); }
	;

Stmt
	: IF LPARN Expr RPARN Stmt %prec PREC_LOWER_THAN_ELSE							{ Y_DEBUG_PRINT("Stmt-1-IF Stmt"); }
	| IF LPARN Expr RPARN Stmt ELSE Stmt											{ Y_DEBUG_PRINT("Stmt-2-IF-ELSE Stmt"); }
	| WHILE LPARN Expr RPARN Stmt													{ Y_DEBUG_PRINT("Stmt-3-WHILE Stmt"); }
	| FOR LPARN StmtForAssign SEMIC StmtOptExpr SEMIC StmtForAssign RPARN Stmt		{ Y_DEBUG_PRINT("Stmt-4-FOR Stmt"); }
	| RETURN StmtOptExpr SEMIC														{ Y_DEBUG_PRINT("Stmt-5-RETURN Stmt"); }
	| Assign SEMIC																	{ Y_DEBUG_PRINT("Stmt-6-Assign Stmt"); }
	| ID LPARN StmtId RPARN SEMIC													{ Y_DEBUG_PRINT("Stmt-7-ID Stmt"); }
	| LCURL RCURL																	{ Y_DEBUG_PRINT("Stmt-8-LCURL RCURL Stmt"); }
	| LCURL StmtRep RCURL															{ Y_DEBUG_PRINT("Stmt-9-LCURL Stmt RCURL Stmt"); }
	| SEMIC																			{ Y_DEBUG_PRINT("Stmt-10-SEMIC Stmt"); }
	;


Assign
	: ID Assign1 EQUAL Expr	{Y_DEBUG_PRINT("Assign-1-ID-Assign1-EQUAL-Expr"); }
	;

Expr
	: SUB Expr %prec UMINUS				{ Y_DEBUG_PRINT("Expr-1-UMINUS Expr"); }
	| ABANG Expr						{ Y_DEBUG_PRINT("Expr-2-ANABG Expr"); }
	| Expr Logop Expr %prec PREC_LOGOP	{ Y_DEBUG_PRINT("Expr-3-Expr-Logop-Expr"); }
	| Expr Relop Expr %prec PREC_RELOP	{ Y_DEBUG_PRINT("Expr-4-Expr-Relop-Expr"); }
	| Expr Binop Expr %prec PREC_BINOP	{ Y_DEBUG_PRINT("Expr-5-Expr-Binop-Expr"); }
	| ID ExprId							{ Y_DEBUG_PRINT("Expr-6-ID"); }
	| LPARN Expr RPARN					{ Y_DEBUG_PRINT("Expr-7-LPARN-Expr-RPARN");}
	| INTCON							{ Y_DEBUG_PRINT("Expr-8-INTCON"); }
	| CHARCON							{ Y_DEBUG_PRINT("Expr-9-CHARCON"); }
	| STRINGCON							{ Y_DEBUG_PRINT("Expr-10-STRINGCON"); }
	| error								{ warn(":invalid expression "); }
	;

Binop
	: ADD					{ Y_DEBUG_PRINT("Binop-1-ADD"); }
	| SUB					{ Y_DEBUG_PRINT("Binop-2-SUB"); }
	| MUL					{ Y_DEBUG_PRINT("Binop-3-MUL"); }
	| DIV					{ Y_DEBUG_PRINT("Binop-4-DIV"); }
	;

Relop
	: EQUALS				{ Y_DEBUG_PRINT("Relop-1-EQUALS"); }
	| NOTEQU				{ Y_DEBUG_PRINT("Relop-2-NOTEQU"); }
	| LESEQU				{ Y_DEBUG_PRINT("Relop-3-LESEQU"); }
	| LESSTH				{ Y_DEBUG_PRINT("Relop-6-LESSTH"); }
	| GREEQU				{ Y_DEBUG_PRINT("Relop-4-GREEQU"); }
	| GREATE				{ Y_DEBUG_PRINT("Relop-5-GREATE"); }
	;

Logop
	: ANDCOM				{ Y_DEBUG_PRINT("Logop-1-ANDCOM"); }
	| ORCOMP				{ Y_DEBUG_PRINT("Logop-2-ORCOMP"); }
	;

StmtForAssign
	:
	| Assign				{ Y_DEBUG_PRINT("StmtForAssign -> Assign"); }
	;

StmtOptExpr
	:
	| Expr					{ Y_DEBUG_PRINT("StmtOptExpr -> Expr"); }
	;

StmtId
	:
	| ExprList				{ Y_DEBUG_PRINT("StmtId -> ExprList"); }
	;

StmtRep
	: Stmt					{ Y_DEBUG_PRINT("StmtRep-1 -> Stmt"); }
	| StmtRep Stmt			{ Y_DEBUG_PRINT("StmtRep-2 -> StmtRep Stmt"); }
	;

Assign1
	:						{ Y_DEBUG_PRINT("Assign1-1-Empty"); }
	| LBRAC Expr RBRAC		{ Y_DEBUG_PRINT("Assign1-2-LBRAC-Expr-RBRAC"); }
	;

ExprId
	:						{ Y_DEBUG_PRINT("ExprId-1-Empty"); }
	| LPARN StmtId RPARN	{ Y_DEBUG_PRINT("ExprId-2-LPARN-StmtId-RPARN"); }
	| LBRAC Expr RBRAC		{ Y_DEBUG_PRINT("ExprId-3-LBRAC-Expr-RBRAC"); }
	| error RBRAC			{ Y_DEBUG_PRINT("ExprId-4-error-RBRAC"); }
	;

ExprList
	: Expr					{ Y_DEBUG_PRINT("ExprList-1 -> Expr"); }
	| ExprList COMMA Expr	{ Y_DEBUG_PRINT("ExprList-2 -> ExprList-COMMA-Expr"); }
	;

%%

int main(int argc, char **argv)
{
	int result = yyparse();

	if (lex_state == 1)
	{
		yyerror("End of file within a comment\n");
	}
	else if (lex_state == 2)
	{
		yyerror("End of file within a string\n");
	}

	return result;
}

int yywrap() { return 1; }

void yyerror(char const *s) { fprintf(stderr, "%s on line %d\n", s, input_line_nbr); }

void warn(char const *s) { fprintf(stderr, "%s\n", s); }
