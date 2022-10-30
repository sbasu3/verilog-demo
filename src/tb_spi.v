`default_nettype none
`timescale 1us/1ns

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb_spi;
	//SPI I/F
	reg ss;
	reg sclk;
	wire miso;
	reg mosi;

	//Outputs

	wire [7:0] lines_in;
	wire [7:0] lines_out;

	reg clk;
	reg [7:0] uc_data;
	//inputs
	assign lines_in[0] = ss;
	assign lines_in[1] = sclk;
	assign lines_in[2] = miso;
	assign lines_in[3] = mosi;
	assign lines_in[4] = clk;
	assign lines_in[7:5] = 3'b000;
	//outputs


    // instantiate the DUT
	expander DUT(.io_in(lines_in) , .io_out(lines_out));
    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb_spi.vcd");
        $dumpvars;
		sclk = 1'b0;
		uc_data = 8'b10000000; //RESET CMD
		//latch = 1'b0;
		#1;
		ss = 1'b1;
		#160;
		ss = 1'b0;

		uc_data = 8'b00000000; //RESET DATA
		//latch = 1'b0;
		#1;
		ss = 1'b1;
		#160;
		ss = 1'b0;

		uc_data = 8'b10000000; //MODE CMD
		//latch = 1'b0;
		#1;
		ss = 1'b1;
		#160;
		ss = 1'b0;

		uc_data = 8'b0001000; //MODE DATA
		//latch = 1'b0;
		#1;
		ss = 1'b1;
		#160;
		ss = 1'b0;

		uc_data = 8'b10011011; //GPIO WRITE CMD
		//latch = 1'b0;
		#1;
		ss = 1'b1;
		#160;
		ss = 1'b0;

		uc_data = 8'b10101010; //GPIO WRITE DATA
		//latch = 1'b0;
		#1;
		ss = 1'b1;
		#160;
		ss = 1'b0;

    end

	always 
		begin
		clk = 1'b0;
		#1;
		clk = 1'b1;
		#1;
		end

	always #10 sclk = ~sclk;

	always@(posedge sclk) begin
		{mosi,uc_data} <= {uc_data,miso};
	end

endmodule
