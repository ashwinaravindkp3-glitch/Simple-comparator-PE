`timescale 1ns/1ps

module tb_Sort4;
  reg clk;
  reg rst_n;
  reg start;
  reg [7:0] a0, a1, a2, a3;
  wire [7:0] R0, R1, R2, R3;
  wire done;

  Sort4_FSM dut (
    .clk(clk), .rst_n(rst_n), .start(start),
    .i0(a0), .i1(a1), .i2(a2), .i3(a3),
    .R0(R0), .R1(R1), .R2(R2), .R3(R3),
    .done(done)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 ns period (100 MHz)
  end

  initial begin
    $dumpfile("sort4_fsm.vcd");
    $dumpvars(0, tb_Sort4);
  end

  initial begin
    // reset
    rst_n = 0;
    start = 0;
    a0 = 0; a1 = 0; a2 = 0; a3 = 0;
    #20;
    rst_n = 1;
    #20;

    // test 1
    a0 = 8'd45; a1 = 8'd12; a2 = 8'd78; a3 = 8'd5;
    #6;
    start = 1;
    @(posedge clk);
    start = 0;
    wait(done == 1);
    @(posedge clk);
    $display("Result1: R0=%0d R1=%0d R2=%0d R3=%0d (Expected: 5 12 45 78)", R0, R1, R2, R3);

    // test 2
    #20;
    a0 = 8'd30; a1 = 8'd90; a2 = 8'd15; a3 = 8'd60;
    #6;
    start = 1;
    @(posedge clk);
    start = 0;
    wait(done == 1);
    @(posedge clk);
    $display("Result2: R0=%0d R1=%0d R2=%0d R3=%0d (Expected: 15 30 60 90)", R0, R1, R2, R3);

    // test 3: already sorted
    #20;
    a0 = 8'd10; a1 = 8'd20; a2 = 8'd30; a3 = 8'd40;
    #6;
    start = 1;
    @(posedge clk);
    start = 0;
    wait(done == 1);
    @(posedge clk);
    $display("Result3: R0=%0d R1=%0d R2=%0d R3=%0d (Expected: 10 20 30 40)", R0, R1, R2, R3);

    // test 4: reverse sorted
    #20;
    a0 = 8'd100; a1 = 8'd75; a2 = 8'd50; a3 = 8'd25;
    #6;
    start = 1;
    @(posedge clk);
    start = 0;
    wait(done == 1);
    @(posedge clk);
    $display("Result4: R0=%0d R1=%0d R2=%0d R3=%0d (Expected: 25 50 75 100)", R0, R1, R2, R3);

    #20 $finish;
  end

  // per-cycle trace
  always @(posedge clk) begin
    $display("T=%0t | start=%b | inputs=(%0d,%0d,%0d,%0d) | R=(%0d,%0d,%0d,%0d) done=%b",
             $time, start, a0, a1, a2, a3, R0, R1, R2, R3, done);
  end

endmodule
