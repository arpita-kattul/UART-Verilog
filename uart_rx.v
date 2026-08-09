module uart_rx(
  input clk,
  input reset,
  input rx,
  output reg [7:0]data_out,
  output reg data_valid,
  output reg framing_error
);
  
  reg [1:0]state, next_state;
  parameter IDLE=2'b00, START_CHECK=2'b01, DATA=2'b10, STOP=2'b11;
  reg [7:0]shift_reg;
  reg [2:0]bit_count,baud_count;
  
  parameter BAUD_DIV=4;
  
  always @(posedge clk) begin
    if(reset) begin
      state<=IDLE;
      baud_count<=0;
      bit_count<=0;
      shift_reg<=8'b0;
      data_valid<=0;
      data_out<=8'b0;
      framing_error<=0;
    end
    
    else begin
      state<=next_state;
      case(state)
        IDLE:begin
          bit_count<=0;
          baud_count<=0;
          data_valid<=0;
          framing_error<=0;
        end
        
        START_CHECK:begin
          if(baud_count==(BAUD_DIV/2)-1)
            baud_count<=0;
          else
            baud_count<=baud_count+1;
        end
        
        DATA: begin
          if(baud_count==BAUD_DIV-1) begin
            shift_reg <= {shift_reg[6:0], rx}; // LSB first receive
            bit_count<=bit_count+1;
            baud_count<=0;
          end
          
          else
            baud_count<=baud_count+1;
        end
        
        STOP: begin
          if(baud_count==BAUD_DIV-1) begin
            if(rx==1'b1) begin
              data_out<=shift_reg;
              data_valid<=1'b1;
              framing_error<=0;
            end
            
            else begin
              data_valid<=0;
              framing_error<=1;
            end
            
            baud_count<=0;
          end
          else 
            baud_count<=baud_count+1;
        end
      endcase
    end
  end
  
   
  always @(*) begin
    case(state) 
      IDLE:begin
        if(rx==0)
          next_state=START_CHECK;
        else
          next_state=IDLE;
      end
      
      START_CHECK: begin
        if(baud_count==(BAUD_DIV/2)-1) begin
          if(rx==0)
            next_state=DATA;
          else
            next_state=IDLE;
        end
        
        else
          next_state=START_CHECK;
      end
      
      DATA: begin
        if(baud_count==BAUD_DIV-1&&bit_count==7)
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
  
endmodule