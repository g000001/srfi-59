;;;; srfi-59.asd -*- Mode: Lisp;-*-

(cl:in-package :asdf)

(defsystem :srfi-59
  :serial t
  :depends-on (:fiveam
               :srfi-98
               :srfi-23)
  :components ((:file "package")
               (:file "util")
               (:file "srfi-59")
               (:file "test")))

(defmethod perform ((o test-op) (c (eql (find-system :srfi-59))))
  (load-system :srfi-59)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :srfi-59.internal :srfi-59))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))
