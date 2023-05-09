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

create_timer .segment
        \1_timer_counter: .byte $00
        \1_timer_state: .byte $00
        \1_timer_max: .byte \2
.endm

create_dual_state_timer .segment
        \1_timer_counter: .byte $00
        \1_timer_state: .byte $01
        \1_timer_maxes: .byte \2, \3
.endm

create_tri_state_timer .segment
        \1_timer_counter: .byte $00
        \1_timer_state: .byte $02
        \1_timer_maxes: .byte \2, \3, \4
.endm

check_timer .macro
        lda \1_timer_counter
        cmp #255 ;; disabled
        beq +
        inc \1_timer_counter
        lda \1_timer_counter
        cmp \1_timer_max
        bcc +
        mova \1_timer_counter, #0
        jsr \2
        +
.endm

inc_tri_state:
        inc $d9
        lda $d9
        cmp #3
        bne +
        lda #0
        sta $d9
        +
        rts

check_tri_state_timer .macro
        lda \1_timer_counter
        cmp #255 ;; disabled
        beq +
        inc \1_timer_counter
        lda \1_timer_counter
        ldx \1_timer_state
        cmp \1_timer_maxes, x
        bcc +
        lda #0
        sta \1_timer_counter
        lda \1_timer_state
        sta $d9
        jsr inc_tri_state
        lda $d9
        sta \1_timer_state
        jsr \2
        +
.endm

check_dual_state_timer .macro
        lda \1_timer_counter
        cmp #255 ;; disabled
        beq +
        inc \1_timer_counter
        lda \1_timer_counter
        ldx \1_timer_state
        cmp \1_timer_maxes, x
        bcc +
        lda #0
        sta \1_timer_counter
        lda \1_timer_state
        eor #1
        sta \1_timer_state
        jsr \2
        +
.endm

check_dual_state_sticky_timer .macro
        lda \1_timer_counter
        cmp #255 ;; disabled
        beq +
        inc \1_timer_counter
        lda \1_timer_counter
        ldx \1_timer_state
        cmp \1_timer_maxes, x
        bcc +
        lda #0
        sta \1_timer_counter
        lda \1_timer_state
        cmp #1
        beq +
        eor #1
        sta \1_timer_state
+       jsr \2
.endm

check_tri_state_sticky_timer .macro
        lda \1_timer_counter
        cmp #255 ;; disabled
        bne +
        jmp tri_state_out
+       inc \1_timer_counter
        lda \1_timer_counter
        ldx \1_timer_state
        cmp \1_timer_maxes, x
        bcc +
        lda #0
        sta \1_timer_counter
        lda \1_timer_state
        cmp #1
        beq +
        sta $d9
        jsr inc_tri_state
        lda $d9
        sta \1_timer_state
+       jsr \2
tri_state_out:
.endm

increment_counter .macro
        inc \1
        lda \1
        cmp \2
        bcc +
        lda #0
        sta \1
        +
.endm

increment_counter_callback .macro
        inc \1
        lda \1
        cmp \2
        bcc +
        lda #0
        sta \1
        jsr \3
        +
.endm

disable_timer .macro
        lda #255
        sta \1_timer_counter
.endm

trigger_timer .macro
        lda \1_timer_max
        sta \1_timer_counter
.endm

trigger_dual_state_timer .macro
        ldx \1_timer_state
        lda \1_timer_maxes, x
        sta \1_timer_counter
.endm

enable_timer .macro
        lda #255
        cmp \1_timer_counter
        bne +
        lda #0
        sta \1_timer_counter
        +
.endm

trigger_enable_timer .macro
        lda #255
        cmp \1_timer_counter
        bne +
        lda \1_timer_max
        sta \1_timer_counter
        +
.endm

reset_timer .macro
        lda #0
        sta \1_timer_counter
.endm

;; param 1: irq label
;; param 2: timer value
safe_enable_timer_a .macro
	cli
	enable_timer_a \1, \2
	sei
.endm

;; param 1: irq label
;; param 2: timer value
enable_timer_a .macro
	lda #<\1
	sta $fb
	lda #>\1
	sta $fc

	lda #<\2
	sta $fd
	lda #>\2
	sta $fe

	jsr enable_timer_a_helper
.endm

push_timer_values .macro
	pusha $912e
	pusha $912d
	pusha $911e
	pusha $911b
	pusha $912b
	pusha $9116
	pusha $9126
	pusha $9125
	pusha $314
	pusha $315
.endm

pull_timer_values .macro
	pulla $315
	pulla $314
	pulla $9125
	pulla $9126
	pulla $9116
	pulla $912b
	pulla $911b
	pulla $911e
	pulla $912d
	pulla $912e
.endm

enable_timer_a_helper:
    ;; sync timer to raster line
    ldx #118
-   cpx $9004
    bne -

    lda #$7f
    sta $912e     ; disable and acknowledge interrupts
    sta $912d
    sta $911e     ; disable NMIs (Restore key)

    lda #$40      ; enable Timer A free run of both VIAs
    sta $911b
    sta $912b

    lda $fd
    ldx $fe
    sta $9116     ; load the timer low byte latches
    sta $9126
    stx $9125     ; start the IRQ timer A

    mova $314, $fb   ; set the raster IRQ routine pointer
    mova $315, $fc
    mova $912e, #$c0 ; enable Timer A underflow interrupts
    rts
