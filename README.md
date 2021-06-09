This project is **deprecated**. This was the first proof of concept for running Ada on the Raspberry Pi RP2040 Pico board. There is a [blog post](https://synack.me/ada/pico/2021/03/03/from-zero-to-blinky-ada.html) about it. The [rp2040_hal](https://github.com/JeremyGrosser/rp2040_hal), [pico_bsp](https://github.com/JeremyGrosser/pico_bsp), and [pico_examples](https://github.com/JeremyGrosser/pico_examples) projects have superseded this repository. If you're working on a new project, you should start with the examples there.

## Notes

The RP2040 has no internal flash. The boot ROM loads the first 256 bytes from an external SPI flash which is expected to be a stage 2 bootloader that configures the XIP_SSI peripheral for the specific flash chip in use then relocates the vector table to the flash memory.

The Makefile builds the pico-sdk and runs the gcc preprocessor to generate boot2.S. crt0.S has been manually patched and is not currently auto-generated.

You'll need an arm-none-eabi toolchain and cmake to build pico-sdk and the AdaCore Community 2020 GNAT toolchain to build Ada code. Other toolchains may work, ymmv.
