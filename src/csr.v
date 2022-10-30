`default_nettype none

module core_logic 
#(	parameter ADDR_WIDTH = 6,
	parameter DATA_WIDTH = 8,
	parameter DEPTH = 32
)
(
	//SPI block i/f
	input [DATA_WIDTH - 1 :0] data_in,
	output reg [DATA_WIDTH - 1 :0] data_out,
	input data_rdy,
	input rst,
	output reg data_latch,
	//Inputs
	input clk,
	//Outputs
	output [DATA_WIDTH - 1 :0] out
);
	//CSR RAM space
	reg [DATA_WIDTH - 1:0] csr[0:DEPTH - 1];
	reg [ADDR_WIDTH - 1:0] addr;
	reg	[1:0] op;
	
	//RESET 
	//reg rst;
	//reg rst_bar;	


	//GPIO
	reg [DATA_WIDTH - 1:0] portA;
 	assign out = portA;
	//PWM Controller
	reg [ 2*DATA_WIDTH - 1:0] counter;

	//Read/Write to CSR
	always@(posedge clk) begin
		if(data_latch)
			{op,addr} <= data_in;
	end


	always@(posedge clk) begin
		if(op[1])
			csr[addr] <= data_in;
		else if ( op[0] )	begin//possible bug introduced
			data_out <= csr[addr];
			data_latch <= 1'b1;
		end
	end 


	always@(posedge clk) begin
		if(rst) begin
			data_out 	<= 	8'b00000000;
			data_latch 	<= 	1'b0;
			addr 		<=	6'b000000;
			op			<=	2'b00;
			portA		<= 	8'b00000000;
			counter		<= 	16'd0;	
		end
		else if(csr[0][3])
			portA[7:0] <= csr[27][7:0];
		else if(csr[0][2])
			portA[0] <= ({csr[3],csr[4]} > counter);
	end



	//PWM Logic
	always@(posedge clk  ) begin
		if(csr[0][2])
			counter <= counter + 1'b1;
	end



endmodule
