---
title: "Flashing"
weight: 2
# bookFlatSection: true
# bookToc: true
# bookHidden: false
# bookCollapseSection: true
# bookComments: true
# bookSearchExclude: false
---

# Flashing a new board

The following guide describes the necessary step to flash a new board.
If your board already has a firmware on it, you can use [mesaflash](https://github.com/jstjst/mesaflash/tree/stmbl-fpga-master).

## Program the FPGA over JTAG

Connect a Raspberry Pi Pico with the [JTAGprobe](https://github.com/dst202/JTAGprobe) firmware to the JTAG port.
Apply 24V to the PWR connector (preferable with a current limited supply).
The green power LED should light up and after a short blink the red INIT and DONE LEDs light up. The board will draw about 60 mA in this state.
You can also hold the JTAG connections on the pads after powering up the board.
Use [OpenOCD](https://openocd.org/) to read out the FPGA device signature:
`openocd -f interface/cmsis-dap.cfg -c "adapter speed 10000; transport select jtag" -f cpld/xilinx-xc6s.cfg -c "init; exit"`

```
Open On-Chip Debugger 0.12.0
Licensed under GNU GPL v2
For bug reports, read
        http://openocd.org/doc/doxygen/bugs.html
jtag
xc6s_print_dna
Info : Using CMSIS-DAPv2 interface with VID:PID=0x2e8a:0x000c, serial=E663AC91D342A338
Info : CMSIS-DAP: SWD supported
Info : CMSIS-DAP: JTAG supported
Info : CMSIS-DAP: Atomic commands supported
Info : CMSIS-DAP: Test domain timer supported
Info : CMSIS-DAP: FW Version = 2.0.0
Info : CMSIS-DAP: Interface Initialised (JTAG)
Info : SWCLK/TCK = 0 SWDIO/TMS = 0 TDI = 0 TDO = 0 nTRST = 0 nRESET = 0
Info : CMSIS-DAP: Interface ready
Info : clock speed 10000 kHz
Info : cmsis-dap JTAG TLR_RESET
Info : cmsis-dap JTAG TLR_RESET
Info : JTAG tap: xc6s.tap tap/device found: 0x24001093 (mfg: 0x049 (Xilinx), part: 0x4001, ver: 0x2)
Warn : gdb services need one or more targets defined
```

If you get the device signatur above, you can flash the board:
`openocd -f interface/cmsis-dap.cfg -c "adapter speed 10000; transport select jtag" -f cpld/xilinx-xc6s.cfg -c "init; xc6s_program xc6s.tap; pld load 0 hostmot2-firmware/bit/stmblETH_FALLBACK.bit; exit"`

```
Open On-Chip Debugger 0.12.0
Licensed under GNU GPL v2
For bug reports, read
        http://openocd.org/doc/doxygen/bugs.html
jtag
xc6s_print_dna
Info : Using CMSIS-DAPv2 interface with VID:PID=0x2e8a:0x000c, serial=E663AC91D342A338
Info : CMSIS-DAP: SWD supported
Info : CMSIS-DAP: JTAG supported
Info : CMSIS-DAP: Atomic commands supported
Info : CMSIS-DAP: Test domain timer supported
Info : CMSIS-DAP: FW Version = 2.0.0
Info : CMSIS-DAP: Interface Initialised (JTAG)
Info : SWCLK/TCK = 0 SWDIO/TMS = 0 TDI = 0 TDO = 0 nTRST = 0 nRESET = 0
Info : CMSIS-DAP: Interface ready
Info : clock speed 10000 kHz
Info : cmsis-dap JTAG TLR_RESET
Info : cmsis-dap JTAG TLR_RESET
Info : JTAG tap: xc6s.tap tap/device found: 0x24001093 (mfg: 0x049 (Xilinx), part: 0x4001, ver: 0x2)
Warn : gdb services need one or more targets defined
Info : cmsis-dap JTAG TLR_RESET
```

The programming takes about one minute, after programming openocd will exit.
If the programming was sucsessfull the INIT LED should blink (indicating that a fallback bit file was flashed), continue with [Write the ethernet EEPROM](flashing/#write-the-ethernet-eeprom) without powering down the board.
If you have trouble with the programming, try to solder the JTAG connector (there is no verification of the program).

## Write the ethernet EEPROM

Connect to the board via Ethernet.
{{% hint danger %}}
 Only the `J5` RJ45 connector is a ethernet port, the other RJ45 connectors are SSerial ports and may damage your PC.
{{% /hint %}}

Set your network config appropriately and try to ping the board `ping -c 4 192.168.1.121`

```
PING 192.168.1.121 (192.168.1.121) 56(84) bytes of data.
64 bytes from 192.168.1.121: icmp_seq=1 ttl=63 time=0.622 ms
64 bytes from 192.168.1.121: icmp_seq=2 ttl=63 time=0.636 ms
64 bytes from 192.168.1.121: icmp_seq=3 ttl=63 time=1.10 ms
64 bytes from 192.168.1.121: icmp_seq=4 ttl=63 time=1.49 ms

--- 192.168.1.121 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3055ms
rtt min/avg/max/mdev = 0.622/0.961/1.488/0.359 ms
```

Use the script `tools/init/stmblETH-init.sh` to write the board name and mac address to the EEPROM.

```
Old Name: ����������������
New Name: stmblETH

Old MAC Addr: 00FFFFFFFFFF
New MAC Addr: 0073746D626C

Reseting Ethernet CPU
```

{{% hint warning %}}
 If you use more than one board, you should set different MAC addresses.
{{% /hint %}}

After writing the values to the EEPROM continue with [Write the bit file in the SPI flash](flashing/#write-the-bit-file-in-the-spi-flash) without powering down the board.

## Write the bit file in the SPI flash

Check if mesaflash recognizes the board: `./mesaflash --device ether --addr 192.168.1.121`

```
ETH device stmblETH at ip=192.168.1.121
```

Flash the fallback firmware and boot block: `./mesaflash --device ether --addr 192.168.1.121 --fix-boot-block --fallback --write hostmot2-firmware/bit/stmblETH_FALLBACK.bit`

```
Checking file... OK
  File type: Xilinx bit file
Boot sector OK
FLASH memory sectors to write: 6, max sectors in area: 15
Erasing FLASH memory sectors starting from 0x10000...
  |EEEEEE
Programming FLASH memory sectors starting from 0x10000...
  |WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
Board configuration updated successfully.
Checking file... OK
  File type: Xilinx bit file
Boot sector OK
Verifying FLASH memory sectors starting from 0x10000...
  |VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
Board configuration verified successfully.

You must power cycle the hardware or use the --reload command to load a new firmware.
```

Flash the main firmware: `./mesaflash --device ether --addr 192.168.1.121 --write hostmot2-firmware/bit/stmblETH_SSD13.bit`

```
Checking file... OK
  File type: Xilinx bit file
Boot sector OK
FLASH memory sectors to write: 6, max sectors in area: 16
Erasing FLASH memory sectors starting from 0x100000...
  |EEEEEE
Programming FLASH memory sectors starting from 0x100000...
  |WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
Board configuration updated successfully.
Checking file... OK
  File type: Xilinx bit file
Boot sector OK
Verifying FLASH memory sectors starting from 0x100000...
  |VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
Board configuration verified successfully.

You must power cycle the hardware or use the --reload command to load a new firmware.
```

You can also flash a firmware for usage with the SPI host interface, but you will lose ethernet connectivity afterwards.