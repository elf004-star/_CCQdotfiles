# dotfiles

通过 `mklink` 创建符号链接，将仓库中的配置文件链接到当前用户主目录。

## 包含的文件

| 仓库文件 | 链接位置 | 作用 |
|---|---|---|
| `_vimrc` | `%USERPROFILE%\_vimrc` | Vim 配置 |
| `.gitconfig` | `%USERPROFILE%\.gitconfig` | Git 全局配置（含 GitHub 代理、Gitee 凭证等） |
| `.gitconfig-gitea` | `%USERPROFILE%\.gitconfig-gitea` | Gitea 专属身份配置，由 `.gitconfig` 的 `includeIf` 在 `~/code/gitea/` 目录下自动加载，覆盖全局 user 身份 |
| `.ssh/config` | `%USERPROFILE%\.ssh\config` | SSH 客户端配置（GitHub 本地代理、自建 Gitea 的 Host 别名等） |

## 安装

> 说明：
> - cmd 不支持 `~` 展开，因此用 `%USERPROFILE%`（当前用户主目录）代替硬编码的用户名
> - 需以管理员身份运行 cmd，或已开启"开发者模式"，否则 `mklink` 会因权限不足失败
> - 仓库需克隆在用户主目录下（如 `C:\Users\<用户名>\_CCQdotfiles`）
> - 若目标位置已存在同名真实文件，需先备份并删除，否则 `mklink` 会报"文件已存在"
> - `.ssh\config` 需确保 `%USERPROFILE%\.ssh` 目录已存在（首次使用 SSH 后会自动生成）

```cmd
mklink "%USERPROFILE%\_vimrc" "%USERPROFILE%\_CCQdotfiles\_vimrc"
mklink "%USERPROFILE%\.gitconfig" "%USERPROFILE%\_CCQdotfiles\.gitconfig"
mklink "%USERPROFILE%\.gitconfig-gitea" "%USERPROFILE%\_CCQdotfiles\.gitconfig-gitea"
mklink "%USERPROFILE%\.ssh\config" "%USERPROFILE%\_CCQdotfiles\.ssh\config"
```
