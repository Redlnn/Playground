# Zinit + oh-my-posh

配置文件中也包含 `Powerlevel10k` 的配置，注释或取消注释相应行就行。

Zinit 用于高性能地加载 oh-my-zsh 或其他外部的 zsh 插件，`oh-my-posh`
或 `Powerlevel10k` 用于设置 zsh 主题。

## 安装一些前置依赖

### Debian

```bash
sudo aptitude install zsh batcat fzf exa git subversion
```

### Ubuntu

```bash
sudo aptitude install zsh bat fzf exa git subversion
```

## 常用变量

添加到下面内容到 `.zshrc` 或 `.bashrc` 或 `.profile` 或 `.zprofile`
中，一些软件包的可执行文件可能会放在 `~/bin` 或 `~/.local/bin` 中。

```bash
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
```

## 设置系统代理及 svn 代理

以 WSL 连接主机中的 HTTP 代理为例：

1. Windwos 使用 Powershell（管理员）执行以下命令添加防火墙规则（不要重复执行）

   ```powershell
   New-NetFirewallRule -DisplayName "WSL" -Direction Inbound  -InterfaceAlias "vEthernet (WSL)"  -Action Allow
   ```

2. 设置系统代理（可以添加到 `.zshrc` 或 `.bashrc` 或 `.profile` 或 `.zprofile` 中）
   > 下面的 `Redlnn-PC` 为主机的主机名（Hostname/设备名称）

   ```bash
   export http_proxy=http://Redlnn-PC.local:7890
   export https_proxy=http://Redlnn-PC.local:7890
   export ftp_proxy=http://Redlnn-PC.local:7890
   export HTTP_PROXY=http://Redlnn-PC.local:7890
   export HTTPS_PROXY=http://Redlnn-PC.local:7890
   export FTP_PROXY=http://Redlnn-PC.local:7890
   export no_proxy="127.0.0.1,localhost,127.0.1.1,Redlnn-PC,Redlnn-PC."
   export NO_PROXY="127.0.0.1,localhost,127.0.1.1,Redlnn-PC,Redlnn-PC."
   ```

3. 设置 SVN 代理

   执行一次 `svn` 命令，编辑 `~/.subversion/servers` 文件，取消注释 `[global]` 下的
   `http-proxy-host` 和 `http-proxy-port` 并修改，如下：

   ```ini
   [global]
   http-proxy-host = Redlnn-PC.local
   http-proxy-port = 7890
   ```

4. 设置 Git 代理

   编辑 `./.gitconfig` 文件，添加或合并以下配置

   ```ini
   [http]
       proxy = Redlnn-PC.local:7890
   [https]
       proxy = Redlnn-PC.local:7890
   ```

## 安装 Zinit

```bash
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
```

## 安装 Homebrew

### 设置 Homebrew 源为中科大源

```bash
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
```

### 运行安装脚本

```bash
bash -c "$(curl -fsSL https://mirrors.ustc.edu.cn/misc/brew-install.sh)"
```

根据提示进行操作，最后按照安装脚本的提示，将以下内容放入 `~/.profile` 和 `~/.zprofile`：

```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Set PATH, MANPATH, etc., for Homebrew.
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
```

### 安装 oh-my-posh

```bash
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```

> 更新的话使用 `brew update && brew upgrade oh-my-posh`

## 修改 .zshrc

将 `.zshrc` 内所有内容替换为下面的内容，包含以下操作：

1. 修复 GPG 无法在使用 zsh 弹出密码输入界面的问题，同时兼容 Powerlevel10k
2. 调用 oh-my-posh 并指定自定义主题（如果不需要自定义主题，删除第 4 行的 `config` 参数即可）
3. 设置 zsh 历史记录，供其他插件使用
4. 初始化 Zinit
5. 加载插件及其依赖

   > 1. oh-my-zsh 插件依赖：clipboard
   > 2. 用 svn 加载 oh-my-zsh 插件：extract（一条命令解压大部分压缩文件）
   > 3. oh-my-zsh 插件：virtualenv
   > 4. oh-my-zsh 插件：command-not-found（执行未知命令时提示安装包）
   > 5. oh-my-zsh 插件：plugins/colored-man-pages（彩色 man 手册）
   > 6. zsh 插件：fast-syntax-highlighting（更快的命令高亮）
   > 7. zsh 插件：zsh-completions
   > 8. zsh 插件：zsh-autosuggestions

```bash
# Fix GPG，must be written first when use Instant Prompt of Powerlevel10k
# See https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/gpg-agent/gpg-agent.plugin.zsh
export GPG_TTY=$(tty)

# Fix for passphrase prompt on the correct tty
# See https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html#option-_002d_002denable_002dssh_002dsupport
function _gpg-agent_update-tty_preexec {
  gpg-connect-agent updatestartuptty /bye &>/dev/null
}
autoload -U add-zsh-hook
add-zsh-hook preexec _gpg-agent_update-tty_preexec

# If enable-ssh-support is set, fix ssh agent integration
if [[ $(gpgconf --list-options gpg-agent 2>/dev/null | awk -F: '$1=="enable-ssh-support" {print $10}') = 1 ]]; then
  unset SSH_AGENT_PID
  if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  fi
fi

# Load oh-my-posh
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh-themes/custom.json)"

# See https://zsh.sourceforge.io/Doc/Release/Options.html
setopt INTERACTIVE_COMMENTS      # Allow use comments in command-line
# Set history for zsh plugins
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Load Powerlevel10k
#zinit ice depth=1; zinit light romkatv/powerlevel10k

# 使用 fzf 实现命令 Tab 键补全
[[ $(command -v fzf) ]] && zinit light Aloxaf/fzf-tab

# Load plugin from oh-my-zsh
# See https://github.com/ohmyzsh/ohmyzsh/blob/master/lib
# See https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins
zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::grep.zsh
zinit snippet OMZL::key-bindings.zsh
zinit ice svn; zinit snippet OMZ::plugins/extract
# zinit snippet OMZL::git.zsh
# zinit snippet OMZP::git
zinit snippet OMZP::virtualenv
# zinit snippet OMZP::z
[[ -e /usr/lib/command-not-found ]] && zinit snippet OMZP::command-not-found
zinit ice svn; zinit snippet OMZ::plugins/colored-man-pages

# 命令高亮+智能提示+一键补全
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    blockf \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ALIASES
alias ...=../..
alias ....=../../..
alias .....=../../../..
alias ......=../../../../..
alias grep='grep --color=auto'
alias md='mkdir -p'
alias rd=rmdir
alias micro='micro -clipboard terminal'

# Replace ls by exa
if [[ $(command -v exa) ]] {
    DISABLE_LS_COLORS=true
    unset LS_BIN_FILE
    for i (/bin/ls /usr/bin/ls /usr/local/bin/ls) {
        [[ ! -x ${i} ]] || {
            local LS_BIN_FILE=${i}
            break
        }
    }
    [[ -n ${LS_BIN_FILE} ]] || local LS_BIN_FILE=$(whereis ls 2>/dev/null | awk '{print $2}')
    alias lls=${LS_BIN_FILE}
    # lls is the original ls. lls为原版ls
    alias ls="exa -F --color=auto"
    # Exa is a modern version of ls. exa是一款优秀的ls替代品,拥有更好的文件展示体验,输出结果更快,使用rust编写。
    alias l='exa -Flbh --icons'
    alias la='exa -Flabgh --icons'
    alias ll='exa -Flbgh --icons'
    alias lsa='exa -FlabghR --icons'
    alias lst='exa -FlabghT --icons' # 输入lst,将展示类似于tree的树状列表
} else {
    alias ls='ls -F --color=auto'
    # color should not be always.
    alias lst='tree -pCsh'
    alias l='ls -Flah --color'
    alias la='ls -FlAh --color'
    alias ll='ls -Flh --color'
    alias lsa='ls -Flah --color'
}

# Replace cat by batcat
set_bat_paper_variable() {
    unset CAT_BIN_FILE i
    for i (/bin/cat ${PREFIX}/bin/cat /usr/bin/cat /usr/local/bin/cat) {
        [[ ! -x ${i} ]] || {
            local CAT_BIN_FILE=${i}
            unset i
            break
        }
    }
    [[ -n ${CAT_BIN_FILE} ]] || local CAT_BIN_FILE=$(whereis cat 2>/dev/null | awk '{print $2}')
    alias lcat=${CAT_BIN_FILE}
    # lcat is the original cat.
    typeset -g BAT_PAGER="less -m -RFQ" # You can type q to quit bat. 输q退出bat的页面视图
}

if [[ $(command -v bat) ]] {
    alias cat="bat -pp"
    set_bat_paper_variable
}

# 256 Color
export TERM=xterm-256color

#export PATH=$PATH:$NODE_HOME/bin
#export NODE_PATH=$NODE_HOME/lib/node_modules
export PATH=$PATH:$HOME/.local/bin

export LC_ALL=zh_CN.UTF-8
export LANGUAGE=zh_CN.UTF-8
export LANG=zh_CN.UTF-8

cd ~  # For WSL
```

## 更改默认 shell

```bash
chsh -s /usr/bin/zsh
```
