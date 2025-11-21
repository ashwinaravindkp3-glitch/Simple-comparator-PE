# Clock constraint - 100 MHz
create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]

# Input/Output delays (relative to clock)
set_input_delay -clock clk -min 1.000 [get_ports {rst_n start i0[*] i1[*] i2[*] i3[*]}]
set_input_delay -clock clk -max 2.000 [get_ports {rst_n start i0[*] i1[*] i2[*] i3[*]}]
set_output_delay -clock clk -min 0.500 [get_ports {R0[*] R1[*] R2[*] R3[*] done}]
set_output_delay -clock clk -max 1.500 [get_ports {R0[*] R1[*] R2[*] R3[*] done}]
