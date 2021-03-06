*      stack u, ret, c, long

 section bss
buf1 rmb 20
 endsect


 section rodata
ldectbl fdb $3b9a,$ca00
 fdb $05f5,$e100
 fdb $0098,$9680
 fdb $000f,$4240
 fdb $0001,$86a0
 fdb $0000,10000
 fdb $0000,1000
 fdb $0000,100
 fdb $0000,10
 endsect

 section code

_pflinit EXPORT
_pflinit: rts


_pflong EXPORT
_pflong: pshs u
 leau buf1,y
 pshs u
 ldb 4+2+1,s
switch cmpb #'d
 beq case_d
 cmpb #'o
 beq case_o
 cmpb #'x
 beq case_x
 cmpb #'X
 beq case_x
 lda #'l
 std ,u++
pflxit clr ,u
 puls d,u,pc
 pag
case_o leax 8,s *long
case_o1 ldb 3,x
 andb #$07
 addb #'0
 stb ,u+
 ldb #3
 bsr fshifts
 bne case_o1
 bra case_x3


fshifts lsr 0,x
 ror 1,x
 ror 2,x
 ror 3,x
 decb
 bne fshifts
 lda 0,x
 ora 1,x
 ora 2,x
 ora 3,x
 rts


case_x andb #$20 lower case bit
 pshs b
 leax 9,s
case_x1 ldb 3,x
 andb #$0f
 pshs b
 lda #'0
 cmpb #9
 ble case_x2
 lda #'A-10
 adda 1,s
case_x2 adda ,s+
 sta ,u+
 ldb #4
 bsr fshifts
 bne case_x1
 leas 1,s
case_x3 ldx ,s
 clr ,u
frevers EXTERNAL
 lbsr frevers
 puls d,u,pc

case_d ldb 8,s
 bpl case_d4
 ldd #0
 subd 10,s
 std 10,s
 ldd #0
 sbcb 9,s
 sbca 8,s
 std 8,s
 cmpd #$8000
 bne case_d3
 ldd 2,x
 bne case_d3
 leax >tminlong,pcr
case_d2 lda ,x+
 sta ,u+
 bne case_d2
case_d1 lbra pflxit

case_d3 ldb #'-
 stb ,u+
case_d4 leax ldectbl,pcr
 clra
 ldb #10
 pshs a
 pshs d
 bra case_d11

case_d7 inc ,s
case_d8 ldd 13,s
 subd 2,x
 std 13,s
 ldd 11,s
 sbcb 1,x
 sbca 0,x
 std 11,s
 bcc case_d7
 ldd 13,s
 addd 2,x
 std 13,s
 ldd 11,s
 adcb 1,x
 adca 0,x
 std 11,s
 ldb ,s
 tst 2,s
 bne case_d9
 tstb
 beq case_d10
 inc 2,s
case_d9 addb #'0
 stb ,u+
case_d10 leax 4,x
 clr ,s
case_d11 dec 1,s
 bne case_d8
 ldb 14,s
 addb #'0
 stb ,u+
 leas 3,s
 bra case_d1


tminlong fcc '-2147483648'
 fcb 0

 endsect
