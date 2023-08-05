#!/bin/bash

gccver=12.2.0
binutilsver=2.40
prefix=/usr/local/psn00bsdk
export PATH=$PATH:"$prefix"/bin:"$prefix"/mipsel-none-elf/bin
export PSN00BSDK_LIBS="$prefix"/psn00bsdk/libpsn00b
sudo rm -f /usr/local/bin/psn00b-env

set -e

if command -v dnf &> /dev/null; then
    sudo dnf install -y autoconf automake g++ make libtool texinfo help2man ncurses-devel cmake tinyxml2-devel
elif command -v apt &> /dev/null; then
    sudo apt install --yes build-essential cmake libtinyxml2-dev
fi

tmp=$(mktemp -d --tmpdir psn00b.XXX)

cleanup() 
{ 
    if [[ -e "$tmp" ]]; then  
        yes | rm -r "$tmp"   
    fi
}
trap cleanup EXIT

sudo rm -rf "$prefix"
sudo mkdir -p "$prefix"
sudo chown -R $USER: "$prefix"
cd "$tmp"

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
cd ../

cd "$prefix"
git clone --recursive https://github.com/lameguy64/psn00bsdk
cd psn00bsdk
cmake --preset default . --install-prefix "$prefix" -G "Unix Makefiles"
cmake --build ./build
cmake --install ./build

echo -e '#!/bin/bash\n'"export PATH=\$PATH:"$prefix"/bin:"$prefix"/mipsel-none-elf/bin\nexport PSN00BSDK_LIBS="$prefix"/libpsn00b\necho \$PATH\necho\nbash" | sudo tee -a /usr/local/bin/psn00b-env
sudo chmod -R 775 /usr/local/bin/psn00b-env

echo "Execute the psnoob-env command to add the PSN00bSDK to your shell"