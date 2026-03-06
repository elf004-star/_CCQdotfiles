" ==================================================
" 基础配置
" ==================================================

" 关闭 vi 兼容模式，使用完整的 Vim 功能
set nocompatible

" 启用文件类型检测、插件和缩进规则
filetype plugin indent on

" ==================================================
" 显示设置
" ==================================================

set number                " 显示行号
" set cursorline           " 高亮当前行（当前注释掉了）
set ruler                 " 在状态栏显示光标位置（行号，列号）
set laststatus=2          " 总是显示状态栏（0=不显示，1=多窗口时显示，2=总是显示）
set showmatch             " 光标移动到括号时高亮匹配的括号
set incsearch             " 实时搜索，输入搜索内容时立即显示匹配结果
set hlsearch              " 高亮所有匹配的搜索结果

" ==================================================
" 编码设置
" ==================================================

set encoding=utf-8        " Vim 内部使用的字符编码
set fileencoding=utf-8    " 保存文件时使用的编码
" 自动检测文件编码的顺序列表
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936

" ==================================================
" 语法高亮
" ==================================================

syntax enable             " 启用语法高亮
syntax on                 " 开启语法高亮（更严格的语法检查）

" ==================================================
" 缩进设置
" ==================================================

set tabstop=4             " 一个 Tab 键在文件中显示的宽度（4个空格）
set shiftwidth=4          " 自动缩进时每次缩进的空格数
set softtabstop=4         " 按 Tab 键或 Backspace 键时移动的空格数
set expandtab             " 将 Tab 键转换为空格（推荐）
set autoindent            " 新行自动保持与上一行相同的缩进
set smartindent           " 智能缩进，根据编程语言规则调整
set smarttab              " 在行首按 Tab 键使用 shiftwidth，其他地方使用 tabstop

" ==================================================
" 搜索设置
" ==================================================

set ignorecase            " 搜索时忽略大小写
set smartcase             " 如果搜索模式包含大写字母，则区分大小写

" ==================================================
" 系统特定配置
" ==================================================

" 检测是否为 Windows 系统
if has("win32") || has("win64") || has("win16")
    " Windows 配置
    
    " 加载 Vim 自带的示例配置
    source $VIMRUNTIME/vimrc_example.vim
    
    " 加载 Windows 风格的键位映射（Ctrl+C/Ctrl+V 等）
    source $VIMRUNTIME/mswin.vim
    
    " 检查是否在 GUI 模式下运行
    if has("gui_running")
        " GUI 模式（gVim）配置
        
        " 设置光标在不同模式下的形状
        set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
        set guicursor+=a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
        
        colorscheme slate        " 设置颜色主题为 slate
        set encoding=utf-8
        set fileencodings=utf-8,gbk,big5,latin1
        " 主字体
        set guifont=0xProto\ Nerd\ Font\ Mono:h24  " 设置 GUI 字体
        " 宽字体
        set guifontwide=NSimSun:h24
    else
        " 终端模式（命令行 Vim）配置
        
        " 设置光标形状：插入模式=竖线，正常模式=方块，替换模式=下划线
        let &t_SI = "\<Esc>[6 q"   " 插入模式：竖线
        let &t_EI = "\<Esc>[2 q"   " 正常模式：方块
        let &t_SR = "\<Esc>[4 q"   " 替换模式：下划线
        
        " 启动和退出时设置终端光标形状（使用 silent 避免输出提示）
        autocmd VimEnter * silent !echo -ne "\e[2 q"  " 启动时：方块
        autocmd VimLeave * silent !echo -ne "\e[0 q"  " 退出时：默认
    endif
    
    " 设置光标行高亮样式
    highlight CursorLine ctermbg=237 guibg=#3a3a3a cterm=bold gui=bold
    
    " 设置文件换行符检测顺序（Windows 优先）
    set fileformats=dos,unix,mac
    
else
    " Linux/Unix 系统配置
    
    " 设置光标形状
    let &t_SI = "\e[6 q"   " 插入模式：竖线
    let &t_EI = "\e[2 q"   " 正常模式：方块
    let &t_SR = "\e[4 q"   " 替换模式：下划线
    
    " 启动和退出时设置终端光标形状（使用 silent 避免输出提示）
    autocmd VimEnter * silent !echo -ne '\e[2 q'  " 启动时：方块
    autocmd VimLeave * silent !echo -ne '\e[0 q'  " 退出时：默认
    
    " 检测终端类型，设置颜色支持
    if &term =~ "xterm" || &term =~ "screen" || &term =~ "tmux"
        " 检测是否支持真彩色
        if $COLORTERM == "truecolor" || $COLORTERM == "24bit"
            set termguicolors  " 启用真彩色支持
        endif
    endif
    
    " 设置光标行高亮样式（终端版本）
    highlight CursorLine ctermbg=237 cterm=bold ctermfg=none
    
    " 设置文件换行符检测顺序（Unix 优先）
    set fileformats=unix,dos,mac
endif

" ==================================================
" 自定义语法高亮
" ==================================================

" 定义函数：根据显示环境设置自定义符号的高亮样式
function! SetupCustomSymbolHighlight()
    " 检查是否在 GUI 模式或支持 256 色的终端
    if has("gui_running") || &t_Co >= 256
        " GUI 或 256 色终端：使用亮青色，粗体
        highlight CustomSymbol ctermfg=51 guifg=#00ffff cterm=bold
    else
        " 基本终端：使用青色，粗体
        highlight CustomSymbol ctermfg=cyan cterm=bold
    endif
endfunction

" 为 C/C++ 文件设置自定义符号高亮
autocmd FileType c,cpp call SetupCustomSymbolHighlight()
" 在 C/C++ 文件中匹配特定符号进行高亮
autocmd FileType c,cpp syntax match CustomSymbol /[&||<>=,;+\-*\/%!]/

" ==================================================
" 键盘映射
" ==================================================

" 使用 jk 快速退出插入模式（比按 Esc 更方便）
inoremap jk <Esc>

" 设置映射的超时时间（毫秒）
set timeoutlen=300

" Windows 系统下确保 jk 映射生效（防止被其他配置覆盖）
if has("win32") || has("win64") || has("win16")
    inoremap jk <Esc>
endif

" 使用 Ctrl+L 清除搜索高亮并重绘屏幕
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" ==================================================
" 其他优化设置
" ==================================================

" 禁用备份文件
set nobackup
set noswapfile        " 禁用交换文件
set nowritebackup     " 禁用写入备份

" 如果支持持久化撤销，则启用撤销历史记录
if has("persistent_undo")
    set undofile      " 将撤销历史保存到文件
    
    " 根据系统设置撤销文件目录
    if has("win32") || has("win64")
        set undodir=$HOME/vimfiles/undo  " Windows 目录
    else
        set undodir=$HOME/.vim/undo      " Linux/Unix 目录
    endif
    
    " 如果目录不存在则创建
    if !isdirectory(&undodir)
        silent call mkdir(&undodir, "p", 0700)  " p=创建父目录，0700=权限
    endif
endif

" 设置行号显示样式
highlight LineNr ctermfg=grey ctermbg=black        " 普通行号
highlight CursorLineNr ctermfg=yellow ctermbg=black cterm=bold  " 当前行行号

" 滚动时保留上下文行数
set scrolloff=5        " 垂直方向保留5行
set sidescrolloff=5    " 水平方向保留5列

" 自动重新加载外部修改的文件
set autoread
" 当窗口获得焦点或进入缓冲区时检查文件是否被修改
autocmd FocusGained,BufEnter * checktime

" 历史记录设置
set history=1000       " 命令历史记录数量
set undolevels=1000    " 撤销操作的最大次数

" ==================================================
" 文件类型特定设置
" ==================================================

" Python 文件使用 4 空格缩进
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab

" Web 开发相关文件使用 2 空格缩进
autocmd FileType javascript,typescript,html,css setlocal tabstop=2 shiftwidth=2 expandtab

" Markdown 文件设置：启用换行，禁用自动换行
autocmd FileType markdown setlocal wrap linebreak nolist textwidth=0 wrapmargin=0

" YAML 文件使用 2 空格缩进
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab

