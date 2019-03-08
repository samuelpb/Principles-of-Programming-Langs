#lang racket

; *********************************************
; *  314 Principles of Programming Languages  *
; *  Spring 2019                              *
; *  Student Version                          *
; *********************************************

;; contains "ctv", "A", and "reduce" definitions
(require "include.rkt")

;; contains simple dictionary definition
(require "dictionary.rkt")

;; -----------------------------------------------------
;; HELPER FUNCTIONS

;; *** CODE FOR ANY HELPER FUNCTION GOES HERE ***

;;checks the words vector against the dictionary
(define check
  (lambda (dict-vectors word-vector)
    (if (null? word-vector) #t
        ;;if it reaches the end of the word vector, all hash values have been there, so return true
        ;;if still in the vector, check each value to ensure it is in the dictionary
       (if (member (car word-vector) dict-vectors)
           (check dict-vectors (cdr word-vector)) #f)
                   )
  ))
;;NOTE: this still works with the '() value, as the word-vector for that and only that would be all 0s

;;returns the key at each point in the list
(define number
  (lambda (w value)
    (+ (* value 29) (ctv w))
     ))

;;creates the list from the dictionary
(define createHashVectors
  (lambda (h-list word-s)
    (if (null? h-list)
    '()
    ;;map the functions onto the dictionary, for each hash function given in h-list
    (append (map (car h-list) word-s)(createHashVectors (cdr h-list) word-s))
    ))
  )


;; -----------------------------------------------------
;; KEY FUNCTION

;; Reduce applies the function to the beginning of the list, combining it with the result of the rest of the list
;; So it works from right to left on the list of the word, as needed
;; therefore no need to reverse the list, just reduce function for the multiplication of the value and 29 with the list
(define key
  (lambda (w)
    (if (null? w) 0
    (reduce number w 5413)  ;; *** FUNCTION BODY IS MISSING ***
)))

;; -----------------------------------------------------
;; EXAMPLE KEY VALUES
;;   (key '(h e l l o))       = 111037761665
;;   (key '(m a y))           = 132038724
;;   (key '(t r e e f r o g)) = 2707963878412931

;; -----------------------------------------------------
;; HASH FUNCTION GENERATORS

;; value of parameter "size" should be a prime number

(define gen-hash-division-method
  (lambda (size) ;; range of values: 0..size-1
     (lambda (w)
       ;;take modulous of the key and the size
       (modulo (key w) size)
)))

;; value of parameter "size" is not critical
;; Note: hash functions may return integer values in "real"
;;       format, e.g., 17.0 for 17

(define gen-hash-multiplication-method
  (lambda (size) ;; range of values: 0..size-1
     (lambda (w)
       ;;take floor of the size multiplied by the fraction part from key of w multiplied by A
       ;;get fracion part by subtacting the floor of K * A from K * A
       (floor (* size (-(* (key w) A) (floor (* (key w) A)))))
)))


;; -----------------------------------------------------
;; EXAMPLE HASH FUNCTIONS AND HASH FUNCTION LISTS

(define hash-1 (gen-hash-division-method 70111))
(define hash-2 (gen-hash-division-method 89989))
(define hash-3 (gen-hash-multiplication-method 700426))
(define hash-4 (gen-hash-multiplication-method 952))

(define hashfl-1 (list hash-1 hash-2 hash-3 hash-4))
(define hashfl-2 (list hash-1 hash-3))
(define hashfl-3 (list hash-2 hash-3))

;; -----------------------------------------------------
;; EXAMPLE HASH VALUES
;;   to test your hash function implementation
;;
;; (hash-1 '(h e l l o))        ==> 26303
;; (hash-1 '(m a y))            ==> 19711
;; (hash-1 '(t r e e f r o g))  ==> 3010
;;
;; (hash-2 '(h e l l o))        ==> 64598
;; (hash-2 '(m a y))            ==> 24861
;; (hash-2 '(t r e e f r o g))  ==> 23090
;;
;; (hash-3 '(h e l l o))        ==> 313800.0
;; (hash-3 '(m a y))            ==> 317136.0
;; (hash-3 '(t r e e f r o g))  ==> 525319.0
;;
;; (hash-4 '(h e l l o))        ==> 426.0
;; (hash-4 '(m a y))            ==> 431.0
;; (hash-4 '(t r e e f r o g))  ==> 714.0

;; -----------------------------------------------------
;; SPELL CHECKER GENERATOR

(define gen-checker
  (lambda (hashfunctionlist dict)
     (lambda (word)
            (check (createHashVectors hashfunctionlist dictionary)(createHashVectors hashfunctionlist (list word)))
)))

;; -----------------------------------------------------
;; EXAMPLE SPELL CHECKERS

(define checker-1 (gen-checker hashfl-1 dictionary))
(define checker-2 (gen-checker hashfl-2 dictionary))
(define checker-3 (gen-checker hashfl-3 dictionary))

;; EXAMPLE APPLICATIONS OF A SPELL CHECKER
;;
;;  (checker-1 '(a r g g g g)) ==> #f
;;  (checker-2 '(h e l l o)) ==> #t
;;  (checker-2 '(a r g g g g)) ==> #f
