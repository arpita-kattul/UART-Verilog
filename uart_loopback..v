module uart_loopback(
    input clk,
    input reset,
    input tx_start,
    input [7:0] data,

    output tx,
    output busy,

    output [7:0] data_out,
    output data_valid,
    output framing_error
);

    // Internal connection between UART TX and UART RX
    wire loopback_rx;

    // UART Transmitter
    uart_tx dut_tx (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .data(data),
        .tx(loopback_rx),
        .busy(busy)
    );

    // UART Receiver
    uart_rx dut_rx (
        .clk(clk),
        .reset(reset),
        .rx(loopback_rx),
        .data_out(data_out),
        .data_valid(data_valid),
        .framing_error(framing_error)
    );

    // Expose TX output
    assign tx = loopback_rx;

endmodule