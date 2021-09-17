# oh-my-zsh
## 代码
官方仓库：[GitHub](https://github.com/ohmyzsh/ohmyzsh)  
中国大陆镜像（每日同步一次）：[Gitee](https://gitee.com/mirrors/oh-my-zsh)

## 安装方法1
在中国大陆速度较慢

Github:
```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```
Gitee:
```
sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)"
sh -c "$(wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh -O -)"
```

## 安装方法2（大陆镜像）
1. `wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh -O /tmp/oh-my-zsh_install.sh`
2. 用文本编辑器打开 `/tmp/oh-my-zsh_install.sh`
3. 修改第 45 行，由 `REPO=${REPO:-ohmyzsh/ohmyzsh}` 改为 `REPO=${REPO:-mirrors/ohmyzsh}`
4. 修改第 46 行，由 `REMOTE=${REMOTE:-https://github.com/${REPO}.git}` 改为 `REMOTE=${REMOTE:-https://gitee.com/${REPO}.git}`
5. 保存并运行 `/tmp/oh-my-zsh_install.sh`

# oh-my-zsh插件
## zsh-autosuggestions
Github: `git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions`  
Gitee: `git clone https://gitee.com/hailin_cool/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions`

## zsh-syntax-highlighting
Github: `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting`  
Gitee: `git clone https://gitee.com/hailin_cool/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting`
