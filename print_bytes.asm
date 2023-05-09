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

.enc "screen"
bytes_for: .text "bytes for"
bytes_for_end:
hex_values: .text "0123456789abcdef"
.enc "none"

char_pointer_backup: .byte $00

pb_key_handlers:=(
    do_nothing, ;; left shift
    do_nothing, ;; right shift
    do_nothing, ;; space
    pb_minus_char, ;; colon
    pb_plus_char, ;; semicolon
    do_nothing, ;; w
    do_nothing, ;; a
    do_nothing, ;; s
    do_nothing, ;; d
    do_nothing, ;; c
    do_nothing, ;; p
    do_nothing, ;; k
    do_nothing, ;; b
    do_nothing, ;; u
    do_nothing, ;; f5 ;; save
    do_nothing, ;; f7 ;; load
    increment_foreground, ;; f
    increment_background, ;; g
    increment_border, ;; h
    pb_minus_char_extra, ;; at
    pb_plus_char_extra, ;; star
    handle_escape, ;; e
    do_nothing, ;; cursor down
    do_nothing, ;; cursor up
    do_nothing, ;; cursor right
    do_nothing, ;; cursor left
    pb_handle_flip, ;; z
    do_nothing, ;; 1
    do_nothing, ;; 2
    do_nothing, ;; 3
    do_nothing, ;; 4
    do_nothing, ;; 5
    do_nothing, ;; 6
    do_nothing, ;; 7
    do_nothing, ;; 8
    do_nothing, ;; 9
    do_nothing, ;; 0
    do_nothing, ;; m
    do_nothing, ;; t
    prepare_full_new, ;; f1
    prepare_partial_new, ;; f3
    do_nothing, ;; y
    do_nothing, ;; o
    do_nothing, ;; x
    do_nothing, ;; n
    do_nothing, ;; enter
    handle_escape, ;; escape
    handle_escape ;; run-stop
)-1

pb_key_handlers_hi .byte >pb_key_handlers
pb_key_handlers_lo .byte <pb_key_handlers

;; y is offset to ($fb)
print_fe_as_hex_at_fb:
        pusha $fe
        pusha $fe
        lsr $fe
        lsr $fe
        lsr $fe
        lsr $fe
        ldx $fe
        lda hex_values, x
        sta ($fb), y
        iny
        pulla $fe
        anda $fe, #%00001111
        ldx $fe
        lda hex_values, x
        sta ($fb), y
        iny
        iny
        pulla $fe
        rts

print_fd_at_fb:
        ;; print index
        lda #"0"
        clc
        adc $fd
        sta ($fb), y
        iny
        iny
        rts

print_bytes_for:
        go_print_string bytes_for, #3, #2
        mova x_pos, #13
        mova y_pos, #2
        jsr load_screen_bytes_into_fb
        mova $fe, current_character
        jsr print_fe_as_hex_at_fb
        lda current_character
        sta ($fb), y
        rts

print_current_character:
        jsr print_bytes_for

        mova x_pos, #4
        mova y_pos, #10
        jsr load_screen_bytes_into_fb
        mova $2c, #0
        mova $2b, current_character

        ;; multiply by 8
        ldx #3
-       asl $2b
        rol $2c
        dex
        bne -

        mova $fd, #DESTINATION_BYTES_START_HIGH
        mova $fe, #00

        lda $fe
        clc
        adc $2b
        sta $2b

        lda $fd
        adc $2c
        sta $2c

        mova $fd, #0 ;; index on the far left
        ldy #0
-       lda ($2b), y
        sta $fe

        ldy #0 ;; y in now an index into the output

        ;; print index
        jsr print_fd_at_fb
        inc $fd

        ;; print hex then binary
        jsr print_fe_as_hex_at_fb

-       asl $fe
        bcc +
        lda #"1"
        jmp p1
+       lda #"0"
p1:     sta ($fb), y
        iny
        cpy #13
        bne -

        inc y_pos
        inc y_pos
        jsr load_screen_bytes_into_fb

        ldy $fd
        cpy #8
        bne --
        rts

char_updated:
        jsr print_current_character
        jsr plot_characters
        rts

pb_plus_char:
        jsr plus_char
        jmp char_updated

pb_minus_char:
        jsr minus_char
        jmp char_updated

pb_plus_char_extra:
        jsr plus_char_extra
        jmp char_updated

pb_minus_char_extra:
        jsr minus_char_extra
        jmp char_updated

pb_handle_flip:
        jsr handle_flip
        jmp char_updated

pb_handle_keys:
        handle_keys pb_key_handlers
        rts

reset_print_bytes:
        pulla $9005
        jmp print_bytes

;; entry point
print_bytes:
        ;; reset and save old characters
        mova char_pointer_backup, $9005
	pusha $9005
	anda $9005, #240

        enable_timer_a pb_irq, TIMER_VALUE

	jsr set_screen_colors
	jsr clear_screen
	color_chars foreground_color
        jsr char_updated

	;; clear inputs
-       jsr $ffe4
	bne -

-       jsr read_key

        cmpa do_escape, #1
        beq +

        cmpa full_new_state, DO_FULL_NEW_STATE
        jmpeq reset_print_bytes

        cmpa partial_new_state, DO_PARTIAL_NEW_STATE
        jmpeq reset_print_bytes

        jmp -

        ;; restore characters
+       mova do_escape, #0
        pulla $9005
	rts

pb_irq:
        handle_keys pb_key_handlers
        jmp $eabf
