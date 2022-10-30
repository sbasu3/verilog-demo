`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb (
    // testbench is controlled by test.py
    input clk,
    input rst,
	input ss,
	input sclk,
	input mosi,
	output miso,
    output [6:0] out
   );

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    wire [7:0] inputs = {3'b0,mosi,sclk,ss,rst,clk};
    wire [7:0] outputs;

    assign out = {outputs[6:0],miso};

    // instantiate the DUT
        sbasu3_top DUT(
		.io_in  (inputs),
        .io_out (outputs)
        );

endmodule
