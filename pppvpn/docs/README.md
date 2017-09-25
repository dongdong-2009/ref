# 安装PPTP服务

## 下载并安装pptpd
.. code-block:: shell
	sudo apt-get install pptpd

## 配置vpn地址，编辑配置文件：

.. code-block:: shell
	sudo vim /etc/pptpd.conf
	找到localip和remoteip，修改为自己需要的地址，例如：

	localip 192.168.10.1
	remoteip 192.168.10.2-100

## 设置dns：
.. code-block:: shell
	sudo vim /etc/ppp/pptpd-options
	将ms-dns修改为：

	ms-dns 8.8.8.8
	ms-dns 223.5.5.5
## 设置连接的帐号：
.. code-block:: shell
	sudo vim /etc/ppp/chap-secrets
	根据需要设置

	# client        server  secret                  IP addresses
	test pptpd 123456 *
## 重新启动pptpd服务：
.. code-block:: shell
	/etc/init.d/pptpd restart
	至此，使用VPN客户端已经能够连接上来了，但是还不能通过这个VPN服务上网。

## 开启服务器内核转发功能，编辑
.. code-block:: shell

	sudo vim /etc/sysctl.conf
	找到

	#net.ipv4.ip_forward=1
	改为

	net.ipv4.ip_forward=1
	保存关闭，然后运行下面的命令生效：

	sudo sysctl -p
# 开启防火墙转发功能：
.. code-block:: shell

	安装iptables，如果没有安装的话

	sudo apt-get install iptables
	建立一个NAT

	sudo iptables -t nat -A POSTROUTING -s 192.168.10.0/24-o eth0 -j MASQUERADE
	192.168.10.0是刚刚设置的localip所在的网段，eth0是外网网卡地址

	设置MTU，防止包过大

	sudo iptables -A FORWARD -s 192.168.10.0/24 -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1200
	保存规则配置，使服务器重启后不丢失

	sudo iptables-save >/etc/iptables-rules
	编辑网卡文件，加载网卡时自动加载规则

	sudo vim  /etc/network/interfaces
	在末尾加入

	pre-up iptables-restore </etc/iptables-rules
	至此，连接到此VPN服务的客户端就能共享上网了。
