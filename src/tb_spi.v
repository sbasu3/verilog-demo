`default_nettype none
`timescale 1ns/1ps

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

	reg sys_clk;
	reg rst;
	reg [7:0] uc_data;
	//inputs
	assign lines_in[0] = sys_clk;
	assign lines_in[1] = rst;
	assign lines_in[2] = ss;
	assign lines_in[3] = sclk;
	assign lines_in[4] = mosi;
	assign lines_in[7:5] = 3'b0;
	//outputs

	assign miso = lines_out[0];

    // instantiate the DUT
	sbasu3_top DUT(.io_in(lines_in) , .io_out(lines_out));
    // this part dumps the trace to a vcd file that can be viewed with GTKWave


	task write_spi_byte;
		input [7:0] byte;
		begin
			@(posedge sys_clk)
			ss = 1'b0;
			uc_data = byte;
			#1;
			ss = 1'b1;
			{mosi,uc_data} = {uc_data,miso};
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#10 sclk = ~sclk;
			#1 ss = 1'b0;
		end
	endtask
		


    initial begin
        $dumpfile ("tb_spi.vcd");
        $dumpvars;
		sclk = 1'b0;
		rst = 1'b0;
		mosi = 1'b0;
		ss = 1'b0;
		#20;
		rst = 1'b1;
		#20;
		rst = 1'b0;
		#5 write_spi_byte(8'b10000000); //RESET CMD
		#5 write_spi_byte(8'b00000000); //RESET DATA
		#5 write_spi_byte(8'b10000000); //MODE CMD
		#5 write_spi_byte(8'b00010000); //MODE DATA
		#5 write_spi_byte(8'b10011011); //GPIO WRITE CMD
		#5 write_spi_byte(8'b10101010); //GPIO WRITE DATA
    end

	
	always 
		begin
		sys_clk = 1'b0;
		#1;
		sys_clk = 1'b1;
		#1;
		end


	always@(posedge sclk) begin
		{mosi,uc_data} <= {uc_data,miso};
	end

endmodule
