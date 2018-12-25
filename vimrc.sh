" 支援的顏色數量
set t_Co=256

" 啟用語法顏色
syntax on

" 顏色方案 (theme)
" 可在 /usr/share/vim/vimNN/colors 下找到可用的 theme
" 這裡的 NN 是 vim 的版本號碼
colorscheme torte

" 顯示行尾空白
highlight ExtraWhitespace ctermbg=DarkRed
autocmd BufEnter * if &ft != 'help' | match ExtraWhitespace /\s\+$/ | endif

" 自儲存前自動移除行尾空白
autocmd BufWritePre * :%s/\s\+$//e

" 自動成對
"inoremap ( ()<Esc>i
"inoremap [ []<Esc>i
"inoremap { {}<Esc>i
"inoremap < <><Esc>i
"inoremap " ""<Esc>i
"inoremap ' ''<Esc>i

" 自動縮排
" 啟用自動縮排以後，在貼上剪貼簿的資料時排版可能會亂掉，
" 這時可以手動切換至貼上模式 :set paste 再進行貼上
set ai

" 標記關鍵字
set hls
highlight Search cterm=none ctermbg=yellow ctermfg=gray

" 顯示行號
set number

" 行號顏色
highlight LineNr cterm=none ctermbg=DarkGray ctermfg=black
highlight CursorLineNr cterm=bold ctermbg=gray ctermfg=yellow

" 每行 80 的暗示
set colorcolumn=80
highlight ColorColumn ctermbg=blue

" 使用空白代替 Tab
set expandtab

" 自訂縮排 (Tab) 數
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=2

" 字數過長時不換行
set nowrap

" 關閉嗶嗶聲
set noeb

" 捲動時保留底下 2 行
set scrolloff=2

" 啟用行游標提示
set cursorline

" 高亮當前行 (水平)，要設定 set cursorline 才有效果
highlight CursorLine cterm=none ctermbg=DarkGray ctermfg=white

" 顯示狀態列
set laststatus=2

" 自訂狀態列顏色
highlight User1 cterm=none ctermbg=brown ctermfg=white

" 自訂狀態列資訊
" 狀態列左邊欄位
set statusline=%1*                                      " 使用User1自訂顏色方案
set statusline+=[
set statusline+=%{strlen(&filetype)?&filetype:'plain'}  " file type
set statusline+=,\ %{strlen(&fenc)?&fenc:&enc}          " file encoding
set statusline+=,\ %{&ff}                               " eol type
set statusline+=]
set statusline+=%m                                      " modified flag
set statusline+=%r                                      " read only flag
set statusline+=\ %-.20f                                " filename, <=20 chars
set statusline+=%=                                      " 開始靠右資訊
set statusline+=size:%{FileSize()}                      " file size
set statusline+=\ col:%c                              " column number
set statusline+=\ line:%l/%L                          " #line/#total
set statusline+=\ ~\ %p%%                               " percentage

" 自訂函數 - 狀態列
function FileSize()
    let bytes = getfsize(expand("%:p"))
    return substitute(bytes,'\d\zs\ze\%(\d\d\d\)\+$',',','g')
endfunction

" 自訂函數 - 快捷鍵
function MapToggle(key, opt)
  let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
  exec 'nnoremap '.a:key.' '.cmd
  exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command -nargs=+ MapToggle call MapToggle(<f-args>)

" Toogle 的快捷鍵
MapToggle <F5> wrap
MapToggle <F6> paste
MapToggle <F12> number


