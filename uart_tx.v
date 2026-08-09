module uart_tx(
  input clk,
  input reset,
  input tx_start,
  input [7:0]data,
  output reg tx,
  output reg busy
);
  
  parameter BAUD_DIV=4;
  
  parameter IDLE=2'b00, START= 2'b01, DATA=2'b10, STOP=2'b11;
  
  reg [1:0]state, next_state;
  reg [7:0]shift_reg;
  reg [2:0]bit_count, baud_count;
  
  //SEQUENTIAL LOGIC
  always @(posedge clk) begin
    if(reset) begin
      state<=IDLE;
      shift_reg<=8'b0;
      bit_count<=3'b0;
      baud_count<=3'b0;
    end
    
    else begin
      state<=next_state;
      
      case(state)
        IDLE: begin
          if(tx_start) begin
            shift_reg<=data;
            bit_count<=0;
            baud_count<=0;
          end
        end
          
          START: begin
            if(baud_count==BAUD_DIV-1)
              baud_count<=0;
            else
              baud_count<=baud_count+1;
          end
          
          DATA: begin
            if(baud_count==BAUD_DIV-1) begin
              baud_count<=0;
              shift_reg<=shift_reg>>1;
              
              if(bit_count<7)
                bit_count<=bit_count+1;
              else
                bit_count<=0;
            end
            
            else
              baud_count<=baud_count+1;
          end
          
          STOP: begin
            if(baud_count==BAUD_DIV-1)
              baud_count<=0;
            else
              baud_count<=baud_count+1;
          end
      endcase
    end
  end
  
  //NEXT STATE LOGIC
  always @(*) begin
    case(state)
      IDLE: begin
        if(tx_start)
          next_state=START;
        else
          next_state=IDLE;
      end
      
      START: begin
        if(baud_count==BAUD_DIV-1)
          next_state=DATA;
        else
          next_state=START;
      end
      
      DATA: begin
        if(baud_count==BAUD_DIV-1 && bit_count==7)
          next_state=STOP;
        else
          next_state=DATA;
      end
      
      STOP: begin
        if(baud_count==BAUD_DIV-1)
          next_state=IDLE;
        else
          next_state=STOP;
      end
      
      default: next_state=IDLE;
      
    endcase
  end
  
  //OUTPUT LOGIC
  always @(*) begin
    case(state)
      IDLE: begin
        tx=1'b1;
        busy=1'b0;
      end
      
      START: begin
        tx=1'b0;
        busy=1'b1;
      end
      
      DATA: begin
        tx=shift_reg[0];
        busy=1'b1;
      end
      
      STOP: begin
        tx=1'b1;
        busy= 1'b0;
      end
    endcase
  end
  
endmodule
      
      
        
          
          
              
  

