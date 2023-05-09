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

EXTRA_MOVE_AMOUNT = #5

SMALL_SIZE = #1
LARGE_SIZE = #2

SMALL_Y_START = #8
SMALL_Y_END = #22
SMALL_X_START = #7
SMALL_X_END = #14
SMALL_WIDTH = #8
SMALL_HEIGHT = #8

FOUR_WIDTH = SMALL_WIDTH * 2
FOUR_HEIGHT = SMALL_HEIGHT * 2

;; grid by variables below:
;; 12
;; 03

FOUR_Y_START_0 = 20
FOUR_Y_END_0 = 34
FOUR_X_START_0 = 3
FOUR_X_END_0 = 10

FOUR_Y_START_1 = 4
FOUR_Y_END_1 = 18
FOUR_X_START_1 = 3
FOUR_X_END_1 = 10

FOUR_Y_START_2 = 4
FOUR_Y_END_2 = 18
FOUR_X_START_2 = 11
FOUR_X_END_2 = 18

FOUR_Y_START_3 = 20
FOUR_Y_END_3 = 34
FOUR_X_START_3 = 11
FOUR_X_END_3 = 18

four_coords_start_x: .byte FOUR_X_START_1, FOUR_X_START_0, FOUR_X_START_3, FOUR_X_START_2
four_coords_start_y: .byte FOUR_Y_START_1, FOUR_Y_START_0, FOUR_Y_START_3, FOUR_Y_START_2
four_coords_end_x: .byte FOUR_X_END_1, FOUR_X_END_0, FOUR_X_END_3, FOUR_X_END_2
four_coords_end_y: .byte FOUR_Y_END_1, FOUR_Y_END_0, FOUR_Y_END_3, FOUR_Y_END_2
four_coords_0_offset: .byte 1, 0, 2, 3
four_coords_1_offset: .byte 0, 5, 7, 2
four_coords_2_offset: .byte 5, 4, 6, 7
four_coords_0_lohi_offset: .byte 8, 0, 16, 24
four_coords_1_lohi_offset: .byte 0, 40, 56, 16
four_coords_2_lohi_offset: .byte 40, 32, 48, 56
four_coords_start_y_in_order: .byte FOUR_Y_START_0, FOUR_Y_START_1, FOUR_Y_START_2, FOUR_Y_START_3
four_coords_offset: .byte $00 ;; 0, 1, 2

SMALL_DISPLAY_MODE = #0
FOUR_DISPLAY_MODE = #1
display_mode: .byte $00

x_start: .byte $00
y_start: .byte $00
x_end: .byte $00
y_end: .byte $00
x_end_next: .byte $00
y_end_next: .byte $00

x_start_max: .byte $00
x_end_max: .byte $00
y_start_max: .byte $00
y_end_max: .byte $00

BLANK_CURSOR_CHAR = #$51
SET_CURSOR_CHAR = #$d1

UNDO_BYTE = #$fd
UNDO_CHAR = #$fe
UNDO_NOPE = #$ff
UNDO_NOPE_NAUGHT = $ff

CURSOR_LINE_1 = 38
CURSOR_LINE_2 = 44

character_bytes: .byte $0, $0, $0, $0, $0, $0, $0, $0
current_character: .byte $0
temp_character:  .byte $0
current_character_high: .byte DESTINATION_BYTES_START_HIGH ;; these are pointers into
current_character_low: .byte $00  ;; destination character bytes

;; where to draw to, not necessarily current_character
draw_character: .byte $00
draw_x_start: .byte $00
draw_y_start: .byte $00

mid_freq: .byte $f2
x_pos: .byte $00
y_pos: .byte $00
new_x_pos: .byte $00
new_y_pos: .byte $00
current_width: .byte $00
current_height: .byte $00
prev_char: .byte $01
size_mode: .byte $00
setty_bytes: .byte %10000000
             .byte %01000000
             .byte %00100000
             .byte %00010000
             .byte %00001000
             .byte %00000100
             .byte %00000010
             .byte %00000001
border_visible: .byte $01

char_indicator_on_top: .byte $00
char_blank_line: .byte CURSOR_LINE_1
char_cursor_line: .byte CURSOR_LINE_2

foreground_color: .byte $01
background_color: .byte $00
border_color: .byte $00

do_reset_character: .byte $00
do_handle_pos_change: .byte $00
do_toggle_border: .byte $00

do_save: .byte $00
do_load: .byte $00
do_escape: .byte $00
do_print_bytes: .byte $00

;; where to wee to
wee_target: .byte $00
do_wee_left: .byte $00
do_wee_right: .byte $00

undo_stack_x: .fill 256, UNDO_NOPE_NAUGHT
undo_stack_y: .fill 256, UNDO_NOPE_NAUGHT
undo_stack_type: .fill 256, UNDO_NOPE_NAUGHT
undo_stack_draw_character: .fill 256, UNDO_NOPE_NAUGHT
undo_stack_current_character: .fill 256, UNDO_NOPE_NAUGHT
undo_stack_index: .byte $00
undo_after_wee: .byte $00
undo_run_count: .byte $00

;; char byte 0, char byte 1, ..., char byte 7, char #, repeat
whole_character_undo: .fill 256, UNDO_NOPE_NAUGHT
whole_character_undo_index: .byte $00

character_clipboard: .fill 32, 0
CHARACTER_CLIPBOARD_NOPE = #0
CHARACTER_CLIPBOARD_SMALL = #1
CHARACTER_CLIPBOARD_FOUR = #2
character_clipboard_mode: .byte $00
character_clipboard_index: .byte $00

do_four_mode: .byte $00
do_small_mode: .byte $00

key_handlers:=(
    do_nothing, ;; left shift
    do_nothing, ;; right shift
    color_space, ;; space
    minus_char, ;; colon
    plus_char, ;; semicolon
    handle_w, ;; w
    handle_a, ;; a
    handle_s, ;; s
    handle_d, ;; d
    character_to_clipboard, ;; c
    clipboard_to_character, ;; p
    clear_character_and_copy, ;; k
    set_toggle_border, ;; b
    do_undo, ;; u
    prepare_save, ;; f5
    prepare_load, ;; f7
    increment_foreground, ;; f
    increment_background, ;; g
    increment_border, ;; h
    minus_char_extra, ;; at
    plus_char_extra, ;; star
    handle_escape, ;; e
    four_coords_down, ;; cursor down
    four_coords_up, ;; cursor up
    do_nothing, ;; cursor right
    do_nothing, ;; cursor left
    handle_flip, ;; z
    enter_one_mode, ;; 1
    do_nothing, ;; 2
    do_nothing, ;; 3
    enter_four_mode, ;; 4
    do_nothing, ;; 5
    do_nothing, ;; 6
    do_nothing, ;; 7
    do_nothing, ;; 8
    do_nothing, ;; 9
    do_nothing, ;; 0
    do_nothing, ;; m
    prepare_print_bytes, ;; t
    prepare_full_new, ;; f1
    prepare_partial_new, ;; f3
    handle_horizontal_flip, ;; y
    copy_original_character, ;; o
    do_xray, ;; x
    do_nothing, ;; n
    do_nothing, ;; enter
    handle_escape, ;; escape
    handle_escape ;; run-stop
)-1

key_handlers_hi .byte >key_handlers
key_handlers_lo .byte <key_handlers

start_char_editor:
        jsr copy_character_bytes
        ;; fall through

handle_char_editor_new:
        mova draw_character, #0
        mova current_character_high, #DESTINATION_BYTES_START_HIGH
        mova current_character_low, #0
        rts

resume_char_editor:
        cmpa display_mode, FOUR_DISPLAY_MODE
        jsreq setup_four_mode

        cmpa display_mode, SMALL_DISPLAY_MODE
        jsreq setup_small_mode

        jsr clear_screen
        jsr set_screen_colors
        color_chars foreground_color

        mova size_mode, SMALL_SIZE
        mova repeat_delay, repeats

        mova new_y_pos, y_start
        mova new_x_pos, x_start
        mova y_pos, y_start
        mova x_pos, x_start
        jsr reset_new_state

        jsr color_character
        jsr plot_character
        jsr initialize_cursor
        jsr plot_characters
        jsr plot_border

        enable_timer_a irq, TIMER_VALUE

-       jsr read_key

        ;; not safe to do these operations in the irq
        cmpa do_four_mode, #1
        bne +
        mova do_four_mode, #0
        mova display_mode, FOUR_DISPLAY_MODE
        jmp resume_char_editor

+       cmpa do_small_mode, #1
        bne +
        mova do_small_mode, #0
        mova display_mode, SMALL_DISPLAY_MODE
        jmp resume_char_editor

+       cmpa do_save, #1
        bne +
        mova do_save, #0
        jsr save_file
        jmp resume_char_editor

+       cmpa do_load, #1
        bne +
        mova do_load, #0
        jsr load_file
        jmp resume_char_editor

+       cmpa do_print_bytes, #1
        bne +
        mova do_print_bytes, #0
        jsr print_bytes
        jmp resume_char_editor

+       cmpa do_escape, #1
        bne +
        mova do_escape, #0
        rts

+       cmpa full_new_state, DO_FULL_NEW_STATE
        bne +
        rts

+       cmpa partial_new_state, DO_PARTIAL_NEW_STATE
        bne +
        rts

+       jmp -

clear_border:
        cmpa border_visible, #1
        rtseq

        mova $2b, SPACE_CHAR
        mova $2c, BLACK_COLOR

        jmp border_border

plot_border:
        cmpa border_visible, #0
        rtseq

        mova $2b, ANTI_SPACE_CHAR
        mova $2c, BLUE_COLOR

        jmp border_border

setup_small_mode:
        mova display_mode, SMALL_DISPLAY_MODE
        mova x_start, SMALL_X_START
        mova y_start, SMALL_Y_START
        mova draw_x_start, SMALL_X_START
        mova draw_y_start, SMALL_Y_START
        mova x_end, SMALL_X_END
        mova y_end, SMALL_Y_END
        mova x_end_next, SMALL_X_END + 1
        mova y_end_next, SMALL_Y_END + 2

        mova current_width, SMALL_WIDTH
        mova current_height, SMALL_HEIGHT

        mova x_start_max, x_start
        mova x_end_max, x_end
        mova y_start_max, y_start
        mova y_end_max, y_end
        rts

setup_four_mode:
        mova display_mode, FOUR_DISPLAY_MODE
        mova x_start, #FOUR_X_START_1
        mova y_start, #FOUR_Y_START_1
        mova draw_x_start, x_start
        mova draw_y_start, y_start
        mova x_end, #FOUR_X_END_3
        mova y_end, #FOUR_Y_END_3
        mova x_end_next, x_end
        inc x_end_next
        mova y_end_next, y_end
        inc y_end_next
        inc y_end_next

        mova current_width, FOUR_WIDTH
        mova current_height, FOUR_HEIGHT

        mova x_start_max, #FOUR_X_START_1
        mova x_end_max, #FOUR_X_END_2
        mova y_start_max, #FOUR_Y_START_1
        mova y_end_max, #FOUR_Y_END_0

        cmpa char_indicator_on_top, #1
        jsreq really_handle_flip

        rts

border_border:
        pusha x_pos
        pusha y_pos

        ;; top
        mova x_pos, x_start
        mova y_pos, y_start
        dec y_pos
        dec y_pos
        jsr load_screen_bytes_into_fb
        jsr load_color_bytes_into_fd

        ldx current_width
-       stay ($fb), y, $2b
        stay ($fd), y, $2c
        iny
        dex
        bne -

        ;; bottom
        mova x_pos, x_start
        mova y_pos, y_end_next
        jsr load_screen_bytes_into_fb
        jsr load_color_bytes_into_fd

        ldx current_width
-       stay ($fb), y, $2b
        stay ($fd), y, $2c
        iny
        dex
        bne -

        ;; left
        mova x_pos, x_start
        dec x_pos
        mova y_pos, y_start
        dec y_pos
        dec y_pos
        jsr load_screen_bytes_into_fb
        jsr load_color_bytes_into_fd

        ldx current_height
        inx
-       stay ($fb), y, $2b
        stay ($fd), y, $2c
        a16 $fb, $fc, #22
        a16 $fd, $fe, #22
        dex
        bpl -

        ;; right
        mova x_pos, x_end_next
        mova y_pos, y_start
        dec y_pos
        dec y_pos
        jsr load_screen_bytes_into_fb
        jsr load_color_bytes_into_fd

        ldx current_height
        inx
-       stay ($fb), y, $2b
        stay ($fd), y, $2c
        a16 $fb, $fc, #22
        a16 $fd, $fe, #22
        lda $2b
        dex
        bpl -

        pulla y_pos
        pulla x_pos
        rts

four_coords_down:
        cmpa display_mode, FOUR_DISPLAY_MODE
        rtsne

        cmpa four_coords_offset, #2
        rtseq

        inc four_coords_offset
        mova do_reset_character, #1
        jsr update_draw_character
        rts

four_coords_up:
        cmpa display_mode, FOUR_DISPLAY_MODE
        rtsne

        cmpa four_coords_offset, #0
        rtseq

        dec four_coords_offset
        mova do_reset_character, #1
        jsr update_draw_character
        rts


clear_small_character:
        pusha x_start
        pusha y_start
        mova x_start, SMALL_X_START
        mova y_start, SMALL_Y_START

        jsr really_clear_character

        pulla y_start
        pulla x_start
        rts

clear_four_character:
        pusha x_start
        pusha y_start

        ldx #3

-       movay x_start, four_coords_start_x, x
        movay y_start, four_coords_start_y, x
        phx
        jsr really_clear_character
        plx
        dex
        bpl -

        pulla y_start
        pulla x_start

        rts

clear_character:
        cmpa display_mode, SMALL_DISPLAY_MODE
        bne +
        jsr clear_small_character
        rts

+       cmpa display_mode, FOUR_DISPLAY_MODE
        bne +
        jsr clear_four_character
+       rts


color_character:
    rts
        pusha x_pos
        pusha y_pos

        mova x_pos, x_start
        mova y_pos, y_start

-       jsr load_color_bytes_into_fd
        ldy SMALL_WIDTH - 1

-       stay ($fd), y, WHITE_COLOR
        dey
        bpl -

        inc y_pos
        inc y_pos
        cmpa y_end_next, y_pos
        bcc --

        pulla y_pos
        pulla x_pos
        rts

reset_character:
        jsr clear_character
        jsr plot_character
        jsr color_character
        jsr plot_characters
        jsr clear_border
        jsr plot_border
        jsr initialize_cursor
        rts

add_character_to_undo:
        jsr load_draw_char_into_2b
        ldy #0
        ldx whole_character_undo_index

-       lda ($2b), y
        sta whole_character_undo, x
        inc whole_character_undo_index
        inx
        iny
        cpy #8
        bne -

        ldx undo_stack_index
        stay undo_stack_type, x, UNDO_CHAR
        stay undo_stack_current_character, x, current_character
        stay undo_stack_draw_character, x, draw_character
        inc undo_stack_index
        rts

really_clear_character:
        phx
        pusha x_pos
        pusha y_pos

        mova x_pos, x_start
        mova y_pos, y_start

-       jsr load_screen_bytes_into_fb
        ldy SMALL_WIDTH - 1

-       stay ($fb), y, SPACE_CHAR
        dey
        bpl -

        inc y_pos
        inc y_pos
        cmpa y_end_next, y_pos
        bcc --

        pulla y_pos
        pulla x_pos
        plx

        rts

plot_character:
        cmpa display_mode, SMALL_DISPLAY_MODE
        bne +
        jsr plot_small_character
        rts

+       cmpa display_mode, FOUR_DISPLAY_MODE
        bne +
        jsr plot_four_character
+       rts

load_four_coords_lohi_offsets_into_fd:
        cmpa four_coords_offset, #0
        bne +
        mova $fd, #<four_coords_0_lohi_offset
        mova $fe, #>four_coords_0_lohi_offset
+       cmpa four_coords_offset, #1
        bne +
        mova $fd, #<four_coords_1_lohi_offset
        mova $fe, #>four_coords_1_lohi_offset
+       cmpa four_coords_offset, #2
        bne +
        mova $fd, #<four_coords_2_lohi_offset
        mova $fe, #>four_coords_2_lohi_offset
+       rts

load_four_coords_offsets_into_fd:
        cmpa four_coords_offset, #0
        bne +
        mova $fd, #<four_coords_0_offset
        mova $fe, #>four_coords_0_offset
+       cmpa four_coords_offset, #1
        bne +
        mova $fd, #<four_coords_1_offset
        mova $fe, #>four_coords_1_offset
+       cmpa four_coords_offset, #2
        bne +
        mova $fd, #<four_coords_2_offset
        mova $fe, #>four_coords_2_offset
+       rts

plot_four_character:
        pusha x_start
        pusha y_start

        mova $2b, #0

-       pusha current_character_low
        pusha current_character_high

        jsr load_four_coords_lohi_offsets_into_fd

        ldy $2b
        movay x_start, four_coords_start_x, y
        movay y_start, four_coords_start_y, y

        lda ($fd), y
        sta $2c
        a16 current_character_low, current_character_high, $2c
        cmpa current_character_high, #DESTINATION_BYTES_LAST_HIGH
        bne +
        ;; overflow!
        mova current_character_high, #DESTINATION_BYTES_START_HIGH

+       jsr plot_small_character

        pulla current_character_high
        pulla current_character_low

        inc $2b
        cmpa $2b, #4
        bne -

        pulla y_start
        pulla x_start

        mova do_reset_character, #0
        rts

plot_small_character:
        mova $fb, current_character_low
        mova $fc, current_character_high

        ;; set up /character\ variable
        ldy #7
-       lda ($fb),y
        sta character_bytes, y
        dey
        bpl -

        pusha y_pos
        mova y_pos, y_start
        ldy #0
-       movay temp_character, character_bytes, y
        jsr plot_character_line
        inc y_pos
        inc y_pos
        iny
        cpy #8
        bne -

        pulla y_pos
        rts

plot_character_line:
        pha
        tya
        pha
        txa
        pha

        ldy y_pos
        movay $fb, screen_bytes, y
        iny
        movay $fc, screen_bytes, y

        adda x_start, SMALL_WIDTH - 1
        tay
        lda temp_character
-       clc
        lsr
        bcc no_carry
        pha
        lda ANTI_SPACE_CHAR
        sta ($fb),y
        pla
no_carry:
        dey
        cpy x_start
        bpl -

        pla
        tax
        pla
        tay
        pla

        rts

plot_characters:
        pusha x_pos
        pusha y_pos

        mova x_pos, #0
        mova y_pos, #40
        jsr load_screen_bytes_into_fb

        mova $fd, $fb
        mova $fe, $fc

        mova y_pos, #42
        jsr load_screen_bytes_into_fb

        pusha current_character

        cmpa char_indicator_on_top, #0
        beq +
        dec current_character
+
        ;; plot character line towards bottom of screen
        ldy #0
        lda current_character
        sec
        sbc #20

-       sta ($fb), y
        ina
        sta ($fd), y
        ina
        iny
        cpy #22
        bne -

        pulla current_character

        mova x_pos, #0

        ;; plot character indicator on top or bottom
        mova x_pos, #10
        mova y_pos, char_blank_line
        jsr load_screen_bytes_into_fb
        stay ($fb), y, SPACE_CHAR

        mova y_pos, char_cursor_line
        jsr load_screen_bytes_into_fb
        stay ($fb), y, BLANK_CURSOR_CHAR

        pulla y_pos
        pulla x_pos
        rts

prepare_save:
    mova do_save, #1
    enable_timer_a do_no_irq, TIMER_VALUE
    rts

prepare_load:
    mova do_load, #1
    enable_timer_a do_no_irq, TIMER_VALUE
    rts

prepare_print_bytes:
        mova do_print_bytes, #1
        enable_timer_a do_no_irq, TIMER_VALUE
        rts

increment_foreground:
    cmpa foreground_color, YELLOW_COLOR
    bne +
    mova foreground_color, #$ff
+   inc foreground_color
    color_chars foreground_color
    rts

increment_background:
    cmpa background_color, YELLOW_COLOR
    bne +
    mova background_color, #$ff
+   inc background_color
    lda #%00001111
    and $900f
    sta $900f
    lda background_color
    clc
    asl
    asl
    asl
    asl
    ora $900f
    sta $900f
    rts

increment_border:
    cmpa border_color, YELLOW_COLOR
    bne +
    mova border_color, #$ff
+   inc border_color
    lda #%11111000
    and $900f
    sta $900f
    lda border_color
    ora $900f
    sta $900f
    rts

do_nothing:
        rts

irq:
        jsr test_new

        print_current_character_as_hex #10, #0

        cmpa do_handle_pos_change, #1
        bne +
        jsr handle_pos_change
        mova do_handle_pos_change, #0

+       cmpa do_reset_character, #1
        bne +
        jsr reset_character
        mova do_reset_character, #0

+       cmpa do_toggle_border, #1
        bne +
        jsr toggle_border
        mova do_toggle_border, #0

+       cmpa do_wee_left, #1
        bne +
        jsr wee_left
        jmp $eabf

+       cmpa do_wee_right, #1
        bne +
        jsr wee_right
        jmp $eabf

+       cmpa undo_run_count, #0
        beq +
        jsr do_undo
        dec undo_run_count

+       cmpa wee_target, current_character
        bne +
        cmpa undo_after_wee, #1
        bne +

        mova undo_after_wee, #0
        jsr do_undo

+       handle_keys key_handlers

        jmp $eabf

set_toggle_border:
        mova do_toggle_border, #1
        rts

toggle_border:
        lda border_visible
        eor #1
        sta border_visible
        jsr reset_character
        rts

clear_character_and_copy:
        cmpa display_mode, FOUR_DISPLAY_MODE
        jmpeq clear_four_character_and_copy

        cmpa display_mode, SMALL_DISPLAY_MODE
        jmpeq really_clear_character_and_copy

        rts

load_draw_char_into_2b:
        mova $2b, draw_character
        mova $2c, #0
        rol16 $2b, $2c
        rol16 $2b, $2c
        rol16 $2b, $2c
        lda $2c
        clc
        adc #DESTINATION_BYTES_START_HIGH
        sta $2c
        rts

load_source_char_into_fb:
        mova $fb, draw_character
        mova $fc, #0
        rol16 $fb, $fc
        rol16 $fb, $fc
        rol16 $fb, $fc
        lda $fc
        clc
        adc SOURCE_BYTES_START_HIGH
        sta $fc
        rts

really_clear_character_and_copy:
        mova $fb, #0
        jsr load_draw_char_into_2b
        jsr check_character_for_blank
        cmpa $fb, #1
        rtseq

        jsr add_character_to_undo
        jsr really_clear_character

        jsr load_screen_bytes_into_fb
        stay ($fb), y, BLANK_CURSOR_CHAR

        ldy #7
        lda #0
-       sta ($2b), y
        dey
        bpl -

        rts

;; on each call to \1,
;; ($2b) is pointer to draw character's memory
for_each_draw_character_do .macro
        pusha draw_character
        jsr load_four_coords_offsets_into_fd
        ldy #3
-       lda ($fd), y
        clc
        adc current_character
        sta draw_character
        phy
        jsr load_draw_char_into_2b
        jsr \1
        ply
        dey
        bpl -
        pulla draw_character
.endm

xray_small_character:
        jsr load_draw_char_into_2b
        ldy #7
-       lda ($2b), y
        eor #$ff
        sta ($2b), y
        dey
        bpl -
        mova do_reset_character, #1
        rts

xray_four_character:
        for_each_draw_character_do xray_small_character
        rts

do_xray:
        cmpa display_mode, SMALL_DISPLAY_MODE
        bne +
        jsr xray_small_character
        rts

+       cmpa display_mode, FOUR_DISPLAY_MODE
        bne +
        jsr xray_four_character
+       rts

check_character_for_blank:
        ldy #7
-       lda ($2b), y
        cmp #0
        beq +
        rts
+       dey
        bpl -

        inc $fb
        rts

clear_four_character_and_copy:
        mova $fb, #0
        for_each_draw_character_do check_character_for_blank
        cmpa $fb, #4
        rtseq

        for_each_draw_character_do really_clear_character_and_copy
        mova do_reset_character, #1
        rts

copy_original_character:
        cmpa display_mode, SMALL_DISPLAY_MODE
        jsreq copy_original_small_character

        cmpa display_mode, FOUR_DISPLAY_MODE
        jsreq copy_original_four_character

        mova do_reset_character, #1
        rts

copy_original_small_character:
        jsr add_character_to_undo
        jsr load_draw_char_into_2b
        jsr load_source_char_into_fb
        ldy #7
-       lda ($fb), y
        sta ($2b), y
        dey
        bpl -
        rts

copy_original_four_character:
        for_each_draw_character_do copy_original_small_character
        rts

minus_char_extra:
        ldx EXTRA_MOVE_AMOUNT
-       jsr minus_char
        dex
        bne -
        rts

minus_char:
        jsr do_minus_char
        jsr do_minus_char
        rts

do_minus_char:
        dec current_character
        cmpa current_character_low, #0
        bne +
        cmpa current_character_high, #DESTINATION_BYTES_START_HIGH
        bne +
        mova current_character_low, LAST_CHARACTER_LOW
        mova current_character_high, LAST_CHARACTER_HIGH
        jmp dm1
+       s16 current_character_low, current_character_high, #8
dm1:    mova do_reset_character, #1
        mova draw_character, current_character
        mova four_coords_offset, #0
        rts

plus_char_extra:
        ldx EXTRA_MOVE_AMOUNT
-       jsr plus_char
        dex
        bne -
        rts

plus_char:
        jsr do_plus_char
        jsr do_plus_char
        rts

do_plus_char:
        inc current_character
        cmpa current_character_low, LAST_CHARACTER_LOW
        bne +
        cmpa current_character_high, LAST_CHARACTER_HIGH
        bne +
        mova current_character_high, #DESTINATION_BYTES_START_HIGH
        mova current_character_low, #0
        jmp dp1
+       a16 current_character_low, current_character_high, #8
dp1:    mova do_reset_character, #1
        mova draw_character, current_character
        mova four_coords_offset, #0
        rts

update_upper_draw_character:
        lda new_x_pos
        cmp #FOUR_X_END_0 + 1
        bcs +
        ldy #0
        mova draw_y_start, #FOUR_Y_START_1
        rts
+       mova draw_x_start, #FOUR_X_START_2
        mova draw_y_start, #FOUR_Y_START_1
        ldy #3
        rts

update_draw_character:
        mova draw_x_start, x_start
        mova draw_y_start, y_start
        mova draw_character, current_character

        cmpa display_mode, FOUR_DISPLAY_MODE
        rtsne

        cmpa four_coords_offset, #0
        bne +
        mova $2b, #<four_coords_0_offset
        mova $2c, #>four_coords_0_offset
+       cmpa four_coords_offset, #1
        bne +
        mova $2b, #<four_coords_1_offset
        mova $2c, #>four_coords_1_offset
+       cmpa four_coords_offset, #2
        bne +
        mova $2b, #<four_coords_2_offset
        mova $2c, #>four_coords_2_offset

+       mova draw_y_start, #FOUR_Y_START_0
        ldy #1
        lda new_y_pos
        cmp #FOUR_Y_END_1 + 2
        bcs +
        jsr update_upper_draw_character
        jmp u1
+       lda new_x_pos
        cmp #FOUR_X_END_0 + 1
        bcc u1
        mova draw_x_start, #FOUR_X_START_2
        mova draw_y_start, #FOUR_Y_START_3
        ldy #2
u1:     lda ($2b), y
        clc
        adc draw_character
        sta draw_character
        rts

handle_w:
        lda y_pos
        cmp y_start_max
        rtseq
        sta new_y_pos

        ldx size_mode
-       dec new_y_pos
        dec new_y_pos
        dex
        bne -

        mova new_x_pos, x_pos
        mova do_handle_pos_change, #1
        jsr update_draw_character
        rts

handle_s:
        lda y_pos
        cmp y_end_max
        rtseq
        sta new_y_pos

        ldx size_mode
-       inc new_y_pos
        inc new_y_pos
        dex
        bne -

        mova new_x_pos, x_pos
        mova do_handle_pos_change, #1
        jsr update_draw_character
        rts

handle_a:
        lda x_pos
        cmp x_start_max
        rtseq
        sta new_x_pos

        ldx size_mode
-       dec new_x_pos
        dex
        bne -

        mova new_y_pos, y_pos
        mova do_handle_pos_change, #1
        jsr update_draw_character
        rts

handle_d:
        lda x_pos
        cmp x_end_max
        rtseq
        sta new_x_pos

        ldx size_mode
-       inc new_x_pos
        dex
        bne -
        mova new_y_pos, y_pos
        mova do_handle_pos_change, #1
        jsr update_draw_character
        rts

handle_flip:
        cmpa display_mode, FOUR_DISPLAY_MODE
        rtseq
        ;; fall through

really_handle_flip:
        lda char_indicator_on_top
        eor #1
        sta char_indicator_on_top

        cmpa char_indicator_on_top, #0
        beq +
        mova char_blank_line, #CURSOR_LINE_2
        mova char_cursor_line, #CURSOR_LINE_1
        jsr do_plus_char
        jmp handle1
+       mova char_blank_line, #CURSOR_LINE_1
        mova char_cursor_line, #CURSOR_LINE_2
        jsr do_minus_char
handle1:
        rts

handle_pos_change:
        jsr load_screen_bytes_into_fb
        lda ($fb), y
        cmp BLANK_CURSOR_CHAR
        bne +
        stay ($fb), y, SPACE_CHAR
        jmp handle_new_pos
+       stay ($fb), y, ANTI_SPACE_CHAR
handle_new_pos:
        mova x_pos, new_x_pos
        mova y_pos, new_y_pos
        jsr load_screen_bytes_into_fb
        lda ($fb), y
        cmp SPACE_CHAR
        bne +
        ;; we have an anti-space
        stay ($fb), y, BLANK_CURSOR_CHAR
        rts
+       stay ($fb), y, SET_CURSOR_CHAR
        rts

color_space:
        ;; don't toggle the color more than once before de-press
        cmpa #2, repeats
        rtscs

        jsr load_screen_bytes_into_fb
        lda ($fb), y
        cmp BLANK_CURSOR_CHAR
        bne +
        stay ($fb), y, SET_CURSOR_CHAR
        jsr add_undo
        jmp copy_screen_character_to_character_bytes
+       stay ($fb), y, BLANK_CURSOR_CHAR
        jsr add_undo
        jmp copy_screen_character_to_character_bytes

handle_escape:
        mova do_escape, #1
        enable_timer_a do_no_irq, TIMER_VALUE
        rts

add_undo:
        ldx undo_stack_index
        stay undo_stack_x, x, x_pos
        stay undo_stack_y, x, y_pos
        stay undo_stack_current_character, x, current_character
        stay undo_stack_draw_character, x, draw_character
        stay undo_stack_type, x, UNDO_BYTE
        inc undo_stack_index
        rts

FAST_WEE_COUNT = #4

wee_right:
        ldy FAST_WEE_COUNT
-       cmpa wee_target, current_character
        bne +
        mova do_wee_right, #0
        rts
+       jsr plus_char
        dey
        bne -
        rts

wee_left:
        ldy FAST_WEE_COUNT
-       cmpa wee_target, current_character
        bne +
        mova do_wee_left, #0
        rts
+       jsr minus_char
        dey
        bne -
        rts

go_wee:
        jsr try_wee_flip
        sec
        sbc current_character
        sta $fb

        lda current_character
        sec
        sbc wee_target
        sta $fc

        cmpa $fb, $fc
        bcc +
        mova do_wee_right, #1
        rts
+       mova do_wee_left, #1
        rts

try_wee_flip:
        lda current_character
        eor wee_target
        and #1
        rtseq ;; we're on the correct side
        jmp really_handle_flip ;; will rts

do_undo:
        ldx undo_stack_index
        dex

        cmpax undo_stack_type, x, UNDO_NOPE
        rtseq

+       cmpax undo_stack_current_character, x, current_character
        beq +
        movay wee_target, undo_stack_current_character, x
        mova undo_after_wee, #1
        jmp go_wee

+       cmpax undo_stack_type, x, UNDO_CHAR
        bne +
        stay undo_stack_type, x, UNDO_NOPE
        dec undo_stack_index
        jmp do_undo_char

+       pusha x_pos
        pusha y_pos
        pusha current_character
        pusha draw_character

        movay x_pos, undo_stack_x, x
        movay y_pos, undo_stack_y, x
        movay draw_character, undo_stack_draw_character, x
        stx undo_stack_index

        jsr load_screen_bytes_into_fb
        cmpax ($fb), y, SPACE_CHAR
        bne +
        stay ($fb), y, ANTI_SPACE_CHAR
        jmp dou1
+       cmpax ($fb), y, ANTI_SPACE_CHAR
        bne +
        stay ($fb), y, SPACE_CHAR
        jmp dou1
+       cmpax ($fb), y, BLANK_CURSOR_CHAR
        bne +
        stay ($fb), y, SET_CURSOR_CHAR
        jmp dou1
+       cmpax ($fb), y, SET_CURSOR_CHAR
        bne dou1
        stay ($fb), y, BLANK_CURSOR_CHAR

dou1:
        jsr copy_screen_character_to_character_bytes

        pulla draw_character
        pulla current_character
        pulla y_pos
        pulla x_pos
        rts

do_undo_char:
        pusha draw_character
        ldx undo_stack_index
        lda undo_stack_draw_character, x
        sta draw_character
        jsr load_draw_char_into_2b

        dec whole_character_undo_index
        ldy #7
        ldx whole_character_undo_index

-       lda whole_character_undo, x
        sta ($2b), y
        dec whole_character_undo_index
        dex
        dey
        bpl -

        mova do_reset_character, #1
        stx whole_character_undo_index
        inc whole_character_undo_index
        pulla draw_character
        rts

;; the line has changed, now reflect it into the actual character
copy_screen_character_to_character_bytes:
        pusha x_pos
        mova x_pos, draw_x_start
        jsr load_screen_bytes_into_fb

        mova $fd, #0
-       lda ($fb), y
        cmp SPACE_CHAR
        beq +
        cmp BLANK_CURSOR_CHAR
        beq +
        lda setty_bytes, y
        ora $fd
        sta $fd
+       iny
        cpy SMALL_WIDTH
        bne -

        jsr load_draw_char_into_2b

        ;; put the new dude, $fd, into position in the character memory
        lda y_pos
        sec
        sbc draw_y_start
        clc
        lsr
        tay
        stay ($2b), y, $fd

        pulla x_pos
        rts

character_to_clipboard:
        cmpa display_mode, SMALL_DISPLAY_MODE
        jmpeq small_character_to_clipboard

        cmpa display_mode, FOUR_DISPLAY_MODE
        jmpeq four_character_to_clipboard

        rts

character_to_clipboard_helper:
        ldy #7
        ldx character_clipboard_index
-       lda ($2b), y
        sta character_clipboard, x
        inx
        dey
        bpl -
        stx character_clipboard_index
        rts

small_character_to_clipboard:
        mova character_clipboard_mode, CHARACTER_CLIPBOARD_SMALL
        mova character_clipboard_index, #0
        jsr load_draw_char_into_2b
        jmp character_to_clipboard_helper

four_character_to_clipboard:
        mova character_clipboard_mode, CHARACTER_CLIPBOARD_FOUR
        mova character_clipboard_index, #0
        for_each_draw_character_do character_to_clipboard_helper
        rts

clipboard_to_character:
        cmpa display_mode, SMALL_DISPLAY_MODE
        jmpeq clipboard_to_small_character

        cmpa display_mode, FOUR_DISPLAY_MODE
        jmpeq clipboard_to_four_character

        rts

clipboard_to_character_helper:
        jsr add_character_to_undo
        ldy #7
        ldx character_clipboard_index
-       lda character_clipboard, x
        sta ($2b), y
        inx
        dey
        bpl -
        stx character_clipboard_index
        rts

clipboard_to_small_character:
        cmpa character_clipboard_mode, CHARACTER_CLIPBOARD_SMALL
        rtsne
        mova character_clipboard_index, #0
        mova do_reset_character, #1
        jmp clipboard_to_character_helper

clipboard_to_four_character:
        cmpa character_clipboard_mode, CHARACTER_CLIPBOARD_FOUR
        rtsne
        mova character_clipboard_index, #0
        mova do_reset_character, #1
        for_each_draw_character_do clipboard_to_character_helper
        rts

handle_horizontal_flip:
        cmpa display_mode, SMALL_DISPLAY_MODE
        jmpeq handle_small_horizontal_flip_helper

        cmpa display_mode, FOUR_DISPLAY_MODE
        jmpeq handle_four_horizontal_flip

        rts

handle_small_horizontal_flip_helper:
        jsr load_draw_char_into_2b
        jmp handle_small_horizontal_flip

handle_small_horizontal_flip:
        ldy #7
-       lda ($2b), y
        sta $fb
        mova $fc, #0
        ldx #7
-       lsr $fb
        rol $fc
        dex
        bpl -
        lda $fc
        sta ($2b), y
        dey
        bpl --
        mova do_reset_character, #1
        rts

load_four_draw_character .macro
        ldy \1
        lda ($fd), y
        clc
        adc current_character
        sta draw_character
        jsr load_draw_char_into_2b
.endm

four_flip_helper:
        ldy #7
-       lda ($2b), y
        pha
        lda ($fb), y
        sta ($2b), y
        pla
        sta ($fb), y
        dey
        bpl -
        rts

handle_four_horizontal_flip:
        pusha draw_character
        for_each_draw_character_do handle_small_horizontal_flip

        ;; swap right chars with left
        load_four_draw_character #1
        mova $fb, $2b
        mova $fc, $2c
        load_four_draw_character #2
        jsr four_flip_helper

        load_four_draw_character #0
        mova $fb, $2b
        mova $fc, $2c
        load_four_draw_character #3
        jsr four_flip_helper

        pulla draw_character
        rts

paste_clipboard:
        rts

enter_four_mode:
        mova do_four_mode, #1
        enable_timer_a do_no_irq, TIMER_VALUE
        cmpa char_indicator_on_top, #0
        rtseq
        jmp handle_flip

enter_one_mode:
        mova do_small_mode, #1
        enable_timer_a do_no_irq, TIMER_VALUE
        rts

initialize_cursor:
        jsr load_screen_bytes_into_fb
        cmpax ($fb), y, SPACE_CHAR
        bne +
        stay ($fb), y, BLANK_CURSOR_CHAR
        rts
+       stay ($fb), y, SET_CURSOR_CHAR
        rts
