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

        *=$1201
        jmp start_tiler

        ;; right before destination bytes
        *=$13ed

save_file_start:
.enc "none"
filename_petscii_preamble: .text "@0:"
filename_petscii_preamble_end:
filename_petscii: .text "                "
filename_petscii_end:
.enc "screen"

        *=$1c00 ;; right after character bytes

destination_bytes_end:
world: .fill 506, "."
world_end:
world_color: .fill 506, WHITE_COLOR_NAUGHT
world_color_end:
sidebar_chars: .byte ANTI_SPACE_CHAR_NAUGHT
               .fill 9, " "
sidebar_chars_end:
sidebar_chars_index: .byte $01
SIDEBAR_LENGTH = #10
save_file_end:
        *=$2101 ;; entry

jmp start_tiler

world_left: .fill 506, "."
world_right: .fill 506, "."

world_dots: .fill 506, "."

world_color_left: .fill 506, WHITE_COLOR_NAUGHT
world_color_right: .fill 506, WHITE_COLOR_NAUGHT

world_color_white: .fill 506, WHITE_COLOR_NAUGHT

world_clipboard: .fill 506, "."
world_color_clipboard: .fill 506, WHITE_COLOR_NAUGHT

.include "macros.asm"
.include "characters.asm"
.include "screen_bytes_32.asm"
.include "screen_routines.asm"
.include "colors.asm"
.include "timer.asm"
.include "save.asm"
.include "pseudo_characters.asm"
.include "print_numbers.asm"
.include "char_editor.asm"
.include "timer_values.asm"
.include "print_bytes.asm"

TOPOLOGY_X_START = #0
TOPOLOGY_X_END = #21
TOPOLOGY_Y_START = #0
TOPOLOGY_Y_END = #44
TOPOLOGY_WIDTH = #22
TOPOLOGY_HEIGHT = #23
TOPOLOGY_DOUBLE_HEIGHT = #46
WORLD_COORDINATES_X_START = 5

.enc "screen"
x_string: .text "x "
x_string_end:
y_string: .text " y "
y_string_end:
.enc "none"

create_timer squelch_characters, 60
characters_up: .byte $00

do_world_move: .byte $00
zone_number: .byte $00
prev_x_world: .byte $00
prev_y_world: .byte $00
x_world: .byte $00
y_world: .byte $00
go_char_editor: .byte $00

current_color: .byte WHITE_COLOR_NAUGHT
do_handle_world_pos_change: .byte $00

;; memory for bucket fill
bucket_fill_x: .fill 256, $ff
bucket_fill_y: .fill 256, $ff
bucket_fill_character: .byte $00
bucket_fill_color: .byte $00
bucket_fill_index: .byte $00

NO_FULL_NEW_STATE = #0
FIRST_FULL_NEW_STATE = #1
SECOND_FULL_NEW_STATE = #2
DO_FULL_NEW_STATE = #3

full_new_state: .byte 0

NO_PARTIAL_NEW_STATE = #0
FIRST_PARTIAL_NEW_STATE = #1
SECOND_PARTIAL_NEW_STATE = #2
DO_PARTIAL_NEW_STATE = #3

partial_new_state: .byte 0

topo_world_bytes:
        .byte $00, $10    ;; line 0
        .byte $16, $10    ;; line 1
        .byte $2c, $10    ;; line 2
        .byte $42, $10    ;; line 3
        .byte $58, $10    ;; line 4
        .byte $6e, $10    ;; line 5
        .byte $84, $10    ;; line 6
        .byte $9a, $10    ;; line 7
        .byte $b0, $10    ;; line 8
        .byte $c6, $10    ;; line 9
        .byte $dc, $10    ;; line 10
        .byte $f2, $10    ;; line 11
        .byte $08, $11    ;; line 12
        .byte $1e, $11    ;; line 13
        .byte $34, $11    ;; line 14
        .byte $4a, $11    ;; line 15
        .byte $60, $11    ;; line 16
        .byte $76, $11    ;; line 17
        .byte $8c, $11    ;; line 18
        .byte $a2, $11    ;; line 19
        .byte $b8, $11    ;; line 20
        .byte $ce, $11    ;; line 21
        .byte $e4, $11    ;; line 22

topo_color_bytes:
        .byte $00, $94    ;; line 0
        .byte $16, $94    ;; line 1
        .byte $2c, $94    ;; line 2
        .byte $42, $94    ;; line 3
        .byte $58, $94    ;; line 4
        .byte $6e, $94    ;; line 5
        .byte $84, $94    ;; line 6
        .byte $9a, $94    ;; line 7
        .byte $b0, $94    ;; line 8
        .byte $c6, $94    ;; line 9
        .byte $dc, $94    ;; line 10
        .byte $f2, $94    ;; line 11
        .byte $08, $95    ;; line 12
        .byte $1e, $95    ;; line 13
        .byte $34, $95    ;; line 14
        .byte $4a, $95    ;; line 15
        .byte $60, $95    ;; line 16
        .byte $76, $95    ;; line 17
        .byte $8c, $95    ;; line 18
        .byte $a2, $95    ;; line 19
        .byte $b8, $95    ;; line 20
        .byte $ce, $95    ;; line 21
        .byte $e4, $95    ;; line 22

world_bytes:
        .byte $00, $1c    ;; line 0
        .byte $16, $1c    ;; line 1
        .byte $2c, $1c    ;; line 2
        .byte $42, $1c    ;; line 3
        .byte $58, $1c    ;; line 4
        .byte $6e, $1c    ;; line 5
        .byte $84, $1c    ;; line 6
        .byte $9a, $1c    ;; line 7
        .byte $b0, $1c    ;; line 8
        .byte $c6, $1c    ;; line 9
        .byte $dc, $1c    ;; line 10
        .byte $f2, $1c    ;; line 11
        .byte $08, $1d    ;; line 12
        .byte $1e, $1d    ;; line 13
        .byte $34, $1d    ;; line 14
        .byte $4a, $1d    ;; line 15
        .byte $60, $1d    ;; line 16
        .byte $76, $1d    ;; line 17
        .byte $8c, $1d    ;; line 18
        .byte $a2, $1d    ;; line 19
        .byte $b8, $1d    ;; line 20
        .byte $ce, $1d    ;; line 21
        .byte $e4, $1d    ;; line 22

world_color_bytes:
        .byte $fa, $1d    ;; line 0
        .byte $10, $1e    ;; line 1
        .byte $26, $1e    ;; line 2
        .byte $3c, $1e    ;; line 3
        .byte $52, $1e    ;; line 4
        .byte $68, $1e    ;; line 5
        .byte $7e, $1e    ;; line 6
        .byte $94, $1e    ;; line 7
        .byte $aa, $1e    ;; line 8
        .byte $c0, $1e    ;; line 9
        .byte $d6, $1e    ;; line 10
        .byte $ec, $1e    ;; line 11
        .byte $02, $1f    ;; line 12
        .byte $18, $1f    ;; line 13
        .byte $2e, $1f    ;; line 14
        .byte $44, $1f    ;; line 15
        .byte $5a, $1f    ;; line 16
        .byte $70, $1f    ;; line 17
        .byte $86, $1f    ;; line 18
        .byte $9c, $1f    ;; line 19
        .byte $b2, $1f    ;; line 20
        .byte $c8, $1f    ;; line 21
        .byte $de, $1f    ;; line 22

world_key_handlers:=(
    do_nothing, ;; left shift
    do_nothing, ;; right shift
    draw_world_space, ;; spacebar
    minus_char_world, ;; colon
    plus_char_world, ;; semicolon
    go_up, ;; w
    go_left, ;; a
    go_down, ;; s
    go_right, ;; d
    copy_world, ;; c
    paste_world, ;; p
    prepare_print_bytes, ;; k
    bring_up_overlay, ;; b
    do_nothing, ;; u
    prepare_save, ;; f5
    prepare_load, ;; f7
    do_nothing, ;; f
    increment_background, ;; g
    increment_border, ;; h
    minus_char_extra, ;; at
    plus_char_extra, ;; star
    do_nothing, ;; escape
    shift_down, ;; cursor down
    shift_up, ;; cursor up
    shift_right, ;; cursor right
    shift_left, ;; cursor left
    really_handle_flip, ;; z
    handle_one, ;; 1
    handle_two, ;; 2
    handle_three, ;; 3
    handle_four, ;; 4
    handle_five, ;; 5
    handle_six, ;; 6
    handle_seven, ;; 7
    handle_eight, ;; 8
    handle_nine, ;; 9
    handle_zero, ;; 0
    bucket_fill, ;; m
    prepare_print_bytes, ;; t
    prepare_full_new, ;; f1
    prepare_partial_new, ;; f3
    do_nothing, ;; y
    apply_color, ;; o
    prepare_char_editor, ;; x
    suck_char, ;; n
    do_nothing, ;; enter
    kill_overlay, ;; escape
    kill_overlay ;; run-stop
)-1

world_key_handlers_hi .byte >world_key_handlers
world_key_handlers_lo .byte <world_key_handlers

start_tiler:
        jsr copy_character_bytes
        jsr reset_new_state

resume_tiler:
        jsr clear_screen
        jsr set_screen_colors
        color_chars foreground_color
        jsr print_room
        mova do_world_move, #1

        disable_timer squelch_characters
        enable_timer_a walk_irq, TIMER_VALUE

-       jsr read_key

        ;; not safe to do these operations in the irq
        cmpa do_save, #1
        bne +
        mova do_save, #0
        jsr save_file
        jmp resume_tiler

+       cmpa do_load, #1
        bne +
        mova do_load, #0
        jsr load_file
        jmp resume_tiler

+       cmpa go_char_editor, #1
        bne +
        mova go_char_editor, #0
        jsr resume_char_editor
        jmp resume_tiler

+       cmpa do_print_bytes, #1
        bne +
        mova do_print_bytes, #0
        jsr print_bytes
        jmp resume_tiler

+       cmpa full_new_state, DO_FULL_NEW_STATE
        bne +
        jsr do_full_new
        jmp resume_tiler

+       cmpa partial_new_state, DO_PARTIAL_NEW_STATE
        bne +
        jsr do_partial_new
        jmp resume_tiler

+       jmp -
        rts

bring_up_overlay:
        lda characters_up
        eor #1
        sta characters_up
        cmp #0
        bne +
        trigger_timer squelch_characters
        rts
+       jsr color_bottom_black
        jsr plot_characters
        jsr print_world_coordinates
        rts

minus_char_world:
        cmpa characters_up, #1
        beq +
        reset_timer squelch_characters
+       jsr minus_char
        rts

plus_char_world:
        cmpa characters_up, #1
        beq +
        reset_timer squelch_characters
+       jsr plus_char
        rts

key_reader_special_callback:
        mova $2c, #0

        cmpa full_new_state, #0
        rtseq

        cmpa $fc, #F1_KEY
        bne +
        mova $2c, #1

+       cmpa $fc, #F3_KEY
        bne +
        mova $2c, #1

+       cmpa $2c, #1
        rtseq

        mova full_new_state, #255
        mova partial_new_state, #255
        rts

reset_new_state:
        mova full_new_state, #0
        mova partial_new_state, #0
        pusha x_pos
        pusha y_pos
        jsr cleanup_new_state
        pulla y_pos
        pulla x_pos
        rts

reset_world:
        ldx #0
-       lda #"."
        sta world, x
        inx
        cpx #225
        bne -

        ldx #0
-       lda WHITE_COLOR
        sta world_color, x
        inx
        cpx #225
        bne -
        rts

do_full_new:
        enable_timer_a do_no_irq, TIMER_VALUE
        jsr copy_character_bytes
        jsr reset_world
        jsr handle_char_editor_new
        jsr reset_new_state

        mova current_character, #0
        mova current_color, WHITE_COLOR
        mova x_world, #0
        mova y_world, #0
        rts

do_partial_new:
        enable_timer_a do_no_irq, TIMER_VALUE
        jsr reset_world
        jsr reset_new_state
        mova current_color, WHITE_COLOR
        mova x_world, #0
        mova y_world, #0
        rts

prepare_full_new:
        inc full_new_state
        rts

print_second_full_new_state:
        set_screen_byte #1, #0, #"!"
        set_screen_byte #1, #2, #"!"
        inc_screen_color #1, #0
        inc_screen_color #1, #2
        ;; passthrough
print_first_full_new_state:
        set_screen_byte #0, #0, #"!"
        set_screen_byte #0, #2, #"!"
        inc_screen_color #0, #0
        inc_screen_color #0, #2
        rts

finish_full_new_state:
        mova full_new_state, DO_FULL_NEW_STATE
cleanup_new_state:
        set_screen_byte #0, #0, #" "
        set_screen_byte #0, #2, #" "
        set_screen_byte #1, #0, #" "
        set_screen_byte #1, #2, #" "
        rts

test_full_new:
        cmpa full_new_state, #255
        jmpeq cleanup_new_state
        cmpa full_new_state, #1
        jmpeq print_first_full_new_state
        cmpa full_new_state, #2
        jmpeq print_second_full_new_state
        lda full_new_state
        cmp #3
        bcs finish_full_new_state
        rts

print_second_partial_new_state:
        set_screen_byte #1, #0, #"!"
        inc_screen_color #1, #0
        ;; passthrough
print_first_partial_new_state:
        set_screen_byte #0, #0, #"!"
        inc_screen_color #0, #0
        rts

finish_partial_new_state:
        set_screen_byte #0, #0, #" "
        set_screen_byte #1, #0, #" "
        mova partial_new_state, DO_FULL_NEW_STATE
        rts

prepare_partial_new:
        inc partial_new_state
        rts

test_partial_new:
        cmpa partial_new_state, #255
        jmpeq cleanup_new_state
        cmpa partial_new_state, #1
        jmpeq print_first_partial_new_state
        cmpa partial_new_state, #2
        jmpeq print_second_partial_new_state
        lda partial_new_state
        cmp #3
        bcs finish_partial_new_state
        rts

world_save:
        mova do_save, #0
        jsr save_file
        jsr resume_tiler
        rts

world_load:
        mova do_load, #0
        jsr load_file
        jsr resume_tiler
        rts

topo_to_fb:
        lda topo_world_bytes, y
        sta $fb
        iny
        lda topo_world_bytes, y
        sta $fc
        stx $fd
        a16 $fb, $fc, $fd
        rts

topo_color_to_fb:
        lda topo_color_bytes, y
        sta $fb
        iny
        lda topo_color_bytes, y
        sta $fc
        stx $fd
        a16 $fb, $fc, $fd
        rts

world_to_fb:
        lda world_bytes, y
        sta $fb
        iny
        lda world_bytes, y
        sta $fc
        stx $fd
        a16 $fb, $fc, $fd
        rts

world_color_to_fb:
        lda world_color_bytes, y
        sta $fb
        iny
        lda world_color_bytes, y
        sta $fc
        stx $fd
        a16 $fb, $fc, $fd
        rts

coords_to .macro
        ldx \1 ; x
        lda \2 ; y
        clc
        asl
        tay
        jsr \3
        ldy #0
.endm

load_world_bytes_into_d9:
        ldy y_pos
        lda world_bytes, y
        sta $d9
        iny
        lda world_bytes, y
        sta $da
        a16 $d9, $da, x_pos
        ldy #0
        rts

load_world_color_bytes_into_d9:
        ldy y_pos
        lda world_color_bytes, y
        sta $d9
        iny
        lda world_color_bytes, y
        sta $da
        a16 $d9, $da, x_pos
        ldy #0
        rts

apply_color:
        coords_to x_world, y_world, world_color_to_fb
        lda current_color
        sta ($fb), y
        rts

suck_char:
        cmpa characters_up, #1
        beq +
        reset_timer squelch_characters
+       coords_to x_world, y_world, world_to_fb
        lda ($fb), y
        sta wee_target
        jmp go_wee

print_room:
        pusha x_world
        pusha y_world

        mova x_world, #0
        mova y_world, #0

-       coords_to x_world, y_world, world_to_fb
        lda ($fb), y
        pha
        coords_to x_world, y_world, topo_to_fb
        pla
        sta ($fb), y

        coords_to x_world, y_world, world_color_to_fb
        lda ($fb), y
        pha
        coords_to x_world, y_world, topo_color_to_fb
        pla
        sta ($fb), y

        inc x_world
        cmpa x_world, TOPOLOGY_WIDTH
        bne -

        mova x_world, #0
        inc y_world
        cmpa y_world, TOPOLOGY_HEIGHT
        bne -

        pulla y_world
        pulla x_world
        rts

print_room_first_line:
        pusha x_world
        pusha y_world

        mova x_world, #0
        mova y_world, #0

-       coords_to x_world, y_world, world_to_fb
        lda ($fb), y
        pha
        coords_to x_world, y_world, topo_to_fb
        pla
        sta ($fb), y

        coords_to x_world, y_world, world_color_to_fb
        lda ($fb), y
        pha
        coords_to x_world, y_world, topo_color_to_fb
        pla
        sta ($fb), y

        inc x_world
        cmpa x_world, TOPOLOGY_WIDTH
        bne -

        pulla y_world
        pulla x_world
        rts


print_room_last_four_lines:
        pusha x_world
        pusha y_world

        mova x_world, #0
        mova y_world, TOPOLOGY_HEIGHT - 4

-       coords_to x_world, y_world, world_to_fb
        lda ($fb), y
        pha
        coords_to x_world, y_world, topo_to_fb
        pla
        sta ($fb), y

        coords_to x_world, y_world, world_color_to_fb
        lda ($fb), y
        pha
        coords_to x_world, y_world, topo_color_to_fb
        pla
        sta ($fb), y

        inc x_world
        cmpa x_world, TOPOLOGY_WIDTH
        bne -

        mova x_world, #0
        inc y_world
        cmpa y_world, TOPOLOGY_HEIGHT
        bne -

        pulla y_world
        pulla x_world
        rts

test_new:
        pusha x_pos
        pusha y_pos
        jsr test_full_new
        jsr test_partial_new
        pulla y_pos
        pulla x_pos
        rts

do_no_irq:
        jmp $eabf

move_world_character:
        jsr plot_characters
        jsr move_character
        mova do_reset_character, #0
        rts

handle_squelch_characters_timeout:
        disable_timer squelch_characters
        jsr print_room_first_line
        jsr print_room_last_four_lines
        jsr move_character
        mova characters_up, #0
        rts

walk_irq:
        check_timer squelch_characters, handle_squelch_characters_timeout

        cmpa do_wee_left, #1
        jsreq wee_left

        cmpa do_wee_right, #1
        jsreq wee_right

        cmpa characters_up, #1
        bne +
        jsr print_world_coordinates

+       jsr test_new

        cmpa do_reset_character, #1
        jsreq move_world_character

        cmpa do_world_move, #1
        bne +
        jsr move_character
        mova do_world_move, #0

+       handle_keys world_key_handlers
        jmp $eabf

move_character:
        coords_to prev_x_world, prev_y_world, world_to_fb
        lda ($fb), y
        pha
        coords_to prev_x_world, prev_y_world, topo_to_fb
        pla
        sta ($fb), y

        coords_to x_world, y_world, topo_to_fb
        lda current_character
        sta ($fb), y

        coords_to prev_x_world, prev_y_world, world_color_to_fb
        lda ($fb), y
        pha
        coords_to prev_x_world, prev_y_world, topo_color_to_fb
        pla
        sta ($fb), y

        coords_to x_world, y_world, topo_color_to_fb
        stay ($fb), y, current_color

        rts

print_world_coordinates:
        .enc "screen"
        mova $1003, #"x"
        mova $1008, #"y"
        .enc "none"

        lda x_world
        print_a_as_hex #5, #0

        lda y_world
        print_a_as_hex #10, #0

        print_current_character_as_hex #14, #0

        coords_to x_world, y_world, world_color_to_fb
        lda ($fb), y
        print_a_as_hex #17, #0
        rts

go_up:
        cmpa y_world, #0
        rtseq
        mova prev_y_world, y_world
        dec y_world
        mova prev_x_world, x_world
        mova do_world_move, #1
        rts

go_down:
        cmpa y_world, TOPOLOGY_HEIGHT - 1
        rtseq
        mova prev_y_world, y_world
        inc y_world
        mova prev_x_world, x_world
        mova do_world_move, #1
        rts

go_left:
        cmpa x_world, #0
        rtseq
        mova prev_x_world, x_world
        dec x_world
        mova prev_y_world, y_world
        mova do_world_move, #1
        rts

go_right:
        cmpa x_world, TOPOLOGY_WIDTH - 1
        rtseq
        mova prev_x_world, x_world
        inc x_world
        mova prev_y_world, y_world
        mova do_world_move, #1
        rts

prepare_char_editor:
        mova go_char_editor, #1
        enable_timer_a do_no_irq, TIMER_VALUE
        rts

draw_world_space:
        coords_to x_world, y_world, world_to_fb
        stay ($fb), y, current_character

        coords_to x_world, y_world, topo_to_fb
        stay ($fb), y, current_character

        coords_to x_world, y_world, world_color_to_fb
        stay ($fb), y, current_color

        coords_to x_world, y_world, topo_color_to_fb
        stay ($fb), y, current_color

        rts

color_current_character:
        coords_to x_world, y_world, topo_color_to_fb
        stay ($fb), y, current_color
        rts

increment_character_color:
        inc current_color
        cmpa current_color, YELLOW_COLOR + 1
        bne +
        mova current_color, BLACK_COLOR
+       jsr color_current_character
        rts

handle_one:
        mova current_color, WHITE_COLOR
        jmp color_current_character

handle_two:
        mova current_color, RED_COLOR
        jmp color_current_character

handle_three:
        mova current_color, CYAN_COLOR
        jmp color_current_character

handle_four:
        mova current_color, VIOLET_COLOR
        jmp color_current_character

handle_five:
        mova current_color, GREEN_COLOR
        jmp color_current_character

handle_six:
        mova current_color, BLUE_COLOR
        jmp color_current_character

handle_seven:
        mova current_color, YELLOW_COLOR
        jmp color_current_character

handle_eight:
        mova current_color, #8
        jmp color_current_character

handle_nine:
        mova current_color, #9
        jmp color_current_character

handle_zero:
        mova current_color, BLACK_COLOR
        jmp color_current_character

try_bucket_fill:
        lda x_world
        cmp TOPOLOGY_WIDTH
        bcs +
        lda y_world
        cmp TOPOLOGY_HEIGHT
        bcs +

        coords_to x_world, y_world, world_to_fb
        cmpax ($fb), y, bucket_fill_character
        bne +

        coords_to x_world, y_world, world_color_to_fb
        cmpax ($fb), y, bucket_fill_color
        bne +

        jsr add_bucket_item
        jsr draw_world_space
+       rts

dec_x:
        dec x_world
        jsr try_bucket_fill
        inc x_world
        rts

dec_x_inc_y:
        dec x_world
        inc y_world
        jsr try_bucket_fill
        dec y_world
        inc x_world
        rts

inc_y:
        inc y_world
        jsr try_bucket_fill
        dec y_world
        rts

inc_x_inc_y:
        inc x_world
        inc y_world
        jsr try_bucket_fill
        dec y_world
        dec x_world
        rts

inc_x:
        inc x_world
        jsr try_bucket_fill
        dec x_world
        rts

inc_x_dec_y:
        inc x_world
        dec y_world
        jsr try_bucket_fill
        inc y_world
        dec x_world
        rts

dec_y:
        dec y_world
        jsr try_bucket_fill
        inc y_world
        rts

dec_x_dec_y:
        dec x_world
        dec y_world
        jsr try_bucket_fill
        inc y_world
        inc x_world
        rts

add_bucket_item:
        ldx bucket_fill_index
        stay bucket_fill_x, x, x_world
        stay bucket_fill_y, x, y_world
        inc bucket_fill_index
        rts

get_bucket_item:
        dec bucket_fill_index
        ldx bucket_fill_index
        movay x_world, bucket_fill_x, x
        movay y_world, bucket_fill_y, x
        rts

bucket_fill:
        mova $2b, #0
        mova $2c, #0

        ;; don't bucket fill if the starting world block + color is equal
        ;; to our current topo block + color
        coords_to x_world, y_world, world_to_fb
        movay bucket_fill_character, ($fb), y
        cmpa bucket_fill_character, current_character
        bne +
        mova $2b, #1

+       coords_to x_world, y_world, world_color_to_fb
        movay bucket_fill_color, ($fb), y
        cmpa bucket_fill_color, current_color
        bne +
        mova $2c, #1

+       lda $2b
        and $2c
        rtsne

        coords_to x_world, y_world, world_color_to_fb

        mova bucket_fill_index, #0
        jsr add_bucket_item

        pusha x_world
        pusha y_world

-       jsr get_bucket_item

        jsr try_bucket_fill
        jsr dec_x
        jsr dec_x_inc_y
        jsr inc_y
        jsr inc_x_inc_y
        jsr inc_x
        jsr inc_x_dec_y
        jsr dec_y
        jsr dec_x_dec_y

        cmpa bucket_fill_index, #0
        bne -

        pulla y_world
        pulla x_world
        rts

color_bottom_black:
        pusha x_world
        pusha y_world

        mova x_world, #0
        mova y_world, TOPOLOGY_HEIGHT - 4

        coords_to x_world, y_world, topo_to_fb
        ldy #21
        lda SPACE_CHAR
-       sta ($fb), y
        dey
        bpl -

        mova y_world, TOPOLOGY_HEIGHT - 1

        coords_to x_world, y_world, topo_to_fb
        ldy #21
        lda SPACE_CHAR
-       sta ($fb), y
        dey
        bpl -

        pulla y_world
        pulla x_world
        rts

really_shift_world_left:
        ldx #0

-       ldy #1
-       lda ($fb), y
        dey
        sta ($fb), y
        iny
        iny
        cpy TOPOLOGY_WIDTH
        bne -

        ldy #0
        lda ($fd), y
        ldy TOPOLOGY_WIDTH - 1
        sta ($fb), y

        a16 $fb, $fc, TOPOLOGY_WIDTH
        a16 $fd, $fe, TOPOLOGY_WIDTH

        inx
        cpx TOPOLOGY_HEIGHT
        bne --

        rts

really_shift_world_right:
        ldx #0

-       ldy TOPOLOGY_WIDTH - 2
-       lda ($fd), y
        iny
        sta ($fd), y
        dey
        dey
        cpy #255
        bne -

        ldy TOPOLOGY_WIDTH - 1
        lda ($fb), y
        ldy #0
        sta ($fd), y

        a16 $fb, $fc, TOPOLOGY_WIDTH
        a16 $fd, $fe, TOPOLOGY_WIDTH

        inx
        cpx TOPOLOGY_HEIGHT
        bne --

        rts

shift_world_left .macro
        mova $fb, #<\1
        mova $fc, #>\1
        mova $fd, #<\2
        mova $fe, #>\2
        jsr really_shift_world_left
.endm

shift_world_right .macro
        mova $fb, #<\1
        mova $fc, #>\1
        mova $fd, #<\2
        mova $fe, #>\2
        jsr really_shift_world_right
.endm

shift_up:
        ;; first world line
        mova $fb, #$00
        mova $fc, #$1c
        ;; second world line
        mova $fd, #$16
        mova $fe, #$1c
        ;; last line
        mova $31, #$e4
        mova $32, #$1d
        ;; what to fill
        mova $33, #"."
        jsr really_shift_up

        ;; first world color line
        mova $fb, #$fa
        mova $fc, #$1d
        ;; second world color line
        mova $fd, #$10
        mova $fe, #$1e
        ;; last line
        mova $31, #$de
        mova $32, #$1f
        ;; what to fill
        mova $33, WHITE_COLOR
        jsr really_shift_up

        mova do_world_move, #1
        jsr print_room
        rts

really_shift_up:
        ldx TOPOLOGY_HEIGHT - 1
-       ldy TOPOLOGY_WIDTH - 1
-       lda ($fd), y
        sta ($fb), y
        dey
        bpl -

        a16 $fb, $fc, TOPOLOGY_WIDTH
        a16 $fd, $fe, TOPOLOGY_WIDTH

        dex
        bpl --

        ;; store dots
        ldy TOPOLOGY_WIDTH - 1
        lda $33
-       sta ($31), y
        dey
        bpl -
        rts

shift_down:
        ;; second to last line
        mova $fb, #$ce
        mova $fc, #$1d
        ;; last line
        mova $fd, #$e4
        mova $fe, #$1d
        ;; first line
        mova $31, #$00
        mova $32, #$1c
        ;; what to fill
        mova $33, #"."
        jsr really_shift_down

        ;; second to last color line
        mova $fb, #$c8
        mova $fc, #$1f
        ;; last color line
        mova $fd, #$de
        mova $fe, #$1f
        ;; first color line
        mova $31, #$fa
        mova $32, #$1d
        ;; what to fill
        mova $33, WHITE_COLOR
        jsr really_shift_down

        mova do_world_move, #1
        jsr print_room
        rts

really_shift_down:
        ldx TOPOLOGY_HEIGHT - 1
-       ldy TOPOLOGY_WIDTH - 1
-       lda ($fb), y
        sta ($fd), y
        dey
        bpl -

        s16 $fb, $fc, TOPOLOGY_WIDTH
        s16 $fd, $fe, TOPOLOGY_WIDTH

        dex
        bpl --

        lda $33
        ldy TOPOLOGY_WIDTH - 1
-       sta ($31), y
        dey
        bpl -

        rts

shift_left:
        ;; world
        shift_world_left world_left, world
        shift_world_left world, world_right
        shift_world_left world_right, world_dots

        ;; color
        shift_world_left world_color_left, world_color
        shift_world_left world_color, world_color_right
        shift_world_left world_color_right, world_color_white

        mova do_world_move, #1
        jsr print_room
        rts

shift_right:
        ;; world
        shift_world_right world, world_right
        shift_world_right world_left, world
        shift_world_right world_dots, world_left

        ;; color
        shift_world_right world_color, world_color_right
        shift_world_right world_color_left, world_color
        shift_world_right world_color_white, world_color_left

        mova do_world_move, #1
        jsr print_room
        rts

really_copy_screen:
        ldx TOPOLOGY_HEIGHT - 1
-       ldy TOPOLOGY_WIDTH - 1
-       lda ($fd), y
        sta ($fb), y
        dey
        bpl -

        a16 $fb, $fc, TOPOLOGY_WIDTH
        a16 $fd, $fe, TOPOLOGY_WIDTH

        dex
        bpl --
        rts

copy_screen .macro
        mova $fb, #<\1
        mova $fc, #>\1
        mova $fd, #<\2
        mova $fe, #>\2
        jsr really_copy_screen
.endm

copy_world:
        copy_screen world_clipboard, world
        copy_screen world_color_clipboard, world_color
        rts

paste_world:
        coords_to x_world, y_world, world_to_fb
        mova $fd, #<world_clipboard
        mova $fe, #>world_clipboard
        jsr really_paste

        coords_to x_world, y_world, world_color_to_fb
        mova $fd, #<world_color_clipboard
        mova $fe, #>world_color_clipboard
        jsr really_paste

        jsr print_room
        rts

really_paste:
        lda TOPOLOGY_WIDTH - 1
        sec
        sbc x_world
        sta $31

        lda TOPOLOGY_HEIGHT - 1
        sec
        sbc y_world
        tax

-       ldy $31
-       lda ($fd), y
        sta ($fb), y
        dey
        bpl -

        a16 $fb, $fc, TOPOLOGY_WIDTH
        a16 $fd, $fe, TOPOLOGY_WIDTH
        dex
        bpl --

        rts

really_fill_world:
        ldy #0
-       sta ($31), y
        iny
        bne -

        inc $32

        ldy #0
-       sta ($31), y
        iny
        cpy #250
        bne -

        rts

fill_world .macro
        mova $31, #<\1
        mova $32, #>\1
        lda \2
        jsr really_fill_world
.endm

initialize_world_outters:
        fill_world world_left, #"."
        fill_world world_right, #"."
        fill_world world_color_left, WHITE_COLOR
        fill_world world_color_right, WHITE_COLOR
        rts

kill_overlay:
        lda characters_up
        cmp #0
        rtseq
        trigger_timer squelch_characters
        rts
