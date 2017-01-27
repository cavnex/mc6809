
        org     $a000

CURPOS  equ     $88
KEYSTAT equ     $87

KEYLS   equ     $1
KEYRS   equ     $2
KEYSHF  equ     $4
KEYUP   equ     $8

EXECPTR equ     487

        FDB     POLCAT
        FDB     CHROUT

start   orcc    #$50 

        clr     KEYSTAT
        lds     #$3FF
        jsr     CLS
        
        ldx     #GREGMSG
        jsr     PRTMSG

        ldx     EXECPTR
        cmpx    #0
        beq     keylp
        jmp     ,x

keylp   
        jsr     POLCAT
        beq     keylp

        ;bsr     PRTHEX
        bsr     PUTCHR
        bra     keylp

lp      bra     lp

PRTNYB  cmpa    #10
        blo     NYB1
        adda    #7
NYB1    adda    #$30
        bra     PUTCHR
   

PRTHEX  pshs    a
        lsra
        lsra
        lsra
        lsra
        bsr     PRTNYB
        lda     ,s
        anda    #$F
        bsr     PRTNYB
        lda     #$20
        bsr     PUTCHR
        puls    a,pc



PUTCHR  ldu     CURPOS
        cmpa    #13
        beq     CHRCR
        cmpa    #8
        beq     CHRBS
        cmpa    #32
        bhs     CHRSYM
        rts
CHRSYM  cmpa    #$40             // Symbols & Numbers from $20 to $3F ?
        bhs     1$
        eora    #$40
        bra     CHRWRT      
1$      cmpa    #$60            // Is this uppercase or lowercase?
        blo     CHRWRT          // Uppercase, write directly.
        eora    #$60
CHRWRT  sta     ,u+
CHRPST  cmpu    #$600
        beq     CHRSCR
        stu     CURPOS
        rts 
CHRSCR  pshs    x
        bsr     SCROLL
        puls    x
        ldu     #$5E0
        stu     CURPOS
        rts
CHRCR   tfr     u,d
        andb    #$E0
        addd    #$20
        tfr     d,u
        bra     CHRPST
CHRBS   cmpu    #$400
        bne     CHRBS1
        rts
CHRBS1  leau    -1,u
        lda     #$60
        sta     ,u
        stu     CURPOS
        rts
        
CHROUT  pshs    u,d
        bsr     PUTCHR
        puls    u,d,pc

PRTMSG  lda     ,x+
        beq     PRTEND
        bsr     PUTCHR
        bra     PRTMSG
PRTEND  rts

CLS     ldx     #$400
        stx     CURPOS     
        lda     #$60
CLS1    sta     ,x+
        cmpx    #$600
        bne     CLS1
        rts

SCROLL  ldx     #$420
SCRLP   lda     ,x+
        sta     -33,x
        cmpx    #$600
        bne     SCRLP
        ldx     #$5E0
        lda     #$60
CLRLN   sta     ,x+
        cmpx    #$600
        bne     CLRLN
        rts

RDFIFO  lda     KEYSTAT         ; If either shift is pressed, set the KEYSHF flag
        lsla
        ora     KEYSTAT
        lsla
        anda    #KEYSHF
        pshs    a
        lda     KEYSTAT
        anda    #~KEYSHF
        ora     ,s+
        sta     KEYSTAT

        lda     $F001 // Bit 0 = EMPTY, Bit 1 = FULL
        coma
        bita    #$1 // ~Empty flag
        bne     rdkey
        rts
rdkey   lda     $F000

        cmpa    #$F0 // keyup
        bne     1$
        lda     KEYSTAT             ; Last code was keyup
        ora     #KEYUP
        sta     KEYSTAT
        bra     RDFIFO
1$      pshs    b
        ldb     #KEYLS
        cmpa    #$12 ; L-SHIFT
        bne     2$
3$      lda     KEYSTAT
        bita    #KEYUP
        beq     4$
        comb
        andb    KEYSTAT
        bra     5$
4$      orb     KEYSTAT
5$      stb     KEYSTAT
        puls    b
        ldb     KEYSTAT             ; Last code wasn't keyup
        andb    #~KEYUP
        stb     KEYSTAT
        bra     RDFIFO
2$      ldb     #KEYRS
        cmpa    #$59 ; R-SHIFT
        beq     3$
        ldb     KEYSTAT             ; Last code wasn't keyup
        bitb    #KEYUP
        beq     6$
        clra                        ; Ignore keyups
6$      andb    #~KEYUP
        stb     KEYSTAT
        puls    b
        tsta
        rts

POLCAT  jsr     RDFIFO
        bne     10$
        clra
        rts
10$     jsr     KeyCodeToASCII
        tsta
        rts

GREGMSG FCC     /Greg's 25Mhz 6809 Micro-Demo/
        FCB     13
        FCC     /Type:/
        FCB     13
        FCB     0
   
LKUP0
    FCB 13,9,9
    FCB 14,126,96


LKUP1
    FCB 21,81,113
    FCB 22,33,49
    FCB 26,90,122
    FCB 27,83,115
    FCB 28,65,97
    FCB 29,87,119
    FCB 30,64,50


TAB2
    FCB   0,0
    FCB   67,99
    FCB   88,120
    FCB   68,100
    FCB   69,101
    FCB   36,52
    FCB   35,51
    FCB   0,0
    FCB   0,0
    FCB   32,32
    FCB   86,118
    FCB   70,102
    FCB   84,116
    FCB   82,114
    FCB   37,53
    FCB   0,0


TAB3
    FCB   0,0
    FCB   78,110
    FCB   66,98
    FCB   72,104
    FCB   71,103
    FCB   89,121
    FCB   94,54
    FCB   0,0
    FCB   0,0
    FCB   0,0
    FCB   77,109
    FCB   74,106
    FCB   85,117
    FCB   38,55
    FCB   42,56
    FCB   0,0


TAB4
    FCB   0,0
    FCB   60,44
    FCB   75,107
    FCB   73,105
    FCB   79,111
    FCB   41,48
    FCB   40,57
    FCB   0,0
    FCB   0,0
    FCB   62,46
    FCB   63,47
    FCB   76,108
    FCB   58,59
    FCB   80,112
    FCB   95,45
    FCB   0,0


LKUP5
    FCB 82,34,39
    FCB 84,123,91
    FCB 85,43,61
    FCB 90,13,13
    FCB 91,125,93
    FCB 93,124,92


LKUP6
    FCB 102,8,8


LKUP7
    FCB 118,26,26


MasterLookup
    FDB  LKUP0,2
    FDB  LKUP1,7
    FDB  TAB2,0
    FDB  TAB3,0
    FDB  TAB4,0
    FDB  LKUP5,6
    FDB  LKUP6,1
    FDB  LKUP7,1        

KeyCodeToASCII
    pshs    a,x
    ldx     #MasterLookup
    lsra
    lsra
    anda    #$FC
    leax    a,x
    ldd     2,x
    beq     KeyTable
    lda     ,s
    ldx     ,x
LkUp
    tstb
    beq     KeyNotFound
    cmpa    ,x
    beq     KeyFound
    leax    3,x
    decb
    bra     LkUp
KeyFound
    puls    a
    lda     KEYSTAT
    bita    #KEYSHF
    beq     1$
    lda     1,x
    bra     2$
1$  lda     2,x
2$  puls    x,pc
KeyNotFound
    puls    a,x
    clra
    rts
KeyTable
    lda     ,s
    anda    #$f
    lsla
    ldx     ,x
    leax    a,x
    puls    a
    lda     KEYSTAT
    bita    #KEYSHF
    beq     3$ 
    lda     ,x
    bra     4$
3$  lda     1,x
4$  puls    x,pc

    

    org     $a3f0
    fdb     start
    fdb     start
    fdb     start
    fdb     start
    fdb     start
    fdb     start
    fdb     start
    fdb     start
