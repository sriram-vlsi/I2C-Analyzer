`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2024 23:18:16
// Design Name: 
// Module Name: i2c_start_stop
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
module start_stop(scl, sda, ra2, rb2, ra1, rb1, ra, rb, start_pulse, stop_pulse, resetn);
input scl, sda, resetn;
output reg ra;
output reg rb;
output reg ra1;
output reg rb2;
output reg ra2;
output reg rb1;
output start_pulse;
output stop_pulse;

// detects rising edge of sda for stop condition 
always @ (posedge sda, negedge resetn) 
begin
    if (resetn==0)
        ra=0;
    else
        ra <= scl;
end 
// detects falling edge of sda for start condition
always @ (negedge sda, negedge resetn)
begin
    if (resetn==0)
            rb=0;
else
    rb <= scl;
end
//stores i/p of ra(stop condition) 
always@ (posedge scl, negedge resetn)
begin
    if (resetn==0)
        ra1=0;
    else
        ra1<= ra;
end 
 
//stores i/p of rb(start condition)
always@ (posedge scl, negedge resetn)
begin
    if (resetn==0)
        rb1=0;
    else
        rb1<= rb;
end 

//creates another signal of ra1 which is delayed by 1 clock cycle
always@ (posedge scl, negedge resetn)
begin
    if (resetn==0)
        ra2=0;
    else
        ra2<= ra1;
end 

////creates another signal of rb1 which is delayed by 1 clock cycle
always@ (posedge scl, negedge resetn)
begin
    if (resetn==0)
        rb2=0;
    else
        rb2<= rb1;
end 

// creates a pulse for start and stop condition
assign start_pulse= ~rb2 & rb1;
assign stop_pulse= ~ra2 & ra1;


endmodule