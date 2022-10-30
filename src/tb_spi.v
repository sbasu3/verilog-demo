`default_nettype none
`timescale 1us/1ns

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb_spi;
	reg ss;
	reg clk;
	wire miso;
	reg mosi;
	wire [7:0] data;
	wire [7:0] out;
	reg rst;
	wire rdy;
	reg latch;


	reg [7:0] uc_data;
    // instantiate the DUT

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb_spi.vcd");
        $dumpvars (0, spi);
        #1;
		rst = 1'b1;
		#2;
		rst = 1'b0;
		uc_data = 8'b01011011;
		latch = 1'b0;
		#1;
		ss = 1'b1;
		#16;
		ss = 1'b0;
    end

	always 
		begin
		clk = 1'b0;
		#1;
		clk = 1'b1;
		#1;
		end

	always@(posedge clk) begin
		{mosi,uc_data} <= {uc_data,miso};
	end

endmodule
