module InstructionMemory(
    input  [31:0] address,
    output reg [31:0] instruction
);
    reg [31:0] imem [0:255];

  initial begin
    imem[0] = 32'h00500093;  
    imem[1] = 32'h00300113;  
    imem[2] = 32'h002081b3;  
    imem[3] = 32'h00208463;  
    imem[4] = 32'h06300213;  
    imem[5] = 32'h00302023;  
    imem[6] = 32'h00002283;  
    imem[7] = 32'h00518463;  
    imem[8] = 32'h06f00313;  
    imem[9] = 32'h0de00393;  
end

    always @(*) begin
        instruction = imem[address[31:2]];  
    end

endmodule
