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
   (local-file "patches/lpi4a/0005-revyos_defconfig-enable-some-usb-device-driver.patch")
   (local-file "patches/lpi4a/0006-revyos_defconfig-enable-tcp-bbr.patch")))

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
		    (commit "8631d2c44f1160e75a940718c11d678b8e314710")))
	      (file-name (string-append "linux-thead-git"))
	      (sha256
	       (base32
		"1nyrinvrgsnrry13qwx0mcxsii5m2qsi5kfyxmdvvdsvy4rjkdi4"))
	      (patches
	       %linux-lpi4a-patches))
	     #:defconfig "revyos_defconfig"
	     #:extra-version "lpi4a"))
   (version "5.10.113")))

(define-public %linux-lpi4a-cluster-patches
  (list
   (local-file "patches/lpi4a-cluster/0001-arch-riscv-boot-dts-lpi4a-disable-i2c-io-expander-fo.patch")
   (local-file "patches/lpi4a-cluster/0002-arch-riscv-boot-dts-light-lpi4a-ref-disable-audio.patch")))

(define-public linux-lpi4a-cluster
  (package
   (inherit (customize-linux
	     #:name "linux-lpi4a-cluster"
	     #:linux linux-libre-riscv64-generic
	     #:source
	     (origin
	      (method git-fetch)
	      (uri (git-reference
		    (url "https://github.com/revyos/thead-kernel")
		    (commit "8631d2c44f1160e75a940718c11d678b8e314710")))
	      (file-name (string-append "linux-thead-git"))
	      (sha256
	       (base32
		"1nyrinvrgsnrry13qwx0mcxsii5m2qsi5kfyxmdvvdsvy4rjkdi4"))
	      (patches
	       (append
		%linux-lpi4a-patches
		%linux-lpi4a-cluster-patches)))
	     #:defconfig "revyos_defconfig"
	     #:extra-version "cluster"))
   (version "5.10.113")))

(define-public %linux-lpi4a-latop-patches
  (list
   (local-file "patches/lpi4a-latop/0002-lpi4a-use-rtl8852bs-sdio-wifi-card.patch")
   (local-file "patches/lpi4a-latop/0003-rtl8852bs-fix-kernel-stuck.patch")
   (local-file "patches/lpi4a-latop/0005-rtl8852bs-don-t-printk-a-lot-of-debug-log-on-console.patch")
   (local-file "patches/lpi4a-latop/0006-arch-riscv-boot-dts-thead-light-lpi4a-ref.dts-disabl.patch")
   (local-file "patches/lpi4a-latop/0007-add-aic8800-sdio-wifi-card-driver.patch")
   (local-file "patches/lpi4a-latop/0008-arch-riscv-boot-dts-thead-light-lpi4a-ref.dts-add-li.patch")
   (local-file "patches/lpi4a-latop/0009-arch-riscv-boot-dts-thead-light-lpi4a-ref.dts-add-pw.patch")
   (local-file "patches/lpi4a-latop/0010-arch-riscv-boot-dts-thead-light-lpi4a-ref.dts-change.patch")
   (local-file "patches/lpi4a-latop/0001-drivers-add-panel-jadard-jd9365da-h3.patch")
   (local-file "patches/lpi4a-latop/0002-revyos_defconfig-enable-PANEL_JADARD_JD9365DA_H3.patch")
   (local-file "patches/lpi4a-latop/0003-revyos_defconfig-enable-aic8800-wifi.patch")
   (local-file "patches/lpi4a-latop/0011-revyos_defconfig-disable-rtl8723ds-enable-8852bs.patch")))

(define-public %linux-lpi4a-latop-7inch-patches
  (list
   (local-file "patches/lpi4a-latop-7inch/0001-drivers-panel-jadard-jd9365da-h3-7inch-screen-suppor.patch")
   (local-file "patches/lpi4a-latop-7inch/0001-change-touch-screen-size-x-size-y.patch")))

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
		    (commit "8631d2c44f1160e75a940718c11d678b8e314710")))
	      (file-name (string-append "linux-thead-git"))
	      (sha256
	       (base32
		"1nyrinvrgsnrry13qwx0mcxsii5m2qsi5kfyxmdvvdsvy4rjkdi4"))
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
   (local-file "patches/lpi4a-latop-14inch/0004-drivers-panel-jadard-jd9365da-h3-change-param-for-te.patch")))

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
		    (commit "8631d2c44f1160e75a940718c11d678b8e314710")))
	      (file-name (string-append "linux-thead-git"))
	      (sha256
	       (base32
		"1nyrinvrgsnrry13qwx0mcxsii5m2qsi5kfyxmdvvdsvy4rjkdi4"))
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
   linux-lpi4a linux-lpi4a-cluster linux-lpi4a-latop-7inch linux-lpi4a-latop-14inch))

(packages->manifest %lpi4a-kernels)
