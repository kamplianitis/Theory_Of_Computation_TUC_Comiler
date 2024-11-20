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

|-----------|-----------|KEYWORDS|-----------|------------|
|-----------|-----------|----------|-----------|------------|
| `integer` | `scalar`  | `str`    | `boolean` | `True`     |
| `False`   | `const`   | `if`     | `else`    | `endif`    |
| `for`     | `in`      | `endfor` | `while`   | `endwhile` |
| `def`     | `enddef`  | `main`   | `return`  | `comp`     |
|   `endcomp`        | `of`    |   |           |            |

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

# PI syntax Analysis

## Main function
The main structural thing of PI language is main.

The definition of the main function is show below:
```pi
def main():
    main body
enddef;
```

In general any fuction can be declared as follows:
```pi
def function(arg1, arg2, ...) -> return_value:
    ...
    ...
    ...
    return return_value;
enddef;
```

Every other aspect of the PI language follows basic languages' syntax.

# Repository structure
The repository consists of the following structure:

- `Testcases`: The directory contains the test cases including both files written in PI but also their respective c ones.
- `mylexer.l`, `pi_lex.l`: The written lexical analyzer
- `myanalyzer.y`: The written syntax analyzer
- `lex.yy.c` : File derived after the step 2. in the repository's execution steps. It contains the lexical analyzer code.
- `cgen.c`, `cgen.h`: code generation helper functions included
- `pi_parser.tab.h`, `plib.h`: header files that contain token types and reading processes.

# How to execute the repository

Execute the following series of commands to test PI language:

1. Read the `.l` files containing the lexical analyzer and make the desired changes
2. Execute the following commands:

    2.1.
    ```sh
        flex mylexer.l
    ```

    2.2
    ```sh
        gcc -o mylexer lex.yy.c -lfl
    ```
    > !Note: This process is to be done only if you're not interested in implementing only a lexical analysis. Since this could be a real case, this process is included in the execution process.
3. Read the myanalyzer.y and make the required changes. 
4. Compile the analyzer's code using the following:

    4.1
    ```sh
        bison -d –v –r all myanalyzer.y
    ```

    4.2
    ```sh
        flex mylexer.l
    ```

    4.3
    ```sh
        gcc -o mycompiler lex.yy.c myanalyzer.tab.c cgen.c -lfl
    ```

After executing either part of the above process or even the whole one, run to `Testcases` and try to execute a `.pi` file using the following command:

```sh
    ./mycompiler <file_of_your_choice.pi>
```


# Requirements
- Ubuntu 20.04 or greater
- flex
- byson
- gcc
