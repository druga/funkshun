; implementation-independent AVL trees
; mostly copy-paste from http://swizard.info/articles/functional-data-structures.html#link12

; srfi instead of non-standard (define-record)
(use srfi-9) ; record types

(define-record-type avl-tree (make-avl-tree root less? equ?) avl-tree?
  (root avl-root avl-root!)
  (less? avl-less)
  (equ? avl-equ)
)
(define-record-type avl-node (make-avl-node key value l-child r-child l-depth r-depth) avl-node?
  (key avl-key)
  (value avl-value)
  (l-child avl-l-child) (r-child avl-r-child)
  (l-depth avl-l-depth) (r-depth avl-r-depth)
)
(define with-avl-tree (
	lambda curry
	(let ((obj (car curry)))
		`((lambda (root less? equ?) ,@(cdr curry)) ,(avl-root obj) ,(avl-less obj) ,(avl-equ obj))
	)
))
(define with-avl-node (
	lambda curry
	(let ((obj (car curry)))
		`((lambda (key value l-child r-child l-depth r-depth) ,@(cdr curry)) ,(avl-key obj) 
			,(avl-value obj) ,(avl-l-child obj) ,(avl-r-child obj) ,(avl-l-depth obj) ,(avl-r-depth obj))
	)
))

(define (make-empty-avl-tree less? equ?)
  (make-avl-tree '() less? equ?))
(define (avl-tree-insert tree key value) (
 with-avl-tree tree
  (avl-root! root (avl-tree-insert-node root key value less?))
))
