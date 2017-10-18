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
	
* ssh -R:  
	https://yq.aliyun.com/articles/8469  
	ssh -CqTfnN -R  0.0.0.0:7001:IP_SA:22   IP_CA   
* ctags list:  
	以前都用ctrl + ]，为了列出所有其他匹配项还要:ts。今天才发现g]可以直接列出所有匹配项，省得再:ts了  
	另外，修改.vimrc中，加上  
	nmap <C-]> g]  
	即可直接把Ctrl + ]映射到g]  
* TinyCore:  
	1. unetbootin
	2. http://www.minilinux.net/node/2355  
* fltk:  
	http://www.fltk.org/doc-1.1/  
	http://www3.telus.net/public/robark/  
* dropbear:  
	cd /etc
	mkdir dropbear
	cd dropbear
	/usr/local/bin dropbearkey -t rsa -f dropbear_rsa_host_key
	/usr/local/bin dropbearkey -t dss -f dropbear_dss_host_key
	./dropbear -p 22（监听22端口）  
* linux 鸟哥:  
	http://cn.linux.vbird.org/linux_basic/0510osloader.php  

* vim :  
	set tabstop=2  
	set softtabstop=2  
	set shiftwidth=2  
	set hls  
	:colorscheme evening  
	nmap <C-]> g]  
	set nocompatible  
	set backspace=indent,eol,start  
* pandoc:  
	pandoc.exe -s XXX.md -o XXX.docx
	
* valgrand:
        sudo valgrind --tool=memcheck --leak-check=full --show-reachable=yes ./AmberGwZ3  -n0 -p /dev/ttyACM0
	--read-var-info=yes|no
	--track-origins=yes 定位错误源
	--leak-resolution 合并backtraces
	
* amazon:
   https://www.programmableweb.com/news/how-to-get-started-amazon%E2%80%99s-alexa-skills-kit/how-to/2016/08/02?page=2
   dlaudience01@gmail.com
* c++ web:  
   http://blog.csdn.net/xiaoxiaoyeyaya/article/details/42541419  
   
