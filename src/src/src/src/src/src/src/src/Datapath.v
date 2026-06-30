module Datapath (
    input clk,
    input reset
);

    
    wire [31:0] pc_current;
    wire [31:0] pc_plus4;
    wire [31:0] next_pc;

    PC pc_reg (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc_current)
    );

    assign pc_plus4 = pc_current + 32'd4;
    wire [31:0] instruction;

    InstructionMemory imem (
        .address(pc_current),
        .instruction(instruction)
    );

   
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [4:0] rd  = instruction[11:7];

    
    wire        RegWrite;
    wire [2:0]  ImmSel;
    wire        ALUSrc;
    wire [3:0]  ALUControl;
    wire        MemWrite;
    wire        MemRead;
    wire        MemToReg;
    wire        Branch;
    wire        Jump;
    wire        BranchType;

    ControlUnit cu (
        .instruction(instruction),
        .RegWrite(RegWrite),
        .ImmSel(ImmSel),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .Branch(Branch),
        .Jump(Jump),
        .BranchType(BranchType)
    );

    
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] write_back_data;

    RegisterFile rf (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .RegWrite(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    
    wire [31:0] imm_out;

    ImmediateGenerator immgen (
        .instruction(instruction),
        .ImmSel(ImmSel),
        .imm_out(imm_out)
    );

   
    wire [31:0] alu_b;
    assign alu_b = (ALUSrc) ? imm_out : read_data2;

    
    wire [31:0] alu_result;
    wire        alu_zero;

    ALU alu (
        .ALUcontrol(ALUControl),
        .a(read_data1),
        .b(alu_b),
        .f(alu_result),
        .zero(alu_zero)
    );

    
    wire [31:0] mem_read_data;

    DataMemory dmem (
        .clk(clk),
        .address(alu_result),
        .write_data(read_data2),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .read_data(mem_read_data)
    );

    
    assign write_back_data = (Jump)     ? pc_plus4 :
                              (MemToReg) ? mem_read_data :
                                           alu_result;

    
    wire [31:0] branch_target;
    wire        branch_taken;

    assign branch_target = pc_current + imm_out;
    assign branch_taken = Branch & (BranchType ? ~alu_zero : alu_zero);

    assign next_pc = (Jump)         ? branch_target :
                      (branch_taken) ? branch_target :
                                        pc_plus4;

endmodule
