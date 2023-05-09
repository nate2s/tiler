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

;; $1000
screen_bytes:
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
SCREEN_BYTES_COUNT = #46

;; $9400
color_bytes:
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
COLOR_BYTES_COUNT = #46

;; $14d8
topo_bytes:
        .byte $d8, $14    ;; line 0
        .byte $50, $15    ;; line 1
        .byte $c8, $15    ;; line 2
        .byte $40, $16    ;; line 3
        .byte $b8, $16    ;; line 4
        .byte $30, $17    ;; line 5
        .byte $a8, $17    ;; line 6
        .byte $20, $18    ;; line 7
        .byte $98, $18    ;; line 8
        .byte $10, $19    ;; line 9
        .byte $88, $19    ;; line 10
        .byte $00, $1a    ;; line 11
        .byte $78, $1a    ;; line 12
        .byte $f0, $1a    ;; line 13
        .byte $68, $1b    ;; line 14
TOPO_BYTES_COUNT = #30

SOURCE_BYTES_START_LOW = #$00
SOURCE_BYTES_START_HIGH = #$80
SOURCE_BYTES_LENGTH = #8
DESTINATION_BYTES_START_LOW = $00
DESTINATION_BYTES_START_HIGH = $14
DESTINATION_BYTES_LAST_HIGH = $1c
LAST_CHARACTER_LOW = #$f8
LAST_CHARACTER_HIGH = #$1b
LAST_CHARACTER_LAST_LOW = #$00
LAST_CHARACTER_LAST_HIGH = #$1c
