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


	localparam [1:0] 
		reset = 2'b00,
		idle = 2'b01,
		active = 2'b10,
		load = 2'b11;


	reg [1:0] state, state_next;

	reg [3:0] bit_cnt;
	reg [7:0] spi_register;
	wire clk_en;

	//assign clk_en = ss & sclk &  !rst;

	always @(posedge sys_clk or posedge rst)
	begin
    if(rst) // go to state reset if reset
        state = reset;
    else // otherwise update the states
        state = state_next;
	end
	
	always@(posedge state[0] or negedge state[0] or posedge state[1] or negedge state[1] or negedge ss or posedge ss or posedge sclk or posedge data_latch)
	begin
		state_next = state;

		case(state)
			reset:
				if(rst) begin
					state_next <= reset;
					spi_register <= 8'b0;
					bit_cnt <= 4'b0;
					data_rdy <= 1'b0;
					miso <= 1'b0;
					
				end else if(ss) begin
					state_next = active;
				end else 
					state_next = idle;
			idle:
				if(rst)
					state_next = reset;
				else if(ss)
					state_next = active;
				else if(data_latch)
					state_next = load;
				else
					state_next = idle;

			active:
				if(rst)
					state_next = reset;
				else if(!ss) begin 
					state_next = idle;
					bit_cnt = 4'b0;
				end else if(sclk) begin
					state_next <= active;
					{miso,spi_register} <= {spi_register,mosi};
					bit_cnt <= bit_cnt + 1'b1;
				end
			load:
				if(rst)
					state_next = reset;
				else if(!ss) begin
					state_next <= idle;
					spi_register <= spi_data_in;
					data_rdy <= 1'b0;
				end else
					state_next = load;
		endcase
	end

	always@(*)
	begin
		if(bit_cnt == 4'b1000)
			data_rdy = 1'b1;
		else
			data_rdy = 1'b0;
	end
	
	assign spi_data_out[7:0] = spi_register[7:0];


endmodule 
