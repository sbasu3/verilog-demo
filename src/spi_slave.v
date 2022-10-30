`default_nettype none

module spi_slave(
	input ss,
	input sclk,
	input mosi,
	output reg miso,
	input [7:0] spi_data_in,
	output [7:0] spi_data_out,
	output  reg data_rdy,
	input rst,
	input data_latch,
	input sys_clk
);

	reg [3:0] bit_cnt;
	reg [7:0] spi_register;
	wire clk_en;

	assign clk_en = ss & sclk &  !rst;

	always@(posedge sys_clk) 
	begin
		if(rst) begin
			bit_cnt <= 4'b0;
			spi_register	<= 8'b0;
			miso	<= 1'b0;
			data_rdy <= 1'b0;
		end
	end

	always@(negedge ss)
	begin
		bit_cnt	<= 4'b0;
	end

	always@(posedge clk_en) 
	begin
			{miso,spi_register}	= {spi_register,mosi};
			bit_cnt 	=	bit_cnt + 1'b1;
	end
	
	always@(*)
	begin
		if(bit_cnt == 4'b1000)
			data_rdy = 1'b1;
		else
			data_rdy = 1'b0;
	end
	
	always@(posedge data_latch) 
	begin
		spi_register	<= spi_data_in;
		data_rdy		<= 1'b0;
	end

	assign spi_data_out[7:0] = spi_register[7:0];


endmodule 
