	nios_system u0 (
		.button_export          (<connected-to-button_export>),          //          button.export
		.clk_clk                (<connected-to-clk_clk>),                //             clk.clk
		.color_from_export      (<connected-to-color_from_export>),      //      color_from.export
		.color_to_export        (<connected-to-color_to_export>),        //        color_to.export
		.command_export         (<connected-to-command_export>),         //         command.export
		.currx_export           (<connected-to-currx_export>),           //           currx.export
		.curry_export           (<connected-to-curry_export>),           //           curry.export
		.otg_hpi_address_export (<connected-to-otg_hpi_address_export>), // otg_hpi_address.export
		.otg_hpi_cs_export      (<connected-to-otg_hpi_cs_export>),      //      otg_hpi_cs.export
		.otg_hpi_data_in_port   (<connected-to-otg_hpi_data_in_port>),   //    otg_hpi_data.in_port
		.otg_hpi_data_out_port  (<connected-to-otg_hpi_data_out_port>),  //                .out_port
		.otg_hpi_r_export       (<connected-to-otg_hpi_r_export>),       //       otg_hpi_r.export
		.otg_hpi_w_export       (<connected-to-otg_hpi_w_export>),       //       otg_hpi_w.export
		.px_export              (<connected-to-px_export>),              //              px.export
		.py_export              (<connected-to-py_export>),              //              py.export
		.reset_reset_n          (<connected-to-reset_reset_n>),          //           reset.reset_n
		.sdram_clk_clk          (<connected-to-sdram_clk_clk>),          //       sdram_clk.clk
		.sdram_wire_addr        (<connected-to-sdram_wire_addr>),        //      sdram_wire.addr
		.sdram_wire_ba          (<connected-to-sdram_wire_ba>),          //                .ba
		.sdram_wire_cas_n       (<connected-to-sdram_wire_cas_n>),       //                .cas_n
		.sdram_wire_cke         (<connected-to-sdram_wire_cke>),         //                .cke
		.sdram_wire_cs_n        (<connected-to-sdram_wire_cs_n>),        //                .cs_n
		.sdram_wire_dq          (<connected-to-sdram_wire_dq>),          //                .dq
		.sdram_wire_dqm         (<connected-to-sdram_wire_dqm>),         //                .dqm
		.sdram_wire_ras_n       (<connected-to-sdram_wire_ras_n>),       //                .ras_n
		.sdram_wire_we_n        (<connected-to-sdram_wire_we_n>)         //                .we_n
	);

