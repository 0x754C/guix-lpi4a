(define-module (lpi4a system lpi4a)
 #:use-module (gnu)
 #:use-module (gnu bootloader u-boot)
 #:use-module (lpi4a packages linux)
 #:use-module (lpi4a packages bootloaders)
 #:use-module (gnu packages certs)
 #:use-module (gnu packages tmux)
 #:use-module (gnu packages ssh)
 #:use-module (gnu packages curl)
 #:use-module (gnu packages admin)
 #:use-module (gnu packages networking)
 #:use-module (gnu packages linux)
 #:use-module (gnu packages rsync)
 #:use-module (gnu packages terminals)
 #:use-module (gnu packages ncurses)
 #:use-module (gnu packages ntp)
 #:use-module (gnu services networking)
 #:use-module (gnu services ssh)
 #:use-module (gnu services linux))

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
  (users %base-user-accounts)
  (packages
   (append
    (list nss-certs le-certs tmux curl htop openssh rsync ntp strace
          iperf lrzsz picocom tcpdump ncurses i2c-tools wpa-supplicant)
    %base-packages))
  (services
   (append
    (list
     (service ntp-service-type)
     (service openssh-service-type)
     (service dhcp-client-service-type))
    %base-services)))
)

%lpi4a-os
