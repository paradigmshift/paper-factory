# Paper Factory documentation
Source code parser that constructs documentation in `markdown`.

### Languages
- Common Lisp

### Dependencies
- [my-tools](https://github.com/paradigmshift/my-tools)

### Variables
**pattern-index**

*defparameter* **pattern-index**

Contains the patterns for each language supported. Add patterns here
to extend language parsing or add new languages.
***********************
**language**

*defvar* **language**

Current language to parse.
***********************
**sub-list**

*defparameter* **sublist**

List of tokens to be removed from strings. This is used mainly when
removing tokens like commas from argument lists before turning the
arguments into symbols.
***********************

### Functions
**split-newline**

*function* **split-newline** *str* => *list*

Splits the string at the newlines, returns a list.
***********************
**split-space**

*function* **split-space** *str* => *list*

Splits the string at the spaces, returns a list.
***********************
**match-function**

*function* **match-function** *fn-def language* => *alist*

Applies the function pattern of `language` to the `fn-def`. Returns the function's name, args, and body as alist elements.
***********************
**get-val**

*function* **get-val** *key bindings* => *value of key*

Retrieve the value of key.
***********************
**function-name**

*function* **function-name** *bindings* => *symbol*

Retrieve name value from bindings.
***********************
**function-body**

*function* **function-body** *bindings* => *symbol*

Retrieve body value from bindings.
***********************
**function-args**

*function* **function-args** *bindings* => *symbol*

Retrieve args value from bindings.
***********************
**function-docs**

*function* **function-docs** *body* => *string*

If extant retrieve docstring from body.
***********************
**remove-parens**

*function* **remove-parens** *string* => *string*

Removes opening and closing parentheses from a string.
***********************
**write-function**

*function* **write-function** *fn-def language* => *string*

Parses `fn-def` according to the language given and returns a
formatted string.
***********************
**make-doc**

*function* **make-doc** *dname contents* => *file*

Writes contents to file.
***********************
**function-p**

*function* **function-p** *language* => *closure*

Returns a closure that checks if the sexp matches the function pattern.
***********************
**load-symbols**

*function* **load-symbols** *fname* => *list*

Reads in an entire lisp file as symbols.
***********************
**load-file-to-string**

*function* **load-file-to-string** *fname* => *string*

Returns as a string the contents of a file.
***********************
**whereis**

*function* **whereis** *pred seq* => *index*

Returns the index of the item searched for. `pred` is usually a
predicate that tests for certain conditions like sequences starting or
ending with a particular character or symbol.
***********************
**str-to-sym**

*function* **str-to-sym** *str start-pred end-pred* => *symbols*

Turns a function represented as a string into symbols. Start-pred and End-pred tell the function where to start and stop collecting the argument lists. E.g. for Python it would be (starts-with #() and (ends-with #:) since the arglist starts with a "(" and ends with a ":" ---> def add (a, b):.
***********************
**starts-with**

*function* **starts-with** *x* => *closure*

Returns a closure that checks if the string starts with `x`.
***********************
**ends-with**

*function* **ends-with** *x* => *closure*

Returns a closure that checks if the string ends with `x`.
***********************
**split-by-def**

*function* **split-by-def** *def str* => *strings*

Splits the string at every occurance of `def`.
***********************
**extras-p**

*function* **extras-p** *banned* => *closure*

Returns a closure that checks if the token is a member of `banned`.
***********************
**function-defs**

*function* **function-defs** *sexps language* => *sexps*

Removes expressions that don't match the function pattern of the given language.
***********************
**build-lisp-doc**

*function* **build-lisp-doc** *fname* => *file*

Builds the document from a lisp file with proper formatting.
***********************
**build-python-doc**

*function* **build-python-doc** *fname* => *file*

Builds the document from a python file with proper formatting.
***********************
