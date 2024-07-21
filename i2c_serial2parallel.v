`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2024 11:20:52
// Design Name: 
// Module Name: i2c_serial2parallel
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

module i2c_serial2parallel(scl, sda,resetn, scl_ff_start, scl_ff_stop, upcount_trigger_start, 
upcount_trigger_stop, upcount_trigger, upcounter,scl_ff_start_delay, scl_ff);

input scl, sda, resetn;
output reg upcount_trigger_start;
output reg upcount_trigger_stop;
output reg scl_ff_start;
output reg scl_ff_stop;
output reg[5:0] upcounter;
output upcount_trigger;
output reg scl_ff_start_delay;
output scl_ff;


always@(negedge sda, negedge resetn)
begin
    if(resetn==0)
        scl_ff_start=0;
    else
        scl_ff_start=scl; 
end
always@(negedge scl, negedge resetn)
begin
    if(resetn==0)
        scl_ff_start_delay<= 0;
    else
        scl_ff_start_delay<= scl_ff_start;     
end

assign scl_ff= scl_ff_start&~scl_ff_start_delay;

always@(negedge scl, negedge resetn)

begin
    if(resetn==0)
        upcount_trigger_start<=0;
    else if (resetm==1)
        upcount_trigger_start<=1;
    else if (resetm==0)
        upcount_trigger_start<=upcount_trigger_start;
end        
        
assign resetm=scl_ff_start | upcount_trigger_start;

always@(posedge scl, negedge resetn)
begin  
    if (resetn==0)
        upcounter=0;
        
    else if(upcount_trigger==1)
        upcounter<= upcounter+6'b000001;

    else if(upcount_trigger==0)
        upcounter<=0;
        
    else if(scl_ff==1)
        upcounter<=0;
     

end

always@(posedge sda, negedge resetn)
begin
    if(resetn==0)
        scl_ff_stop=0;
    else
        scl_ff_stop=scl;
end

always@(posedge scl, negedge resetn)

begin
    if (resetn==0)
        upcount_trigger_stop<=0;
    else if (resetl==0)
        upcount_trigger_stop<=0;
    else if (scl_ff_stop==1)
        upcount_trigger_stop<=upcount_trigger_stop;
end        
assign resetl= upcount_trigger_stop+scl_ff_stop;
assign upcount_trigger= upcount_trigger_start & ~upcount_trigger_stop;

start_stop u_startstop (
.scl(scl),
.sda(sda),
.resetn(resetn)
);


endmodule


 