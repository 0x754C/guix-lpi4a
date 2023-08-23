(define-module (lpi4a packages bootloaders)
 #:use-module (gnu packages)
 #:use-module (gnu packages bootloaders)
 #:use-module (guix packages)
 #:use-module (guix git-download)
 #:use-module (guix build utils)
 #:use-module (guix profiles)
 #:use-module (guix gexp))

(define-public %u-boot-lpi4a-patches
  (list
   (local-file
    "patches/u-boot-lpi4a/0001-configs-light_lpi4a_defconfig-replace-n-to-not-set.patch")
   (local-file
    "patches/u-boot-lpi4a/0002-include-configs-light-c910.h-change-bootpartition.patch")))

(define-public u-boot-lpi4a
  (package
   (inherit (make-u-boot-package
	     "light_lpi4a" "riscv64-linux-gnu"))
   (name "u-boot-lpi4a")
   (version "9999")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
	   (url "https://github.com/revyos/thead-u-boot.git")
	   (commit "329e2581fe5bd0afdb59c1b1d715124bc82262e2")))
     (file-name (string-append "u-boot-thead-git"))
     (sha256
      (base32
       "13r3ml7kkb7fqgv2fv5h2yd9axgi78l700g4iy2vbpgxxfxlmlcq"))
     (patches
      %u-boot-lpi4a-patches)))))

u-boot-lpi4a
