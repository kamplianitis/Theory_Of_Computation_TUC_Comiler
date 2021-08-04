%{
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>		
#include "cgen.h"

extern int yylex(void);
extern int line_num;
%}

%union
{
	char* crepr;
}


 
%token <crepr> STRING


%token KW_INT
%token KW_REAL
%token KW_STRING
%token KW_BOOL
%token KW_VAR
%token KW_CONST
%token KW_IF
%token KW_ELSE
%token KW_FOR
%token KW_WHILE
%token KW_BREAK
%token KW_CONTINUE
%token KW_NIL
%token KW_AND
%token KW_OR
%token KW_NOT
%token KW_RETURN
%token KW_BEGIN
%token KW_FUNC
%token KW_TRUE
%token KW_FALSE

%token <crepr> IDENTIFIER
%token <crepr> CONSTANT_INTEGER
%token <crepr> CONSTANT_FLOAT
%token <crepr> CONSTANT_STRING

%token OPERATOR_PLUS
%token OPERATOR_MINUS
%token OPERATOR_MULT
%token OPERATOR_BACKSHLASH
%token OPERATOR_MODULO
%token OPERATOR_POW
%token OPERATOR_EQUAL
%token OPERATOR_UNEQUAL
%token OPERATOR_SMALLER
%token OPERATOR_SMALLEREQUAL
%token OPERATOR_BIGGER
%token OPERATOR_BIGGEREQUAL
%token OPERATOR_ASSIGN

%token DELIMETER_LEFTBLOCK
%token DELIMETER_RIGHTBLOCK
%token DELIMETER_ASSIGN
%token DELIMETER_SEMICOLON
%token DELIMETER_COMMA
%token DELIMETER_RIGHTPAR
%token DELIMETER_LEFTPAR
%token DELIMETER_LEFTBRACKET
%token DELIMETER_RIGHTBRACKET

%start program

%type <crepr> decl_list body decl
// generics
%type <crepr> type_converter
%type <crepr> id_list
%type <crepr> array
%type <crepr> double_operator
%type <crepr> logic_operator
%type <crepr> comparator
%type <crepr> array_expressions
// declarations
%type <crepr> variable_declaration
%type <crepr> constant_declaration
%type <crepr> expressions
%type <crepr> function_declaration function_arguements function_body
%type <crepr> return_type return_void
%type <crepr> list_declaration


// statements
%type <crepr> variable_statement
%type <crepr> function_statement
%type <crepr> function_statement_arg
%type <crepr> for_statement
%type <crepr> while_statement
%type <crepr> if_statement
%type <crepr> if_else_statement
%type <crepr> One_line_command
%type <crepr> else_statement
%type <crepr> function_statement_expr
%type <crepr> for_variable_statement


%left   KW_OR
%left   KW_AND
%left   OPERATOR_EQUAL OPERATOR_UNEQUAL OPERATOR_SMALLER OPERATOR_SMALLEREQUAL OPERATOR_BIGGER OPERATOR_BIGGEREQUAL
%left   OPERATOR_MULT OPERATOR_BACKSHLASH OPERATOR_MODULO
%right  OPERATOR_POW
%left  OPERATOR_PLUS OPERATOR_MINUS
%right  KW_NOT

%%

program: decl_list KW_FUNC KW_BEGIN DELIMETER_LEFTPAR DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET body DELIMETER_RIGHTBRACKET DELIMETER_SEMICOLON{ 

 /* We have a successful parse! 
    Check for any errors and generate output. 
  */
  
  if (yyerror_count == 0) {
    // include the pilib.h file
    puts(c_prologue); 
    printf("/* program */ \n\n");
    printf("%s\n\n", $1);
    printf("int main() {\n%s\n} \n", $7);
  }
}
|KW_FUNC KW_BEGIN DELIMETER_LEFTPAR DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET body DELIMETER_RIGHTBRACKET DELIMETER_SEMICOLON{ 

 /* We have a successful parse! 
    Check for any errors and generate output. 
  */
  
  if (yyerror_count == 0) {
    // include the pilib.h file
    puts(c_prologue); 
    printf("/* program */ \n\n");
    printf("int main() {\n%s\n} \n", $6);
  }
}
;


type_converter: 
	KW_INT {$$ = template("%s", "int");}
|	KW_BOOL {$$ = template("%s", "int");}	// no boolean types in c and C uses ints to depict them
|	KW_REAL {$$ = template("%s","double");}
|	KW_STRING {$$ = template("%s", "char*");}
;

//GENERICS

id_list: 
	IDENTIFIER {$$ = $1;}
|	IDENTIFIER DELIMETER_LEFTBLOCK expressions DELIMETER_RIGHTBLOCK {$$ = template("%s[%s]",$1,$3);}
|	id_list DELIMETER_COMMA IDENTIFIER {$$ = template("%s, %s", $1,$3);}
;

array:
	IDENTIFIER DELIMETER_LEFTBLOCK DELIMETER_RIGHTBLOCK type_converter {$$ = template("%s* %s", $4, $1);}
|	IDENTIFIER DELIMETER_LEFTBLOCK expressions DELIMETER_RIGHTBLOCK type_converter {$$ = template("%s %s[%s]", $5, $1, $3);}
;


double_operator:
  	expressions OPERATOR_MULT expressions {$$ = template("%s * %s", $1,$3);}
|	expressions OPERATOR_BACKSHLASH expressions {$$ = template("%s / %s",$1,$3);}
|	expressions OPERATOR_MODULO expressions {$$ = template("%s %s %s", $1,"%", $3);}
|	expressions OPERATOR_POW expressions {$$ = template("%s ** %s", $1,$3);}
;

comparator: 
	expressions OPERATOR_EQUAL expressions {$$ = template("%s == %s", $1,$3);}
|	expressions OPERATOR_UNEQUAL expressions {$$ = template("%s != %s", $1,$3);} 
|	expressions OPERATOR_SMALLER expressions {$$ = template("%s < %s", $1, $3);}
|	expressions OPERATOR_SMALLEREQUAL expressions {$$ = template("%s <= %s", $1, $3);}
|	expressions OPERATOR_BIGGER expressions {$$ = template("%s > %s", $1, $3);}
|	expressions OPERATOR_BIGGEREQUAL expressions {$$ = template("%s >= %s",$1,$3);}
;

logic_operator:
	expressions KW_AND expressions {$$ = template("%s && %s", $1,$3);}
|	expressions KW_OR  expressions  {$$ = template("%s || %s",$1, $3);}
|	KW_NOT expressions {$$ = template(" !%s ",$2);}
;
// DECLARATIONS AND NEEDED STUFF


array_expressions :
	expressions {$$ = template("%s", $1);}
|	array_expressions DELIMETER_COMMA expressions {$$ = template("%s , %s", $1, $3);}
;


variable_declaration: 
	KW_VAR id_list type_converter DELIMETER_SEMICOLON{$$ = template("%s %s; ", $3, $2); }
|	KW_VAR id_list OPERATOR_ASSIGN expressions type_converter DELIMETER_SEMICOLON {$$ = template("%s %s = %s;" , $5,$2, $4);}
;


constant_declaration:
//	KW_CONST id_list OPERATOR_ASSIGN expressions type_converter DELIMETER_SEMICOLON{$$ = template("%s %s %s = %s;","const",$5,$2,$4);}
	KW_CONST array OPERATOR_ASSIGN DELIMETER_LEFTBLOCK array_expressions DELIMETER_RIGHTBLOCK DELIMETER_SEMICOLON{$$ = template("%s %s = [%s];","const",$2,$5);}
|	KW_CONST list_declaration type_converter DELIMETER_SEMICOLON {$$ = template("%s %s %s;","const",$3,$2);}
;

list_declaration: 
	IDENTIFIER OPERATOR_ASSIGN expressions {$$ = template("%s = %s", $1, $3);}
|	list_declaration DELIMETER_COMMA IDENTIFIER OPERATOR_ASSIGN expressions {$$ = template("%s, %s = %s",$1, $3, $5);}
;

function_declaration:
	KW_FUNC IDENTIFIER DELIMETER_LEFTPAR DELIMETER_RIGHTPAR type_converter DELIMETER_LEFTBRACKET function_body return_type DELIMETER_RIGHTBRACKET DELIMETER_SEMICOLON{$$= template("%s %s()\n{\n%s\n%s\n}",$5, $2, $7,$8);} // type foo(){body returntype}
|	KW_FUNC IDENTIFIER DELIMETER_LEFTPAR function_arguements DELIMETER_RIGHTPAR type_converter DELIMETER_LEFTBRACKET function_body return_type DELIMETER_RIGHTBRACKET DELIMETER_SEMICOLON {$$= template("%s %s(%s)\n{\n%s\n%s\n}",$6, $2,$4,$8,$9);} // type foo(arg){body reutrntype}
|	KW_FUNC IDENTIFIER DELIMETER_LEFTPAR DELIMETER_RIGHTPAR type_converter DELIMETER_LEFTBRACKET return_type DELIMETER_RIGHTBRACKET DELIMETER_SEMICOLON{$$= template("%s %s()\n{\n%s\n}",$5, $2,$7);} // type foo(){returntype}
|	KW_FUNC IDENTIFIER DELIMETER_LEFTPAR function_arguements DELIMETER_RIGHTPAR type_converter DELIMETER_LEFTBRACKET return_type DELIMETER_RIGHTBRACKET DELIMETER_SEMICOLON{$$= template("%s %s(%s)\n{\n%s\n}",$6, $2,$4,$8);} // type foo(arg){returntype}
|	KW_FUNC IDENTIFIER DELIMETER_LEFTPAR DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET DELIMETER_RIGHTBRACKET DELIMETER_SEMICOLON {$$= template("%s %s()\n{\n}","void", $2);} // void foo(){}
|	KW_FUNC IDENTIFIER DELIMETER_LEFTPAR DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET DELIMETER_SEMICOLON {$$= template("%s %s()\n{\n%s\n}","void", $2 , $6);} // void foo(){body}
|	KW_FUNC IDENTIFIER DELIMETER_LEFTPAR DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_void DELIMETER_RIGHTBRACKET DELIMETER_SEMICOLON {$$= template("%s %s()\n{\n%s\n%s\n}","void", $2 , $6,$7);} // void foo(){body returnvoid}
|	KW_FUNC IDENTIFIER DELIMETER_LEFTPAR function_arguements DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET DELIMETER_RIGHTBRACKET DELIMETER_SEMICOLON{$$= template("%s %s(%s)\n{\n}","void", $2,$4);} // void foo(arg){}
|	KW_FUNC IDENTIFIER DELIMETER_LEFTPAR function_arguements DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET DELIMETER_SEMICOLON {$$= template("%s %s(%s)\n{\n%s\n}","void", $2 , $4, $7);} // void foo(arg){body}
|	KW_FUNC IDENTIFIER DELIMETER_LEFTPAR function_arguements DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_void DELIMETER_RIGHTBRACKET DELIMETER_SEMICOLON {$$= template("%s %s(%s)\n{\n%s\n%s\n}","void", $2, $4, $7, $8);} // void foo(arg){body returnvoid}
;

function_arguements:
	IDENTIFIER type_converter {$$ = template("%s %s",$2, $1);}
|	IDENTIFIER DELIMETER_LEFTBLOCK DELIMETER_RIGHTBLOCK type_converter {$$ = template("%s* %s",$4, $1);} 
|	function_arguements DELIMETER_COMMA IDENTIFIER type_converter {$$ =  template("%s , %s %s", $1, $4,$3);}

;


function_body:
  One_line_command {$$ = template("%s", $1);}
| if_statement {$$ = template("%s",$1);}
| while_statement {$$ = template("%s",$1);}
| One_line_command function_body {$$ = template("%s\n%s",$1, $2);}
| if_statement function_body {$$ = template("%s\n%s",$1, $2);}
| while_statement function_body {$$ = template("%s\n%s",$1, $2);}
| for_statement {$$ = template("%s",$1);}
| for_statement function_body {$$ = template("%s\n%s",$1, $2);}
;

return_type:
	KW_RETURN expressions DELIMETER_SEMICOLON{$$  = template("%s %s;", "return", $2);}
;

return_void:
	KW_RETURN DELIMETER_SEMICOLON{$$ = template("%s;", "return");}
;

// EXPRESSIONS

expressions: 
	CONSTANT_INTEGER {$$ = $1;}
|	IDENTIFIER {$$ = $1;}
|	IDENTIFIER DELIMETER_LEFTBLOCK expressions DELIMETER_RIGHTBLOCK {$$ = template("%s[%s]", $1,$3);}
|	IDENTIFIER DELIMETER_LEFTBLOCK DELIMETER_RIGHTBLOCK {$$ = template("%s[%s]", $1);}
|	CONSTANT_FLOAT {$$ = $1;}
|	CONSTANT_STRING {$$ = $1;}
|	DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR {$$ = template("(%s)", $2);}
|	logic_operator  {$$ = $1;}
| 	double_operator {$$ = $1;}
|	comparator	 {$$= $1;}
| 	expressions OPERATOR_PLUS expressions {$$ = template("%s + %s",$1,$3);}
|	expressions OPERATOR_MINUS expressions {$$ = template("%s -%s", $1, $3);}
| 	OPERATOR_PLUS expressions {$$ = template("+%s", $2);}
|	OPERATOR_MINUS expressions {$$ = template("-%s", $2);}
| 	KW_TRUE {$$ = template("%s", "1");}
|	KW_FALSE {$$ = template("%s", "0");}
|	function_statement_expr {$$  = template("%s", $1);}

;



// STATEMENTS
variable_statement:
	IDENTIFIER OPERATOR_ASSIGN expressions DELIMETER_SEMICOLON {$$ = template("%s = %s;", $1, $3);}
|	IDENTIFIER DELIMETER_LEFTBLOCK DELIMETER_RIGHTBLOCK OPERATOR_ASSIGN expressions DELIMETER_SEMICOLON {$$ = template("%s * = %s;",$1,$5);}
|	IDENTIFIER DELIMETER_LEFTBLOCK expressions DELIMETER_RIGHTBLOCK OPERATOR_ASSIGN expressions DELIMETER_SEMICOLON {$$ = template("%s[%s] = %s;", $1,$3,$6);}
;

for_variable_statement:
	IDENTIFIER OPERATOR_ASSIGN expressions{$$ = template("%s = %s", $1, $3);}
;


function_statement_arg:
	expressions {$$ = template("%s", $1);}
|	function_statement_arg DELIMETER_COMMA expressions {$$ = template("%s , %s",$1, $3);}
;

function_statement:
	IDENTIFIER DELIMETER_LEFTPAR DELIMETER_RIGHTPAR{$$ = template("%s ()" ,$1);}
|	IDENTIFIER DELIMETER_LEFTPAR function_statement_arg DELIMETER_RIGHTPAR {$$ = template("%s (%s)" ,$1, $3);}
;

function_statement_expr:
	IDENTIFIER DELIMETER_LEFTPAR DELIMETER_RIGHTPAR {$$ = template("%s ()" ,$1);}
|	IDENTIFIER DELIMETER_LEFTPAR function_statement_arg DELIMETER_RIGHTPAR{$$ = template("%s (%s)" ,$1, $3);}
;



for_statement:
	KW_FOR DELIMETER_LEFTPAR variable_declaration expressions DELIMETER_SEMICOLON expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET {$$ = template ("%s (%s %s; %s) \n \t{\n%s\n\t}", "for", $3, $4, $6, $9);}
|	KW_FOR DELIMETER_LEFTPAR for_variable_statement DELIMETER_SEMICOLON  expressions DELIMETER_SEMICOLON expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET {$$ = template ("%s (%s; %s; %s) \n \t{\n%s\n\t}", "for", $3, $5, $7, $10);}
|	KW_FOR DELIMETER_LEFTPAR variable_declaration expressions DELIMETER_SEMICOLON variable_statement DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET {$$ = template ("%s (%s %s; %s) \n \t{\n%s\n\t}", "for", $3, $4, $6, $9);}
|	KW_FOR DELIMETER_LEFTPAR for_variable_statement DELIMETER_SEMICOLON expressions DELIMETER_SEMICOLON for_variable_statement DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET {$$ = template ("%s (%s; %s; %s) \n \t{\n%s\n\t}", "for",$3, $5, $7, $10);}
|	KW_FOR DELIMETER_LEFTPAR variable_declaration expressions DELIMETER_SEMICOLON expressions DELIMETER_RIGHTPAR One_line_command {$$ = template ("%s (%s %s; %s) \n %s", "for", $3, $4, $6, $8);}
|	KW_FOR DELIMETER_LEFTPAR for_variable_statement DELIMETER_SEMICOLON  expressions DELIMETER_SEMICOLON expressions DELIMETER_RIGHTPAR One_line_command {$$ = template ("%s (%s; %s; %s) \n \t{\n%s\n\t}", "for", $3, $5, $7, $9);}
|	KW_FOR DELIMETER_LEFTPAR variable_declaration expressions DELIMETER_SEMICOLON variable_statement DELIMETER_RIGHTPAR One_line_command {$$ = template ("%s (%s %s; %s) \n %s", "for", $3, $4, $6, $8);}
|	KW_FOR DELIMETER_LEFTPAR for_variable_statement DELIMETER_SEMICOLON expressions DELIMETER_SEMICOLON for_variable_statement DELIMETER_RIGHTPAR One_line_command {$$ = template ("%s (%s; %s; %s) \n %s", "for",$3, $5, $7, $9);}

;

while_statement: 
	KW_WHILE DELIMETER_LEFTPAR expressions  DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET {$$ = template("%s(%s) \n{\n%s\n}", "while", $3,$6);}
|	KW_WHILE DELIMETER_LEFTPAR expressions  DELIMETER_RIGHTPAR One_line_command {$$ = template("%s(%s)\n %s", "while", $3, $5);}
;

if_statement:
	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR One_line_command {$$ = template("%s (%s) \n %s", "if", $3,$5);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR return_void {$$ = template("%s (%s) \n %s", "if", $3,$5);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR return_type {$$ = template("%s (%s) \n %s", "if", $3,$5);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET {$$ = template("%s (%s)\n{\n%s\n}","if", $3,$6);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_void DELIMETER_RIGHTBRACKET {$$ = template("%s (%s)\n{\n%s\n%s\n}","if", $3,$6,$7);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_type DELIMETER_RIGHTBRACKET {$$ = template("%s (%s)\n{\n%s\n%s\n}","if", $3,$6,$7);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR One_line_command if_else_statement{$$ = template("%s (%s) \n %s %s", "if", $3,$5, $6);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR return_void if_else_statement{$$ = template("%s (%s) \n %s %s", "if", $3,$5, $6);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR return_type if_else_statement{$$ = template("%s (%s) \n %s %s", "if", $3,$5, $6);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET if_else_statement {$$ = template("%s (%s)\n{\n%s\n} %s","if", $3,$6,$8);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_void DELIMETER_RIGHTBRACKET if_else_statement {$$ = template("%s (%s)\n{\n%s\n%s\n} %s","if", $3,$6,$7,$9);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_type DELIMETER_RIGHTBRACKET if_else_statement {$$ = template("%s (%s)\n{\n%s\n%s\n} %s","if", $3,$6,$7,$9);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR One_line_command else_statement{$$ = template("%s (%s) \n %s %s", "if", $3,$5, $6);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR return_void else_statement{$$ = template("%s (%s) \n %s %s", "if", $3,$5, $6);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR return_type else_statement{$$ = template("%s (%s) \n %s %s", "if", $3,$5, $6);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET else_statement {$$ = template("%s (%s)\n{\n%s\n} %s","if", $3,$6,$8);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_void DELIMETER_RIGHTBRACKET else_statement {$$ = template("%s (%s)\n{\n%s\n%s\n} %s","if", $3,$6,$7,$9);}
|	KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_type DELIMETER_RIGHTBRACKET else_statement {$$ = template("%s (%s)\n{\n%s\n} %s","if", $3,$6,$7,$9);}
;


One_line_command:
	variable_declaration {$$ = template("%s",$1); }
| constant_declaration {$$ = template("%s",$1); }
| variable_statement {$$ = template("%s",$1);}
| KW_BREAK DELIMETER_SEMICOLON {$$ = template("%s;", "break");}
| KW_CONTINUE DELIMETER_SEMICOLON {$$ = template("%s;", "continue");}
| function_statement DELIMETER_SEMICOLON {$$= template("%s;",$1);}
;


if_else_statement:
	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR One_line_command {$$ = template("\n%s(%s) \n%s", "else if ", $4, $6);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR return_void {$$ = template("\n%s(%s) \n%s", "else if ", $4, $6);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR return_type {$$ = template("\n%s(%s) \n%s", "else if ", $4, $6);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET {$$ =  template("\n%s(%s) \n{\n%s\n}", "else if",$4,  $7);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_void DELIMETER_RIGHTBRACKET {$$ =  template("\n%s(%s) \n{\n%s\n%s\n}", "else if",$4,  $7,$8);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_type DELIMETER_RIGHTBRACKET {$$ =  template("\n%s(%s) \n{\n%s\n%s\n}", "else if",$4,  $7, $8);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR One_line_command  else_statement {$$ = template("\n%s(%s) \n %s %s", "else if ",$4, $6,$7);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR return_void  else_statement {$$ = template("\n%s(%s) \n %s %s", "else if ",$4, $6,$7);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR return_type  else_statement {$$ = template("\n%s(%s) \n %s %s", "else if ",$4, $6,$7);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET else_statement {$$ =  template("\n%s(%s) \n{\n%s\n} %s", "else if",$4 ,$7, $9);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_void DELIMETER_RIGHTBRACKET else_statement {$$ =  template("\n%s(%s) \n{\n%s\n%s\n} %s", "else if",$4 ,$7,$8, $10);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_type DELIMETER_RIGHTBRACKET else_statement {$$ =  template("\n%s(%s) \n{\n%s\n%s\n} %s", "else if",$4 ,$7,$8, $10);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR One_line_command if_else_statement {$$ = template("\n%s(%s) \n%s %s", "else if", $4,$6,$7);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR return_void if_else_statement {$$ = template("\n%s(%s) \n%s %s", "else if", $4,$6,$7);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR return_type if_else_statement {$$ = template("\n%s(%s) \n%s %s", "else if", $4,$6,$7);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET if_else_statement {$$ =  template("\n%s(%s) \n{\n%s\n} %s", "else if", $4,$7,$9);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_void DELIMETER_RIGHTBRACKET if_else_statement {$$ =  template("\n%s(%s) \n{\n%s\n%s\n} %s", "else if",$4 ,$7,$8, $10);}
|	KW_ELSE KW_IF DELIMETER_LEFTPAR expressions DELIMETER_RIGHTPAR DELIMETER_LEFTBRACKET function_body return_type DELIMETER_RIGHTBRACKET if_else_statement {$$ =  template("\n%s(%s) \n{\n%s\n%s\n} %s", "else if",$4 ,$7,$8, $10);}
;


else_statement:
	KW_ELSE One_line_command {$$ = template("\n%s \n %s", "else", $2);}
|	KW_ELSE return_void {$$ = template("\n%s \n %s", "else", $2);}
|    	KW_ELSE return_type {$$ = template("\n%s \n %s", "else", $2);}	
|	KW_ELSE DELIMETER_LEFTBRACKET function_body DELIMETER_RIGHTBRACKET {$$ =  template("\n%s \n{\n%s\n}", "else", $3);}
|	KW_ELSE DELIMETER_LEFTBRACKET function_body return_void DELIMETER_RIGHTBRACKET {$$ =  template("\n%s \n{\n%s\n %s}", "else", $3, $4);}
|	KW_ELSE DELIMETER_LEFTBRACKET function_body return_type DELIMETER_RIGHTBRACKET {$$ =  template("\n%s \n{\n%s\n %s}", "else", $3, $4);}
;
	
	
	
decl_list: 
 decl { $$ = $1; }
| decl_list decl { $$ = template("%s\n%s", $1, $2); }
;

decl:  
	variable_declaration {$$ = $1;}
|	constant_declaration {$$ = $1;}
|	function_declaration {$$ = $1;}
;
 


body:
variable_declaration {$$ = template("%s",$1); }
| variable_declaration body {$$ = template("%s\n%s",$1,$2);}
| constant_declaration {$$ = template("%s",$1); }
| constant_declaration body {$$ = template("%s\n%s",$1,$2); }
| variable_statement {$$ = template("%s", $1);}
| variable_statement body {$$ = template("%s\n%s", $1,$2); }
| function_statement DELIMETER_SEMICOLON {$$= template("%s;",$1);}
| function_statement DELIMETER_SEMICOLON body {$$ = template("%s;\n%s", $1, $3);}
| for_statement {$$ = template("%s", $1);}
| for_statement body {$$ = template("%s\n%s", $1,$2);}
| while_statement {$$ = template("%s", $1);}
| while_statement body {$$ = template("%s \n%s",$1,$2);}
| if_statement {$$ = template("%s", $1);}
| if_statement body {$$ = template("%s\n%s",$1,$2);}
| return_void {$$ = template("%s",$1);}
| return_type {$$ = template("%s",$1);}
;

%%
int main () {
  if ( yyparse() != 0 )
    printf("Rejected!\n");
}

