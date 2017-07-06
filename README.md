# Reference Record  
  This is document for record http ref  

* free-electrons  
	http://free-electrons.com/docs/  
	
* breed uboot:  
	https://breed.hackpascal.net/  
	
* Imx283:  
	http://pan.baidu.com/s/1skABBfn  
	https://wiki.openwrt.org/toh/i2se/duckbill  
	http://blog.csdn.net/wshini7316/article/details/8623092  
	http://www.nxp.com/products/microcontrollers-and-processors/arm-processors/i.mx-applications-processors/i.mx28-applications-processors-integrated-power-management-unit-pmu-arm9-core/multimedia-applications-processors-high-performance-low-power-arm9-core:i.MX283?tab=Documentation_Tab

* 启动跟踪Linux Kernel Code:  
	http://www.jianshu.com/p/c50563d5d999

* openwrt:  
	https://wiki.openwrt.org/zh-cn/doc/devel/packages  
	http://blog.csdn.net/lichengtongxiazai/article/details/38941913  
	http://blog.csdn.net/voice_shen/article/details/7441894  
	http://blog.csdn.net/ooonebook/article/details/53495002


* qemu:  
	qemu-system-arm -M versatilepb -m 128M -nographic -s -S -kernel zImage -append "console=ttyAMA0"


* OpenWrt CONFIG_KERNEL_DEBUG_LL in .config to enable CONFIG_DEBUG_LL AND EARLY_PRINTK

* gdb/gdbserver:  
	CONFIG_DEBUG=y
	--- a/gdb/remote.c      2014-07-29 20:37:42.000000000 +0800
	+++ b/gdb/remote.c      2017-05-26 16:33:03.352806398 +0800
	@@ -6062,8 +6062,25 @@
	   buf_len = strlen (rs->buf);

	   /* Further sanity checks, with knowledge of the architecture.  */
	+#if 0
	   if (buf_len > 2 * rsa->sizeof_g_packet)
	     error (_("Remote 'g' packet reply is too long: %s"), rs->buf);
	+#else
	+  // if (buf_len > 2 * rsa->sizeof_g_packet)
	+  //  error (_("Remote 'g' packet reply is too long: %s"), rs->buf);
	+  if (buf_len > 2 * rsa->sizeof_g_packet) {
	+    rsa->sizeof_g_packet = buf_len;
	+    for (i = 0; i < gdbarch_num_regs (gdbarch); i++) {
	+      if (rsa->regs[i].pnum == -1)
	+        continue;
	+      if (rsa->regs[i].offset >= rsa->sizeof_g_packet)
	+        rsa->regs[i].in_g_packet = 0;
	+      else
	+        rsa->regs[i].in_g_packet = 1;
	+    }
	+  }
	+#endif
	+

	   /* Save the size of the packet sent to us by the target.  It is used
	      as a heuristic when determining the max size of packets that the  
* git chandao:  
	git commit document : 139  

* wangpanzhijia:  
	http://www.wangpanzhijia.net/sitemap/tab/share5/p/386.html  
	
