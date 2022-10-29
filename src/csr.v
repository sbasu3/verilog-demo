module core_logic 
#(	parameter ADDR_WIDTH = 6,
	parameter DATA_WIDTH = 8;
	parameter DEPTH = 32
)
(
	//SPI block i/f
	input [DATA_WIDTH - 1 :0] data_in,
	output [DATA_WIDTH - 1 :0] data_out,
	input data_rdy,
	output rst,
	output data_latch,
	//Inputs
	input clk,
	//Outputs
	output [DATA_WIDTH - 1 :0] out
);
	//CSR RAM space
	reg [DATA_WIDTH - 1:0] csr[DEPTH];
	reg [ADDR_WIDTH - 1:0] addr;
	reg	[1:0] op;
	
	//RESET 
	reg rst;
	reg rst_bar;	


	//GPIO
	reg [DATA_WIDTH - 1:0] portA;

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
		else if ( op[0] or !op[1] )	begin//possible bug introduced
			data_out <= csr[addr];
			data_latch <= 1'b1;
		end
	end 

	//RESET Logic
	always@(posedge clk and csr[0][0]) begin
		rst <= 1'b1;
		rst_bar <= 1'b0;
	end

	always@(posedge clk and rst) begin
		rst <= 1'b0;
		rst_bar <= 1'b1;
	end

	always@(


	//GPIO Logic
	always@(posedge clk and csr[0][3])
		 portA <= csr[27];

	//PWM Logic
	always@(posedge clk and csr[0][2] ) begin
		counter <= counter + 1'b1;
	end


	always@(posedge clk and csr[0][2] ) begin
		//write others after syntax is verified
		portA[0] <= ({csr[3],csr[4]} > counter);
	end
