`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.12.2023 13:57:19
// Design Name: 
// Module Name: PROJECT_TOP
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


module PROJECT_TOP(clk,rst,start,in,winner,draw,current_state,div_clk,out_rst,oled_spi_clk,oled_spi_data,oled_vdd,oled_vbat,oled_reset_n,oled_dc_n,reset );
input clk,rst,start;
input [3:0]in;
output [1:0]winner;
output [1:0] current_state;
output div_clk;
output draw;
output out_rst;
input reset;
output oled_spi_clk;
output oled_spi_data;
output oled_vdd;
output oled_vbat;
output oled_reset_n;
output oled_dc_n; 


TIC_TAC_TOE  TTT(clk,rst,start,in,winner,draw,current_state,div_clk,out_rst);// TIC TAC TOE MODULE DECLARATION
top Oled(clk,reset,current_state,winner,draw,oled_spi_clk,oled_spi_data,oled_vdd,oled_vbat,oled_reset_n,oled_dc_n );//OLED MODULE DECLARATION


endmodule
