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
	input miso,
    output [7:0] out
   );

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    wire [7:0] inputs = {2'b0, rst,clk,,mosi,miso,sclk,ss};
    wire [7:0] outputs;
    assign out = outputs[7:0];

    // instantiate the DUT
        expander DUT(
		.io_in  (inputs),
        .io_out (outputs)
        );

endmodule
