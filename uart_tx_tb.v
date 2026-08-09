module uart_tx_tb;
  
  reg clk, reset, tx_start;
  reg [7:0] data;
  wire tx, busy;
  
  UART_TX dut(.clk(clk),
              .reset(reset),
              .tx_start(tx_start),
              .data(data),
              .tx(tx),
              .busy(busy));
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    reset=1; tx_start=0; data=8'b0;
    #10;
    
    @(posedge clk);
    reset=0;
    
    //-------CASE-1 RESET RELEASE---------
    if(tx==1&&busy==0)
      $display("CASE 1:PASS");
    else
      $display("CASE 1:FAIL");
    
    //------CASE-2 NORMAL TRNASMISSION------
    $display("\nTC2 : A5 Transmission");
    @(negedge clk); tx_start=1; data=8'hA5;  //prepare input
    @(negedge clk); tx_start=0;  //keep tx_start high for 1 clock
    wait(busy==0);
    
    //-----CASE-3 ALL ZEROS-------
    $display("\n TC3: all zeros");
    @(negedge clk); tx_start=1; data=8'h00;
    @(negedge clk); tx_start=0;
    wait(busy==0);
    
    //-----CASE-4 ALL ones-------
    $display("\n TC4: all ones");
    @(negedge clk); tx_start=1; data=8'hFF;
    @(negedge clk); tx_start=0;
    wait(busy==0);
    
    //----CASE-5 change data during transmission----
    $display("\n change data during transmission");
    @(negedge clk); tx_start=1; data=8'hB4;
    @(negedge clk); tx_start=0;
    
    repeat(8) @(posedge clk); data=8'h45;
    wait(busy==0);
    
    #20;
    $finish;
  end
  
  initial begin
    $monitor("time=%0t reset=%b start=%b data=%h busy=%b tx=%b",
             $time, reset,tx_start,data,busy,tx);
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,uart_tx_tb);
  end
endmodule
    
             
    
    
