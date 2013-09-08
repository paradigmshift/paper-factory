## Paper Factory
A source code parser that constructs documentation in markdown format
by matching the source file with pre-set patterns.

### License

FreeBSD License

Copyright (c) 2013, Mozart Reina
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

### Downloading
Code is hosted at [github](https://github.com/paradigmshift/paper-factory), you can clone or fork the repo there.

### Installation 
Installation is done through either *Quicklisp*'s `ql:quickload
"paper-factory"` or *ASDF2*'s `asdf:load-system :paper-factory`. Just
make sure the code is located somewhere where *ASDF2*'s source
registry can find it.

Quick tutorial on [setting the registry](http://common-lisp.net/project/asdf/asdf/Configuring-ASDF.html).

### Exported Functions
`build-python-doc` - Builds documentation from Python files.

`build-lisp-doc` - Builds documentation from Lisp files.

### Known and temporary issues
- It will completely rewrite any pre-existing file with the same name.
Functionality for checking and appending file contents instead of overwriting will be added in the future.

- As of now it only writes documentation for functions, even though
  the parser is capable of parsing for any other data type. This will
  be addressed in the near future.

- The parser can only extract docstrings from languages that support
  docstrings after the the initial function definition, ex. Python,
  Common Lisp, etc. Languages like JavaScript that do not have
  built-in docstrings will be still be parsed given the correct
  patterns but no docstrings will be inserted in the created file.

- The parser can only read python files with function definitions, if
  other keywords like `import` are present it will break. This will be
  addressed soon.
