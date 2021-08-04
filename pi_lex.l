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
"int"						{printf("Line %d: Found the KW_INT %s\n",line_num,yytext);return KW_INT;}
"real"						{printf("Line %d: Found the KW_REAL %s\n",line_num,yytext);return KW_REAL;}
"string"					{printf("Line %d: Found the KW_STRING %s\n",line_num,yytext);return KW_STRING;}
"bool"						{printf("Line %d: Found the KW_BOOL %s\n",line_num,yytext);return KW_BOOL;}
"var"						{printf("Line %d: Found the KW_VAR %s\n",line_num,yytext);return KW_VAR;}
"const"					{printf("Line %d: Found the KW_CONST %s\n",line_num,yytext);return KW_CONST;}
"if"						{printf("Line %d: Found the KW_IF %s\n",line_num,yytext);return KW_IF;}
"else"						{printf("Line %d: Found the KW_ELSE %s\n",line_num,yytext);return KW_ELSE;}
"for"						{printf("Line %d: Found the KW_FOR %s\n",line_num,yytext);return KW_FOR;}
"while"					{printf("Line %d: Found the KW_WHILE %s\n",line_num,yytext);return KW_WHILE;}
"break"					{printf("Line %d: Found the KW_BREAK %s\n",line_num,yytext);return KW_BREAK;}
"continue"					{printf("Line %d: Found the KW_CONTINUE %s\n",line_num,yytext);return KW_CONTINUE;}
"begin" 					{printf("Line %d: Found the KW_BEGIN %s\n",line_num,yytext);return KW_BEGIN;}
"func"   					{printf("Line %d: Found the KW_FUNC %s\n",line_num,yytext);return KW_FUNC;}
"nil"						{printf("Line %d: Found the KW_NIL %s\n",line_num,yytext);return KW_NIL;}
"and"						{printf("Line %d: Found the KW_AND %s\n",line_num,yytext);return KW_AND;}
"or"						{printf("Line %d: Found the KW_OR %s\n",line_num,yytext);return KW_OR;}
"not"						{printf("Line %d: Found the KW_NOT %s\n",line_num,yytext);return KW_NOT;}
"return"					{printf("Line %d: Found the KW_RETURN %s\n",line_num,yytext);return KW_RETURN;}
"true"						{printf("Line %d: Found the KW_TRUE %s\n",line_num,yytext);return KW_TRUE;}
"false"					{printf("Line %d: Found the KW_FALSE %s\n",line_num,yytext);return KW_FALSE;}


{IDENTIFIER} 					{printf("Line %d: Found the IDENTIFIER %s\n",line_num,yytext); yylval.crepr = strdup(yytext); return IDENTIFIER;}
{CONSTANT_INTEGER}				{printf("Line %d: Found the CONSTANT_INTEGER %s\n",line_num,yytext); yylval.crepr = strdup(yytext); return CONSTANT_INTEGER;}
{CONSTANT_FLOAT}				{printf("Line %d: Found the CONSTANT_FLOAT %s\n",line_num,yytext); yylval.crepr = strdup(yytext); return CONSTANT_FLOAT;}
{CONSTANT_STRING}				{printf("Line %d: Found the CONSTANT_STRING %s\n",line_num,yytext); yylval.crepr = strdup(yytext); return CONSTANT_STRING;}
{STRING}   					{printf("Line %d: Found the STRING %s\n",line_num,yytext); yylval.crepr = strdup(yytext); return STRING;}


"+"						{printf("Line %d: Found the OPERATOR_PLUS %s\n",line_num,yytext); return OPERATOR_PLUS; }
"-"						{printf("Line %d: Found the OPERATOR_MINUS %s\n",line_num,yytext); return OPERATOR_MINUS;}
"*"						{printf("Line %d: Found the OPERATOR_MULT %s\n",line_num,yytext); return OPERATOR_MULT;}
"/"						{printf("Line %d: Found the OPERATOR_BACKSHLASH %s\n",line_num,yytext); return OPERATOR_BACKSHLASH;}
"%"						{printf("Line %d: Found the OPERATOR_MODULO %s\n",line_num,yytext); return OPERATOR_MODULO;}
"**"						{printf("Line %d: Found the OPERATOR_POW %s\n",line_num,yytext); return OPERATOR_POW;}
"=="						{printf("Line %d: Found the OPERATOR_EQUAL %s\n",line_num,yytext); return OPERATOR_EQUAL;}
"!="						{printf("Line %d: Found the OPERATOR_UNEQUAL %s\n",line_num,yytext); return OPERATOR_UNEQUAL;}
"<"						{printf("Line %d: Found the OPERATOR_SMALLER %s\n",line_num,yytext); return OPERATOR_SMALLER;}
"<="						{printf("Line %d: Found the OPERATOR_SMALLEREQUAL %s\n",line_num,yytext); return OPERATOR_SMALLEREQUAL;}
">"						{printf("Line %d: Found the OPERATOR_BIGGER %s\n",line_num,yytext); return OPERATOR_BIGGER;}
">="						{printf("Line %d: Found the OPERATOR_BIGGEREQUAL %s\n",line_num,yytext); return OPERATOR_BIGGEREQUAL;}
" = "						{printf("Line %d: Found the OPERATOR_ASSIGN %s\n",line_num,yytext); return OPERATOR_ASSIGN;}


"["						{printf("Line %d: Found the DELIMETER_LEFTBLOCK %s\n",line_num,yytext);return DELIMETER_LEFTBLOCK;}
"]"						{printf("Line %d: Found the DELIMETER_RIGHTBLOCK %s\n",line_num,yytext);return DELIMETER_RIGHTBLOCK;}	
"="						{printf("Line %d: Found the DELIMETER_ASSIGN %s\n",line_num,yytext); return DELIMETER_ASSIGN;}
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
