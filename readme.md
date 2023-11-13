# [alex-free.github.io](https://alex-free.github.io)

# PSN00bSDK Builder

By Alex Free

Automatically build the [PSN00bSDK](https://github.com/lameguy64/psn00bsdk) by [Lameguy64](https://github.com/lameguy64) on Linux or Windows in a self-contained manner, to not affect anything else on your system. A `psn00b-env` command is provided which adds all the tools installed to `/usr/local/psn00bsdk` to your `$PATH`, and additionally sets the proper `PSN00BSDK_LIBS` envar to enable use of the SDK in the current shell.

| [Homepage](https://alex-free.github.io/psn00bsdk-builder) | [Github](https://github.com/alex-free/psn00bsdk-builder) |

## Downloads

### Version 1.0.1 (11/13/2023)

*   [PSN00bSDK Builder v1.0.1](https://github.com/alex-free/psn00bsdk-builder/releases/download/v1.0.1/psn00bsdk-builder-v1.0.1.zip)

Changes:

*   MSYS2 Windows support.
*   New `sdk.sh` script enables building of only the SDK (instead of building the entire toolchain and then sdk).
*   Cleaner `psn00b-env` script.

[Previous versions](changelog.md).

## Usage
 
The PSN00bsdk builder installs everything to `/usr/local/psn00bsdk`. PSN00bSDK Builder currently will setup mipsel-none-elf GCC 12.2.0/Binutils 2.40 with the latest git commit of the PSN00bSDK at time of script execution.

Supported Operating Systems:

 * Windows 8.1/10/11 64 bit
 * Debian and derivatives (Ubuntu, PopOS!, etc.)
 * Fedora

1) If your on Windows, install [MSYS2](https://www.msys2.org/) and **start the `MSYS2 MSYS` shell**. On Linux, open your terminal.

2) Download the latest release and `cd` into the extracted directory. 

3) Execute `./build.sh`. This will take quite awhile to complete since on the toolchain and sdk will are all compiled from source.

4) To use the SDK/toolchain, execute the `psn00b-env` to add the toolchain/sdk to your `$PATH`, and to set the `PSN00BSDK_LIBS` env var. You'll need to do this every time you open a new Terminal window or `MSYS2 MSYS` window).

5) After running the `./build.sh` script, you can use the `./sdk.sh` script to update the PSN00bSDK to the latest version at any time. This command does not rebuild the toolchain, which is much faster then running `./build.sh` again. To rebuild the toolchain and the sdk all over again, execute the `./build.sh` script once again.

Tip 1: You can also use WSL on Windows instead of MSYS2. Just follow the linux specific instructions if using WSL.

Tip 2: If you want to remove anything installed by either the `build.sh` or `sdk.sh` scripts at any time, just `rm -rf /usr/local/psn00bsdk`. The `build.sh` script in fact already does this when started before rebuilding everything from source.

## License

PSN00bSDK Builder itself is released into the public domain, please see the file `unlicense.txt` for more info. The PSN00bSDK is released under [various licenses](https://github.com/Lameguy64/PSn00bSDK/blob/master/LICENSE.md). The toolchain/compiler is released under the [GNU GPL v3.1](https://gcc.gnu.org/onlinedocs/libstdc++/manual/license.html).
