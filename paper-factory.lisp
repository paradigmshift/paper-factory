;;;; paper-factory.lisp

(in-package #:paper-factory)

;;; "paper-factory" goes here. Hacks and glory await!
(defun split-newline (str)
  (my-tools:split #\Newline #'(lambda (x y)
                                (string-trim " " (subseq str x y)))
                  str))

(defun split-space (str)
  (my-tools:split #\Space #'(lambda (x y)
                              (string-trim " " (subseq str x y)))
                  str))

(defparameter *pattern-index*
  '((cl (functions (defun ?name (?* ?args) (?* ?body)))
     (parameters (defparameter ?name (?* ?body))))
    (python (functions (def ?name (?* ?args) (?* ?body))))))

(defvar *language* 'cl "Language to parse")

(defparameter *sub-list*
  '(#\( #\) #\, #\. #\: #\") "Tokens to be removed")

(defun match-function (fn-def language)
  "Returns the function's name, args, and body as alist elements"
  ;; (my-tools:match '(defun ?name (?* ?args) (?* ?body))
  ;;   fn-def))
  (my-tools:match (first (get-val 'functions (get-val language *pattern-index*)))
    fn-def))

(defun get-val (key bindings)
  "Retrieve the value of key"
  (rest (assoc key bindings)))

(defun function-name (bindings)
  "Retrieve name value from bindings"
  (get-val '?name bindings))

(defun function-body (bindings)
  "Retrieve body value from bindings"
  (get-val '?body bindings))

(defun function-args (bindings)
  "Retrieve args value from bindings"
  (get-val '?args bindings))

(defun function-docs (body)
  "If extant retrieve docstring from body"
  (when (stringp (first body))
    (first body)))

(defun remove-parens (string)
  (remove #\) (remove #\( string)))

(defun write-function (fn-def language)
  "Format for writing to file"
  (let* ((bindings (match-function fn-def language))
         (name (function-name bindings))
         (args (function-args bindings))
         (body (function-body bindings))
         (docs (function-docs body)))
    (format nil "~a~%~%~a~%~%~a~%***********************"
                 (format nil "**~(~a~)**" name)
                 (remove-parens (format nil "*function* **~(~a~)** *~(~a~)* =>" name args))
                 (format nil "~a" docs))))

(defun make-doc (dname contents)
  "Writes to file"
  (with-open-file (out dname
                       :direction :output
                       :if-exists :supersede)
    (format out "~{~&~a~}" contents)))

(defun function-p (language)
  #'(lambda (sexp)
      (match-function sexp language)))

(defun load-symbols (fname)
  "Reads in an entire lisp file"
  (let ((contents (my-tools:slurpfile fname)))
    contents))

(defun load-file-to-string (fname)
  "Returns as a string the contents of a file."
  (let ((contents (my-tools:slurp-to-string fname)))
    contents))

(defun whereis (pred seq)
  "Returns the index of the item searched for."
  (position (find-if pred seq) seq :test #'equal))

;; Hackiest function I've ever written....
(defun str-to-sym (str start-pred end-pred)
  "Turns a function represented as a string into symbols. Start-pred and End-pred tell the function where to start and stop collecting the argument lists. E.g. for Python it would be (starts-with #\() and (ends-with #\:) since the arglist starts with a \"(\" and ends with a \":\" ---> def add (a, b):."
  (let* ((contents (mapcar #'split-space (split-newline (string-upcase str))))
         (opening-pos (whereis start-pred (first contents))) 
         (closing-pos (whereis end-pred (first contents))) 
         (args (loop for x = opening-pos then (1+ x)
                  as y = closing-pos
                  collect (substitute-if #\ (extras-p *sub-list*) (elt (first contents) x))
                  until (= x y)))
         (arglist (remove-if #'(lambda (x) ;; cleans up the arglist
                                 (equal "" x)) (apply #'append (mapcar #'split-space args)))))
    (setf (first contents) (subseq (first contents) 0 opening-pos))
    (when (whereis (starts-with #\") (second contents)) ;; if second line
      ;; is a docstring
      (setf (second contents) (string-trim " " (substitute-if #\ (extras-p *sub-list*)
                                                              (reduce #'(lambda (s1 s2)
                                                                          (concatenate 'string s1 " " s2))
                                                                      (second contents))))))
    (append (mapcar #'intern (first contents))
            (list (mapcar #'intern arglist))
            (if (stringp (second contents))
                (append (list (second contents))
                        (mapcar #'(lambda (l)
                                    (mapcar #'intern l))
                                (rest (rest contents))))
                (mapcar #'(lambda (l)
                            (mapcar #'intern l)) (rest contents))))))

(defun starts-with (x)
  #'(lambda (str)
      (eql (char str 0) x)))

(defun ends-with (x)
  #'(lambda (str)
      (eql (char (reverse str) 0) x)))

(defun split-by-def (def str)
  "Splits the string after every given definition"
  (loop for x = 0 then y
     as y = (search def str :start2 (1+ x))
     collect (string-trim (format nil "~%") (subseq str x y))
     while y))

(defun extras-p (banned)
  #'(lambda (x)
      (member x banned)))

(defun function-defs (sexps language)
  "Removes non-function expressions"
  (remove-if-not (function-p language) sexps))

(defun build-lisp-doc (fname)
  "Builds the document from a lisp file with proper formatting."
  (setf *language* 'cl)
  (let* ((contents (load-symbols fname))
         (functions (function-defs contents *language*))
         (formatted-docs (mapcar #'(lambda (fn-def)
                                     (write-function fn-def *language*))
                                 functions)))
    (make-doc "DOCS.md" formatted-docs)))

;; This only works with files that don't have any other keyword for
;; the moment, have to add split-by-def "import" and other keywords.
(defun build-python-doc (fname)
  "Builds the document from a python file with proper formatting."
  (setf *language* 'python)
  (let* ((contents (split-by-def "def" (load-file-to-string fname)))
         (functions (function-defs (mapcar #'(lambda (s)
                                               (str-to-sym s (starts-with #\()
                                                           (ends-with #\:)))
                                           contents) *language*)))
    (mapcar #'(lambda (fn-def)
                (write-function fn-def *language*)) functions)))
