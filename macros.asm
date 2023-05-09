;;
;; This file is part of tiler, a tileset and scene editor for the VIC20
;; Copyright (C) 2023 Nate Smith (nat2e.smith@gmail.com)
;;
;; tiler is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Lesser General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; tiler is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Lesser General Public License for more details.
;;
;; You should have received a copy of the GNU Lesser General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;

to_zero_or_one .macro
        and #1
        clc
        adc #48
.endm

mova .macro
        lda \2
        sta \1
.endm

rtscs .macro
        bcc +
        rts
        +
.endm

anda .macro
        lda \1
        and \2
        sta \1
.endm

rtseq .macro
        bne +
        rts
        +
.endm

rtsne .macro
        beq +
        rts
        +
.endm

movy .macro
        ldy \2
        sty \1
.endm

movay .macro
        lda \2,\3
        sta \1
.endm

movayy .macro
        ldy \3
        lda \2, y
        sta \1
.endm

stay .macro
        lda \3
        sta \1,\2
.endm

phx .macro
        txa
        pha
.endm

plx .macro
        pla
        tax
.endm

phy .macro
        tya
        pha
.endm

ply .macro
        pla
        tay
.endm

pusha .macro
        lda \1
        pha
.endm

pushax .macro
        lda \1,\2
        pha
.endm

pulla .macro
        pla
        sta \1
.endm

cmpa .macro
        lda \2
        cmp \1
.endm

cmpax .macro
        lda \1, \2
        cmp \3
.endm

adda .macro
        clc
        lda \1
        adc \2
.endm

addas .macro
        lda \1
        adc \2
        sta \1
.endm

a8 .macro
        lda \1
        clc
        adc \2
        sta \1
.endm

s16 .macro
        lda \1
        sec
        sbc \3
        sta \1
        lda \2
        sbc #0
        sta \2
.endm

rol16 .macro
        asl \1
        rol \2
.endm

a16 .macro
        lda \1
        clc
        adc \3
        sta \1
        bcc +
        inc \2
        +
.endm

eora .macro
        lda \1
        eor \2
        sta \1
.endm

flip_flop .macro
        lda \1
        eor #1
        sta \1
.endm

;; "modulus" incorporated
minc .macro
        inc \1
        lda \1
        and \2 - 1
        sta \1
.endm

c16 .macro
        mova \1, \3
        mova \2, \4
.endm

incy .macro
        ldy \1
        iny
        sty \1
.endm

caddas .macro
        clc
        lda \1
        adc \2
        sta \1
.endm

addac .macro
        lda \1
        clc
        adc \2
        sta \1
.endm

ina .macro
        clc
        adc #1
.endm

dea .macro
        sec
        sbc #1
.endm

jcc .macro
        bcs +
        jmp \1
        +
.endm

jcs .macro
        bcc +
        jmp \1
        +
.endm

jsreq .macro
        bne +
        jsr \1
        +
.endm

jsrne .macro
        beq +
        jsr \1
        +
.endm

jmpeq .macro
        bne +
        jmp \1
        +
.endm

jeq .macro
        bne +
        jmp \1
        +
.endm

jne .macro
        beq +
        jmp \1
        +
.endm

load_ptr .macro
        mova \1, #<\2
        mova \1 + 1, #>\2
.endm

load_ptr_plus .macro
        mova \1, \2
        mova \1 + 1, \2 + 1
.endm

def_string .segment
        \1: .text \2
        \1_end:
.endm
