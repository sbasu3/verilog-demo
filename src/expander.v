`default_nettype none
//`include "csr.v"
//`include "spi_slave.v"


module sbasu3_top(
	input [7:0] io_in,
	output [7:0] io_out
);

	wire clk_in = io_in[0];
	wire rst = io_in[1];
	wire ss = io_in[2];
	wire sclk = io_in[3];
	wire mosi = io_in[4];

	wire miso;
	
	wire latch;
	wire [7:0] spi_data_in;
	wire [7:0] spi_data_out;
	wire rdy;

	assign io_out[0] = miso;

	spi_slave spi(	.ss(ss) , .sclk(sclk) , .mosi(mosi) , .miso(miso) , .sys_clk(clk_in),
				.spi_data_in(spi_data_in) , .rst(rst) ,.data_rdy(rdy) , .data_latch( latch) , .spi_data_out (spi_data_out) );

	core_logic core(.data_in(spi_data_out) , .data_out(spi_data_in) ,  .data_rdy(rdy) , .rst(rst) , .data_latch(latch),
				.clk(clk_in) , .out(io_out) ); 


endmodule
