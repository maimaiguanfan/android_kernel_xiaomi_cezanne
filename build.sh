#!/bin/bash
export ARCH=arm64
export SUBARCH=arm64
export HEADER_ARCH=arm64
export CC=/home/maimaiguanfan/google-clang/clang-r353983c1/bin/clang
export CROSS_COMPILE=/home/maimaiguanfan/gcc/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
export CROSS_COMPILE_ARM32=/home/maimaiguanfan/gcc/gcc-arm-9.2-2019.12-x86_64-arm-none-eabi/bin/arm-none-linux-gnueabi-

if [ -f tools/AnyKernel3/anykernel.sh ];
then
	cd tools/AnyKernel3
	git pull upstream master
else
	git submodule update --init --recursive
	cd tools/AnyKernel3
	git remote add upstream https://github.com/osm0sis/AnyKernel3
	git pull upstream master
fi
cd ../..

echo " "
printf "Please enter MGF Kernel version number: "
read v
echo " "
export EV=EXTRAVERSION=-MGF-V$v
rm -rf out/arch/arm64/boot/Image.gz-dtb
make O=out $EV cezanne_user_defconfig
make O=out $EV CC=/home/maimaiguanfan/google-clang/clang-r353983c1/bin/clang -j$(nproc --all)

if [ -f out/arch/arm64/boot/Image.gz-dtb ];
then
	mv out/arch/arm64/boot/Image.gz-dtb tools/AnyKernel3/Image.gz-dtb
	cd tools/AnyKernel3
	zip -r9 MGF-V"$v"_K30U.zip * > /dev/null
	cd ../..
	mv tools/AnyKernel3/MGF-V"$v"_K30U.zip MGF-V"$v"_K30U.zip
	rm -rf tools/AnyKernel3/Image.gz-dtb
	echo " "
	echo "Sucess!"
	echo " "
else
	echo " "
	echo "Failed!"
	echo " "
fi
