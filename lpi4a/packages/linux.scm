(define-module (lpi4a packages linux)
 #:use-module (gnu packages)
 #:use-module (gnu packages linux)
 #:use-module (guix packages)
 #:use-module (guix git-download)
 #:use-module (guix build utils)
 #:use-module (guix profiles)
 #:use-module (guix gexp))

(define-public %linux-lpi4a-patches
  (list
   (local-file "patches/linux-lpi4a/aic8800/0001-drivers-wireless-add-aic8800-support.patch")
   (local-file "patches/linux-lpi4a/aic8800/0002-revyos_defconfig-enable-aic8800-wifi.patch")

   (local-file "patches/linux-lpi4a/dsi/0001-drivers-panel-add-panel-jadard-jd9365da-h3.patch")
   (local-file "patches/linux-lpi4a/dsi/0002-revyos_defconfig-enable-panel-jadard-jd9365da-h3.patch")

   (local-file "patches/linux-lpi4a/laptop/0001-riscv-dts-add-lpi4a-laptop-device-tree.patch")

   (local-file "patches/linux-lpi4a/lpi4a/0001-revyos_defconfig-enable-nfs-kernel-server-support.patch")))
   
(define-public linux-lpi4a
  (package
   (inherit (customize-linux
	     #:name "linux-lpi4a"
	     #:linux linux-libre-riscv64-generic
	     #:source
	     (origin
	      (method git-fetch)
	      (uri (git-reference
		    (url "https://github.com/revyos/thead-kernel")
		    (commit "f72e7cd0775ba52da4380f034d1b51a44eb124e6")))
	      (file-name (string-append "linux-thead-git"))
	      (sha256
	       (base32
		"1pvgvx32sjb4psmryg63rpghqqqywrnhracx78svvirz4im9fdyz"))
	      (patches
	       %linux-lpi4a-patches))
	     #:defconfig "revyos_defconfig"
	     #:extra-version "lpi4a"))
   (version "5.10.113")))

(define-public %linux-lpi4a-latop-patches
  (list
   (local-file "patches/dirty/lpi4a-latop/0001-riscv-dts-lpi4a-latop-enable-dsi-output.patch")))

(define-public %linux-lpi4a-latop-7inch-patches
  (list
   (local-file "patches/dirty/lpi4a-latop-7inch/0001-drivers-7inch-screen-support.patch")))

(define-public linux-lpi4a-latop-7inch
  (package
   (inherit (customize-linux
	     #:name "linux-lpi4a-latop-7inch"
	     #:linux linux-libre-riscv64-generic
	     #:source
	     (origin
	      (method git-fetch)
	      (uri (git-reference
		    (url "https://github.com/revyos/thead-kernel")
		    (commit "f72e7cd0775ba52da4380f034d1b51a44eb124e6")))
	      (file-name (string-append "linux-thead-git"))
	      (sha256
	       (base32
		"1pvgvx32sjb4psmryg63rpghqqqywrnhracx78svvirz4im9fdyz"))
	      (patches
	       (append
		%linux-lpi4a-patches
		%linux-lpi4a-latop-patches
		%linux-lpi4a-latop-7inch-patches)))
	     #:defconfig "revyos_defconfig"
	     #:extra-version "latop-7inch"))
   (version "5.10.113")))

(define-public %linux-lpi4a-latop-14inch-patches
  (list
   (local-file "patches/dirty/lpi4a-latop-14inch/0001-drivers-14inch-screen-support.patch")))

(define-public linux-lpi4a-latop-14inch
  (package
   (inherit (customize-linux
	     #:name "linux-lpi4a-latop-14inch"
	     #:linux linux-libre-riscv64-generic
	     #:source
	     (origin
	      (method git-fetch)
	      (uri (git-reference
		    (url "https://github.com/revyos/thead-kernel")
		    (commit "f72e7cd0775ba52da4380f034d1b51a44eb124e6")))
	      (file-name (string-append "linux-thead-git"))
	      (sha256
	       (base32
		"1pvgvx32sjb4psmryg63rpghqqqywrnhracx78svvirz4im9fdyz"))
	      (patches
	       (append
		%linux-lpi4a-patches
		%linux-lpi4a-latop-patches
		%linux-lpi4a-latop-14inch-patches)))
	     #:defconfig "revyos_defconfig"
	     #:extra-version "latop-14inch"))
   (version "5.10.113")))

(define-public %lpi4a-kernels
  (list
   linux-lpi4a linux-lpi4a-latop-7inch linux-lpi4a-latop-14inch))

(packages->manifest %lpi4a-kernels)
