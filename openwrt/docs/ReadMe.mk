#在上篇博文里，包里的 Makefile 内容如下：

include $(TOPDIR)/rules.mk

PKG_NAME:=helloworld
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/helloworld
    SECTION:=utils
    CATEGORY:=Utilities
    TITLE:=Helloworld -- prints a snarky message
endef

define Package/helloworld/description
    It's my first package demo.
endef

define Build/Prepare
    echo "Here is Package/Prepare"
    mkdir -p $(PKG_BUILD_DIR)
    $(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/helloworld/install
    echo "Here is Package/install"
    $(INSTALL_DIR) $(1)/bin
    $(INSTALL_BIN) $(PKG_BUILD_DIR)/helloworld $(1)/bin/
endef

$(eval $(call BuildPackage,helloworld))

比如上面的 BUILD_DIR, INCLUDE_DIR 等，都在这里定义。还有：

还有关于 TARGET_CC, TARGET_CXX 等非常有用的变量定义。

还有 TAR， FIND， INSTALL_BIN, INSTALL_DIR, INSTALL_DATA等等非常重要的变量定义。

自定义 PKG_XXXX 变量

官网上指定有如下变量需要设置：

PKG_NAME        - The name of the package, as seen via menuconfig and ipkg

PKG_VERSION     - The upstream version number that we're downloading

PKG_RELEASE     - The version of this package Makefile

PKG_LICENSE     - The license(s) the package is available under, SPDX form.

PKG_LICENSE_FILE- file containing the license text

PKG_BUILD_DIR   - Where to compile the package

PKG_SOURCE      - The filename of the original sources

PKG_SOURCE_URL- Where to download the sources from (directory)

PKG_MD5SUM      - A checksum to validate the download

PKG_CAT         - How to decompress the sources (zcat, bzcat, unzip)

PKG_BUILD_DEPENDS - Packages that need to be built before this package, but are not required at runtime. Uses the same syntax as DEPENDS below.

PKG_INSTALL     - Setting it to "1" will call the package's original "make install" with prefix set to PKG_INSTALL_DIR

PKG_INSTALL_DIR - Where "make install" copies the compiled files

PKG_FIXUP       - ???

PKG_SOURCE_PROTO - the protocol to use for fetching the sources (git, svn)

PKG_REV         - the svn revision to use, must be specified if proto is "svn"

PKG_SOURCE_SUBDIR - must be specified if proto is "svn" or "git", e.g. "PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)"

PKG_SOURCE_VERSION - must be specified if proto is "git", the commit hash to check out

PKG_CONFIG_DEPENDS - specifies which config options depend on this package being selected


package.mk会把大部分需要的宏都定义好。理想情况下，用户只需要定义好了 PKG_XXX 之后，不需要再自定义宏，默认的宏就可以满足需求。

比如Build/Prepare/Default的定义：


Build/Prepare宏是在编译前进行的，是准备工作。

可以看出，它分了两种情况：

A，定义了 USE_GIT_TREE，则按git的方式定义。

B，定义了 USB_SOURCE_DIR，则按源码在本地的方案定义。



（5）BuildPackage宏

最重要的一个宏是 BuildPackage。它会在 Makefile 的最后一行被引用。它的实现也就是在 package.mk 文件里。如下为其源码：

define BuildPackage
  $(Build/IncludeOverlay)
  $(eval $(Package/Default))    #定义在package-defaults.mk文件里
  $(eval $(Package/$(1)))       #调用用户自定义的 Package/<包名> 宏

  ifdef DESCRIPTION
    $$(error DESCRIPTION:= is obsolete, use Package/PKG_NAME/description)
  endif

  #检查有没有定义 Package/<包名>/description宏，如果没有定义，则以TITLE默认定义一个
  ifndef Package/$(1)/description
    define Package/$(1)/description
      $(TITLE)
    endef
  endif

  BUILD_PACKAGES += $(1)
  $(STAMP_PREPARED): $$(if $(QUILT)$(DUMP),,$(call find_library_dependencies,$(DEPENDS)))

  #检查 TITLE, CATEGORY, SECTION, VERSION 是否定义，如果没有定义则报错
  $(foreach FIELD, TITLE CATEGORY SECTION VERSION,
    ifeq ($($(FIELD)),)
      $$(error Package/$(1) is missing the $(FIELD) field)
    endif
  )

  #如果有定义DUMP，那就引入Dumpinfo/Package宏的内部。
  #如果没有，那么就引用 Packaget/<包名>/targets里面的每一个target，如果没有定义Packaget/<包名>/targets宏，那么将PKG_TARGETS里的每个target取出来，
  #如果也没有定义PKG_TARGETS，那就默认ipkg作为target。将每一个target，引用 BuildTarget/$(target)。
  $(if $(DUMP), \
    $(Dumpinfo/Package), \
    $(foreach target, \
      $(if $(Package/$(1)/targets),$(Package/$(1)/targets), \
        $(if $(PKG_TARGETS),$(PKG_TARGETS), ipkg) \
      ), $(BuildTarget/$(target)) \
    ) \
  )
  $(if $(PKG_HOST_ONLY)$(DUMP),,$(call Build/DefaultTargets,$(1)))
endef
总结一下语法：

$() 表示要执行的一条语句

$(if 条件, 成立执行, 失败执行)        if条件分支

$(foreach 变量, 成员列表, 执行体)   成员遍历语句

可以看出，语句是可以嵌套使用的。

$(N)  表示第N个参数


自定义宏

必须定义的宏

我定要为我们的package定义特定的宏：

Package/<包名>    #包的参数


在 Package/<包名> 宏中定义与包相关的信息。

如Package/helloworld宏：

define Package/helloworld
    SECTION:=utils
    CATEGORY:=Utilities
    TITLE:=Helloworld -- prints a snarky message
endef
除了上面所列的 SECTION，CATEGORY，TITLE变量外，还可以定义：

SECTION     - 包的种类

CATEGORY    - 显示在menuconfig的哪个目录下

TITLE       -  简单的介绍

DESCRIPTION - (deprecated) 对包详细的介绍

URL - 源码所在的网络路径

MAINTAINER  - (required for new packages) 维护者是谁（出错了联系谁）

DEPENDS     - (optional) 需要依事的包，See below for the syntax.

USERID      - (optional) a username:groupname pair to create at package installation time.





可选定义的宏

其它的宏可以选择性地定义，通常没必要自己重写。但有些情况，package.mk中默认的宏不能满足我们的需求。这时，我们就需要自己重定义宏。

比如，我们在为helloworld写Makefile时，我们要求在编译之前，将 SDK/package/helloworld/src/ 路径下的文件复制到 PKG_BUILD_DIR 所指定的目录下。

于是我们重新定义Build/Prepare宏：

define Build/Prepare
    mkdir -p $(PKG_BUILD_DIR)
    $(CP) ./src/* $(PKG_BUILD_DIR)/
endef
如此以来，在我们 make V=s 时，make工具会在编译之前执行 Build/Prepare 宏里的命令。



再比如，我们要指定包的安装方法：

define Package/helloworld/install
    $(INSTALL_DIR) $(1)/bin
    $(INSTALL_BIN) $(PKG_BUILD_DIR)/helloworld $(1)/bin/
endef
上面的这个宏就是指定了包的安装过程。其中 INSTALL_DIR 定义在 rules.mk 文件里。

INSTALL_DIR = install -d -m0755

INSTALL_BIN = install -m0755

$(1)为第一个参数是./configure时的--prefix参数，通常为""

展开之后就是：

define Package/helloworld/install
    install -d -m0755 /bin
    install -m0755 $(PKG_BUILD_DIR)/helloworld /bin/
endef
它的意思就一目了然了。



除了上面所列举的这两个宏外，在官网上也说明了其它可选的宏：

Package/conffiles (optional)

由该包安装的配置文件的列表，一行一个文件。



Package/description

对包描述的纯文本



Build/Prepare (optional)

A set of commands to unpack and patch the sources. You may safely leave this undefined.



Build/Configure (optional)

You can leave this undefined if the source doesn't use configure or has a normal config script, otherwise you can put your own commands here or use "$(call Build/Configure/Default,)" as above to pass in additional arguments for a standard configure script.



Build/Compile (optional)

How to compile the source; in most cases you should leave this undefined, because then the default is used, which calls make. If you want to pass special arguments to make, use e.g. "$(call Build/Compile/Default,FOO=bar)



Build/Install (optional)

How to install the compiled source. The default is to call make install. Again, to pass special arguments or targets, use $(call Build/Install/Default,install install-foo) Note that you need put all the needed make arguments here. If you just need to add something to the "install" argument, don't forget the 'install' itself.



Build/InstallDev (optional)

For things needed to compile packages against it (static libs, header files), but that are of no use on the target device.



Package/install

A set of commands to copy files into the ipkg which is represented by the $(1) directory. As source you can use relative paths which will install from the unpacked and compiled source, or $(PKG_INSTALL_DIR) which is where the files in the Build/Install step above end up.



Package/preinst

The actual text of the script which is to be executed before installation. Dont forget to include the #!/bin/sh. If you need to abort installation have the script return false.



Package/postinst

The actual text of the script which is to be executed after installation. Dont forget to include the #!/bin/sh.



Package/prerm

The actual text of the script which is to be executed before removal. Dont forget to include the #!/bin/sh. If you need to abort removal have the script return false.



Package/postrm

The actual text of the script which is to be executed after removal. Dont forget to include the #!/bin/sh.



之所以有些宏是以"Package/"开头，有的又以"Build/"，是因为在一个Makefile里生成多个包。OpenWrt默认认为一个Makefile里定义一个包，但我们也可以根据需要将其拆分成多个。所以说，如果我们只希望编译一次，那么只要有一系列的"Build/"的宏定义就可以了。但是，我们也可以通过添加多个"Package/"宏定义，并调用 BuildPackage，来创建多个包。



使之生效

在Makefile的最后一行是：

$(eval $(call BuildPackage,helloworld))
最重要的 BuildPackage定义在 package.mk 文件里。见上面 BuildPackage 宏定义。
