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
    "patches/u-boot-lpi4a/0001-configs-light_lpi4a_defconfig-replace-n-to-not-set.patch")))

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
	   (commit "1bc667409d3d431c8020739befd170403168e547")))
     (file-name (string-append "u-boot-thead-git"))
     (sha256
      (base32
       "1wjjyriq8ipfxgl3d652ghs6lvkhppznd928sxmfq4kl2q5k6d55"))
     (patches
      %u-boot-lpi4a-patches)))))

u-boot-lpi4a
