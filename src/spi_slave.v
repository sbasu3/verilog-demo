`default_nettype none

module spi_slave(
	input ss,
	input sclk,
	input mosi,
	output reg miso,
	input [7:0] data_in,
	output [7:0] data_out,
	output  reg data_rdy,
	input rst,
	input data_latch
);

	reg [3:0] bit_cnt;
	reg [7:0] spi_register;

	always@(posedge rst) 
	begin
		bit_cnt <= 4'b0;
		spi_register	<= 8'b0;
		miso	<= 1'b0;
		data_rdy <= 1'b0;
	end

	always@(negedge ss)
	begin
		bit_cnt	<= 4'b0;
	end

	always@(posedge sclk) 
	begin
		if(ss) begin
			{miso,spi_register}	<= {spi_register,mosi};
			bit_cnt 	<=	bit_cnt + 1'b1;
		end
	end
	
	always@(posedge bit_cnt[3])
		data_rdy <= 1'b1;
	
	always@(posedge data_latch) 
	begin
		spi_register	<= data_in;
		data_rdy		<= 1'b0;
	end

	assign data_out[7:0] = spi_register[7:0];


endmodule 
