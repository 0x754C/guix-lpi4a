(define-module (lpi4a packages linux)
 #:use-module (gnu packages)
 #:use-module (gnu packages linux)
 #:use-module (guix packages)
 #:use-module (guix build-system linux-module)
 #:use-module (guix git-download)
 #:use-module (guix build utils)
 #:use-module (guix profiles)
 #:use-module (guix gexp)
 #:use-module ((guix licenses) #:prefix licenses:)
 #:use-module (guix utils))

(define-public %linux-lpi4a-patches
  (list
   (local-file "patches/linux-lpi4a/aic8800/0001-drivers-wireless-add-aic8800-support.patch")
   (local-file "patches/linux-lpi4a/aic8800/0002-revyos_defconfig-enable-aic8800-wifi.patch")

   (local-file "patches/linux-lpi4a/dsi/0001-drivers-panel-add-panel-jadard-jd9365da-h3.patch")
   (local-file "patches/linux-lpi4a/dsi/0002-revyos_defconfig-enable-panel-jadard-jd9365da-h3.patch")

   (local-file "patches/linux-lpi4a/lpi4a/0001-arch-riscv-revyos_defconfig-enable-usb-monitor.patch")
   (local-file "patches/linux-lpi4a/lpi4a/0001-arch-riscv-revyos_defconfig-enable-usb-ip.patch")
   (local-file "patches/linux-lpi4a/lpi4a/0001-riscv-configs-revyos_defconfig-enable-CW2015.patch")
   (local-file "patches/linux-lpi4a/lpi4a/0001-riscv-configs-revyos_defconfig-enable-suspend.patch")))
   
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
		    (commit "052b22ef8baf010480c157e188e82fb6e3ebeee4")))
	      (file-name (string-append "linux-thead-git"))
	      (sha256
	       (base32
		"0i0bcdp721c80bnh8gx3300vlsdifjfx414h1c67f4lf8hqp6f68"))
	      (patches
	       %linux-lpi4a-patches))
	     #:defconfig "revyos_defconfig"
	     #:extra-version "lpi4a"))
   (version "5.10.113")))

(define-public %linux-lpi4a-latop-patches
  (list
   (local-file "patches/dirty/lpi4a-latop/0001-riscv-dts-lpi4a-latop-enable-dsi-output.patch")
   (local-file "patches/dirty/lpi4a-latop/0002-riscv-dts-light-lpi4a-laptop-rewrite-power-tree.patch")
   (local-file "patches/dirty/lpi4a-latop/0003-arch-riscv-lpi4a-laptop-add-lt8911-devicetree.patch")
   (local-file "patches/dirty/lpi4a-latop/0004-arch-riscv-dts-lpi4a-laptop-tweak-pwm.patch")
   (local-file "patches/dirty/lpi4a-latop/0005-sound-codecs-es8156-limit-volume.patch")))

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
		    (commit "052b22ef8baf010480c157e188e82fb6e3ebeee4")))
	      (file-name (string-append "linux-thead-git"))
	      (sha256
	       (base32
		"0i0bcdp721c80bnh8gx3300vlsdifjfx414h1c67f4lf8hqp6f68"))
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
   (local-file "patches/dirty/lpi4a-latop-14inch/0001-drivers-14inch-screen-support.patch")
   (local-file "patches/dirty/lpi4a-latop-14inch/0002-drm-i2c-add-lt8911-mipi2edp-chip-driver.patch")))

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
		    (commit "052b22ef8baf010480c157e188e82fb6e3ebeee4")))
	      (file-name (string-append "linux-thead-git"))
	      (sha256
	       (base32
		"0i0bcdp721c80bnh8gx3300vlsdifjfx414h1c67f4lf8hqp6f68"))
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
