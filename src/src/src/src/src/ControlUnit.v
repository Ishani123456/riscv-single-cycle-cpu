module ControlUnit(
    input  [31:0] instruction,
    output reg    RegWrite,
    output reg [2:0] ImmSel,
    output reg    ALUSrc,
    output reg [3:0] ALUControl,
    output reg    MemWrite,
    output reg    MemRead,
    output reg    MemToReg,
    output reg    Branch,
    output reg    Jump,
    output reg BranchType
);
    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire       funct7 = instruction[30];

    reg [1:0] ALUOp;

    always @(*) begin
        case(opcode)
            7'b0110011: begin  // R-type
                RegWrite = 1;
                ImmSel   = 3'b000;
                ALUSrc   = 0;
                MemWrite = 0;
                MemRead  = 0;
                MemToReg = 0;
                Branch   = 0;
                Jump     = 0;
                ALUOp    = 2'b10;
                BranchType = 1'b0;
            end
            7'b0010011: begin  // I-type arithmetic
                RegWrite = 1;
                ImmSel   = 3'b000;
                ALUSrc   = 1;
                MemWrite = 0;
                MemRead  = 0;
                MemToReg = 0;
                Branch   = 0;
                Jump     = 0;
                ALUOp    = 2'b10;
                BranchType = 1'b0;
            end
            7'b0000011: begin  // Load
                RegWrite = 1;
                ImmSel   = 3'b000;
                ALUSrc   = 1;
                MemWrite = 0;
                MemRead  = 1;
                MemToReg = 1;
                Branch   = 0;
                Jump     = 0;
                ALUOp    = 2'b00;
                BranchType = 1'b0;
            end
            7'b0100011: begin  // Store
                RegWrite = 0;
                ImmSel   = 3'b001;
                ALUSrc   = 1;
                MemWrite = 1;
                MemRead  = 0;
                MemToReg = 0;
                Branch   = 0;
                Jump     = 0;
                ALUOp    = 2'b00;
                BranchType = 1'b0;
            end
            7'b1100011: begin
               RegWrite = 0;
               ImmSel   = 3'b010;
               ALUSrc   = 0;
               MemWrite = 0;
               MemRead  = 0;
               MemToReg = 0;
               Branch   = 1;
               Jump     = 0;
               ALUOp    = 2'b01;
               BranchType = (funct3 == 3'b001) ? 1'b1 : 1'b0;  
            end
            7'b1101111: begin  // JAL
                RegWrite = 1;
                ImmSel   = 3'b100;
                ALUSrc   = 0;
                MemWrite = 0;
                MemRead  = 0;
                MemToReg = 0;
                Branch   = 0;
                Jump     = 1;
                ALUOp    = 2'b00;
                BranchType = 1'b0;
            end
            default: begin
                RegWrite = 0;
                ImmSel   = 3'b000;
                ALUSrc   = 0;
                MemWrite = 0;
                MemRead  = 0;
                MemToReg = 0;
                Branch   = 0;
                Jump     = 0;
                ALUOp    = 2'b00;
                BranchType = 1'b0;
            end
        endcase
    end

    always @(*) begin
        case(ALUOp)
            2'b00: ALUControl = 4'b0000;
            2'b01: ALUControl = 4'b0001;
            2'b10: begin
                case(funct3)
                    3'b000: ALUControl = funct7 ? 4'b0001 : 4'b0000;
                    3'b001: ALUControl = 4'b0101;
                    3'b010: ALUControl = 4'b1000;
                    3'b100: ALUControl = 4'b0100;
                    3'b101: ALUControl = funct7 ? 4'b0111 : 4'b0110;
                    3'b110: ALUControl = 4'b0011;
                    3'b111: ALUControl = 4'b0010;
                    default: ALUControl = 4'b0000;
                endcase
            end
            default: ALUControl = 4'b0000;
        endcase
    end

endmodule
