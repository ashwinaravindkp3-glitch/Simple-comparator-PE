`timescale 1ns/1ps

// Simple comparator PE: outputs min and max
module PE (
  input  [7:0] A,
  input  [7:0] B,
  output [7:0] Min,
  output [7:0] Max
);
  assign Min = (A < B) ? A : B;
  assign Max = (A < B) ? B : A;
endmodule
