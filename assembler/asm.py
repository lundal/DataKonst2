#!/usr/bin/python

import sys

def main():
    source = open(sys.argv[1], 'r')
    target = open(sys.argv[1].split('.')[0] + '.op', 'w')
    vhdl = False
    lnum = 0
    if len(sys.argv) > 2:
        if sys.argv[2] == '-v':
            vhdl = True
    for line in source:
        line = line.strip()
        code = line.split(' ')
        cmd = code[0]
        string = ''
        if vhdl:
            string = 'constant ins' + `lnum` + '\t: std_logic_vector(0 to 31) := "'

        if cmd == ';':
            pass
        elif cmd == 'add':
            # add
            rd = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            rt = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(rd)
            string += "00000"
            string += "100000"
        elif cmd == 'sub':
            # sub
            rd = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            rt = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(rd)
            string += "00000"
            string += "100010"
        elif cmd == 'addi':
            # add immediate
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '001000'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += ''
        elif cmd == 'addu':
            # add unsigned
            rd = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            rt = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(rd)
            string += "00000"
            string += "100001"
        elif cmd == 'subu':
            # sub unsigned
            rd = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            rt = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(rd)
            string += "00000"
            string += "100011"
        elif cmd == 'addiu':
            # add immediate unsigned
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '001001'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += ''
        elif cmd == 'and':
            #and
            rd = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            rt = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(rd)
            string += "00000"
            string += "100100"
        elif cmd == 'or':
            # or
            rd = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            rt = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(rd)
            string += "00000"
            string += "100101"
        elif cmd == 'nor':
            # nor
            rd = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            rt = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(rd)
            string += "00000"
            string += "100111"
        elif cmd == 'xor':
            # xor
            rd = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            rt = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(rd)
            string += "00000"
            string += "100110"
        elif cmd == 'andi':
            # and immediate
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '001100'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += ''
        elif cmd == 'ori':
            # or immediate
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '001101'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += ''
            pass
        elif cmd == 'xori':
            # xor immediate
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '001110'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += ''
            pass
        elif cmd == 'sll':
            # shift left logical
            rd = int(code[1].replace("r", ""))
            rt = int(code[2].replace("r", ""))
            sh = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "00000"
            string += "{0:05b}".format(rd)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(sh)
            string += "000000"
        elif cmd == 'srl':
            # shift right logical
            rd = int(code[1].replace("r", ""))
            rt = int(code[2].replace("r", ""))
            sh = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "00000"
            string += "{0:05b}".format(rd)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(sh)
            string += "000010"
        elif cmd == 'sra':
            # shift right arithmetic
            rd = int(code[1].replace("r", ""))
            rt = int(code[2].replace("r", ""))
            sh = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "00000"
            string += "{0:05b}".format(rd)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(sh)
            string += "000011"
        elif cmd == 'sllv':
            # shift left logical variable
            rd = int(code[1].replace("r", ""))
            rt = int(code[2].replace("r", ""))
            sh = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "00000"
            string += "{0:05b}".format(rd)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(sh)
            string += "000100"
        elif cmd == 'srlv':
            # shift right logical variable
            rd = int(code[1].replace("r", ""))
            rt = int(code[2].replace("r", ""))
            sh = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "00000"
            string += "{0:05b}".format(rd)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(sh)
            string += "000110"
        elif cmd == 'srav':
            # shift right arithmetic variable
            rd = int(code[1].replace("r", ""))
            rt = int(code[2].replace("r", ""))
            sh = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "00000"
            string += "{0:05b}".format(rd)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(sh)
            string += "000111"
            pass
        elif cmd == 'slt':
            # set if less than
            rd = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            rt = int(code[3].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "{0:05b}".format(rt)
            string += "{0:05b}".format(rd)
            string += "00000"
            string += "101010"
        elif cmd == 'slti':
            # set if less than immediate
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '001010'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += ''
            pass
        elif cmd == 'j':
            # jump uncoditional
            addr = int(code[1])
            string += '000010'
            string += '{0:026b}'.format(addr)
            string += ''
        elif cmd == 'jal':
            # jump and link
            addr = int(code[1])
            string += '000011'
            string += '{0:026b}'.format(addr)
            string += ''
        elif cmd == 'jr':
            # jump register
            rs = int(code[1].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "00000"
            string += "00000"
            string += "00000"
            string += "001000"
        elif cmd == 'jalr':
            # jump and link register
            rs = int(code[1].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "00000"
            string += "00000"
            string += "00000"
            string += "001001"
        elif cmd == 'beq':
            # branch if equal
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '000100'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += ''
        elif cmd == 'bne':
            # branch if not equal
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '000101'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += ''
        elif cmd == 'lui':
            # load upper immediate
            rt = int(code[1].replace("r", ""))
            imm = int(code[2])
            string += '001111'
            string += '00000'
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += ''
        elif cmd == 'lw':
            # load word
            rt = int(code[1].replace("r", ""))
            imm = int(code[2])
            rs = int(code[3].replace("r", ""))
            string += '100011'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += ''
        elif cmd == 'sw':
            # store word
            rt = int(code[1].replace("r", ""))
            imm = int(code[2])
            rs = int(code[3].replace("r", ""))
            string += '101011'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += ''

        if vhdl:
            string += '";'
        string += '\n'
        target.write(string)
        lnum += 1
    target.close()

main()
