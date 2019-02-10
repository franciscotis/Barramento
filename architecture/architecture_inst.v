	architecture u0 (
		.btn_export              (<connected-to-btn_export>),              //   btn.export
		.clk_clk                 (<connected-to-clk_clk>),                 //   clk.clk
		.db_readdata             (<connected-to-db_readdata>),             //    db.readdata
		.en_writeresponsevalid_n (<connected-to-en_writeresponsevalid_n>), //    en.writeresponsevalid_n
		.led_export              (<connected-to-led_export>),              //   led.export
		.reset_reset_n           (<connected-to-reset_reset_n>),           // reset.reset_n
		.rs_writeresponsevalid_n (<connected-to-rs_writeresponsevalid_n>), //    rs.writeresponsevalid_n
		.rw_writeresponsevalid_n (<connected-to-rw_writeresponsevalid_n>), //    rw.writeresponsevalid_n
		.uart_rxd                (<connected-to-uart_rxd>),                //  uart.rxd
		.uart_txd                (<connected-to-uart_txd>)                 //      .txd
	);

