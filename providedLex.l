%{
/*constants are defined outside of the l file in y.tab.h
*constants are defined from 257
*/

//#include "y.tab.h"
#define TOKEN_FOUND	return 1;
#define EOF			return 0;

char the_token[1000];
char full_line[1000];
int input_line_no=1;

%}

letter			[A-Za-z]
digit			[0-9]
whitespace		[ \t]
eol				\n
alfanum			[A-Za-z0-9_]
id				[letter]+[alfanum]*
intcon			[digit]+
ch				[ -]
charcon			(["\n""\0"] | ch)
stringcon		[ch]+
commentStart	"/*"
commentEnd		"*/"
anything		.
bin_op			["+""-""*""/"]
rel_op			["==""!=""<=""<"">="">"]
logical_op		["&&""||"]
prog			[stmt]+
stmt			(if"("expr")"stmt[else(stmt)])|(while"("expr")"stmt)|(for"("[assg]";"[expr]";"[assg]")"stmt)|(return[expr]";")|(assg";")|(id"("[expr{","expr}]")"";")|("{"{stmt}"}")|";"
assg			id["["expr"]"]"="expr
expr			("-"expr)|("!"expr)|((expr)(bin_op)(expr))|((expr)(rel_op)(expr))|((expr)(logical_op)(expr))|(id["("[expr{","expr}]")"|"["expr"]"])|("("expr")")|intcon|charcon|stringcon



%Start comment_in comment_out string_in char_in char_out
%option noyywrap

%%


eol				{ input_line_no++; }


<INITIAL>"/""*"		{ BEGIN(comment_in); }
<comment_in>"*"		{ BEGIN(comment_out); }
<comment_in>[^*]	{ ; }
<comment_out>"*"	{ ; }
<comment_out>"/"	{ BEGIN(INITIAL); }
<comment_out>[^*/]	{ BEGIN(comment_in); }

<INITIAL>\"			{ BEGIN(string_in); }

<INITIAL>{intcon}	{ return(INTCON); }


<INITIAL>anything	{ return(OTHER); }

%%


main() {

        int result;
        while ((result=yylex())!=0) {
            printf("%d\t%s\n", result, yytext);
        }
        return 0;
}
/**/