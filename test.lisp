(cl:in-package "https://github.com/g000001/srfi-59#internals")


(def-suite* srfi-59)


(test vicinity
  (is (string= (home-vicinity)
               (get-environment-variable "HOME"))))


;;; *EOF*
