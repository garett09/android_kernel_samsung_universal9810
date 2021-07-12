#!/bin/bash
export CROSS_COMPILE=/home/$USER/Android/Toolchains/aarch64-cruel-elf/bin/aarch64-cruel-elf-
export CROSS_COMPILE_ARM32=/home/$USER/Android/Toolchains/arm-xxmustafacooTR-eabi/bin/arm-xxmustafacooTR-eabi-
export CC=/home/$USER/Android/Toolchains/proton-clang/bin/clang

ZIP_DIR="/home/$USER/Android/Kernel/Zip/"
CUR_DIR=$PWD

export ANDROID_MAJOR_VERSION=r
export ARCH=arm64

function clean {
		printf "Cleaning\n"
		cd $CUR_DIR
		rm -rf drivers/gator_5.27/gator_src_md5.h scripts/dtbtool_exynos/dtbtool arch/arm64/boot/dtb.img arch/arm64/boot/dts/exynos/*dtb*
		make -j$(nproc) clean
		make -j$(nproc) mrproper
}

all="false"
clean="false"

while getopts ":ca" flag; do
  case "${flag}" in
	c) clean='true' ;;
    a) all='true' ;;
  esac
done

if $clean
then
	clean
	exit 1
fi

if $all
then
	printf "Build Started\n"
	clean
	printf "Building G960\n"
	make exynos9810-starlte_defconfig
	make -j$(nproc --all)
	cp -vr $CUR_DIR/arch/arm64/boot/Image $ZIP_DIR/Kernel/G960zImage
	cp -vr $CUR_DIR/arch/arm64/boot/dtb.img $ZIP_DIR/Kernel/G960dtb.img
	clean
	printf "Building N960\n"
	make exynos9810-crownlte_defconfig
	make -j$(nproc --all)
	cp -vr $CUR_DIR/arch/arm64/boot/Image $ZIP_DIR/Kernel/N960zImage
	cp -vr $CUR_DIR/arch/arm64/boot/dtb.img $ZIP_DIR/Kernel/N960dtb.img
	clean
fi
printf "Building G965\n"
make exynos9810-star2lte_defconfig
make -j$(nproc --all)
cp -vr $CUR_DIR/arch/arm64/boot/Image $ZIP_DIR/Kernel/G965zImage
cp -vr $CUR_DIR/arch/arm64/boot/dtb.img $ZIP_DIR/Kernel/G965dtb.img