module RegisterFile(
    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    input RegWrite,
    output [31:0] read_data1,
    output [31:0] read_data2
);

    reg [31:0] registers [0:31];

    
    assign read_data1 = (rs1 == 5'b0) ? 32'b0 : registers[rs1];
    assign read_data2 = (rs2 == 5'b0) ? 32'b0 : registers[rs2];

    
    always @(posedge clk) begin
        if(RegWrite) begin
            if(rd != 5'b0)
                registers[rd] <= write_data;
        end
    end

endmodule
