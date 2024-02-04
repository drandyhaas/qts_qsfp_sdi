/*
This module is to interconnect XCVR user FIFO in Qsys platform
*/

module  xcvr_user_rx_fifo_converter(
        input    wire [63:0]  data_pattern_checker_pattern_in,               // interconnections
        input    wire         data_pattern_checker_pattern_in_clk,           // interconnections
        input    wire         data_pattern_checker_pattern_in_fifo_read_clk, // interconnections
        output   wire [127:0] data_pattern_checker_pattern_in_fifo_read,     // interconnections
        output   wire         data_pattern_checker_rx_fifo_rdempty,          // interconnections
        output   wire         data_pattern_checker_rx_fifo_wrfull,           // interconnections

        output   wire [63:0]  data,    //  fifo_input.datain
        output   wire         wrreq,   //            .wrreq
        output   wire         rdreq,   //            .rdreq
        output   wire         wrclk,   //            .wrclk
        output   wire         rdclk,   //            .rdclk
        input    wire [127:0] q,       // fifo_output.dataout
        input    wire         rdempty, //            .rdempty
        input    wire         wrfull   //            .wrfull
);

    assign       data  = data_pattern_checker_pattern_in;
    assign       wrreq = 1'b1;
    assign       rdreq = 1'b1;
    assign       wrclk = data_pattern_checker_pattern_in_clk;
    assign       rdclk = data_pattern_checker_pattern_in_fifo_read_clk;

    assign       data_pattern_checker_pattern_in_fifo_read = q;
    assign       data_pattern_checker_rx_fifo_rdempty      = rdempty;
    assign       data_pattern_checker_rx_fifo_wrfull       = wrfull;

endmodule


