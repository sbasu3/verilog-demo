`default_nettype none


module core_logic 
(
	//SPI block i/f
	input [7:0] data_in,
	output reg [7:0] data_out,
	input data_rdy,
	input rst,
	output reg data_latch,
	input sys_clk,
	//Outputs
	output [6 :0] chip_out
);

	localparam [2:0]
		reset = 3'b0,
		set_addr = 3'b001,
		set_data_0 = 3'b010,
		set_data_1 = 3'b011,
		get_data_0 = 3'b100,
		get_data_1 = 3'b101,
		data_idle = 3'b110;

	reg [2:0] pwm_addr;
	reg [1:0] pwm_local;
	reg pwm_rd;
	wire pwm0_cs;
	wire [15:0] pwm_data;

	reg [14:0] counter;

	
	reg [7:0] data0,data1;

	reg [1:0] data_cnt;

	reg [2:0] state,state_next;
	assign pwm0_cs = (pwm_addr == 3'b0);



	always@(posedge sys_clk or posedge rst)
	begin
		if(rst) begin
			state = reset;
			counter = 15'b0; 	
		end else
			begin
				state = state_next;
				counter = counter + 1'b1;
			end
	end

	always@(posedge data_rdy)
	begin
		data_cnt = data_cnt + 1'b1;
	end

	always@(*)
	begin
		state_next = state;

		case(state)
			reset:
				if(rst) begin
					state_next = reset;
					pwm_addr = 3'b111;
					data0 = 8'b0;
					data1 = 8'b0;
					data_cnt = 2'b0;
				end else if(data_rdy)
					state_next = set_addr;
			set_addr:
			begin
				pwm_addr = data_in[4:2];
				pwm_local = data_in[1:0];
				pwm_rd = data_in[7];
				data_cnt = 2'b01;
				if(data_rdy & pwm_rd)
					state_next = set_data_0;
				else if(data_rdy & !pwm_rd)
					state_next = get_data_0;				
			end
			set_data_0:
				if((data_cnt == 2'b01) & data_rdy) begin
					data0 = data_in;
					state_next = set_data_1;
				end
			set_data_1:
				if((data_cnt == 2'b10) & data_rdy) begin
					data1 = data_in;
					//write data to pwm
					state_next = data_idle;
				end
			get_data_0:
				if((data_cnt == 2'b01) & data_rdy)
				begin	
					data_out = data0;
					state_next = get_data_1;
				end
			get_data_1:
				if((data_cnt == 2'b10) &  data_rdy)
				begin	
					data_out = data1;
					state_next = data_idle;
				end
			data_idle:
					if(!data_rdy)
						data_cnt = 2'b0;
					else
						state_next = set_addr;
		endcase
	end
	
	pwm p0(.rst(rst),.sys_clk(sys_clk),.data(pwm_data),.counter(counter),.pwm_out(chip_out[0]),.cs(pwm0_cs),.rd(pwm_rd));
endmodule
