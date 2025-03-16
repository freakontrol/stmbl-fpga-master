---
title: "Prerequisites"
weight: 1
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# Prerequisites

## JTAG programming

If your are programming a new (empty) board, you need a JTAG programmer. I used a Raspberry Pi Pico with the [JTAGprobe](https://github.com/dst202/JTAGprobe) firmware and [OpenOCD](https://openocd.org/).
I also tried to us a FT232RL in combination with openFPGALoader, which for some reason didn't work.

## Host interface

Regardless of whether you use SPI or Ethernet, all the usual requirements for normal mesa cards apply here.
It is recommended to initially flash the board over Ethernet.

## Mesaflash

In order for Mesaflash to recognize the board, you need to compile this adapted version: https://github.com/jstjst/mesaflash/tree/stmbl-fpga-master

## LinuxCNC

In order for LinuxCNC to recognize the board, you need to compile this adapted version: https://github.com/jstjst/linuxcnc/tree/stmbl-fpga-master