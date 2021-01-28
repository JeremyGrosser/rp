uf2: main
	pico-sdk/elf2uf2/elf2uf2 obj/main obj/main.uf2

main: pico-sdk src/boot2.S
	gprbuild -P rp.gpr -j0 -f

pico-sdk:
	git submodule init --update
	cd pico-sdk && cmake . && make

src/boot2.S: pico-sdk
	arm-eabi-gcc -Ipico-sdk/src/rp2040/hardware_regs/include -Ipico-sdk/src/rp2_common/pico_platform/include -Ipico-sdk/src/common/pico_base/include -Ipico-sdk/generated/pico_base -E -o src/boot2.S pico-sdk/src/rp2_common/boot_stage2/bs2_default_padded_checksummed.S

# TODO: figure out how to link the wait_for_vector symbol from bootrom, for now it's commented out manually
#src/crt0.S: pico-sdk
#	arm-eabi-gcc -Ipico-sdk/src/rp2040/hardware_regs/include -Ipico-sdk/src/common/pico_binary_info/include -E -o src/crt0.S pico-sdk/src/rp2_common/pico_standard_link/crt0.S

svd:
	svd2ada -o src/rp2040 -p RP2040_SVD --boolean --gen-interrupts --gen-uint-always src/rp2040.svd
