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

LEFT_SHIFT = 0
RIGHT_SHIFT = 1
SPACE_KEY = 2
COLON_KEY = 3
SEMICOLON_KEY = 4
W_KEY = 5
A_KEY = 6
S_KEY = 7
D_KEY = 8
C_KEY = 9
P_KEY = 10
K_KEY = 11
B_KEY = 12
U_KEY = 13
F5_KEY = 14
F7_KEY = 15
F_KEY = 16
G_KEY = 17
H_KEY = 18
AT_KEY = 19
STAR_KEY = 20
E_KEY = 21
CURSOR_DOWN = 22
CURSOR_UP = 23
CURSOR_RIGHT = 24
CURSOR_LEFT = 25
Z_KEY = 26
ONE_KEY = 27
TWO_KEY = 28
THREE_KEY = 29
FOUR_KEY = 30
FIVE_KEY = 31
SIX_KEY = 32
SEVEN_KEY = 33
EIGHT_KEY = 34
NINE_KEY = 35
ZERO_KEY = 36
M_KEY = 37
T_KEY = 38
F1_KEY = 39
F3_KEY = 40
Y_KEY = 41
O_KEY = 42
X_KEY = 43
N_KEY = 44
RETURN_KEY = 45
ESCAPE_KEY = 46
RUN_STOP_KEY = 47

REPEATS_SIZE = #3
max_down_delay: .byte 20

repeats: .byte $00
repeat_index: .byte $00
repeat_delays: .byte $4, $3, $02
repeat_delay: .byte $00
max_delay: .byte $1e
move_along: .byte $00

key_reads: .byte LEFT_SHIFT, 247, 253
           .byte RIGHT_SHIFT, 239, 191
           .byte W_KEY, 253, 253
           .byte P_KEY, 253, 223
           .byte A_KEY, 251, 253
           .byte D_KEY, 251, 251
           .byte G_KEY, 251, 247
           .byte SEMICOLON_KEY, 251, 191
           .byte S_KEY, 223, 253
           .byte F_KEY, 223, 251
           .byte H_KEY, 223, 247
           .byte K_KEY, 223, 239
           .byte COLON_KEY, 223, 223
           .byte SPACE_KEY, 239, 254
           .byte C_KEY, 239, 251
           .byte B_KEY, 239, 247
           .byte U_KEY, 191, 247
           .byte F5_KEY, 191, 127
           .byte F7_KEY, 127, 127
           .byte AT_KEY, 191, 223
           .byte STAR_KEY, 253, 191
           .byte E_KEY, 191, 253
           .byte CURSOR_DOWN, 247, 127
           .byte CURSOR_UP, 247, 127
           .byte CURSOR_RIGHT, 251, 127
           .byte CURSOR_LEFT, 251, 127
           .byte Z_KEY, 239, 253
           .byte ONE_KEY, 254, 254
           .byte ONE_KEY, 254, 254
           .byte TWO_KEY, 127, 254
           .byte THREE_KEY, 254, 253
           .byte FOUR_KEY, 127, 253
           .byte FIVE_KEY, 254, 251
           .byte SIX_KEY, 127, 251
           .byte SEVEN_KEY, 254, 247
           .byte EIGHT_KEY, 127, 247
           .byte NINE_KEY, 254, 239
           .byte ZERO_KEY, 127, 239
           .byte M_KEY, 239, 239
           .byte T_KEY, 191, 251
           .byte F1_KEY, 239, 127
           .byte F3_KEY, 223, 127
           .byte Y_KEY, 253, 247
           .byte O_KEY, 191, 239
           .byte X_KEY, 247, 251
           .byte N_KEY, 247, 239
           .byte RETURN_KEY, 253, 127
           .byte ESCAPE_KEY, 253, 254
           .byte RUN_STOP_KEY, 247, 254
key_reads_end:

NO_KEY_NAUGHT = $ff
NO_KEY = #NO_KEY_NAUGHT

keys_down: .fill 2, NO_KEY_NAUGHT
keys_down_end:
keys_down_index: .byte $00
down_delay: .byte $00
keys_read_index: .byte $00

add_key:
        sty $fc ;; now $fc has the key
        cmpa keys_down_index, #keys_down_end - keys_down
        rtseq

        jsr key_reader_special_callback

+       cmpa $fc, #RIGHT_SHIFT
        bne +
        mova $fb, #1 ;; shift is on
        rts ;; try again

+       cmpa $fc, #LEFT_SHIFT
        bne +
        mova $fb, #1 ;; shift is on
        rts ;; try again

+       cmpa $fc, #CURSOR_DOWN
        bne +
        clc
        adc $fb ;; go to CURSOR_UP
        sta $fc

+       cmpa $fc, #CURSOR_RIGHT
        bne +
        clc
        adc $fb ;; go to CURSOR_LEFT
        sta $fc

+	;; clear the keyboard buffer
-       jsr $ffe4
        bne -

        ldy keys_down_index
        lda $fc
        cmp keys_down, y
        sta keys_down, y
        jsrne reset_key_delays
        inc keys_down_index
        rts

read_key:
        sei
        mova $fb, #0 ;; shift is not down... yet
        mova keys_down_index, #0
        ldx #0

-       ldy key_reads, x ;; y now has the key
        inx
        lda key_reads, x
        sta $9120
        inx
        lda key_reads, x
        inx

        cmp $9121
        jsreq add_key

        cpx #key_reads_end - key_reads
        bcc -

        cmpa keys_down_index, #0
        jsreq reset_key_delays

        cli
        rts

reset_key_delays:
        mova down_delay, #0
        mova max_delay, #0 ;; harvest keypress immediately
        mova repeat_delay, repeats
        mova repeats, #0
        mova repeat_index, #0
        mova move_along, #0
        rts

handle_keys .macro
	cmpa #0, keys_down_index
        jeq $eabf ;; out

        inc repeats
        cmpa #35, repeats
        bcc +
        mova repeats, #0
        mova move_along, #1

+       inc down_delay
        cmpa max_delay, down_delay
        jcc $eabf ;; out
        mova down_delay, #0

        cmpa max_down_delay, max_delay
        jsreq start_key_repeat
        cmpa max_delay, #0
        jsreq set_max_delay_to_max

        mova keys_read_index, #0

key_read_loop:
        pusha >#handle_keys_after-1
        pusha <#handle_keys_after-1

        ldy keys_read_index
        ldx keys_down, y
        pushax \1_hi,x
        pushax \1_lo,x
        rts ;; jump

handle_keys_after:
	cmpa move_along, #0
        jeq $eabf

        mova move_along, #0
        mova repeats, #0
        cmpa REPEATS_SIZE, repeat_index
        jcs $eabf
        movayy max_delay, repeat_delays, repeat_index
        inc repeat_index

        inc keys_read_index
        cmpa keys_read_index, keys_down_index
        bne key_read_loop
.endm

set_max_delay_to_max:
        mova max_delay, max_down_delay
        rts

start_key_repeat:
        movayy max_delay, repeat_delays, repeat_index
        rts
