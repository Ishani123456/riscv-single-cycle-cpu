module DataMemory (
    input         clk,
    input  [31:0] address,
    input  [31:0] write_data,
    input         MemWrite,
    input         MemRead,
    output [31:0] read_data
);

    reg [31:0] dmem [0:255];

    // Combinational read (word-addressed: use bits [9:2] of address)
    assign read_data = (MemRead) ? dmem[address[9:2]] : 32'b0;

    // Synchronous write
    always @(posedge clk) begin
        if (MemWrite)
            dmem[address[9:2]] <= write_data;
    end

endmodule
