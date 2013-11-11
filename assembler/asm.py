#!/usr/bin/python

import sys

def main():
    source = open(sys.argv[1], 'r')
    target = open(sys.argv[1].split('.')[0] + '.op', 'w')
    for line in source:
        line = line.strip()
        code = line.split(' ')
        cmd = code[0]
        string = ''

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
            string += "100000\n"
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
            string += "100010\n"
        elif cmd == 'addi':
            # add immediate
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '001000'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += '\n'
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
            string += "100001\n"
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
            string += "100011\n"
        elif cmd == 'addiu':
            # add immediate unsigned
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '001001'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += '\n'
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
            string += "100100\n"
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
            string += "100101\n"
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
            string += "100111\n"
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
            string += "100110\n"
        elif cmd == 'andi':
            # and immediate
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '001100'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += '\n'
        elif cmd == 'ori':
            # or immediate
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '001101'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += '\n'
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
            string += '\n'
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
            string += "000000\n"
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
            string += "000010\n"
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
            string += "000011\n"
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
            string += "000100\n"
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
            string += "000110\n"
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
            string += "000111\n"
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
            string += "101010\n"
        elif cmd == 'slti':
            # set if less than immediate
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '001010'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += '\n'
            pass
        elif cmd == 'j':
            # jump uncoditional
            addr = int(code[1])
            string += '000010'
            string += '{0:026b}'.format(addr)
            string += '\n'
        elif cmd == 'jal':
            # jump and link
            addr = int(code[1])
            string += '000011'
            string += '{0:026b}'.format(addr)
            string += '\n'
        elif cmd == 'jr':
            # jump register
            rs = int(code[1].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "00000"
            string += "00000"
            string += "00000"
            string += "001000\n"
        elif cmd == 'jalr':
            # jump and link register
            rs = int(code[1].replace("r", ""))
            string += '000000' # op code
            string += "{0:05b}".format(rs)
            string += "00000"
            string += "00000"
            string += "00000"
            string += "001001\n"
        elif cmd == 'beq':
            # branch if equal
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '000100'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += '\n'
        elif cmd == 'bne':
            # branch if not equal
            rt = int(code[1].replace("r", ""))
            rs = int(code[2].replace("r", ""))
            imm = int(code[3])
            string += '000101'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += '\n'
        elif cmd == 'lui':
            # load upper immediate
            rt = int(code[1].replace("r", ""))
            imm = int(code[2])
            string += '001111'
            string += '00000'
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += '\n'
        elif cmd == 'lw':
            # load word
            rt = int(code[1].replace("r", ""))
            imm = int(code[2])
            rs = int(code[3].replace("r", ""))
            string += '100011'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += '\n'
        elif cmd == 'sw':
            # store word
            rt = int(code[1].replace("r", ""))
            imm = int(code[2])
            rs = int(code[3].replace("r", ""))
            string += '101011'
            string += '{0:05b}'.format(rs)
            string += '{0:05b}'.format(rt)
            string += '{0:016b}'.format(imm)
            string += '\n'

        target.write(string)
    target.close()

main()
