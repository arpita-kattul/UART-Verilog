module uart_loopback_tb;
  
  reg clk, reset, tx_start;
  reg [7:0] data;
  wire tx, busy, data_valid, framing_error;
  wire [7:0] data_out;
  
  uart_loopback dut (
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .data(data),
    .tx(tx),
    .busy(busy),
    .data_out(data_out),
    .data_valid(data_valid),
    .framing_error(framing_error)
);
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    reset=1; tx_start=0; data=8'b0;
    
    @(posedge clk); reset=0; 
    
    //case 1
    @(negedge clk); tx_start=1; data=8'hA5;
    @(negedge clk); tx_start=0;
    
    // Wait until TX actually starts
    wait(busy == 1);

    // Wait until TX finishes
    wait(busy == 0);
    
    #20;
    
    //case 2
    @(negedge clk); tx_start=1; data=8'h0;
    @(negedge clk); tx_start=0;
    wait(busy==1);
    wait(busy==0);
    
    #20;
    
    //case 3
    @(negedge clk); tx_start=1; data=8'hFF;
    @(negedge clk); tx_start=0;
    wait(busy==1);
    wait(busy==0);
    
    #50;
    $finish;
  end
  

  initial begin
    $monitor("T=%0t | reset=%b | tx_start=%b | busy=%b | data=%h | tx=%b | data_out=%h | data_valid=%b | framing_error=%b",
             $time,
             reset,
             tx_start,
             busy,
             data,
             tx,
             data_out,
             data_valid,
             framing_error);
  end
  
  initial begin
    $dumpfile("uart_loopback.vcd");
    $dumpvars(0, uart_loopback_tb);
  end
  
endmodule