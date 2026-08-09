module uart_rx_tb;
  
  reg clk, reset, rx;
  wire [7:0]data_out; 
  wire data_valid, framing_error;
  
  uart_rx dut(.clk(clk),
              .reset(reset),
              .rx(rx),
              .data_out(data_out),
              .data_valid(data_valid),
              .framing_error(framing_error)
             );
  
  initial begin 
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    reset=1; rx=1; 
    #10;
    
    @(posedge clk);
    reset=0; 
    #40;
    
    // reveive A5
    @(negedge clk); rx = 0; #40;

    // D0
    @(negedge clk); rx = 1; #40;

    // D1
    @(negedge clk); rx = 0; #40;

    // D2
    @(negedge clk); rx = 1; #40;

    // D3
    @(negedge clk); rx = 0; #40;

    // D4
    @(negedge clk); rx = 0; #40;

    // D5
    @(negedge clk); rx = 1; #40;

    // D6
    @(negedge clk); rx = 0; #40;

    // D7
    @(negedge clk); rx = 1; #40;

    // Stop
    @(negedge clk); rx = 1; #40;
    
    //receive all 0s
    //start
    @(negedge clk); rx = 0; #40;

    // D0
    @(negedge clk); rx = 0; #40;

    // D1
    @(negedge clk); rx = 0; #40;

    // D2
    @(negedge clk); rx = 0; #40;

    // D3
    @(negedge clk); rx = 0; #40;

    // D4
    @(negedge clk); rx = 0; #40;

    // D5
    @(negedge clk); rx = 0; #40;

    // D6
    @(negedge clk); rx = 0; #40;

    // D7
    @(negedge clk); rx = 0; #40;

    // Stop
    @(negedge clk); rx = 1; #40;
    
    //receive all 1s
    //start
    @(negedge clk); rx = 0; #40;

    // D0
    @(negedge clk); rx = 1; #40;

    // D1
    @(negedge clk); rx = 1; #40;

    // D2
    @(negedge clk); rx = 1; #40;

    // D3
    @(negedge clk); rx = 1; #40;

    // D4
    @(negedge clk); rx = 1; #40;

    // D5
    @(negedge clk); rx = 1; #40;

    // D6
    @(negedge clk); rx = 1; #40;

    // D7
    @(negedge clk); rx = 1; #40;

    // Stop
    @(negedge clk); rx = 1; #40;
    
    //----------------- Framing Error Test -----------------

    // Start
    @(negedge clk); rx = 0; #40;

    // D0
    @(negedge clk); rx = 1; #40;

    // D1
    @(negedge clk); rx = 0; #40;

    // D2
    @(negedge clk); rx = 1; #40;

    // D3
    @(negedge clk); rx = 0; #40;

    // D4
    @(negedge clk); rx = 0; #40;

    // D5
    @(negedge clk); rx = 1; #40;

    // D6
    @(negedge clk); rx = 0; #40;

    // D7
    @(negedge clk); rx = 1; #40;

    // Wrong Stop Bit (Should be 1)
    @(negedge clk); rx = 0; #40;
    
    
    #50;
    $finish;
    
  end
  
  initial begin
    $monitor("TIME=%0t | reset=%b rx=%b data_out=%h data_valid=%b framing_error=%b", 
             $time,
             reset,
             rx,
             data_out,
             data_valid,
             framing_error
            );
  end
  
  initial begin
    $dumpfile("uart_rx.vcd");
    $dumpvars(0, uart_rx_tb);
  end

endmodule
    
    
    
    
    
    
    
  
              

