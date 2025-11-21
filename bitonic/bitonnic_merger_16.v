`timescale 1ns/1ps

// 16-element Bitonic Merger - Parallel Architecture I
// Based on Figure 7 from the paper
module bitonic_merger_16 #(
    parameter DATA_WIDTH = 8
)(
    // Inputs: 16 data values
    input  [DATA_WIDTH-1:0] i0, i1, i2, i3, i4, i5, i6, i7,
    input  [DATA_WIDTH-1:0] i8, i9, i10, i11, i12, i13, i14, i15,
    
    // Outputs: 16 sorted values
    output [DATA_WIDTH-1:0] o0, o1, o2, o3, o4, o5, o6, o7,
    output [DATA_WIDTH-1:0] o8, o9, o10, o11, o12, o13, o14, o15
);

    // ==================== STAGE 1: sel[0] ====================
    // Intermediate wires after stage 1
    wire [DATA_WIDTH-1:0] u0, u1, u2, u3, u4, u5, u6, u7;
    wire [DATA_WIDTH-1:0] u8, u9, u10, u11, u12, u13, u14, u15;
    
    // Stage 1 compare-swap units (8 PEs)
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs1_0 (.A(i0),  .B(i8),  .Min(u0),  .Max(u8));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs1_1 (.A(i1),  .B(i9),  .Min(u1),  .Max(u9));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs1_2 (.A(i2),  .B(i10), .Min(u2),  .Max(u10));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs1_3 (.A(i3),  .B(i11), .Min(u3),  .Max(u11));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs1_4 (.A(i4),  .B(i12), .Min(u4),  .Max(u12));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs1_5 (.A(i5),  .B(i13), .Min(u5),  .Max(u13));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs1_6 (.A(i6),  .B(i14), .Min(u6),  .Max(u14));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs1_7 (.A(i7),  .B(i15), .Min(u7),  .Max(u15));

    // ==================== STAGE 2: sel[1] ====================
    // Intermediate wires after stage 2
    wire [DATA_WIDTH-1:0] v0, v1, v2, v3, v4, v5, v6, v7;
    wire [DATA_WIDTH-1:0] v8, v9, v10, v11, v12, v13, v14, v15;
    
    // Stage 2 compare-swap units (8 PEs)
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs2_0 (.A(u0),  .B(u4),  .Min(v0),  .Max(v4));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs2_1 (.A(u1),  .B(u5),  .Min(v1),  .Max(v5));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs2_2 (.A(u2),  .B(u6),  .Min(v2),  .Max(v6));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs2_3 (.A(u3),  .B(u7),  .Min(v3),  .Max(v7));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs2_4 (.A(u8),  .B(u12), .Min(v8),  .Max(v12));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs2_5 (.A(u9),  .B(u13), .Min(v9),  .Max(v13));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs2_6 (.A(u10), .B(u14), .Min(v10), .Max(v14));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs2_7 (.A(u11), .B(u15), .Min(v11), .Max(v15));

    // ==================== STAGE 3: Clock ====================
    // Final stage compare-swap units (8 PEs)
    wire [DATA_WIDTH-1:0] iii0, iii1, iii2, iii3, iii4, iii5, iii6, iii7;
    wire [DATA_WIDTH-1:0] iii8, iii9, iii10, iii11, iii12, iii13, iii14, iii15;
    
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs3_0 (.A(v0),  .B(v2),  .Min(iii0),  .Max(iii2));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs3_1 (.A(v1),  .B(v3),  .Min(iii1),  .Max(iii3));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs3_2 (.A(v4),  .B(v6),  .Min(iii4),  .Max(iii6));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs3_3 (.A(v5),  .B(v7),  .Min(iii5),  .Max(iii7));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs3_4 (.A(v8),  .B(v10), .Min(iii8),  .Max(iii10));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs3_5 (.A(v9),  .B(v11), .Min(iii9),  .Max(iii11));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs3_6 (.A(v12), .B(v14), .Min(iii12), .Max(iii14));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs3_7 (.A(v13), .B(v15), .Min(iii13), .Max(iii15));

    // ==================== STAGE 4: Final ====================
    // Final compare-swap units (8 PEs)
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs4_0 (.A(iii0),  .B(iii1),  .Min(o0),  .Max(o1));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs4_1 (.A(iii2),  .B(iii3),  .Min(o2),  .Max(o3));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs4_2 (.A(iii4),  .B(iii5),  .Min(o4),  .Max(o5));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs4_3 (.A(iii6),  .B(iii7),  .Min(o6),  .Max(o7));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs4_4 (.A(iii8),  .B(iii9),  .Min(o8),  .Max(o9));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs4_5 (.A(iii10), .B(iii11), .Min(o10), .Max(o11));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs4_6 (.A(iii12), .B(iii13), .Min(o12), .Max(o13));
    compare_swap #(.DATA_WIDTH(DATA_WIDTH)) cs4_7 (.A(iii14), .B(iii15), .Min(o14), .Max(o15));

endmodule
