#lang racket
(require graph)

;read the file into lines
(define read
  (lambda (f)
    (file->list f)))

;creates a list of nodes from the file
(define nodes
  (lambda (data)
    (if (null? data)
    '()
    (if (eq? (car data) 'Nodes)
        (nodes (cdr (cdr data)))
        (if (eq? (car data)  'Edges)
            '()
            (cons (car data) (nodes (cdr data))))))))

;takes the edges information from the files
(define edges
  (lambda (data n)
    (if (eq? n 0)
        data
        (edges (cdr data) (- n 1)))))

;groups the edges into a list of lists acceptable to make a graph
(define edgelist
  (lambda (edges)
    (if (null? edges)
        '()
        (cons (append '() (list (caddr edges) (car edges) (cadr edges))) (edgelist (cdddr edges))))))

(define n (nodes (read "graph.txt")))
(define g (weighted-graph/undirected (edgelist (edges (read "graph.txt") (+ 3 (length n))))))






;adds an edge's info to the hash for all the nodes
(define createH
  (lambda (node H nlist)
    (if (null? nlist)
        '()
        (if (hash-has-key? H (car nlist))
           (if (null? (cdr nlist))
                H
                (make-immutable-hash (append (hash->list H) (hash->list (createH node H (cdr nlist))))))
           (if (has-edge? g node (car nlist))
               (if (null? (cdr nlist))
                   (make-immutable-hash(append (append (cons (cons (car nlist) (cons 0 (edge-weight g node (car nlist)))) '()))))
                   (make-immutable-hash (append (append (append (cons (cons (car nlist) (cons 0 (edge-weight g node (car nlist)))) '()) (hash->list (createH node H (cdr nlist))))))))
               (if (null? (cdr nlist))
                           (make-immutable-hash (append (cons (cons (car nlist) (cons 0 0)) '()) (hash->list H)))
                           (make-immutable-hash (append (cons (cons (car nlist) (cons 0 0)) '()) (hash->list (createH node H (cdr nlist)))))
                ))))))

;returns the key from the Hash table for the value
(define getKey
  (lambda (H value nlist)
    (if (null? nlist)
        '()
        (if (eq? (car (hash-ref H (car nlist))) 1)
            (getKey H value (cdr nlist))
            (if (eq? (cdr (hash-ref H (car nlist))) value)
                (car nlist)
                (getKey H value (cdr nlist)))))))

;creates a list of weights
(define makeminlist
  (lambda (values)
    (if (null? values)
        '()
        (if (eq? (cdr (car values)) 0)
            (makeminlist (cdr values))
            (if (eq? (car (car values)) 1)
                (makeminlist (cdr values))
                (append (cons (cdr (car values) ) '()) (makeminlist (cdr values))))))))
                                                  

;finds the node to which is the smallest connection
(define find
  (lambda (H values)
    (if (null? values)
        '()
        (if (null? (makeminlist values))
            '()
            (getKey H (car (sort (makeminlist values) <)) n )))))


;calls the algorithm on the hash map with all node/link info from the node
(define hash_driver
  (lambda (node)
    (createH node (make-hash (cons (cons node (cons 1 0)) '())) n)))

;changes the node to visited and updates visited
(define update
  (lambda (node nlist H distance)
    (if (eq? '() node)
        H
        (if (null? nlist)
            H
            (if (eq? node (car nlist))
                (update node (cdr nlist) (hash-set H node (cons 1 distance)) distance)
                (if (has-edge? g node (car nlist))
                    (if (< (+ distance (edge-weight g node (car nlist))) (cdr (hash-ref H (car nlist))))
                        (update node (cdr nlist) (hash-set H (car nlist) (cons 0 (+ distance (edge-weight g node (car nlist))))) distance)
                        (if (eq? 0 (cdr (hash-ref H (car nlist))))
                            (if (eq? 1 (car (hash-ref H (car nlist))))
                                (update node (cdr nlist) H distance)
                                (update node (cdr nlist) (hash-set H (car nlist) (cons 0 (+ distance (edge-weight g node (car nlist))))) distance))
                            (update node (cdr nlist) H distance)))
                            
                    (update node (cdr nlist) H distance))
                )
            ))))

;calls the updating of the hash
(define driver
  (lambda (node H)
    (if (null? (find H (hash-values H)))
        H
        (driver node (update (find H (hash-values H)) n H (cdr (hash-ref H (find H (hash-values H))))))
        )))

(define subdriver
  (lambda (node)
    (driver node (hash_driver node))))
;creates the global list of dijkstras for all nodes in the list
(define mainDriver
  (lambda (nodelist)
    (if (null? nodelist)
        '()
        (if (null? (cdr nodelist))
            (cons (car nodelist) (hash->list (subdriver (car nodelist))))
            (append (cons(car nodelist) (hash->list (subdriver (car nodelist)))) (mainDriver (cdr nodelist)))))))
 

(mainDriver (nodes (read "graph.txt")))