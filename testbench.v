`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2024 14:52:49
// Design Name: 
// Module Name: testbench
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


module testbench ;
`define PER 20

reg tb_clk,tb_sda;
reg tb_resetn;
reg [7:0] sda_line_pattern[0:511];
reg [3:0] send_bit;
reg [7:0]  curr_sda_pattern;

integer i;

readwrite_acknack uut(
.sda(tb_sda ),
.scl( tb_clk ),
.slave_address(),
.resetn(tb_resetn)
);


initial

begin
    #0 tb_resetn=0;
   tb_clk =0;
   curr_sda_pattern  = 8'hff;
   send_bit = 0;
   
   for(i=0; i < 511; i=i+1)
   begin
    sda_line_pattern[i] = 8'hff;
   end
#5 tb_resetn=1;
send_start;
#30 serialize_it( 10'h25, 4'd6  ); // Slave address
serialize_it( 10'h1, 4'd0 );   // read bit
serialize_it( 10'h0, 4'd0 );    // nAck bit
serialize_it( 10'h18, 4'd7 );   // Reg address
serialize_it( 10'h0, 4'd0 );    // Ack bit
serialize_it( 10'h14, 4'd8   ); // databyte to register
serialize_it(10'h0, 4'd0);  // ack bit

   
end 


initial
begin
#10  
   forever
   begin
     tb_clk =  #10 ~tb_clk;
   end
end


task serialize_it; 
input [9:0]  data_in;
input [3:0] bits_to_send;
integer bit_left;

begin
    bit_left = bits_to_send;
    
    while ( bit_left >= 0)
    begin: loop
        @(negedge tb_clk);
        tb_sda = #4 data_in[bit_left];
        $display($time, "bit_left=%h, tb_sda=%h", bit_left, tb_sda);
        bit_left = bit_left - 1 ;
        //bit_left = (bit_left>0) ? bit_left - 1 : 0;
        
    end 
    $display("sent");
end
endtask


task send_start;
begin
// Start condition
//  H->L of SDA while SCL =H
tb_sda <= 1'b1;
@(posedge tb_clk);
tb_sda <= #(20/4) 1'b0;

end

endtask


endmodule