# PI Transpiler

An implementation of a transpiler from a new language named "PI" to C code. The purpose of this repo is a novice approach on things like Lexical Analysis/Lexing (flex) and Syntax Analysis/Parsing (bison).

# PI syntax
First thing to define is the the vocabulary of the language. Anything of the following can be considered a part of the vocabulary:

- identifiers
- keywords
- integer constants
- boolean constants
- constant strings
- operators
- delimeters

## PI identifiers

PI identifiers Consist of a lowercase or uppercase letter, followed by a sequence of zero or more lowercase or uppercase letters, decimal system digits [0-9], or underscore (_).

!Note: keywords can not be declared as identifiers.

## PI keywords

PI keywords are the following

- integer
- scalar
- str
- boolean
- True
- False
- const
- if 
- else
- endif
- for 
- in
- endfor
- while
- endwhile
- def
- enddef
- main
- return 
- comp
- endcomp
- of

!Note: `keywords` are case sensitive.

## PI operators

PI operators can be categorized as follows:

- `arithmetic` : `+`, `-`, `*`, `/`, `%`, `**`
- `relational` : `==`, `!=`, `<`, `<=`, `>`, `>=`
- `logical` : `and`, `or`, `not`
- `sign` : `+`, `-`
- `assignment`: `=`, `+=`, `-=`, `*=`, `/=`, `%=`

## PI delimeters
PI language supports the following delimeters:
<p align="center">
=, +=, -=, *=, /=, %=
</p>

# PI synstax Analysis

## Main function
The main structural thing of PI language is main.

The definition of the main function is show below:
```pi
def main():
    main body
enddef;
```