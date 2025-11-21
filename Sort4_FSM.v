`timescale 1ns/1ps

// Sorted 4-element FSM using a standard 3-stage sorting network
module Sort4_FSM (
  input clk,
  input rst_n,         // active low reset
  input start,         // pulse to start (one cycle)
  input [7:0] i0, i1, i2, i3,
  output reg [7:0] R0, R1, R2, R3,
  output reg done      // asserted for one cycle when sorted and stable
);

  // intermediate regs (store current values)
  reg [7:0] r0, r1, r2, r3;

  // PE outputs wires
  wire [7:0] p01_min, p01_max;
  wire [7:0] p23_min, p23_max;
  wire [7:0] p12_min, p12_max;

  // instantiate comparator PEs (combinational)
  PE pe01(.A(r0), .B(r1), .Min(p01_min), .Max(p01_max));
  PE pe23(.A(r2), .B(r3), .Min(p23_min), .Max(p23_max));
  PE pe12(.A(r1), .B(r2), .Min(p12_min), .Max(p12_max));

  // FSM phase
  reg [2:0] phase;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      r0 <= 0; r1 <= 0; r2 <= 0; r3 <= 0;
      R0 <= 0; R1 <= 0; R2 <= 0; R3 <= 0;
      phase <= 0;
      done <= 0;
    end else begin
      done <= 0;
      case (phase)
        0: begin
          // idle: wait for start pulse
          if (start) begin
            r0 <= i0;
            r1 <= i1;
            r2 <= i2;
            r3 <= i3;
            phase <= 1;
          end
        end

        1: begin
          // Stage A: compare (0,1) and (2,3)
          r0 <= p01_min;
          r1 <= p01_max;
          r2 <= p23_min;
          r3 <= p23_max;
          phase <= 2;
        end

        2: begin
          // Stage B: compare (1,2)
          r1 <= p12_min;
          r2 <= p12_max;
          phase <= 3;
        end

        3: begin
          // Stage C: final compare (0,1) and (2,3)
          r0 <= p01_min;
          r1 <= p01_max;
          r2 <= p23_min;
          r3 <= p23_max;
          phase <= 4;
        end

        4: begin
          // Finalize outputs
          R0 <= r0;
          R1 <= r1;
          R2 <= r2;
          R3 <= r3;
          done <= 1;
          phase <= 0;
        end

        default: phase <= 0;
      endcase
    end
  end

endmodule
