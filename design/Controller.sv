`timescale 1ns / 1ps

module Controller (
    //Input
    input logic [6:0] Opcode,
    //7-bit opcode field from the instruction

    //Outputs
    output logic ALUSrc,
    //0: The second ALU operand comes from the second register file output (Read data 2); 
    //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg,
    //0: The value fed to the register Write data input comes from the ALU.
    //1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic [1:0] ALUOp,  //00: LW/SW; 01:Branch; 10: Rtype
    output logic Branch,  //0: branch is not taken; 1: branch is taken
    output logic JalrSel,
    output logic [1:0] RWSel
);

  logic [6:0] R_TYPE, I_TYPE_IMM, LW, SW, BR, JAL, JALR, HALT;

  // atribuição dos opcodes
  assign R_TYPE = 7'b0110011;  //add,and
  assign I_TYPE_IMM = 7'b0010011; // aritmeticas e logicas imediatas (addi, ...)
  assign LW = 7'b0000011;  //lw, lh, lb, lbu
  assign SW = 7'b0100011;  //sw, sh, sb
  assign BR = 7'b1100011;  //beq, bne, blt
  assign JAL = 7'b1101111; // jal (j-type)
  assign JALR = 7'b1100111; // jalr (i-type)
  assign HALT = 7'b1111111; // halt (halt-type -> não existe)
  
                                                                        // não vai usar a ALU pra a soma (vai usar um adder só)
  assign ALUSrc = (Opcode == LW || Opcode == SW || Opcode == I_TYPE_IMM /*|| Opcode == JAL */|| Opcode == JALR);
  assign MemtoReg = (Opcode == LW);
  assign RegWrite = (Opcode == R_TYPE || Opcode == LW || Opcode == I_TYPE_IMM || Opcode == JAL || Opcode == JALR);
  assign MemRead = (Opcode == LW);
  assign MemWrite = (Opcode == SW); 
  assign ALUOp[0] = (Opcode == BR || Opcode == JAL/* || Opcode == JALR*/);
  assign ALUOp[1] = (Opcode == R_TYPE || Opcode == I_TYPE_IMM || Opcode == JAL /*|| Opcode == JALR*/);
  assign Branch = (Opcode == BR || Opcode == JAL /*|| Opcode == JALR*/);
  /* assign JalrSel = */
  assign RWSel[0] = (Opcode == JAL); // guarda o valor do PC+4 no reg 
  assign RWSel[1] = 0; // dps mudar isso 

endmodule
