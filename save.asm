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

BLOCK_CHAR = $a0
SPACEY = $20
UPPERSCORE_CHAR = $45

SAVE_MODE = #0
LOAD_MODE = #1
save_load_mode: .byte $01

MAX_BLINKS = #25
blink_count: .byte $00
blink_chars: .byte BLOCK_CHAR, SPACEY
blink_chars_index: .byte $00

restart: .byte $00

filename_screen_index: .byte $00
is_saving: .byte $00
mode_1515_value: .byte $00

SAVE_STATES_COUNT = #2
SAVE_WORLD_COLOR = #0
SAVE_CHARSET = #1
save_mode: .byte 0

LOAD_STATES_COUNT = #2
LOAD_WORLD_COLOR = #0
LOAD_CHARSET = #1
load_mode: .byte 0

MAX_SAVING_DOTS = #3
saving_dots_index: .byte $00

.enc "screen"
block: .byte BLOCK_CHAR
block_end:
save_title: .byte BLOCK_CHAR
	    .text " save to file "
	    .byte BLOCK_CHAR
save_title_end:
load_title: .byte BLOCK_CHAR
	    .text " load from file "
	    .byte BLOCK_CHAR
load_title_end:
mode_1515: .text "mode 1515"
mode_1515_end:
mode_full: .text "mode full"
mode_full_end:
save_world_color: .text   " save world + color"
save_world_color_end:
save_charset: .text       "    save charset   "
save_charset_end:
load_world_color: .text   " load world + color"
load_world_color_end:
load_charset: .text       "    load charset   "
load_charset_end:
underscore: .fill 16, UPPERSCORE_CHAR
underscore_end:
filename_screen: .text "                 "
filename_screen_end:
saving: .text "saving"
saving_end:
loading: .text "loading"
loading_end:
file_saved: .text "file saved"
file_saved_end:
file_loaded: .text "file loaded"
file_loaded_end:
file_error: .text "error 53  "
file_error_end:
blank_string: .text "                "
blank_string_end:
.enc "none"

.include "1515_data.asm"

go_print_string .macro
	mova $fd, #<\1
	mova $fe, #>\1
	mova x_pos, \2
	mova y_pos, \3
	ldx #\1_end - \1 - 1
	jsr print_string
.endm

print_string:
	jsr load_screen_bytes_into_fb
	txa
	tay

-	lda ($fd), y
	sta ($fb), y
	dey
	bpl -
	rts

convert_letter_to_screen_code:
	sec
	sbc #64
	rts

;; petscii value in accumulator
;; output in same
convert_petscii_to_screen_code:
	cmp #58
	bcs convert_letter_to_screen_code
	rts

add_character:
	tay
	cmpa #filename_screen_end - filename_screen - 1, filename_screen_index
	rtseq
	ldx filename_screen_index
	tya
	sta filename_petscii, x
	jsr convert_petscii_to_screen_code
	ldx filename_screen_index
	sta filename_screen, x
	inc filename_screen_index
	;; make blink active
	mova blink_count, MAX_BLINKS
	rts

erase_character:
	cmpa filename_screen_index, #0
	rtseq
	ldx filename_screen_index
	stay filename_screen, x, SPACE_CHAR
	dec filename_screen_index
	dex
	stay filename_screen, x, SPACE_CHAR
	;; make blink active
	mova blink_count, MAX_BLINKS
	rts

;; save
handle_enter:
	;; check if there's nothing to save
	cmpa #0, filename_screen_index
	rtseq

	cmpa SAVE_MODE, save_load_mode
	beq do_save_file
	jmp do_load_file

setup_save_mode_data:
        cmpa save_mode, SAVE_WORLD_COLOR
        bne +
        mova $fb, #<world
	mova $fc, #>world
        ldx #<world_color_end
        ldy #>world_color_end
        rts
+       ;; save just charset
        mova $fb, #DESTINATION_BYTES_START_LOW
	mova $fc, #DESTINATION_BYTES_START_HIGH
        ldx #<destination_bytes_end
        ldy #>destination_bytes_end
        rts

do_save_file:
	mova is_saving, #1
	mova blink_count, MAX_BLINKS

	go_print_string blank_string, #4, #26
	go_print_string saving, #6, #26

	lda filename_screen_index
	clc
	adc #filename_petscii_preamble_end - filename_petscii_preamble
        ldx #<filename_petscii_preamble
        ldy #>filename_petscii_preamble
        jsr $ffbd ;; setnam

        lda #0
        ldx #9
        ldy #0
        jsr $ffba ;; setlfs

        jsr $ffc0 ;; open for writing

        jsr setup_save_mode_data
	lda #$fb ;; start address
        jsr $ffd8

        bcc +
	go_print_string file_error, #5, #22
        jmp endy
+	go_print_string blank_string, #3, #22
        go_print_string file_saved, #5, #26
endy:
        jsr $ffe7 ;; close everything
	mova is_saving, #0
	mova blink_count, MAX_BLINKS
	rts

setup_load_mode_data:
        cmpa load_mode, LOAD_WORLD_COLOR
        bne +
        ldx #<world
        ldy #>world
        rts
+       ;; load just charset
        ldx #DESTINATION_BYTES_START_LOW
	ldy #DESTINATION_BYTES_START_HIGH
        rts

setup_load_1515_mode_data:
        ldx #<save_file_1515_start
        ldy #>save_file_1515_start
        rts

do_load_file:
        lda mode_1515_value
        cmp #1
        bne +
        jmp load_1515
+       jmp load_full

load_preamble:
        mova is_saving, #1
	mova blink_count, MAX_BLINKS

	go_print_string blank_string, #4, #26
	go_print_string loading, #6, #26

	lda filename_screen_index
	clc
	adc #filename_petscii_preamble_end - filename_petscii_preamble
        ldx #<filename_petscii_preamble
        ldy #>filename_petscii_preamble
        jsr $ffbd ;; setnam

        lda #0
        ldx #9
        ldy #0
        jsr $ffba ;; setlfs

        jsr $ffc0 ;; open for reading
        rts

load_full:
        jsr load_preamble
        jsr setup_load_mode_data
        lda #0

        jsr $ffd5
        bcc +
        go_print_string file_error, #6, #22
        jmp endy
+       go_print_string blank_string, #3, #22
        go_print_string file_loaded, #4, #26
        jsr initialize_world_outters
        jmp endy

load_1515:
        jsr load_preamble
        jsr setup_load_1515_mode_data

        lda #0
        jsr $ffd5
        bcc +
        go_print_string file_error, #6, #22
        jmp endy
+       go_print_string blank_string, #3, #22
        go_print_string file_loaded, #4, #26
        jsr initialize_world_outters
        jsr convert_1515_to_full
        jmp endy

convert_1515_to_full:
        sei
        copy_2048 #DESTINATION_BYTES_START_HIGH, #DESTINATION_BYTES_START_LOW, #>character_bytes_1515, #<character_bytes_1515
        pusha x_pos
        pusha y_pos
        mova x_pos, #3
        mova y_pos, #8
        ldx #0
-       jsr load_world_bytes_into_d9
-       lda world_1515, x
        sta ($d9), y
        inx
        iny
        cpy #15
        bne -

        inc y_pos
        inc y_pos
        cmpa y_pos, #38
        bne --

        mova x_pos, #3
        mova y_pos, #8
        ldx #0
-       jsr load_world_color_bytes_into_d9
-       lda world_1515_color, x
        sta ($d9), y
        inx
        iny
        cpy #15
        bne -
        inc y_pos
        inc y_pos
        cmpa y_pos, #38
        bne --
        pulla y_pos
        pulla x_pos
        cli
        rts

jsra .macro
	cmp \1
	bne +
	jsr \2
	jmp -
	+
.endm

print_save_title:
	go_print_string save_title, #2, #2
	rts

print_load_title:
	go_print_string load_title, #1, #2
	rts

print_1515_mode:
        go_print_string mode_1515, #5, #38
	rts

print_full_mode:
        go_print_string mode_full, #5, #38
	rts

increment_load_mode:
        cmpa save_load_mode, LOAD_MODE
        rtsne

        inc load_mode
        cmpa load_mode, LOAD_STATES_COUNT
        bne +
        mova load_mode, #0
+       jmp print_load_mode

increment_save_mode:
        cmpa save_load_mode, SAVE_MODE
        rtsne

        inc save_mode
        cmpa save_mode, SAVE_STATES_COUNT
        bne +
        mova save_mode, #0
+       jmp print_save_mode

toggle_load_1515_mode:
        cmpa save_load_mode, SAVE_MODE
        rtseq

        lda mode_1515_value
        eor #1
        sta mode_1515_value
        jsr print_load_1515_mode_or_not

print_load_1515_mode_or_not:
        lda mode_1515_value
        cmp #1
        bne +
        jmp print_1515_mode
+       jmp print_full_mode

print_load_stuff:
        jsr print_load_title
        jsr print_load_1515_mode_or_not
        jmp print_load_mode

print_save_stuff:
        jsr print_save_title
        jsr print_save_mode
        rts

print_load_mode:
+       cmpa load_mode, LOAD_WORLD_COLOR
        bne +
        jmp print_load_world_color_mode
+       ;; just charset
        jmp print_load_charset_mode

print_save_mode:
        cmpa save_mode, SAVE_WORLD_COLOR
        bne +
        jmp print_save_world_color_mode
+       ;; just charset
        jmp print_save_charset_mode

print_save_world_color_mode:
        go_print_string save_world_color, #0, #34
	rts

print_save_charset_mode:
        go_print_string save_charset, #0, #34
	rts

print_load_world_color_mode:
        go_print_string load_world_color, #0, #34
	rts

print_load_charset_mode:
        go_print_string load_charset, #0, #34
	rts

save_file:
	mova save_load_mode, SAVE_MODE
	jmp save_or_load_file

load_file:
	mova save_load_mode, LOAD_MODE
	jmp save_or_load_file

;; entry point
save_or_load_file:
        ;; reset and save old characters
	pusha $9005
	anda $9005, #240

	jsr set_screen_colors
	jsr clear_screen
	color_chars foreground_color

	;; clear inputs
-       jsr $ffe4
	bne -

	mova blink_count, MAX_BLINKS

        enable_timer_a save_load_irq, TIMER_VALUE

	go_print_string underscore, #2, #14
	cmpa SAVE_MODE, save_load_mode
	jsreq print_save_stuff
	cmpa LOAD_MODE, save_load_mode
        bne +
        jsr print_load_stuff

+
-       jsr $ffe4
	beq -

	cmp #3 ;; escape
	jmpeq done
	jsra #13, handle_enter ;; enter
	jsra #20, erase_character ;; del
        jsra #134, toggle_load_1515_mode ;; f3
        jsra #135, increment_save_mode ;; f5
        jsra #136, increment_load_mode ;; f7
        jsr add_character
	jmp -

done:
	safe_enable_timer_a do_no_irq, TIMER_VALUE
        ;; restore characters
	pulla $9005
	rts

save_load_irq:
	go_print_string filename_screen, #2, #12

	inc blink_count
	cmpa MAX_BLINKS, blink_count
	jcc $eabf

	cmpa is_saving, #1
	jsreq increment_progress_border
	cmpa is_saving, #0
	jsreq blacken_border

	mova blink_count, #0

	;; toggle index between 1 and 0
	lda #1
	eor blink_chars_index
	sta blink_chars_index

	ldx blink_chars_index
	lda blink_chars, x
	ldx filename_screen_index
	sta filename_screen, x
        jmp $eabf

blacken_border:
	lda $900f
	and #%11111000
	sta $900f
	rts

increment_progress_border:
	lda $900f
	and #%00000111
	clc
	adc #1
	and #%00000111
	tay
	lda $900f
	and #%11111000
	sta $900f
	tya
	ora $900f
	sta $900f
	rts
