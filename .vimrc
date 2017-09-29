" (cogent's new ~/.vimrc)
" David 'cogent' Hand  2007-0924-1047
"
"   vim: ai et ts=4 sw=4 tw=77
"
" 2008-1002-1816  modified somewhat

" Keybindings used in this .vimrc:
" <F1>      toggle highlight of the line and olumn that the cursor is on
" <F5>      toggle highlighting of search results
" <S-F5>    toggle highlighting of certain random annoyances in the text
" <F6>      toggle paste mode
" <S-F6>    toggle "↳\ " at the beginning of continued lines
" »         :next
" «         :prev
" |         toggle status-line display of command-line file position

" TOOO: 
" - fullscreen = command+enter
" - maybe find a better light-background color scheme?
" - vim-perl (incl. template toolkit)

"============================================================================
"   Pathogen 
"   https://github.com/tpope/vim-pathogen
"   http://www.vim.org/scripts/script.php?script_id=2332
"----------------------------------------------------------------------------
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

"============================================================================
"   Solarized
"   https://github.com/altercation/solarized
"   http://ethanschoonover.com/solarized
"----------------------------------------------------------------------------

"let g:solarized_contrast="high"
"let g:solarized_visibility="high"
"syntax enable
"colorscheme solarized

"============================================================================
"   General settings
"----------------------------------------------------------------------------
set nocompatible
set cpoptions+=J

" vi[minfo]:
" 	'1000	Marks remembered for 1000 previous files
" 	!	Save and restore global variables
" 	f1	remember file marks
"	h	turn off hlsearch when first opening a file
" 	r/...	paths of removable media (don't save info on these files)
" 	n	Location of viminfo file
set viminfo='1000,!,f1,h,r/Volumes,r/media,r/mnt/cdrom,r/mnt/floppy,r/mnt/dvdrom,n~/.viminfo

set history=500
set undolevels=1000

set modeline
set modelines=20

"============================================================================
"   Being Careful
"----------------------------------------------------------------------------
set confirm
set autowrite

" back files up.  If we can't put the backup file in the current directory,
"   put it in /tmp instead
set backup
set backupdir-=~/tmp
set backupdir-=~/
set backupdir+=/tmp

"============================================================================
"   Display
"----------------------------------------------------------------------------
"-- Basic Presentation ------------------------------------------------------
set showcmd
set showmode
set shortmess=aIoO
set showbreak=↳\ 

map <S-F6> :call ToggleShowBreaks()<CR>
imap <S-F6> <C-O>:call ToggleShowBreaks()<CR>
map <Esc>[26~ :call ToggleShowBreaks()<CR>
imap <Esc>[26~ <C-O>:call ToggleShowBreaks()<CR>

let s:show_breaks = 1
function ToggleShowBreaks ()
    let s:show_breaks = !s:show_breaks
    if s:show_breaks
        set showbreak=↳\ 
    else
        set showbreak=
    endif
endfunction

"   GUI
set mousehide

"   Windows
set noequalalways
set splitbelow
set splitright

"============================================================================
"   GUI
"----------------------------------------------------------------------------
if has('gui_running')
    nmap <D-CR> :set fullscreen!<CR>
    set number
    set relativenumber
endif



"-- Status Line -------------------------------------------------------------
set laststatus=2  " always show a status line
set statusline=%!CogentStatusLine()

function CogentStatusLine ()
    " this is rather overdone
    let sl_bufnum           = '[%n]'
    let sl_filetype         = '%y'
    let sl_arglist_pos      = CogentStatusLineArglistPos()
    let sl_filename         = '%<%f'
    let sl_modified_flag    = '%m'
    let sl_readonly_flag    = '%r'
    let lhs='%('
    \      . sl_bufnum . sl_filetype . sl_arglist_pos
    \      . sl_modified_flag . sl_readonly_flag
    \      . ' '
    \      . sl_filename
    \      . '%)'

    let sl_bytevalue        = ' [0x%02.8B]'
    let sl_position         = '%l,%c%V %P'
    let rhs='%('
    \      . sl_position . sl_bytevalue
    \      . '%)'

    return lhs . '%= ' . rhs
endfunction

let s:show_arglist_pos = 0
function ToggleCogentStatusLineArglistPos ()  " <cough>
    let s:show_arglist_pos = !s:show_arglist_pos
endfunction

function CogentStatusLineArglistPos ()
    if s:show_arglist_pos
        return '%a'
    else
        return ''
    endif
endfunction

"-- Catch Mistakes and Annoyances -------------------------------------------
"map <S-F5> :call ToggleMatchMistakes()<CR>
"imap <S-F5> <C-O>:call ToggleMatchMistakes()<CR>
"map <Esc>[25~ :call ToggleMatchMistakes()<CR>
"imap <Esc>[25~ <C-O>:call ToggleMatchMistakes()<CR>

let s:match_mistakes = 0
function ToggleMatchMistakes ()
    let s:match_mistakes = !s:match_mistakes

    if s:match_mistakes
        let s:mistakes_WSpaceAtEOL_id  = matchadd('WSpaceAtEOL',  '\s\+$')
        let s:mistakes_LongLineMark_id = matchadd('LongLineMark', '%78c')
    else
        call matchdelete(s:mistakes_WSpaceAtEOL_id)
        call matchdelete(s:mistakes_LongLineMark_id)
    endif
endfunction

"-- vimdiff -----------------------------------------------------------------
" ignore whitespace differences in diff mode
set diffopt+=iwhite

"-- Other Presentation & Fun Toys -------------------------------------------
" paste mode (can't use map, because 'paste' will capture the <F6>)
set pastetoggle=<F6>

" invert search highlighting
"map <F5> :set invhlsearch<CR>
"imap <F5> <C-O>:set invhlsearch<CR>

" really show where the cursor is
map <F1> :set invcursorcolumn invcursorline<CR>
imap <F1> <C-O>:set invcursorcolumn invcursorline<CR>

" a key mapping to toggle fo+=a and fo-=a ?

"============================================================================
"   Behaviors
"----------------------------------------------------------------------------
"-- Filename Autocompletion -------------------------------------------------
set wildmenu
set wildmode=longest:full " was: longest,list
set wildignore=*~,#*#,*.sw?,*.o,*.class,.viminfo,CVS,.svn,.git,._*,Icon?

"-- Search and Replace ------------------------------------------------------
set incsearch
set hlsearch
set smartcase

"-- Editing & Movement ------------------------------------------------------
set backspace=indent,eol
set whichwrap=<,>,~,[,]
set virtualedit=block
set scrolloff=0  " I thought it might be nice to set this to 2.  It wasn't.
set nostartofline

"-- Multiple Files ----------------------------------------------------------
map « :prev<CR>
map » :next<CR>
map \ :call ToggleCogentStatusLineArglistPos()<CR>

"-- Mac OS X cut & paste ----------------------------------------------------

"============================================================================
"   Options Specific to File Types
"   (indenting, formatting, comments, compiling, printing(?),
"   spell-checking, autocompletion) 
"----------------------------------------------------------------------------
" these have been moved to ~/.vim/ftplugin/*.vim

"-- Code --------------------------------------------------------------------
let perl_include_pod=1  " perl highlighter should recognize POD

"-- Geeknet -----------------------------------------------------------------
function Geeknet_whitespace ()
    setlocal tabstop=8
    setlocal shiftwidth=8
    setlocal noexpandtab
endfunction

function Pivotal_whitespace ()
    setlocal tabstop=2
    setlocal shiftwidth=2
    setlocal expandtab
endfunction

"============================================================================
"----------------------------------------------------------------------------
" Orphans!
"----------------------------------------------------------------------------
"============================================================================

filetype plugin indent on  " apparently this might be redundant?

"----------------------------------------------------------------------------
" Available keybindings:
"
"   Q K 0  <Space> <CR> <BS>
"   <F1> ... <F12>
"   <S-F1> ... <S-F8>
"   <Up> <Down> <Left> <Right>
"   <Tab> & <Esc>[Z   (tab & shift-tab)
"   \
"
"   ;x
"
"   Cmd-N is <D-N>
"
" Remember multi-key keybindings!
"----------------------------------------------------------------------------
