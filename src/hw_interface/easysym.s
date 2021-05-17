.globl   _print

_print:
    move.l  4(sp), a1
    move.b  #14, d0
    trap    #15
    rts
