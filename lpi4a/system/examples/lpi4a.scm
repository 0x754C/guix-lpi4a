(use-modules
 (gnu)
 (gnu bootloader u-boot)
 (lpi4a packages linux)
 (lpi4a packages bootloaders))
(use-service-modules networking ssh linux)
(use-package-modules certs tmux ssh curl admin networking linux rsync terminals
 ncurses)

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
    (list nss-certs le-certs tmux curl htop openssh rsync
          iperf lrzsz picocom tcpdump ncurses i2c-tools)
    %base-packages))
  (services
   (append
    (list
     (service openssh-service-type)
     (service dhcp-client-service-type))
    %base-services)))
