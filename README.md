## <b>tiler</b> is a character set and screen editor for the VIC-20

<b>tiler</b> lets you edit character sets and screens to use in your program.

<img src="img/tiler1.png" width="300">
<img src="img/tiler2.png" width="300">

### Instructions

#### In the main mode:

```
x:         enter character editor mode, or leave it
spacebar:  draw
w a s d:   movement
semicolon: current char left
quote:     current char right
c:         copy world
p:         paste world
b:         bring up overlay, or squelch it
z:         flip character selection row in overlay
g:         increment background color
h:         increment border color
1-0:       change color
m:         bucket fill
escape:    squelch overlay
f5:        save
f7:        load
```

#### In the character editor mode:

```
escape:    go to main mode
x:         flip character like an x-ray
spacebar:  draw
w a s d:   movement
semicolon: current char left
quote:     current char right
c:         copy character
p:         paste character
u:         limited undo
k:         clear character and copy it
1:         enable 1-character edit mode
4:         enable 4-character edit mode
y:         horizontal flip
g:         increment background color
h:         increment border color
z:         flip character selection row
1-0:       change color
f5:        save
f7:        load
```

#### In save or load mode:

```
escape:   exit
return:   save or load
f5 or f7: toggle between save/load screen and character set
```

### Build and run in the emulator

```
sh ./build.sh
```

To build tiler the following programs must be installed, with the exception of xvic:

```
vice emulator: xvic
assembler:     64tass
cruncher:      exomizer
```
