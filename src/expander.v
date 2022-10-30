`default_nettype none

module expander(
	input [7:0] io_in,
	output [7:0] io_out
);

	wire ss = io_in[0];
	wire sclk = io_in[1];
	wire miso = io_in[2];
	wire mosi = io_in[3];
	wire clk_in = io_in[4];
	wire rst = io_in[5];

	wire latch;
	wire [7:0] data;
	wire [7:0] out;
	wire rdy;

spi_slave spi(	.ss(ss) , .sclk(sclk) , .mosi(mosi) , .miso(miso) ,
				.data_in(data) , .rst(rst) ,.data_rdy(rdy) , .data_latch( latch) , .data_out (out) );

core_logic core(.data_in(out) , .data_out(data) ,  .data_rdy(rdy) , .rst(rst) , .data_latch(latch),
				.clk(clk_in) , .out(io_out) ); 


endmodule
