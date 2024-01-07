`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.11.2023 15:16:04
// Design Name: 
// Module Name: Tic_Tac_Toe
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TIC_TAC_TOE(clk,rst,start,in,winner,draw,current_state,div_clk,out_rst);

input clk,rst,start;
input [3:0]in; 
output reg [1:0]winner;
output reg draw;
output reg [1:0] current_state;
output reg div_clk=0;
output reg out_rst;
reg illegal_move;//TO DETECT ILLEGAL MOVE
reg rst_buf=1;//FOR RESET DEBOUNCER
reg win,no_space;
reg [1:0] pos1, pos2, pos3,
     pos4, pos5, pos6, pos7, pos8, pos9;//POSITIONS ON THE BOARD
reg ocu1=0,ocu2=0,ocu3=0,ocu4=0,ocu5=0,ocu6=0,ocu7=0,ocu8=0,ocu9=0;//TO CHECK IF POSITIONS OCCUPIED OR NOT
reg [1:0] next_state;
reg pr_in;
parameter IDLE=2'd0,PLAYER_1=2'd1,PLAYER_2=2'd2,GAME_OVER=2'd3;//STATES OF GAME
integer count=0,f=0;
reg [26:0] delay_count=0;//FOR CLOCK DIVIDER

always @(posedge clk)begin            //Code of clk divider for system clk starts here...  
 
  if(delay_count==27'd67108864)
  begin
  delay_count<=27'd0;
  div_clk <= ~div_clk;
  end
  else
  begin
  delay_count<=delay_count+1;
  end
  end                            // Code for system clk ends here


always@(posedge div_clk)begin
out_rst=rst;
if(rst)begin                          //ON RESET USING PUSHBUTTON WE NEED TO USE DEBOUNCER LOGIC
  rst_buf = ~rst_buf;
   {pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9}=2'd0;
   {ocu1,ocu2,ocu3,ocu4,ocu5,ocu6,ocu7,ocu8,ocu9}=1'd0;
  current_state=2'd0;
  next_state=2'd0;
  current_state=next_state;
  illegal_move = 0;
  win = 0;
  no_space=0;//INITIALLY THERE IS SPACE ON THE BOARD
  winner=2'd3;//USED JUST TO VERIFY IF RESET IS WORKING PROPERLY ON FPGA BOARD WINNER=3 IS USED AND DEBOUNCE STATE IT AGAIN GOES TO WINNER=0
  draw=0;
 end
else if(!rst_buf)begin   //USED FOR DEBOUNCER LOGIC FOR PUSHBUTTON
   rst_buf = ~rst_buf;
   current_state=2'd0;
   next_state=2'd0;
   current_state=next_state;
   illegal_move = 0;
   win =0;
   no_space=0;
   winner=2'd0;
   end
 else  begin                   //GAME STARTS HERE
 $display("$time=%d,in=%d",$time,in);
 case(in)                            //IN THIS CASE WE CHECK IF POSITION IS OCCUPIED AND MAKE FLAG(f)=1 BASED ON INPUT PROVIDED
       4'd1: begin 
             if(ocu1) f=1;
             else f=0;
             end
       4'd2: begin 
             if(ocu2) f=1;
             else f=0;
             end
       4'd3: begin 
             if(ocu3) f=1;
             else f=0;
             end
      4'd4: begin 
             if(ocu4) f=1;
             else f=0;
             end
      4'd5: begin 
             if(ocu5) f=1;
             else f=0;
             end  
      4'd6: begin 
             if(ocu6) f=1;
             else f=0;
             end 
      4'd7: begin 
             if(ocu7) f=1;
             else f=0;
             end
      4'd8: begin 
             if(ocu8) f=1;
             else f=0;
             end
      4'd9: begin 
             if(ocu9) f=1;
             else f=0;
             end 
  endcase
 //end
 
 //always@(posedge div_clk)begin
 current_state=next_state;
 $display("$time=%d,curentstate=%d,next_state=%d",$time,current_state,next_state);
 case(current_state)          //IN THIS CASE GAME RUNS AND CHANGES STATE OF THE GAME ACCORDING TO INPUT AND CHECK ALL LOGICS LIKE ILLEGAL_MOVE,NO_SPACE,DRAW AND WHICH PLAYER IS GIVING INPUTS
 
 IDLE: begin                        //INITIALLY GAME WILL BE IN IDLE STATE AND WHEN START=1 IT GOES TO PLAYER1 IMMEDIATELY
       if(start)begin
            next_state = PLAYER_1;
            $display("$time=%d,next_state=%d,current_state=%d",$time,count,current_state);
       end
       else next_state=IDLE;
       end
 PLAYER_1: begin            //IN THIS STATE IT CHECKS IF PLAYER1 INPUT IS LEGAL AND IF IT IS NOT IT STAY IN PLAYER1 ONLY AND IF IT IS IT GOES TO PLAYER2 UNTILL GAME_OVER DUE TO WIN OR DRAW
           $display("$time=%d,no_space=%d",$time,no_space);
           if(!no_space)begin
                  if(in == pr_in)begin 
                      next_state = PLAYER_1;
                      illegal_move = 1; 
                   end
                   else if(in != pr_in & f) begin
                       next_state = PLAYER_1;
                       illegal_move = 1; 
                   end   
                   else begin
                       next_state = PLAYER_2;
                       pr_in = in;
                       illegal_move = 0;
                       end
                  $display("$time=%d,count=%d,pr_in=%d,in=%d,next_state=%d",$time,count,pr_in,in,next_state);
          end
          else if(no_space) begin
                 next_state = GAME_OVER;
          end
          else if(win==1) next_state = GAME_OVER;
          end
 PLAYER_2:begin          //SIMILAR TO ABOVE STATE IT EITHER STAYS IN PLAYER2 OR MOVES TO PLAYER1 UNTILL GAME_OVER EITHER BY WIN OR DRAW
           if(!no_space)begin
                  count=count+1;
                  if(in == pr_in)begin 
                      next_state = PLAYER_2;
                      illegal_move = 1; 
                   end
                   else if(in != pr_in & f) begin
                       next_state = PLAYER_2;
                       illegal_move = 1; 
                       count=0;
                   end   
                   else begin
                       next_state = PLAYER_1;
                       pr_in = in;
                       illegal_move = 0; 
                       end
                  
                  $display("$time=%d,count=%d,pr_in=%d,in=%d,next_state=%d",$time,count,pr_in,in,next_state);
          end
          else if(no_space) begin
                 next_state = GAME_OVER;
          end
          else if(win==1) next_state = IDLE;
          end
 GAME_OVER: begin              //IF GAME_OVER THEN IT WILL STAY IN GAME_OVER UNTILL AGAIN START=0
            if(no_space) draw =1;
            if(!start) next_state = IDLE;
            else next_state = GAME_OVER; 
            end
 endcase

 if(in && (current_state != (IDLE | GAME_OVER))&& !f)begin  //LOGIC TO OCCUPY THE POSITION
   pos1 = (in==1 && !ocu1)? ((current_state == PLAYER_1)? 2'd1:2'd2):pos1;
   if(pos1==2'd1|pos1==2'd2) ocu1=1;
   pos2 = (in==2 && !ocu2)? ((current_state == PLAYER_1)? 2'd1:2'd2):pos2;
   if(pos2==2'd1|pos2==2'd2) ocu2=1;
   pos3 = (in==3 && !ocu3)? ((current_state == PLAYER_1)? 2'd1:2'd2):pos3;
   if(pos3==2'd1|pos3==2'd2) ocu3=1;
   pos4 = (in==4 && !ocu4)? ((current_state == PLAYER_1)? 2'd1:2'd2):pos4;
   if(pos4==2'd1|pos4==2'd2) ocu4=1;
   pos5 = (in==5 && !ocu5)? ((current_state == PLAYER_1)? 2'd1:2'd2):pos5;
   if(pos5==2'd1|pos5==2'd2) ocu5=1; 
   pos6 = (in==6  && !ocu6)? ((current_state == PLAYER_1)? 2'd1:2'd2):pos6;
   if(pos6==2'd1|pos6==2'd2) ocu6=1;
   pos7 = (in==7 && !ocu7)? ((current_state == PLAYER_1)? 2'd1:2'd2):pos7;
   if(pos7==2'd1|pos7==2'd2) ocu7=1;
   pos8 = (in==8 && !ocu8)? ((current_state == PLAYER_1)? 2'd1:2'd2):pos8;
   if(pos8==2'd1|pos8==2'd2) ocu8=1;
   pos9 = (in==9 && !ocu9)? ((current_state == PLAYER_1)? 2'd1:2'd2):pos9; 
   if(pos9==2'd1|pos9==2'd2) ocu9=1;
 end

if(((pos1 == pos2) && (pos2 == pos3))||((pos4 == pos5) && (pos5 == pos6))||((pos7 == pos8) && (pos8 == pos9))||
   ((pos1 == pos4) && (pos4 == pos7))||((pos2 == pos5) && (pos5 == pos8))||((pos3 == pos6) && (pos6 == pos9))||
   ((pos3 == pos5) && (pos5 == pos7))||((pos1 == pos5) && (pos5 == pos9)))
begin                        //LOGIC TO CHECK WINNER OF THE GAME
     $display("$time=%d,win=%d,pos1=%d,pos2=%d,pos3=%d,pos4=%d,pos5=%d,pos6=%d,pos7=%d,pos8=%d,pos9=%d",$time,win,pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9);
     if((pos1&pos2&pos3)|(pos2&pos5&pos8)|(pos3&pos6&pos9)|(pos4&pos5&pos6)|(pos5&pos1&pos9)|(pos3&pos5&pos7)|(pos7&pos8&pos9)|(pos7&pos4&pos1))begin
         win=1;
         if(current_state==PLAYER_1) winner=2'd1;
         else if(current_state==PLAYER_2) winner=2'd2;
         else winner = winner; 
         $display("$time=%d,win=%d,pos1=%d,pos2=%d,pos3=%d,pos4=%d,pos5=%d,pos6=%d,pos7=%d,pos8=%d,pos9=%d",$time,win,pos1,pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9);
         next_state=GAME_OVER;
         end
end
else if
    ((pos1 == 2'b01 || pos1 == 2'b10) &&
    (pos2 == 2'b01 || pos2 == 2'b10) &&
    (pos3 == 2'b01 || pos3 == 2'b10) &&
    (pos4 == 2'b01 || pos4 == 2'b10) &&
    (pos5 == 2'b01 || pos5 == 2'b10) &&
    (pos6 == 2'b01 || pos6 == 2'b10) &&
    (pos7 == 2'b01 || pos7 == 2'b10) &&
    (pos8 == 2'b01 || pos8 == 2'b10) &&
    (pos9 == 2'b01 || pos9 == 2'b10)) 
    begin    //LOGIC FOR DRAW CASE
    no_space=1;
    draw=1;
    end
end
end
initial
$monitor("$time=%d,ilegel_move=%d",$time,illegal_move);
endmodule
