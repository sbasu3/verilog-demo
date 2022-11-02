module pwm(
	input rst,
	input sys_clk,
	input cs,
	input rd,
	inout [15:0] data,
	input [14:0] counter,
	output pwm_out
);


	localparam [2:0]
		reset = 3'b0,
		chip_idle = 3'b001,
		chip_write = 3'b010,
		chip_read = 3'b011,
		pwm_idle = 3'b100,
		pwm_active = 3'b101;

	reg [2:0] state , state_next;

	reg [15:0] data_reg;
	reg [15:0] csr;
	wire en;
	wire [13:0] set_value;

	assign en = csr[0];
	assign set_value = csr[13:0];
	assign data = data_reg;
	
	assign pwm_out = en & ( set_value > counter);
	
	always @(posedge sys_clk or posedge rst)
	begin
    if(rst) // go to state reset if reset
        state = reset;
    else // otherwise update the states
        state = state_next;
	end
	
	always@(*)
	begin
		state_next = state;

		case(state)
			reset:
				if(rst) begin
					state_next = reset;
					csr = 16'b0;
					data_reg = 16'b0;
					//pwm = 0;
				end else if(cs) begin
					state_next = chip_idle;
				end
			chip_idle:
				if(rst)
					state_next = reset;
				else if(rd)
					state_next = chip_read;
				else
					state_next = chip_write;
			chip_read:
				if(rst)
					state_next = reset;
				else if(!rd)
					state_next = chip_write;
				else if(!cs)
					state_next = pwm_idle;
				else
					data_reg = csr;
			chip_write:
				if(rst)
					state_next = reset;
				else if(rd)
					state_next = chip_read;
				else if(!cs)
					state_next = pwm_idle;
				else
					csr = data_reg;
			pwm_idle:
				if(rst)
					state_next = reset;
				else if (cs)
					state_next = chip_idle;
				else if(en)
					state_next = pwm_active;
			pwm_active:
				if(rst)
					state_next = reset;
				else if(!en)
					state_next = pwm_idle;
		endcase
	end
endmodule
