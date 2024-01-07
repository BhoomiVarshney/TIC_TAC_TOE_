module top(
input  clock, //100MHz onboard clock
input  reset,
input [1:0]current_state,input [1:0]winner, input draw,
//oled interface
output oled_spi_clk,
output oled_spi_data,
output oled_vdd,
output oled_vbat,
output oled_reset_n,
output oled_dc_n
);
   
   
 localparam myString = "IDLE1           ";  
 localparam StringLen = 18;  //59+8
 localparam myString2 = "PLAYER1         ";  
 localparam StringLen2 = 18;  //59+8
 localparam myString3 = "PLAYER2         ";  
 localparam StringLen3 = 18;  //59+8
 localparam myString4 = "GAME_OVER       ";  
 localparam StringLen4 = 18;  //59+8
 localparam myString5 = "WINNER PLAYER1  ";  
 localparam StringLen5 = 18;  //59+8
 localparam myString6 = "WINNER PLAYER2  ";  
 localparam StringLen6 = 18;  //59+8
 localparam myString7 = "DRAW            ";  
 localparam StringLen7 = 18;  //59+8
 reg [1:0] state;
 reg [7:0] sendData;
 reg sendDataValid;
 integer byteCounter;
 wire sendDone;
 
 localparam IDLE = 'd0,
            SEND = 'd1,
            DONE = 'd2;
 
 always @(posedge clock)
 begin
    if(reset)
    begin
        if(current_state==2'd0)
        begin
        state <= IDLE;
        byteCounter <= StringLen;
        sendDataValid <= 1'b0;
        end
        if(current_state==2'd1)
        begin
        state <= IDLE;
        byteCounter <= StringLen2;
        sendDataValid <= 1'b0;
        end
        else if(current_state==2'd2)
        begin
        state <= IDLE;
        byteCounter <= StringLen3;
        sendDataValid <= 1'b0;
        end
        else if(current_state==2'd3 & winner == 2'd0 & draw !=1'd1)
        begin
        state <= IDLE;
        byteCounter <= StringLen4;
        sendDataValid <= 1'b0;
        end
        else if(winner==2'd1 & current_state==2'd3)
        begin
        state <= IDLE;
        byteCounter <= StringLen5;
        sendDataValid <= 1'b0;
        end
        else if(winner==2'd2 & current_state==2'd3)
        begin
        state <= IDLE;
        byteCounter <= StringLen6;
        sendDataValid <= 1'b0;
        end
        else if(draw==1'd1 & current_state==2'd3 & winner==2'd0)
        begin
        state <= IDLE;
        byteCounter <= StringLen7;
        sendDataValid <= 1'b0;
        end
       
       
    end
    else
    begin
   
        case(state)
            IDLE:begin
                if(!sendDone)
                begin
                        if(current_state==2'd0)
                        begin
                        sendData <= myString[(byteCounter*8-1)-:8];
                        sendDataValid <= 1'b1;
                        state <= SEND;
                        end
                        else if(current_state==2'd1)
                        begin
                        sendData <= myString2[(byteCounter*8-1)-:8];
                        sendDataValid <= 1'b1;
                        state <= SEND;
                        end
                        else if(current_state==2'd2)
                        begin
                        sendData <= myString3[(byteCounter*8-1)-:8];
                        sendDataValid <= 1'b1;
                        state <= SEND;
                        end
                        else if(current_state==2'd3 & winner==2'd0 & draw ==1'd0)
                        begin
                        sendData <= myString4[(byteCounter*8-1)-:8];
                        sendDataValid <= 1'b1;
                        state <= SEND;
                        end
                        else if(winner == 2'd1 & current_state==2'd3 & draw==1'd0)
                        begin
                        sendData <= myString5[(byteCounter*8-1)-:8];
                        sendDataValid <= 1'b1;
                        state <= SEND;
                        end
                        else if(winner == 2'd2 & current_state==2'd3 & draw==1'd0)
                        begin
                        sendData <= myString6[(byteCounter*8-1)-:8];
                        sendDataValid <= 1'b1;
                        state <= SEND;
                        end
                        else if(draw==1 & current_state==2'd3 & winner==2'd0)
                        begin
                        sendData <= myString7[(byteCounter*8-1)-:8];
                        sendDataValid <= 1'b1;
                        state <= SEND;
                        end
                end
            end
            SEND:begin
                if(sendDone)
                begin
                    sendDataValid <= 1'b0;
                    byteCounter <= byteCounter-1;
                    if(byteCounter != 1)
                        state <= IDLE;
                    else
                        state <= DONE;
                end
            end
            DONE:begin
                state <= DONE;
            end
        endcase
    end
 end
 
 
   
   
oledControl2 OC(
    .clock(clock), //100MHz onboard clock
    .reset(reset),
    //oled interface
    .oled_spi_clk(oled_spi_clk),
    .oled_spi_data(oled_spi_data),
    .oled_vdd(oled_vdd),
    .oled_vbat(oled_vbat),
    .oled_reset_n(oled_reset_n),
    .oled_dc_n(oled_dc_n),
    //
    .sendData(sendData),
    .sendDataValid(sendDataValid),
    .sendDone(sendDone)
        );    
   
endmodule