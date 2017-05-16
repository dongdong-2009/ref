define Profile/evk
  NAME:=evk
  DEPENDS:=+@TARGET_ROOTFS_INCLUDE_KERNEL +@TARGET_ROOTFS_INCLUDE_DTB
  FEATURES+=usbgadget
  PACKAGES+= \
    -dnsmasq -firewall -ppp -ip6tables -iptables -6relayd -mtd uboot-envtools \
    kmod-leds-gpio kmod-ledtrig-timer kmod-usb-mxs-phy -kmod-ipt-nathelper \
    kmod-i2c-mxs kmod-spi-mxs uboot-mxs-mx28evk_nand
endef

define Profile/evk/Description
    imx28 evk 
endef

$(eval $(call Profile,evk))
