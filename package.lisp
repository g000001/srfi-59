;;;; package.lisp

(cl:in-package common-lisp-user)


(defpackage "https://github.com/g000001/srfi-59"
  (:use)
  (:export
   program-vicinity library-vicinity implementation-vicinity user-vicinity
   home-vicinity in-vicinity sub-vicinity make-vicinity pathname->vicinity
   vicinity.suffix? ))


(defpackage "https://github.com/g000001/srfi-59#internals"
  (:use 
   "https://github.com/g000001/srfi-59"
   "https://github.com/g000001/srfi-23"
   "https://github.com/g000001/srfi-98"
   cl 
   fiveam)
  (:shadowing-import-from :srfi-23 error)
  (:shadow lambda member assoc map loop))


;;; *EOF*
