;;;; srfi-59.lisp

(cl:in-package "https://github.com/g000001/srfi-59#internals")

;;@ (implementation-vicinity) should be defined to be the pathname of
;;; the directory where any auxillary files to your Scheme
;;; implementation reside.
(define-function (implementation-vicinity)
  (let ((st (software-type)))
    (declare (ignorable st))
    (cond ((string-equal st 'linux)
           (ignore-errors
             (translate-logical-pathname "sys:src;")))
          ((string-equal st 'unix) "/usr/local/src/scheme/")
          ((string-equal st 'vms) "scheme$src:")
          ((string-equal st 'ms-dos) "C:\\scheme\\"))))

;;@ (library-vicinity) should be defined to be the pathname of the
;;; directory where files of Scheme library functions reside.
(define-function library-vicinity
  (let ((library-path
	 (or
	  ;; Use this getenv if your implementation supports it.
	  (get-environment-variable "SCHEME_LIBRARY_PATH")
	  ;; Use this path if your scheme does not support GETENV
	  ;; or if SCHEME_LIBRARY_PATH is not set.
          (let ((st (software-type)))
            (declare (ignorable st))
            (cond ((string-equal st 'linux)
                   (ignore-errors
                     (translate-logical-pathname "sys:src;")))
                  ((string-equal st 'unix) "/usr/local/src/scheme/")
                  ((string-equal st 'vms) "scheme$src:")
                  ((string-equal st 'ms-dos) "C:\\scheme\\")
                  (:else ""))))))
    (lambda () library-path)))

;;@ (home-vicinity) should return the vicinity of the user's HOME
;;; directory, the directory which typically contains files which
;;; customize a computer environment for a user.
(define-function (home-vicinity)
  (let ((home (get-environment-variable "HOME")))
    (and home
         (let ((st (software-type)))
           (declare (ignorable st))
           (cond ((or (string-equal st 'unix);V7 unix has a / on HOME
                      (string-equal st 'coherent)
                      (string-equal st 'ms-dos) )
                  (if (eqv? #\/ (string-ref home (+ -1 (string-length home))))
                      home
                      (string-append home "/") ))
                 (:else home) )))))


;@
(defun in-vicinity (&rest args)
  (apply #'concatenate 'string args))

;@
(define-function (user-vicinity)
  (let ((st (software-type)))
    (cond ((string-equal 'vms st) "[.]")
          (:else ""))))
;@
(define-function vicinity.suffix?
  (let ((suffi
	 (let ((st (software-type)))
           (declare (ignorable st))
           (cond ((string-equal st 'amiga) '(#\: #\/))
                 ((or (string-equal st 'macos)
                      (string-equal st 'thinkc))
                  '(#\:))
                 ((or (string-equal st 'ms-dos)
                      (string-equal st 'windows)
                      (string-equal st 'atarist)
                      (string-equal st 'os/2))
                  '(#\\ #\/))
                 ((string-equal st 'nosve)
                  '(#\: #\.))
                 ((or (string-equal st 'linux)
                      (string-equal st 'unix)
                      (string-equal st 'coherent)
                      (string-equal st 'plan9))
                  '(#\/))
                 ((string-equal st 'vms)
                  '(#\: #\]))
                 ((string-equal st 'oterwise)
                  (warn "require.scm ~(~a ~a ~a~)" 'unknown 'software-type
                        (software-type) )
                  "/" )))))
    (lambda (chr) (and (member chr suffi) 'T)) ))

;@
(define-function (pathname->vicinity pathname)
  (iterate loop ((i (- (string-length pathname) 1)))
    (cond ((negative? i) "")
	  ((vicinity.suffix? (string-ref pathname i))
	   (subseq pathname 0 (+ i 1)))
	  (:else (loop (- i 1))))))

(define-function (program-vicinity)
  (if *load-pathname*
      (pathname->vicinity *load-pathname*)
      (error 'program-vicinity "called while not within load")))

;@
(define-function sub-vicinity
  (let ((st (software-type)))
    (declare (ignorable st))
    (cond ((string-equal st 'vms)
           (lambda (vic name)
             (let ((l (string-length vic)))
               (if (or (zero? (string-length vic))
                       (not (char=? #\] (string-ref vic (- l 1)))) )
                   (string-append vic "[" name "]")
                   (string-append (subseq vic 0 (- l 1)) "." name "]") ))))
          (:else
           (let ((.vicinity-suffix.
                  (let ((st (software-type)))
                    (declare (ignorable st))
                    (cond ((string-equal st 'nosve)
                           ".")
                          ((or (string-equal st 'macos)
                               (string-equal st 'thinkc))
                           ":")
                          ((or (string-equal st 'ms-dos)
                               (string-equal st 'windows)
                               (string-equal st 'atarist)
                               (string-equal st 'os/2))
                           "\\")
                          ((or (string-equal st 'unix)
                               (string-equal st 'linux)
                               (string-equal st 'coherent)
                               (string-equal st 'plan9)
                               (string-equal st 'amiga) )
                           "/")))))
             (lambda (vic name)
               (string-append vic name .vicinity-suffix.)) )))))

;@
(define-function (make-vicinity pathname) pathname)

;;; eof
