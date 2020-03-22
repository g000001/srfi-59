;;;; srfi-59.asd -*- Mode: Lisp;-*-

(cl:in-package :asdf)


(defsystem :srfi-59
  :version "20200323"
  :description "SRFI 59 for CL: Vicinity"
  :long-description "SRFI 59 for CL: Vicinity
https://srfi.schemers.org/srfi-59"
  :author "Aubrey Jaffer"
  :maintainer "CHIBA Masaomi"
  :license "MIT"
  :serial t
  :depends-on (:fiveam
               :srfi-98
               :srfi-23)
  :components ((:file "package")
               (:file "util")
               (:file "srfi-59")
               (:file "test")))


(defmethod perform :after ((o load-op) (c (eql (find-system :srfi-59))))
  (let ((name "https://github.com/g000001/srfi-59")
        (nickname :srfi-59))
    (if (and (find-package nickname)
             (not (eq (find-package nickname)
                      (find-package name))))
        (warn "~A: A package with name ~A already exists." name nickname)
        (rename-package name name `(,nickname)))))


(defmethod perform ((o test-op) (c (eql (find-system :srfi-59))))
  (let ((*package*
         (find-package
          "https://github.com/g000001/srfi-59#internals")))
    (eval
     (read-from-string
      "
      (or (let ((result (run 'srfi-59)))
            (explain! result)
            (results-status result))
          (error \"test-op failed\") )"))))


;;; *EOF*
