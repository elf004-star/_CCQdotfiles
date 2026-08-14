# dotfiles

通过 `mklink` 创建符号链接，将仓库中的配置文件链接到当前用户主目录。

> 说明：
> - cmd 不支持 `~` 展开，因此用 `%USERPROFILE%`（当前用户主目录）代替硬编码的用户名
> - 需以管理员身份运行 cmd，或已开启"开发者模式"，否则 `mklink` 会因权限不足失败
> - 仓库需克隆在用户主目录下（如 `C:\Users\<用户名>\_CCQdotfiles`）

```cmd
mklink "%USERPROFILE%\_vimrc" "%USERPROFILE%\_CCQdotfiles\_vimrc"
mklink "%USERPROFILE%\.gitconfig" "%USERPROFILE%\_CCQdotfiles\.gitconfig"
```
