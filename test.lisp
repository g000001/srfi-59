(cl:in-package :srfi-59.internal)

(def-suite srfi-59)

(in-suite srfi-59)


(test vicinity
  (is (string= (home-vicinity)
               (srfi-98:get-environment-variable "HOME"))))
