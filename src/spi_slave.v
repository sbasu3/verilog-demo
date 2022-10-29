module spi_slave(
	input ss,
	input clk,
	input mosi,
	output reg miso,
	input [7:0] data_in,
	output [7:0] data_out,
	output data_rdy,
	input rst,
	input data_latch
);

	reg [3:0] bit_cnt;
	reg [7:0] spi_register;

	always@(rst) 
	begin
		bit_cnt <= 4'b0;
		spi_register	<= 8'b0;
	end

	always@(posedge clk) 
	begin
		if(ss) begin
			{miso,spi_register}	<= {spi_register,mosi};
			bit_cnt 	<=	bit_cnt + 1'b1;
		end else begin
			bit_cnt <= 4'b0;
			spi_register <= 8'b0;
		end
	end
	
	assign data_rdy = bit_cnt[3];
	
	always@(posedge data_latch) 
	begin
		spi_register	<= data_in;
	end

	assign data_out[7:0] = spi_register[7:0];


endmodule 
