# Vim 配置问题排查笔记

> 记录一次"`vim test.c` 总是弹 `请按 ENTER 或其它命令继续`"的排查与修复过程,以及可复用的经验。

## 现象

每次打开文件都会出现:

```
请按 ENTER 或其它命令继续   (Press ENTER or type command to continue)
```

## 定位过程(关键:取证,别猜)

1. **确认触发源**:启动时会执行外部命令的只有 `autocmd VimEnter * silent !echo ...`,
   于是把它改成 `silent! call system('echo ...')`(见下文「经验 4」)。
   ——但问题依旧,说明主因不在它。

2. **无头复现 + 翻 `:messages`**:用下面命令加载 vimrc、打开文件、把启动消息 dump 出来:

   ```bash
   # Git Bash 里要用真实 Windows Vim,而不是 msys2 的 /usr/bin/vim
   "/c/Program Files/Vim/vim91/vim.exe" -N --cmd 'set nomore' \
     -u 'C:/Users/CCQ/_CCQdotfiles/_vimrc' test.c \
     -c 'messages' -c 'qa!' < /dev/null
   ```

   结果立刻现形:

   ```
   Error detected while processing _vimrc:
   line    8: E117: Unknown function: plug#begin
   line   11: E492: Not an editor command: Plug 'jiangmiao/auto-pairs'
   line   13: E117: Unknown function: plug#end
   ```

## 根因

**vim-plug 根本没安装。** vimrc 一启动就执行三行 vim-plug 代码,全部报错,
错误消息塞满消息区 → 每次启动弹 "Press ENTER"。

顺带发现:插件目录 `~/vimfiles/plugged/` 一直是空的,`auto-pairs` 从没装上过。

## 修复

1. 安装 vim-plug(Windows Vim 用 `~/vimfiles` 布局):

   ```bash
   mkdir -p ~/vimfiles/autoload
   curl -fLo ~/vimfiles/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ```

2. 安装配置里声明的插件:

   ```bash
   "/c/Program Files/Vim/vim91/vim.exe" -N -u 'C:/Users/CCQ/_CCQdotfiles/_vimrc' \
     -c 'PlugInstall' -c 'qa!'
   ```

3. 重新用第 2 步的 dump 命令验证:消息区干净,不再有 E117/E492。

## 经验教训

### 1. 遇到 "Press ENTER",先翻 `:messages`
它提示之前一定有一条消息。用 `-c 'messages'` 无头 dump 出启动消息,是定位的
最快路径。不要靠猜哪一行"看起来会输出"。

### 2. 复现时必须用用户真实使用的 Vim
这台机器上有两个 Vim,配置布局完全不同:

| | 路径 | 读的 vimrc | 用户目录 |
|---|---|---|---|
| **Windows Vim 9.1**(日常用) | `C:\Program Files\Vim\vim91\vim.exe` | `%USERPROFILE%\_vimrc` | `~/vimfiles/` |
| **msys2 Vim**(Git Bash `/usr/bin/vim`) | `/usr/bin/vim` | `~/.vimrc` | `~/.vim/` |

在 Git Bash 里敲 `vim` 走的是 msys2 版,不读 `_vimrc`,会误导排查。测试一律用
完整路径调用 Windows Vim。

### 3. vim-plug 的路径
- `plug#begin({dir})` 必须是绝对路径,不支持相对路径。
- **不传参数**时,Windows 自动用 `~/vimfiles/plugged`、Unix 用 `~/.vim/plugged`——
  无需硬编码用户名,跨机器通用。
- 只 `call plug#begin()` 不会装插件,必须再跑 `:PlugInstall`。

### 4. `silent !` 在 Windows 上不可靠
`autocmd VimEnter * silent !echo ...` 这类启动时外部命令,在 Windows 上即使加了
`silent` 仍会触发 "Press ENTER" 提示。改用 `system()`:

```vim
" ✗ silent !echo -ne "\e[2 q"
" ✓ 捕获输出,不显示、不提示
autocmd VimEnter * silent! call system('echo -ne "\e[2 q"')
```

### 5. cmd 不支持 `~`
Windows 的 `mklink` 等命令不展开 `~`。跨机器、免硬编码用户名用 `%USERPROFILE%`:

```cmd
mklink "%USERPROFILE%\_vimrc" "%USERPROFILE%\_CCQdotfiles\_vimrc"
```

### 6. 检查清单(下次遇到同类问题)
- [ ] `:messages` 里有没有 E### 错误
- [ ] vim-plug / 插件是否真的装了(`~/vimfiles/autoload/plug.vim` 是否存在)
- [ ] 用的哪个 Vim(Windows 版 / msys2 版)
- [ ] 是否有启动时的外部命令(`VimEnter`/`BufEnter` 里的 `!`、`:checktime` 等)
