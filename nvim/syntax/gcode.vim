" G-code syntax highlighting for Vim/Neovim
" Based on common G-code commands and structure

if exists("b:current_syntax")
  finish
endif

" Case insensitive
syn case ignore

" Comments - lines starting with ( or ; or containing comments
syn match gcodeComment /^[^GMTFXYZIJKR].*/ contains=gcodeCommentMarker
syn match gcodeComment /;.*$/
syn match gcodeComment /([^)]*)/
syn match gcodeCommentMarker /([^)]*)/ contained

" G-codes (motion and function codes)
syn match gcodeGCode /\<G\d\+\(\.\d\+\)\?/
syn match gcodeGCode /\<G\d\+\(\.\d\+\)\?/ containedin=gcodeComment

" M-codes (miscellaneous codes)
syn match gcodeMCode /\<M\d\+\(\.\d\+\)\?/
syn match gcodeMCode /\<M\d\+\(\.\d\+\)\?/ containedin=gcodeComment

" T-codes (tool selection)
syn match gcodeTCode /\<T\d\+/

" F-codes (feed rate)
syn match gcodeFCode /\<F\d\+\(\.\d\+\)\?/

" S-codes (spindle speed)
syn match gcodeSCode /\<S\d\+\(\.\d\+\)\?/

" Coordinates (X, Y, Z, I, J, K, R, etc.)
syn match gcodeCoordinate /\<[XYZIJKR]\s*[-+]\?\d\+\.\?\d*\>/
syn match gcodeCoordinate /\<[XYZIJKR]\s*[-+]\?\d\+\.\?\d*\>/ containedin=gcodeComment

" Line numbers
syn match gcodeLineNumber /\<N\d\+\>/

" Variables and expressions (common in some G-code dialects)
syn match gcodeVariable /#\d\+/
syn match gcodeVariable /\[.*\]/

" Highlight groups
hi def link gcodeComment Comment
hi def link gcodeCommentMarker Comment
hi def link gcodeGCode Statement
hi def link gcodeMCode Type
hi def link gcodeTCode Identifier
hi def link gcodeFCode Constant
hi def link gcodeSCode Constant
hi def link gcodeCoordinate Number
hi def link gcodeLineNumber PreProc
hi def link gcodeVariable Special

let b:current_syntax = "gcode"
