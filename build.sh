#!/bin/bash

gccver=12.2.0
binutilsver=2.40
prefix=/usr/local/psn00bsdk
is_msys2=$(uname -a | grep MSYS | wc -l)
cd "$(dirname "$0")"
ret=$(realpath .)
set -e

if command -v dnf &> /dev/null; then
    sudo dnf install -y autoconf automake g++ make libtool texinfo help2man ncurses-devel cmake tinyxml2-devel git ninja-build
elif command -v apt &> /dev/null; then
    sudo apt install --yes build-essential cmake libtinyxml2-dev git ninja-build libisl-dev texi2html texinfo help2man 
elif command -v pacman &> /dev/null; then
	if [ $is_msys2 -eq 1 ]; then
		pacman --noconfirm -S autoconf libtool texinfo help2man ncurses git make cmake gcc patch ninja
	else
		echo "Error: You must use the MSYS2 MSYS Shell with this script to build on Windows. Please start this script in an MSYS2 MSYS window."
		exit 1
	fi
else
	echo "Error: Unknown package manager/OS"
	exit 1
fi

if [ $is_msys2 -eq 1 ]; then
	rm -f /usr/local/bin/psn00b-env
else
	sudo rm -f '$prefix'
fi

tmp=$(mktemp -d --tmpdir psn00b.XXX)

cleanup() 
{ 
    if [[ -e "$tmp" ]]; then  
        yes | rm -r "$tmp"   
    fi
}
trap cleanup EXIT

if [ $is_msys2 -eq 1 ]; then
	rm -rf "$prefix"
	mkdir -p "$prefix"
else
	sudo rm -rf "$prefix"
	sudo mkdir -p "$prefix"
	sudo chown -R $USER "$prefix"
fi

cd "$tmp"

git clone --recursive https://github.com/lameguy64/psn00bsdk

if [ $is_msys2 -gt 0 ]; then
	patch -u psn00bsdk/tools/mkpsxiso/tinyxml2/tinyxml2.cpp -i "$ret"/tinyxml2.cpp-patch
	patch -u psn00bsdk/tools/mkpsxiso/src/shared/platform.h -i "$ret"/platform.h-patch
fi

wget https://ftpmirror.gnu.org/gnu/binutils/binutils-"$binutilsver".tar.xz
wget https://ftpmirror.gnu.org/gnu/gcc/gcc-"$gccver"/gcc-"$gccver".tar.xz

echo "Extracting Binutils..."
tar xf binutils-"$binutilsver".tar.xz
echo "Extracting GCC..."
tar xf gcc-"$gccver".tar.xz
cd gcc-"$gccver"
./contrib/download_prerequisites
cd ../

mkdir binutils-build
cd binutils-build
../binutils-"$binutilsver"/configure --prefix="$prefix" --target=mipsel-none-elf \
  --disable-docs --disable-nls --disable-werror --with-float=soft
make -j`nproc`
make install-strip
cd ../

mkdir gcc-build
cd gcc-build
../gcc-"$gccver"/configure --prefix="$prefix" --target=mipsel-none-elf \
  --disable-docs --disable-nls --disable-werror --disable-libada \
  --disable-libssp --disable-libquadmath --disable-threads \
  --disable-libgomp --disable-libstdcxx-pch --disable-hosted-libstdcxx \
  --enable-languages=c,c++ --without-isl --without-headers \
  --with-float=soft --with-gnu-as --with-gnu-ld
make -j`nproc`
make install-strip

cd "$tmp"/psn00bsdk

export PATH="$prefix"/bin${PATH:+:${PATH}}
export PSN00BSDK_LIBS="$prefix"/lib/libpsn00b

cmake --preset default . --install-prefix "$prefix"
cmake --build ./build
cmake --install ./build

if [ $is_msys2 -eq 1 ]; then
	mkdir -p /usr/local/bin
	echo -e '#!/bin/bash\n'export PATH="$prefix"/bin\${PATH:+:\${PATH}}\nexport PSN00BSDK_LIBS="$prefix"/lib/libpsn00b\necho \$PATH'\n'bash\n > /usr/local/bin/psn00b-env
else
	echo -e '#!/bin/bash\n'export PATH="$prefix"/bin\${PATH:+:\${PATH}}\nexport PSN00BSDK_LIBS="$prefix"/lib/libpsn00b\necho \$PATH\nbash\n | sudo tee -a /usr/local/bin/psn00b-env
	sudo chmod 775 /usr/local/bin/psn00b-env
fi

echo "Execute the psn00b-env command to add the toolchain and sdk to your shell"