	component architecture is
		port (
			clk_clk       : in  std_logic := 'X'; -- clk
			reset_reset_n : in  std_logic := 'X'; -- reset_n
			uart_write    : out std_logic;        -- write
			uart_read     : in  std_logic := 'X'  -- read
		);
	end component architecture;

	u0 : component architecture
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			reset_reset_n => CONNECTED_TO_reset_reset_n, -- reset.reset_n
			uart_write    => CONNECTED_TO_uart_write,    --  uart.write
			uart_read     => CONNECTED_TO_uart_read      --      .read
		);

