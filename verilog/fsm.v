/*
 * 
*/

module fsm (
	input clock,
	input reset,
	input done_rx,
	input active_tx,
	input done_tx,
	input result_crc,

	output reg enable_tx,
	output reg [7:0] sensor
);

endmodule	