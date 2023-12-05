# 在 Ubunut / Debian 上编译 Python

1. 安装依赖

   ```sh
   sudo apt install build-essential llvm clang lld
   sudo apt install gdb lcov pkg-config libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev libncurses-dev libreadline-dev libsqlite3-dev libssl-dev lzma lzma-dev tk-dev uuid-dev zlib1g-dev
   ```

2. 查看系统自带的 Python 编译选项

   ```sh
   $ python3 -c "import sysconfig; print(sysconfig.get_config_var('CONFIG_ARGS'))""
   '--enable-shared' '--prefix=/usr' '--libdir=/usr/lib/x86_64-linux-gnu' '--enable-ipv6'
   '--enable-loadable-sqlite-extensions' '--with-dbmliborder=bdb:gdbm' '--with-computed-gotos'
   '--without-ensurepip' '--with-system-expat' '--with-dtrace' '--with-wheel-pkg-dir=/usr/share/python-wheels/'
   '--with-ssl-default-suites=openssl' 'MKDIR_P=/bin/mkdir -p' '--with-system-ffi' 'CC=x86_64-linux-gnu-gcc'
   'CFLAGS=-g     -fstack-protector-strong -fstack-clash-protection -Wformat -Werror=format-security -fcf-protection  '
   'LDFLAGS=-Wl,-Bsymbolic-functions     -g -fwrapv -O2   ' 'CPPFLAGS=-Wdate-time -D_FORTIFY_SOURCE=2'
   ```

3. 下载 Python 源码并解压

   ```sh
   wget -P /tmp https://mirrors.huaweicloud.com/python/3.12.0/Python-3.12.0.tar.xz
   cd /tmp
   tar -xf Python-3.12.0.tar.xz
   cd Python-3.12.0
   ```
   
4. 移除不需要的编译参数，修改为 Clang 编译器，使用 lld 链接器。根据 Python
   [官方指南](https://devguide.python.org/getting-started/setup-building/index.html#clang)添加编译器参数
   `-Wno-unused-value -Wno-empty-body -Qunused-arguments`。

   > `--with-bolt` 加了可能会出错，使用该参数需要安装 `llvm-bolt`
   
   ```sh
   ./configure --enable-ipv6 --enable-loadable-sqlite-extensions --with-dbmliborder=bdb:gdbm --with-computed-gotos \
   --with-system-expat --with-ssl-default-suites=openssl --enable-optimizations --with-lto=full MKDIR_P="/bin/mkdir \
   -p" CC="clang" CXX=clang++ CFLAGS="-fstack-protector-strong -Wformat -Werror=format-security -fcf-protection -Wno-unused-value -Wno-empty-body -Qunused-arguments" \
   LDFLAGS="-fuse-ld=lld -Wl,-Bsymbolic-functions -fwrapv -O2" CPPFLAGS="-Wdate-time -D_FORTIFY_SOURCE=2" AR="llvm-ar"
   ```

5. 构建、安装

   ```sh
   make -s -j16
   # 16代表CPU核心数
   sudo make altinstall
   ```
