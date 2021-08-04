/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PI_PARSER_TAB_H_INCLUDED
# define YY_YY_PI_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    STRING = 258,
    KW_INT = 259,
    KW_REAL = 260,
    KW_STRING = 261,
    KW_BOOL = 262,
    KW_VAR = 263,
    KW_CONST = 264,
    KW_IF = 265,
    KW_ELSE = 266,
    KW_FOR = 267,
    KW_WHILE = 268,
    KW_BREAK = 269,
    KW_CONTINUE = 270,
    KW_NIL = 271,
    KW_AND = 272,
    KW_OR = 273,
    KW_NOT = 274,
    KW_RETURN = 275,
    KW_BEGIN = 276,
    KW_FUNC = 277,
    KW_TRUE = 278,
    KW_FALSE = 279,
    IDENTIFIER = 280,
    CONSTANT_INTEGER = 281,
    CONSTANT_FLOAT = 282,
    CONSTANT_STRING = 283,
    OPERATOR_PLUS = 284,
    OPERATOR_MINUS = 285,
    OPERATOR_MULT = 286,
    OPERATOR_BACKSHLASH = 287,
    OPERATOR_MODULO = 288,
    OPERATOR_POW = 289,
    OPERATOR_EQUAL = 290,
    OPERATOR_UNEQUAL = 291,
    OPERATOR_SMALLER = 292,
    OPERATOR_SMALLEREQUAL = 293,
    OPERATOR_BIGGER = 294,
    OPERATOR_BIGGEREQUAL = 295,
    OPERATOR_ASSIGN = 296,
    DELIMETER_LEFTBLOCK = 297,
    DELIMETER_RIGHTBLOCK = 298,
    DELIMETER_ASSIGN = 299,
    DELIMETER_SEMICOLON = 300,
    DELIMETER_COMMA = 301,
    DELIMETER_RIGHTPAR = 302,
    DELIMETER_LEFTPAR = 303,
    DELIMETER_LEFTBRACKET = 304,
    DELIMETER_RIGHTBRACKET = 305
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 13 "pi_parser.y"

	char* crepr;

#line 112 "pi_parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PI_PARSER_TAB_H_INCLUDED  */
