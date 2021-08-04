%{
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "pi_parser.tab.h"
#include "cgen.h"

int line_num = 1;

%}

LETTERS [a-zA-Z]
DIGIT  [0-9]
NUM  {DIGIT}{DIGIT}*
STRING  '[^'\n]*'

IDENTIFIER 				{LETTERS}({LETTERS}*[_]*{DIGIT}*)*
CONSTANT_INTEGER			([1-9]{DIGIT}*|{DIGIT})
CONSTANT_FLOAT				({DIGIT}+"."{DIGIT}+([eE][+-]?[1-9]*)?)
CONSTANT_BOOL				(true|false)
CONSTANT_STRING			(\"([^\\\"]|\\.)*\")


%x comment

%%
"int"						return KW_INT;
"real"						return KW_REAL;
"string"					return KW_STRING;
"bool"						return KW_BOOL;
"var"						return KW_VAR;
"const"					return KW_CONST;
"if"						return KW_IF;
"else"						return KW_ELSE;
"for"						return KW_FOR;
"while"					return KW_WHILE;
"break"					return KW_BREAK;
"continue"					return KW_CONTINUE;
"begin" 					return KW_BEGIN;
"func"   					return KW_FUNC;
"nil"						return KW_NIL;
"and"						return KW_AND;
"or"						return KW_OR;
"not"						return KW_NOT;
"return"					return KW_RETURN;
"true"						return KW_TRUE;
"false"					return KW_FALSE;


{IDENTIFIER} 					{yylval.crepr = strdup(yytext); return IDENTIFIER;}
{CONSTANT_INTEGER}				{yylval.crepr = strdup(yytext); return CONSTANT_INTEGER;}
{CONSTANT_FLOAT}				{yylval.crepr = strdup(yytext); return CONSTANT_FLOAT;}
{CONSTANT_STRING}				{yylval.crepr = strdup(yytext); return CONSTANT_STRING;}
{STRING}   					{yylval.crepr = strdup(yytext); return STRING;}


"+"						return OPERATOR_PLUS;
"-"						return OPERATOR_MINUS;
"*"						return OPERATOR_MULT;
"/"						return OPERATOR_BACKSHLASH;
"%"						return OPERATOR_MODULO;
"**"						return OPERATOR_POW;
"=="						return OPERATOR_EQUAL;
"!="						return OPERATOR_UNEQUAL;
"<"						return OPERATOR_SMALLER;
"<="						return OPERATOR_SMALLEREQUAL;
">"						return OPERATOR_BIGGER;
">="						return OPERATOR_BIGGEREQUAL;
" = "						return OPERATOR_ASSIGN;


"["						return DELIMETER_LEFTBLOCK;
"]"						return DELIMETER_RIGHTBLOCK;	
"="						return DELIMETER_ASSIGN;
";" 						return DELIMETER_SEMICOLON;
","						return DELIMETER_COMMA;
")"						return DELIMETER_RIGHTPAR;
"("						return DELIMETER_LEFTPAR;
"{"						return DELIMETER_LEFTBRACKET;
"}"						return DELIMETER_RIGHTBRACKET;

"//"[^\n]*  	/* eat line comments */

"/*"		BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++line_num;
<comment>"*"+"/"        BEGIN(INITIAL);


[ \r\t]		/* skip whitespace */
\n 		++line_num;
<<EOF>> 	return EOF;

.             { yyerror("lexical error: unrecognized literal '%s'\n", yytext); }


%%
/*
int main()
{
	int token;
	while((token = yylex()) != EOF)
		printf("Line %d Token %d %s \n", line_num, token,  yytext);
}
*/
