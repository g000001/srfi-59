;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :srfi-59
  (:use)
  (:export
   :program-vicinity :library-vicinity :implementation-vicinity :user-vicinity
   :home-vicinity :in-vicinity :sub-vicinity :make-vicinity :pathname->vicinity
   :vicinity.suffix? ))

(defpackage :srfi-59.internal
  (:use :srfi-59 :cl :fiveam :srfi-23)
  (:shadowing-import-from :srfi-23 :error)
  (:shadow :lambda :member :assoc :map :loop))
