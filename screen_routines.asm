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

print_chars:
        ldx #0
        lda #0
-       sta $1000,x
        inx
        txa
        bne -
        rts

set_screen_colors:
        ;; set background+border to black
        lda #%00001000
        sta $900f
        rts

load_color_bytes_into_fd:
        ldy y_pos
        lda color_bytes, y
        sta $fd
        iny
        lda color_bytes, y
        sta $fe
        a16 $fd, $fe, x_pos
        ldy #0
        rts

load_screen_bytes_into_fb:
        ldy y_pos
        lda screen_bytes, y
        sta $fb
        iny
        lda screen_bytes, y
        sta $fc
        a16 $fb, $fc, x_pos
        ldy #0
        rts

inc_screen_color .macro
        mova x_pos, \1
        mova y_pos, \2
        jsr load_color_bytes_into_fd
        lda ($fd), y
        clc
        adc #1
        and #%00000111
        cmp BLACK_COLOR
        bne +
        lda WHITE_COLOR
+       sta ($fd), y
.endm

set_screen_byte .macro
        mova x_pos, \1
        mova y_pos, \2
        jsr load_screen_bytes_into_fb
        lda \3
        sta ($fb), y
.endm

color_chars .macro
        mova $fe, \1
        jsr do_color_chars
.endm

do_color_chars:
        ldy #0
        ldx #0
-       lda color_bytes,x
        sta $fc
        inx
        lda color_bytes,x
        sta $fd
        inx

        ldy #22
        lda $fe
-       sta ($fc),y
        dey
        bpl -

        cpx COLOR_BYTES_COUNT
        bne --
        rts

clear_screen:
        ldy #0
        ldx #0
-       lda screen_bytes,x
        sta $fc
        inx
        lda screen_bytes,x
        sta $fd
        inx

        ldy #22
        lda SPACE_CHAR
-       sta ($fc),y
        dey
        bpl -

        cpx SCREEN_BYTES_COUNT
        bne --
        rts

set_character_ram_to_destination_bytes:
        lda $9005
        and #%11110000
        ora #13
        sta $9005
        rts

copy_2048 .macro
        ;; destination
        lda \2
        sta $d9
        lda \1
        sta $da

        ;; source
        lda \4
        sta $db
        lda \3
        sta $dc

        ;; 8 * 256 = 2048
        ldx #7

-       ldy #0
-       lda ($db),y
        sta ($d9),y
        iny
        bne -

        inc $da
        inc $dc
        dex

        bpl --
.endm

copy_character_bytes:
        ;; set character ram to 5120
        jsr set_character_ram_to_destination_bytes

        copy_2048 #DESTINATION_BYTES_START_HIGH, #0, SOURCE_BYTES_START_HIGH, #0
        rts
