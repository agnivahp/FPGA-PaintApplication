	component nios_system is
		port (
			button_export          : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			clk_clk                : in    std_logic                     := 'X';             -- clk
			color_from_export      : out   std_logic_vector(15 downto 0);                    -- export
			color_to_export        : in    std_logic_vector(15 downto 0) := (others => 'X'); -- export
			command_export         : out   std_logic;                                        -- export
			currx_export           : out   std_logic_vector(9 downto 0);                     -- export
			curry_export           : out   std_logic_vector(9 downto 0);                     -- export
			otg_hpi_address_export : out   std_logic_vector(1 downto 0);                     -- export
			otg_hpi_cs_export      : out   std_logic;                                        -- export
			otg_hpi_data_in_port   : in    std_logic_vector(15 downto 0) := (others => 'X'); -- in_port
			otg_hpi_data_out_port  : out   std_logic_vector(15 downto 0);                    -- out_port
			otg_hpi_r_export       : out   std_logic;                                        -- export
			otg_hpi_w_export       : out   std_logic;                                        -- export
			px_export              : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			py_export              : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
			reset_reset_n          : in    std_logic                     := 'X';             -- reset_n
			sdram_clk_clk          : out   std_logic;                                        -- clk
			sdram_wire_addr        : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba          : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n       : out   std_logic;                                        -- cas_n
			sdram_wire_cke         : out   std_logic;                                        -- cke
			sdram_wire_cs_n        : out   std_logic;                                        -- cs_n
			sdram_wire_dq          : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm         : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_wire_ras_n       : out   std_logic;                                        -- ras_n
			sdram_wire_we_n        : out   std_logic                                         -- we_n
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			button_export          => CONNECTED_TO_button_export,          --          button.export
			clk_clk                => CONNECTED_TO_clk_clk,                --             clk.clk
			color_from_export      => CONNECTED_TO_color_from_export,      --      color_from.export
			color_to_export        => CONNECTED_TO_color_to_export,        --        color_to.export
			command_export         => CONNECTED_TO_command_export,         --         command.export
			currx_export           => CONNECTED_TO_currx_export,           --           currx.export
			curry_export           => CONNECTED_TO_curry_export,           --           curry.export
			otg_hpi_address_export => CONNECTED_TO_otg_hpi_address_export, -- otg_hpi_address.export
			otg_hpi_cs_export      => CONNECTED_TO_otg_hpi_cs_export,      --      otg_hpi_cs.export
			otg_hpi_data_in_port   => CONNECTED_TO_otg_hpi_data_in_port,   --    otg_hpi_data.in_port
			otg_hpi_data_out_port  => CONNECTED_TO_otg_hpi_data_out_port,  --                .out_port
			otg_hpi_r_export       => CONNECTED_TO_otg_hpi_r_export,       --       otg_hpi_r.export
			otg_hpi_w_export       => CONNECTED_TO_otg_hpi_w_export,       --       otg_hpi_w.export
			px_export              => CONNECTED_TO_px_export,              --              px.export
			py_export              => CONNECTED_TO_py_export,              --              py.export
			reset_reset_n          => CONNECTED_TO_reset_reset_n,          --           reset.reset_n
			sdram_clk_clk          => CONNECTED_TO_sdram_clk_clk,          --       sdram_clk.clk
			sdram_wire_addr        => CONNECTED_TO_sdram_wire_addr,        --      sdram_wire.addr
			sdram_wire_ba          => CONNECTED_TO_sdram_wire_ba,          --                .ba
			sdram_wire_cas_n       => CONNECTED_TO_sdram_wire_cas_n,       --                .cas_n
			sdram_wire_cke         => CONNECTED_TO_sdram_wire_cke,         --                .cke
			sdram_wire_cs_n        => CONNECTED_TO_sdram_wire_cs_n,        --                .cs_n
			sdram_wire_dq          => CONNECTED_TO_sdram_wire_dq,          --                .dq
			sdram_wire_dqm         => CONNECTED_TO_sdram_wire_dqm,         --                .dqm
			sdram_wire_ras_n       => CONNECTED_TO_sdram_wire_ras_n,       --                .ras_n
			sdram_wire_we_n        => CONNECTED_TO_sdram_wire_we_n         --                .we_n
		);

