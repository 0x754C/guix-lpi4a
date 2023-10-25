(define-module (lpi4a system lpi4a)
  #:use-module (gnu)
  #:use-module (gnu system nss)
  #:use-module (gnu bootloader u-boot)
  #:use-module (lpi4a packages linux)
  #:use-module (lpi4a packages bootloaders)
  #:use-module (lpi4a packages shepherd)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages busybox)
  #:use-module (gnu packages admin)
  #:use-module (gnu services shepherd)
  )

(define-public %lpi4a-os
  (operating-system
   (host-name "lpi4a")
   (timezone "Hongkong")
   (locale "en_US.utf8")
   (kernel linux-lpi4a)
   (kernel-arguments
    (list
     "console=ttyS0,115200"
     "rootwait"
     "earlycon"
     "clk_ignore_unused"))
   (initrd-modules (list))
   (firmware (list))
   ;; just generate a extlinux config file
   (bootloader (bootloader-configuration
		(bootloader u-boot-bootloader)
		(targets '("/dev/null"))))
   (file-systems (cons (file-system
                        (device (file-system-label "lpi4a-root"))
                        (mount-point "/")
                        (type "ext4"))
                       %base-file-systems))
   (users
    (cons*
     (user-account
      (name "sipeed")
      (comment "sipeed")
      (group "users")
      (password (crypt "licheepi" "$6$abc"))
      (supplementary-groups '("wheel" "dialout" "audio" "video")))
     %base-user-accounts))
   
   (packages (list busybox nss-certs le-certs))
   (services %base-services)

   (essential-services
    (modify-services
     (operating-system-default-essential-services this-operating-system)
     (shepherd-root-service-type config =>
      (shepherd-configuration
       (shepherd shepherd-0.9)))))

   (name-service-switch %mdns-host-lookup-nss)))

%lpi4a-os
