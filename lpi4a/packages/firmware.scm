(define-module (lpi4a packages firmware)
  #:use-module (gnu packages)
  #:use-module (guix build-system copy)
  #:use-module (guix git-download)
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

(define-public th1520-boot-firmware
  (package
   (inherit aic8800-firmware)
   (name "th1520-boot-firmware")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
	   (url "https://github.com/revyos/th1520-boot-firmware/")
	   (commit "ad8f2a03765b2066cbb6143ce98ddf2111b0c7bc")))
     (file-name (string-append "th1520-boot-firmware"))
     (sha256
      (base32
       "1bgs81nhyb102rpzs70w0wq5b3mm003qwp43m26hx8bchgvznw32"))))
   (arguments
    '(#:install-plan
      '(("addons/boot" "boot"))))
   (synopsis "firmware for th1520")
   (description synopsis)))

(define-public %lpi4a-firmwares
  (list
   aic8800-firmware rtl8723ds-bt-fw th1520-boot-firmware))

(packages->manifest %lpi4a-firmwares)
