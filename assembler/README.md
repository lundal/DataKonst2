# Assembler

## Instructions

__add__ _rd_ _rs_ _rt_
__sub__ _rd_ _rs_ _rt_
__addi__ _rt_ _rs_ _imm_
__addu__ _rd_ _rs_ _rt_
__subu__ _rd_ _rs_ _rt_
__addiu__ _rt_ _rs_ _imm_

__and__ _rd_ _rs_ _rt_
__or__ _rd_ _rs_ _rt_
__nor__ _rd_ _rs_ _rt_
__xor__ _rd_ _rs_ _rt_
__andi__ _rt_ _rs_ _imm_
__ori__ _rt_ _rs_ _imm_
__xori__ _rt_ _rs_ _imm_

__sll__ _rd_ _rt_ _sh_
__srl__ _rd_ _rt_ _sh_
__sra__ _rd_ _rt_ _sh_
__sllv__ _rd_ _rt_ _sh_
__srlv__ _rd_ _rt_ _sh_
__srav__ _rd_ _rt_ _sh_

__j__ _addr_
__jal__ _addr_
__jr__ _rs_
__jalr__ _rs_
__beq__ _rt_ _rs_ _imm_
__bne__ _rt_ _rs_ _imm_

__lui__ _rt_ _imm_
__lw__ _rt_ _imm_ _rs_
__sw__ _rt_ _imm_ _rs_
