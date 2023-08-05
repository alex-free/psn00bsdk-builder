# [alex-free.github.io](https://alex-free.github.io)

# PSN00bSDK Builder

By Alex Free

Build the [PSN00bSDK](https://github.com/lameguy64/psn00bsdk) by [Lameguy64](https://github.com/lameguy64) on APT (Debian/Ubuntu based distributions) and DNF (RedHat based distributions) with one command. PSN00bSDK builder installs everything to `/usr/local/psn00bsdk` in a self-contained manner, to not affect anything else on your system. A `/usr/local/bin/psn00b-env` command is provided which adds all the tools installed to `/usr/local/psn00bsdk` to your path, and additionally sets the proper `PSN00BSDK_LIBS` envar to enable use of the SDK in the current shell.

PSN00bSDK Builder currently will setup mipsel-none-elf GCC 12.2.0/Binutils 2.40 with the latest PSN00bSDK.

## Links

*   [Homepage](https://alex-free.github.io/psn00bsdk-builder)

*   [Github](https://github.com/alex-free/psn00bsdk-builder)

## Downloads

_Tip:_ Use `git` to clone the latest version: 

`git clone https://github.com/alex-free/psn00bsdk-builder`

### Version 1.0 (8/5/2023)

*   [PSN00bSDK Builder v1.0](https://github.com/alex-free/psn00bsdk-builder/releases/download/v1.0/psn00bsdk-builder-v1.0.zip)

## Usage

Download the latest release of PSN00bSDK builder, and execute the `build.sh` script on your Linux system.

## License

PSN00bSDK Builder itself is released into the public domain, please see the file `unlicense.txt` for more info. The PSN00bSDK is released under [various licenses](https://github.com/Lameguy64/PSn00bSDK/blob/master/LICENSE.md).
