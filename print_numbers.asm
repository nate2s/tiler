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
digit_numbers: .text "0123456789abcdef"
.enc "none"

print_a_as_hex .segment
        tax
        pusha current_character
        txa
        sta current_character
        print_current_character_as_hex \1, \2
        pulla current_character
.endm

print_current_character_as_hex .macro
        pusha x_pos
        pusha y_pos
        mova x_pos, \1
        mova y_pos, \2
        jsr really_print_current_character_as_hex
        pulla y_pos
        pulla x_pos
.endm

really_print_current_character_as_hex:
        jsr load_screen_bytes_into_fb
        lda current_character
        lsr
        lsr
        lsr
        lsr
        tax
        lda digit_numbers, x
        sta ($fb), y

        lda current_character
        and #%00001111
        tax
        lda digit_numbers, x
        iny
        sta ($fb), y
        rts
