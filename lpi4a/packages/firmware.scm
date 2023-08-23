(define-module (lpi4a packages firmware)
  #:use-module (gnu packages)
  #:use-module (guix build-system copy)
  #:use-module (guix packages)
  #:use-module (guix build utils)
  #:use-module (guix profiles)
  #:use-module (guix gexp))

(define-public aic8800-firmware
  (package
   (name "aic8800-firmware")
   (version "0.1")
   (source
    (local-file "blobs/aic8800-fw" #:recursive? #t))
   (build-system copy-build-system)
   (arguments
    '(#:install-plan
      '(("aic8800" "lib/firmware/")
	("aic8800D80" "lib/firmware/")
	("aic8800DC" "lib/firmware/"))))
   (home-page "")
   (synopsis "firmware for aic8800 wifi & bluetooth")
   (description synopsis)
   (license #f)))

(define-public rtl8723ds-bt-fw
  (package
   (inherit aic8800-firmware)
   (name "rtl8723ds-bt-fw")
   (source
    (local-file "blobs/rtl8723ds-bt-fw" #:recursive? #t))
   (arguments
    '(#:install-plan
      '(("rtlbt" "lib/firmware/"))))
   (synopsis "firmware for rtl8723ds bluetooth")
   (description synopsis)))

(define-public rtl8852bs-bt-fw
  (package
   (inherit aic8800-firmware)
   (name "rtl8852bs-bt-fw")
   (source
    (local-file "blobs/rtl8852bs-bt-fw" #:recursive? #t))
   (arguments
    '(#:install-plan
      '(("rtlbt" "lib/firmware/"))))
   (synopsis "firmware for rtl8852bs bluetooth")
   (description synopsis)))

(define-public %lpi4a-firmwares
  (list
   aic8800-firmware rtl8723ds-bt-fw rtl8852bs-bt-fw))

(packages->manifest %lpi4a-firmwares)
