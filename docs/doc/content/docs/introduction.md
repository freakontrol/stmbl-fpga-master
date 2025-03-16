---
title: "Introduction"
weight: 1
# bookFlatSection: true
bookToc: true
# bookHidden: false
# bookCollapseSection: true
# bookComments: true
# bookSearchExclude: false
---

# STMBL FPGA Master Introduction Guide

## Description

This is a FPGA controller board specifically designed to be used as a master for up to 12 stmbl drives. It can be used for other applications.
The hardware has the same form factor as the [STMBL](https://github.com/freakontrol/stmbl) v5 drives.
The FPGA runs the hostmot2 firmware.

## Anatomy of the STMBL FPGA Master

The STMBL FPGA Master uses a Spartan 6 and can be either connected via ethernet or SPI to a LinuxCNC host. The board is designed to carry a Raspberry Pi 4 or 5 with the SPI host interface connections.
The board also supplies power to the Raspberry Pi.

{{% hint danger %}}
 Don't connect a USB C power supply to the Raspberry Pi.
{{% /hint %}}

It is also possible to use the board without a Raspberry Pi and connect a host via ethernet.

![STMBL FPGA Master Anatomy](/stmbl-fpga-master/images/iso1-dark.png)

{{% hint danger %}}
 In Hardware v0.9, the Pinout of SSerial 0-5 and 12-13 is reversed (1-8, 2-7, ...), use a [Rollover cable](https://en.wikipedia.org/wiki/Rollover_cable).
{{% /hint %}}

Power to the board should be 24V. A green LED will light when power is supplied.
The board could draw up to 80W if it supplies the SSerial daughter boards and the Raspberry Pi (and USB devices).
For standalone usage the board draws about 2-3W.

{{% hint warning %}}
 A high power consumption is not tested yet, the DC-DC converters might need additional cooling.
{{% /hint %}}

![STMBL FPGA Master Connectors](/stmbl-fpga-master/images/iso2-dark.png)