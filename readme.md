# Digital Signal Processing System for ADC

This project is about the implementation of the Digital Signal Processing (DSP) stage of an acquisition and processing system for an Analog-to-Digital Converter (ADC). The ADC used is the AD9249 from Analog Devices, which has 16 channels at 65 MSps with each sample having 14 bits.

## Overview

1. Introduction
2. Implemented Architecture Design
   1. Digital Signal Processing
   2. AXI Register Block
   3. Clock Domain Crossing
3. Scalability to 16 Channels
4. Simulation

## Introduction

The digital samples from the ADC are delivered in serial format with a 455 MHz clock. These samples go through a SERDES block and are then converted to an AXI4-Stream format. The DSP stage begins at this point.

## Implemented Architecture Design

### Digital Signal Processing

The deserialized samples from the ADC are fed into a DSP module through AXI4-Stream. A multiplexer controlled by a register is implemented, capable of selecting between three possible data inputs: the one from the ADC, a sinusoidal tone generated using the DDS Compiler IP, and a 16-bit counter data source.

### AXI Register Block

A block of 5 32-bit AXI registers was implemented with the following functions:

1. Define the control core ID
2. Define the core version as the date in BCD
3. Control the enable signal of the data FIFO
4. Control the data source (ADC, counter, or DDS Compiler-generated signal)
5. Choose whether to use a filtering stage or not

### Clock Domain Crossing

A clock domain crossing (CDC) is necessary to manage the flow of data between the different clock domains.

## Scalability to 16 Channels

The AD9249 has 16 channels, and only one was used in this project. If all channels were to be used and the same DSP applied, there would be modules that could be reused and others that would need to be repeated.

## Simulation

A testbench was set up to verify the correct functioning of the architecture. The testbench emulated an AXI agent and an ADC agent, consisting of various stages to read and write registers through the AXI4-Lite interface and control the signals of the MUX.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
