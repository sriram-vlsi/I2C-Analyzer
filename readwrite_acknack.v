`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.06.2024 12:21:03
// Design Name: 
// Module Name: readwrite_acknack
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


module readwrite_acknack(scl, sda, slave_address,slave_address_trigger, resetn, upcounter, read_1,
read_trigger_1, write_1, write_trigger_1, ack_1,nack_1, ack_1_trigger, nack_1_trigger,register_address_trigger,register_address
,ack_2_trigger,ack_2, nack_2_trigger, nack_2
, scl_1
, slave_address_trigger_1,  slave_address_1
, read_trigger_2,read_2, write_trigger_2, write_2
, databyte_to_register_trigger, databyte_to_register
, ack_3_trigger, ack_3, nack_3_trigger, nack_3
, residue_bit, shift_reg
);

input scl, sda, resetn;
output reg[6:0] slave_address;
output [5:0] upcounter;
output slave_address_trigger;
output reg read_1;
output  read_trigger_1;
output reg write_1;
output  write_trigger_1;
output reg ack_1;
output reg nack_1;
output ack_1_trigger;
output nack_1_trigger;
output register_address_trigger;
output reg [7:0] register_address;
output ack_2_trigger;
output reg ack_2;
output nack_2_trigger;
output reg nack_2;
output scl_1;
output  slave_address_trigger_1;
output reg [6:0] slave_address_1;
output read_trigger_2;
output reg read_2;
output write_trigger_2;
output reg write_2;
output databyte_to_register_trigger;
output reg [7:0]databyte_to_register;
output ack_3_trigger;
output nack_3_trigger;
output reg ack_3;
output reg nack_3;
output reg residue_bit;
output reg [8:0]shift_reg;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//SLAVE ADDRESS IN PARALLEL FORM//
////////////////////////////////////////////////////

always@(posedge scl, negedge resetn)
begin
    if(resetn==0)
        slave_address<=0;
    else if(slave_address_trigger==1)
        begin
            slave_address[0]<=sda;
            slave_address[1]<=slave_address[0];
            slave_address[2]<=slave_address[1];
            slave_address[3]<=slave_address[2];
            slave_address[4]<=slave_address[3];
            slave_address[5]<=slave_address[4];
            slave_address[6]<=slave_address[5];
        end

end

assign slave_address_trigger= (~upcounter[5] & ~upcounter[4] & ~upcounter[3] & upcounter[0]) | (~upcounter[5] & ~upcounter[4] & ~upcounter[3] & upcounter[1]) | (~upcounter[5] & ~upcounter[4] & ~upcounter[3] & upcounter[2]);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//READ AND WRITE CONDITIONS//
////////////////////////////////////////////////
always@(posedge scl, negedge resetn)  // read is 1, write is 0
begin
    if(resetn==0)
        read_1<=0;
    else if(read_trigger_1==1)
        read_1<=sda&read_trigger_1;
    else if(read_trigger_1==0)
        read_1<=0;
end
always@(posedge scl, negedge resetn)
begin
    if(resetn==0)
        write_1<=0;
    else if(write_trigger_1==1)
        write_1<=~sda&write_trigger_1;
    else if(write_trigger_1==0)
        write_1<=0;
end
assign read_trigger_1= (~upcounter[5]&~upcounter[4]&upcounter[3]&~upcounter[2]&~upcounter[1]&~upcounter[0]);
assign write_trigger_1= (~upcounter[5]&~upcounter[4]&upcounter[3]&~upcounter[2]&~upcounter[1]&~upcounter[0]);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ACKNOWLEDGE AND NOT ACKNLOWDGE BIT//
///////////////////////////////////////////////
always@(posedge scl, negedge resetn)   // acknowledge is 0, nack is 1
begin
    if(resetn==0)
        ack_1<=0;
    else if( ack_1_trigger==1)
        ack_1<=ack_1_trigger&~sda;
    else if( ack_1_trigger==0)
        ack_1<=0;
end
always@(posedge scl, negedge resetn)
begin
    if(resetn==0)
        nack_1<=0;
    else if( nack_1_trigger==1)
        nack_1<=sda&nack_1_trigger;
    else if(nack_1_trigger==0)
        nack_1<=0;
end
assign ack_1_trigger= (~upcounter[5]&~upcounter[4]&upcounter[3]&~upcounter[2]&~upcounter[1]&upcounter[0]);
assign nack_1_trigger= (~upcounter[5]&~upcounter[4]&upcounter[3]&~upcounter[2]&~upcounter[1]&upcounter[0]);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//REGISTER ADDRESS//
//////////////////////////////////////////////////////////
always@(posedge scl, negedge resetn)
begin
    if(resetn==0)
        register_address<=0;
    else if(register_address_trigger==1)
        begin
            register_address[0]<=sda;
            register_address[1]<=register_address[0];
            register_address[2]<=register_address[1];
            register_address[3]<=register_address[2];
            register_address[4]<=register_address[3];
            register_address[5]<=register_address[4];
            register_address[6]<=register_address[5];
            register_address[7]<=register_address[6];
        end

end


assign register_address_trigger= (~upcounter[5]&~upcounter[4]&upcounter[3]&upcounter[1]) | (~upcounter[5]&~upcounter[4]&upcounter[3]&upcounter[2])
                                 | (~upcounter[5]&upcounter[4]&~upcounter[3]&~upcounter[2]&~upcounter[1]);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                 
 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ACKNLOWDGE NOT ACKNOWLEDGE BIT AFTER REGISTER ADDRESS//
//////////////////////////////////////////////////////////
always@(posedge scl, negedge resetn)
begin
    if(resetn==0)
        ack_2<=0;
    else if( ack_2_trigger==1)
        ack_2<=ack_2_trigger&~sda;
    else if( ack_2_trigger==0)
        ack_2<=0;
end
always@(posedge scl, negedge resetn)
begin
    if(resetn==0)
        nack_2<=0;
    else if( nack_2_trigger==1)
        nack_2<=sda&nack_2_trigger;
    else if(nack_2_trigger==0)
        nack_2<=0;
end
assign ack_2_trigger= (~upcounter[5]&upcounter[4]&~upcounter[3]&~upcounter[2]&upcounter[1]&~upcounter[0]);
assign nack_2_trigger=(~upcounter[5]&upcounter[4]&~upcounter[3]&~upcounter[2]&upcounter[1]&~upcounter[0]);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////DATA WRITTEN TO 8 BIT REGISTER//
////////////////////////////////////////
always@(posedge scl, negedge resetn)
begin
    if(resetn==0)
        databyte_to_register<=0;
    else if(databyte_to_register_trigger==1)
        begin
            shift_reg[8:0] <= {shift_reg [7:0], sda};
            
            if (scl_ff_start==1 )
                databyte_to_register <= 0;

            else if (scl_ff_start==0 )
                databyte_to_register  <= shift_reg[7:0];
                
            else if(scl_ff_start==1)
                residue_bit<= shift_reg[0];

            databyte_to_register[0]<=sda;
            databyte_to_register[1]<=databyte_to_register[0];
            databyte_to_register[2]<=databyte_to_register[1];
            databyte_to_register[3]<=databyte_to_register[2];
            databyte_to_register[4]<=databyte_to_register[3];
            databyte_to_register[5]<=databyte_to_register[4];
            databyte_to_register[6]<=databyte_to_register[5];
            databyte_to_register[7]<=databyte_to_register[6];
        end

end

assign databyte_to_register_trigger= ((~upcounter[5]&upcounter[4]&~upcounter[3]&upcounter[2]) |
                                     (~upcounter[5]&upcounter[4]&upcounter[3]&~upcounter[2]));                        
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////ACKNLOWDGE NOT ACKNOWLEDGE BIT AFTER REGISTER ADDRESS 2//
////////////////////////////////////////////////////////////
always@(posedge scl, negedge resetn)
begin
    if( ack_3_trigger==1)
        ack_3<=ack_3_trigger&~sda;
    else if( ack_3_trigger==0)
        ack_3<=0;
end
always@(posedge scl, negedge resetn)
begin
    if( nack_3_trigger==1)
        nack_3<=sda&nack_3_trigger;
    else if(nack_3_trigger==0)
        nack_3<=0;
end
assign ack_3_trigger= (~upcounter[5]&upcounter[4]&upcounter[3]&upcounter[2]&~upcounter[1]&~upcounter[0]);
assign nack_3_trigger=(~upcounter[5]&upcounter[4]&upcounter[3]&upcounter[2]&~upcounter[1]&~upcounter[0]);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//MEMORY ELEMENT//
//////////////////////////////

reg [17:0]  memory_array_read;
reg [25:0]  memory_array_write;
always@(negedge sda, negedge resetn)

begin
    if(scl_ff_start&(~upcounter[5]&upcounter[4]&~upcounter[3]&~upcounter[2]&upcounter[1]&upcounter[0])==1) 
        memory_array_read[17:0]<= {slave_address[6:0], read_1&write_1,  nack_1&~ack_1, register_address[7:0]};
    if(scl_ff_start&(~upcounter[5]&upcounter[4]&upcounter[3]&upcounter[2]&~upcounter[1]&upcounter[0])==1)
        memory_array_write[25:0]<={slave_address[6:0], read_1&write_1,  nack_1&~ack_1, register_address[7:0], databyte_to_register[7:0]
        , nack_3&~ack_3 };
end

always@(posedge sda, negedge resetn)
begin
    if(scl_ff_start&(~upcounter[5]&upcounter[4]&upcounter[3]&upcounter[2]&~upcounter[1]&upcounter[0])==1)
        memory_array_write[25:0]<={slave_address[6:0], read_1&write_1,  nack_1&~ack_1, register_address[7:0], databyte_to_register[7:0]
        , nack_3&~ack_3 };
end
////////////////////////////////////////////////////////////////////////////////
//UPCOUNTER RESET//
//////////////////////////////////////////////////////////////////////////////////

i2c_serial2parallel u_i2c_serial2parallel(
.scl(scl),
.sda(sda),
.resetn(resetn),
.upcounter(upcounter),
.scl_ff_start(scl_ff_start)
);

endmodule
