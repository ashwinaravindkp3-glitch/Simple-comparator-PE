`timescale 1ns/1ps

// Compare-swap unit (PE)
module compare_swap #(
    parameter DATA_WIDTH = 8
)(
    input  [DATA_WIDTH-1:0] A,
    input  [DATA_WIDTH-1:0] B,
    output [DATA_WIDTH-1:0] Min,
    output [DATA_WIDTH-1:0] Max
);
    
    assign Min = (A <= B) ? A : B;
    assign Max = (A <= B) ? B : A;
    
endmodule
