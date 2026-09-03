# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 仓库定位

Windows 个人 dotfiles 仓库。仓库里的配置文件通过 `mklink` 符号链接安装到用户主目录
(`%USERPROFILE%`)下,本仓库无构建、测试、lint 流程。

**核心约束:仓库会在多台机器/多个用户名下同步**(README 与 NOTES.md 反复强调),因此:
- cmd 命令一律用 `%USERPROFILE%`(cmd 不展开 `~`,也不硬编码用户名)
- Zed 配置装在 `%APPDATA%\Zed` 下(`%APPDATA%` 同为环境变量),install 命令用 `%APPDATA%` 而非 `%USERPROFILE%`
- Vim/SSH 配置里用 `~`,vim-plug 不传目录参数以自动适配平台默认值
- 新增任何硬编码 `C:\Users\<某用户名>` 的写法都是错误,除非是临时调试

## 安装 / 符号链接(新机器)

> 需管理员 cmd 或开启"开发者模式";若目标已有同名真实文件,先备份删除再 mklink。

```cmd
mklink "%USERPROFILE%\_vimrc"          "%USERPROFILE%\_CCQdotfiles\_vimrc"
mklink "%USERPROFILE%\.gitconfig"      "%USERPROFILE%\_CCQdotfiles\.gitconfig"
mklink "%USERPROFILE%\.gitconfig-gitea" "%USERPROFILE%\_CCQdotfiles\.gitconfig-gitea"
mklink "%USERPROFILE%\.ssh\config"     "%USERPROFILE%\_CCQdotfiles\.ssh\config"
mklink "%APPDATA%\Zed\keymap.json"     "%USERPROFILE%\_CCQdotfiles\Zed\keymap.json"
mklink "%APPDATA%\Zed\settings.json"   "%USERPROFILE%\_CCQdotfiles\Zed\settings.json"
mklink "%APPDATA%\Zed\tasks.json"       "%USERPROFILE%\_CCQdotfiles\Zed\tasks.json"
```

`.ssh\config` 前需确保 `%USERPROFILE%\.ssh` 目录已存在;Zed 三个配置需先装过 Zed
(`%APPDATA%\Zed` 目录存在)。编辑即生效(链接到真实文件),改完文件无需任何构建步骤。

## 配置架构(需跨文件理解的部分)

### Git 身份分层(`.gitconfig` + `.gitconfig-gitea`)

- `.gitconfig` = 基础全局配置:**elf004** 身份、gitee 凭证 provider、
  `autocrlf=false`、GitHub HTTP 代理 `127.0.0.1:8118`。
- 关键机制是分层覆盖:
  `.gitconfig` 里的 `includeIf "gitdir:~/code/gitea/"` → 加载 `.gitconfig-gitea`,
  把身份覆盖为 **CCQ**(chunqianchen006@gmail.com)。
- **后果:在 `~/code/gitea/` 下任何仓库提交,身份是 CCQ;其余地方是 elf004。**
  新增远程/仓库或排查"提交作者不对"问题时,先看仓库路径是否命中此 includeIf。
  验证:`git config --list --show-origin`(在 gitea 目录内外各看一次)。

### 网络/代理分层(SSH + Git)

GitHub 走了两层本地代理,自建 Gitea 走 cpolar 隧道:

| 目标 | 机制 | 关键点 |
|---|---|---|
| `github.com`(git over SSH) | `.ssh/config` | `ProxyCommand /mingw64/bin/connect -S 127.0.0.1:8118` |
| GitHub(HTTPS) | `.gitconfig` | `[http "https://github.com"] proxy` |
| 自建 Gitea | `.ssh/config` | Host 别名 `ccq`(及裸 cpolar 地址),端口 14845,`IdentityFile ~/.ssh/id_ed25519_gitea_ccq`,`IdentitiesOnly yes` |

测试连通:`ssh -T git@github.com`、`ssh -T ccq`。注意 connect 是 Git Bash 的
`/mingw64/bin/connect`——若默认 shell 不是 Git Bash 会找不到该程序。

### Vim 配置(`_vimrc`)

- **下划线前缀是刻意的**:Windows Vim 读 `%USERPROFILE%\_vimrc`(而非 `.vimrc`)。
- 大量 `has("win32")` vs Unix 分支(光标形状、字体、编码、fileformats 等)。
- vim-plug 用 `call plug#begin()` **不传目录**——自动按平台选插件目录
  (Windows `~/vimfiles/plugged`,Unix `~/.vim/plugged`),这是跨机器通用的关键。
- 剪贴板同步用 `TextYankPost` 显式写 `@+`,而非 `set clipboard=unnamedplus`:
  Windows 上 unnamedplus 有 bug(y/yy 不同步,见 vim/vim#18357)。

## Vim 常用命令

安装/更新 vim-plug 声明的插件(用**真实 Windows Vim** 完整路径,别用 Git Bash 里的 vim):

```bash
"/c/Program Files/Vim/vim91/vim.exe" -N \
  -u 'C:/Users/<USER>/_CCQdotfiles/_vimrc' -c 'PlugInstall' -c 'qa!'
```

无头验证 vimrc 启动是否报错(出问题时的第一诊断手段):

```bash
"/c/Program Files/Vim/vim91/vim.exe" -N --cmd 'set nomore' \
  -u 'C:/Users/<USER>/_CCQdotfiles/_vimrc' <文件> -c 'messages' -c 'qa!' < /dev/null
```

## 本机 Vim 陷阱(详见 NOTES.md,该文件是排查手册)

- **本机有两个 Vim**:Windows Vim 9.1(`C:\Program Files\Vim\vim91\vim.exe`,
  读 `_vimrc`、`~/vimfiles/`)和 msys2 vim(Git Bash `/usr/bin/vim`,读 `~/.vimrc`、
  `~/.vim/`)。Git Bash 里敲 `vim` 走的是 msys2 版,**不读 `_vimrc`**,测试配置必须
  用完整路径调 Windows Vim。
- 启动弹 "Press ENTER / 请按 ENTER" = vimrc 启动期有报错塞满消息区,最常见是
  vim-plug 未装(E117: Unknown function: plug#begin)。用上面的 `-c 'messages'` 命令定位。
- vim-plug 必须装到 `~/vimfiles/autoload/plug.vim`;光 `plug#begin()` 不会装插件,
  要跑 `:PlugInstall`。
- Windows 上 `autocmd ... silent !echo` 即使 silent 仍会触发 "Press ENTER",
  改用 `silent! call system('...')`。
