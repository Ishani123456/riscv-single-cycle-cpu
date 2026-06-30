module ALU(
    input  [3:0]  ALUcontrol,
    input  [31:0] a,
    input  [31:0] b,
    output reg [31:0] f,
    output zero
);

    assign zero = (f == 32'b0);

    always @(*) begin
        case(ALUcontrol)
            4'b0000: f = a+b;   // ADD
            4'b0001: f = a-b;   // SUB
            4'b0010: f = a&b;   // AND
            4'b0011: f = a|b;   // OR
            4'b0100: f = a^b;   // XOR
            4'b0101: f = a<<b[4:0];   // SLL
            4'b0110: f = a>>b[4:0];   // SRL
            4'b0111: f = $signed(a) >>> b[4:0];   // SRA (hint: $signed)
            4'b1000: f = ($signed(a) < $signed(b)) ? 1 : 0;   // SLT
            default: f = 32'b0;
        endcase
    end

endmodule
