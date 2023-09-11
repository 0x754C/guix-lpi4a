(define-module (lpi4a packages shepherd)
 #:use-module (gnu packages)
 #:use-module (gnu packages admin)
 #:use-module (gnu packages guile-xyz)
 #:use-module (guix packages)
 #:use-module (guix build utils)
 #:use-module (guix gexp))

(define-public shepherd-fix
  (package
   (inherit shepherd)
   (native-inputs
    (modify-inputs
     (package-native-inputs shepherd)
     (replace "guile-fibers"
	      ;; Work around
	      ;; <https://github.com/wingo/fibers/issues/89>.  This
	      ;; affects any system without a functional real-time
	      ;; clock (RTC), but in practice these are typically Arm
	      ;; single-board computers.
	      guile-fibers-1.1)))
   (inputs
    (modify-inputs
     (package-inputs shepherd)
     (replace "guile-fibers"
	      (this-package-native-input "guile-fibers"))))))

shepherd-fix
