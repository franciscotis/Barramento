
module architecture (
	btn_export,
	clk_clk,
	db_readdata,
	en_writeresponsevalid_n,
	led_export,
	reset_reset_n,
	rs_writeresponsevalid_n,
	rw_writeresponsevalid_n,
	uart_rxd,
	uart_txd);	

	input	[3:0]	btn_export;
	input		clk_clk;
	output	[7:0]	db_readdata;
	output		en_writeresponsevalid_n;
	output	[3:0]	led_export;
	input		reset_reset_n;
	output		rs_writeresponsevalid_n;
	output		rw_writeresponsevalid_n;
	input		uart_rxd;
	output		uart_txd;
endmodule
