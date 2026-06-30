module InstructionMemory(
    input  [31:0] address,
    output reg [31:0] instruction
);
    reg [31:0] imem [0:255];

  initial begin
    imem[0] = 32'h00500093;  // addi x1, x0, 5
    imem[1] = 32'h00300113;  // addi x2, x0, 3
    imem[2] = 32'h002081b3;  // add  x3, x1, x2
    imem[3] = 32'h00208463;  // beq  x1, x2, 8   (not taken)
    imem[4] = 32'h06300213;  // addi x4, x0, 99
    imem[5] = 32'h00302023;  // sw   x3, 0(x0)
    imem[6] = 32'h00002283;  // lw   x5, 0(x0)
    imem[7] = 32'h00518463;  // beq  x3, x5, 8   (taken)
    imem[8] = 32'h06f00313;  // addi x6, x0, 111 (should be SKIPPED)
    imem[9] = 32'h0de00393;  // addi x7, x0, 222 (should execute)
end

    always @(*) begin
        instruction = imem[address[31:2]];  // fill this in
    end

endmodule
