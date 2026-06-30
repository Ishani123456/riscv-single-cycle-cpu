module InstructionMemory(
    input  [31:0] address,
    output reg [31:0] instruction
);
    reg [31:0] imem [0:255];

    initial begin
        $readmemh("program.mem", imem);
    end

    always @(*) begin
        instruction = imem[address[31:2]];
    end
endmodule
