# Serial Code in VHDL (Synchronous Process)

## Overview

This lab focuses on implementing a serial counter system in VHDL, using a synchronous process. The system counts numbers based on a given upper bound and supports repeating the count cycle upon completion.
---


## System Description

The system consists of three main processes:

1. **Fast Counter** - Counts rapidly from 0 to the current value of the Slow Counter.
2. **Slow Counter** - Increments when the Fast Counter reaches its current count.
3. **Control Process** - Manages the counting behavior, including start, freeze, and reset.

![slowfast2](https://github.com/user-attachments/assets/08dbb6b8-5f7a-4beb-828b-c3e5166a4ffe)

The counting process continues until both counters reach the specified upper bound. If the `repeat` flag is set, the system restarts counting from zero.

### Inputs

* **upperBound\_i**: An n-bit vector that specifies the target number to count up to.
* **clk**: Clock signal.
* **rst**: Reset signal to initialize the counters.
* **repeat**: A control bit indicating whether to restart counting after reaching the upper bound.

### Outputs

* **cout**: An n-bit vector representing the current count of the Fast Counter.
* **busy**: A status bit indicating whether the counter is actively counting.

### Control Signals

* **control\_fast\_signal**: Determines whether the Fast Counter should count ("00"), restart ("01"), or freeze ("10" or "11").
* **control\_slow\_signal**: Similar control for the Slow Counter.

---

## Process Details

### Fast Counter

* **Inputs**: clk, rst, control
* **Output**: cout (current count)
* **Function**: Increments from zero to the value of the Slow Counter every clock cycle. Resets to zero when the Slow Counter advances.

### Slow Counter

* **Inputs**: upperBound\_i, clk, rst, control
* **Output**: snt\_slow\_s (local signal for current count)
* **Function**: Increments only when the Fast Counter reaches the current count value.

### Control Process

* **Inputs**: upperBound\_i, cout, snt\_slow\_s, repeat, clk
* **Outputs**: control\_slow, control\_fast, busy
* **Function**: Determines when to count, freeze, or restart based on input signals. Ensures synchronization between the Fast and Slow Counters.

---

## Usage Notes

* Always start the system with the `rst` signal turned on to initialize the counters.
* If `repeat` is set, the system will continuously restart counting upon reaching the upper bound.
* The `busy` signal indicates whether the counting process is active.
