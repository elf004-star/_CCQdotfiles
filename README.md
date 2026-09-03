# dotfiles

通过 `mklink` 创建符号链接，将仓库中的配置文件链接到当前用户主目录。

## 包含的文件

| 仓库文件 | 链接位置 | 作用 |
|---|---|---|
| `_vimrc` | `%USERPROFILE%\_vimrc` | Vim 配置 |
| `.gitconfig` | `%USERPROFILE%\.gitconfig` | Git 全局配置（含 GitHub 代理、Gitee 凭证等） |
| `.gitconfig-gitea` | `%USERPROFILE%\.gitconfig-gitea` | Gitea 专属身份配置，由 `.gitconfig` 的 `includeIf` 在 `~/code/gitea/` 目录下自动加载，覆盖全局 user 身份 |
| `.ssh/config` | `%USERPROFILE%\.ssh\config` | SSH 客户端配置（GitHub 本地代理、自建 Gitea 的 Host 别名等） |
| `Zed/keymap.json` | `%APPDATA%\Zed\keymap.json` | Zed 按键映射（vim 模式、终端面板等快捷键） |
| `Zed/settings.json` | `%APPDATA%\Zed\settings.json` | Zed 编辑器设置（vim_mode、主题/字体、AI 服务商、本地代理等） |
| `Zed/tasks.json` | `%APPDATA%\Zed\tasks.json` | Zed 任务配置 |

## 安装

> 说明：
> - cmd 不支持 `~` 展开，因此用 `%USERPROFILE%`（当前用户主目录）代替硬编码的用户名
> - 需以管理员身份运行 cmd，或已开启"开发者模式"，否则 `mklink` 会因权限不足失败
> - 仓库需克隆在用户主目录下（如 `C:\Users\<用户名>\_CCQdotfiles`）
> - 若目标位置已存在同名真实文件，需先备份并删除，否则 `mklink` 会报"文件已存在"
> - `.ssh\config` 需确保 `%USERPROFILE%\.ssh` 目录已存在（首次使用 SSH 后会自动生成）
> - Zed 配置在 `%APPDATA%\Zed`（`%APPDATA%` 即 `C:\Users\<用户名>\AppData\Roaming`，同属环境变量、不硬编码用户名）；需先安装过 Zed 该目录才会存在

```cmd
mklink "%USERPROFILE%\_vimrc" "%USERPROFILE%\_CCQdotfiles\_vimrc"
mklink "%USERPROFILE%\.gitconfig" "%USERPROFILE%\_CCQdotfiles\.gitconfig"
mklink "%USERPROFILE%\.gitconfig-gitea" "%USERPROFILE%\_CCQdotfiles\.gitconfig-gitea"
mklink "%USERPROFILE%\.ssh\config" "%USERPROFILE%\_CCQdotfiles\.ssh\config"
mklink "%APPDATA%\Zed\keymap.json" "%USERPROFILE%\_CCQdotfiles\Zed\keymap.json"
mklink "%APPDATA%\Zed\settings.json" "%USERPROFILE%\_CCQdotfiles\Zed\settings.json"
mklink "%APPDATA%\Zed\tasks.json" "%USERPROFILE%\_CCQdotfiles\Zed\tasks.json"
```
