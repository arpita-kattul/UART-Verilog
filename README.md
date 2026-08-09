# UART-Verilog
UART Transmitter, Receiver and Loopback implementation in Verilog

# UART Communication System using Verilog

A UART communication system designed and verified using Verilog HDL.

This project implements a UART Transmitter, UART Receiver, and UART Loopback verification setup.

## Overview

UART (Universal Asynchronous Receiver-Transmitter) is a serial communication protocol used for asynchronous data transmission between digital systems.

This project consists of:

- UART Transmitter (TX)
- UART Receiver (RX)
- UART Loopback verification

The designs use FSM-based control, shift registers, baud-rate counters, and bit counters for serial data transmission and reception.

## UART Frame Format

The UART transmission uses the following frame format:

Idle | Start | 8 Data Bits | Stop
  1  |   0   |   LSB First |  1

Each transmitted byte consists of:

- 1 Start bit
- 8 Data bits
- 1 Stop bit

Data is transmitted and received LSB first.

## UART Transmitter

The UART transmitter converts 8-bit parallel data into a serial bit stream.

### Features

- 8-bit data transmission
- LSB-first transmission
- Start-bit generation
- Stop-bit generation
- Busy signal
- Parameterized baud-rate divider
- FSM-based control
- Shift-register based transmission

## UART Receiver

The UART receiver detects the incoming serial data, reconstructs the original 8-bit data, and validates the received frame.

### Features

- Start-bit detection
- Start-bit validation
- 8-bit serial data reception
- LSB-first reception
- Stop-bit validation
- Data-valid indication
- Framing-error detection
- FSM-based control
- Shift-register based reception

## UART Loopback

The UART loopback test integrates the UART transmitter and receiver to verify end-to-end serial communication.

In the loopback configuration, the serial output of the UART transmitter is directly connected to the serial input of the UART receiver.

```text
        8-bit Data
            |
            v
     +--------------+
     |  UART TX     |
     | Transmitter  |
     +--------------+
            |
            | Serial Data
            v
     +--------------+
     |  UART RX     |
     |  Receiver    |
     +--------------+
            |
            v
       Received Data

