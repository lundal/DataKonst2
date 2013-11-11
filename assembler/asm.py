#!/usr/bin/python

import sys

def main():
    source = open(sys.argv[1], 'r')
    target = open(sys.argv[1].split('.')[0] + '.op', 'w')
    for line in source:
        line = line.strip()
        code = line.split(' ')
        cmd = code[0]

        if cmd == 'add':
            # add
            pass
        elif cmd == 'sub':
            # sub
            pass
        elif cmd == 'addi':
            # add immediate
            pass
        elif cmd == 'addu':
            # add unsigned
            pass
        elif cmd == 'subu':
            # sub unsigned
            pass
        elif cmd == 'addiu':
            # add immediate unsigned
            pass
        elif cmd == 'and':
            #and
            pass
        elif cmd == 'or':
            # or
            pass
        elif cmd == 'nor':
            # nor
            pass
        elif cmd == 'xor':
            # xor
            pass
        elif cmd == 'andi':
            # and immediate
            pass
        elif cmd == 'ori':
            # or immediate
            pass
        elif cmd == 'xori':
            # xor immediate
            pass
        elif cmd == 'sll':
            # shift left logical
            pass
        elif cmd == 'srl':
            # shift right logical
            pass
        elif cmd == 'sra':
            # shift right arithmetic
            pass
        elif cmd == 'sllv':
            # shift left logical variable
            pass
        elif cmd == 'srlv':
            # shift right logical variable
            pass
        elif cmd == 'srav':
            # shift right arithmetic variable
            pass
        elif cmd == 'slt':
            # set if less than
            pass
        elif cmd == 'slti':
            # set if less than immediate
            pass
        elif cmd == 'j':
            # jump uncoditional
            pass
        elif cmd == 'jal':
            # jump and link
            pass
        elif cmd == 'jr':
            # jump register
            pass
        elif cmd == 'jalr':
            # jump and link register
            pass
        elif cmd == 'beq':
            # branch if equal
            pass
        elif cmd == 'bne':
            # branch if not equal
            pass
        elif cmd == 'lui':
            # load upper immediate
            pass
        elif cmd == 'lw':
            # load word
            pass
        elif cmd == 'sw':
            # store word
            pass

main()
