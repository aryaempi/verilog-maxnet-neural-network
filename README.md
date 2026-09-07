# Maxnet Neural Network in Verilog

A modular Verilog implementation of a four-neuron Maxnet competitive neural
network.

The design reads four initial neuron values, repeatedly applies lateral
inhibition, and selects the neuron with the largest initial value. The supplied
test data selects neuron `0` as the winner.

## Features

- Four competing neurons
- Modular RTL design
- Finite-state-machine controller
- Separate datapath and controller
- Memory-based initial neuron values
- One processing unit for each neuron
- Floating-point adder and multiplier modules
- Activation function that limits negative results to zero
- Convergence detection and two-bit winner index output
- ModelSim testbench

## Architecture

```text
maxnet
|- controller
`- datapath
   |- memory
   |- register modules
   |- 4 x PU modules
   |  |- fp_multiplier
   |  |- fp_adder
   |  `- activation
   |- check
   `- encoder4to2
```

## Main Modules

| File | Purpose |
| --- | --- |
| `maxnet.v` | Top-level module that connects the controller and datapath. |
| `controller.v` | FSM for initialization, computation, and completion. |
| `datapath.v` | Main processing path for the Maxnet network. |
| `PU.v` | Processing unit for one neuron. |
| `memory.v` | Stores the initial neuron values. |
| `register.v` | Stores neuron values between iterations. |
| `fp_adder.v` | Floating-point addition module. |
| `fp_multiplier.v` | Floating-point multiplication module. |
| `activation.v` | Activation function that changes negative values to zero. |
| `check.v` | Detects network convergence. |
| `encoder4to2.v` | Generates the winner index. |
| `mux2-1.v` | 2-to-1 multiplexer. |
| `mux4-1.v` | 4-to-1 multiplexer. |
| `maxnet_tb.v` | Simulation testbench. |

## Operation

For neuron `i`, the processing unit calculates:

```text
a_i(new) = activation(a_i + sum(epsilon_neg x a_j)), where j != i
```

`epsilon_neg` is a negative inhibition coefficient. The network converges when
only one neuron has a non-zero value. The `encoder4to2` module then reports its
index.

## Simulation

Compile and run the design in ModelSim or QuestaSim:

```tcl
vlib work

vlog activation.v
vlog check.v
vlog encoder4to2.v
vlog mux2-1.v
vlog mux4-1.v
vlog register.v
vlog memory.v
vlog fp_adder.v
vlog fp_multiplier.v
vlog PU.v
vlog controller.v
vlog datapath.v
vlog maxnet.v
vlog maxnet_tb.v

vsim -voptargs=+acc work.maxnet_tb
add wave -r sim:/maxnet_tb/*
run -all
```

## Expected Result

The supplied testbench uses these initial values:

```text
Neuron 0: 0.8
Neuron 1: 0.4
Neuron 2: 0.6
Neuron 3: 0.2
```

Expected simulation output:

```text
SUCCESS: Winner Detected!
Winner Neuron Index: 0
```

## License

This project is released under the MIT License. See `LICENSE` for details.
