# ── WORD STYLE ───────────────────────────────────────────────────────────────
autoload -Uz select-word-style
select-word-style bash

# ── OPTIONS ──────────────────────────────────────────────────────────────────
setopt PROMPT_SUBST autocd appendhistory sharehistory \
       hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_find_no_dups

# ── HISTORY ──────────────────────────────────────────────────────────────────
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# ── PROMPT ───────────────────────────────────────────────────────────────────
git_branch() { git symbolic-ref --short HEAD 2>/dev/null | sed 's/.*/ (&)/'; }
# Colors: 141 (Soft Purple), 109 (Muted Blue/Teal), 211 (Soft Pink), 246 (Grey)
PROMPT='%F{211}%B%(?.⚡.💀)%b%f %F{109}%~%f %B%F{141}$(git_branch)%f%b %F{141}❯%f '
RPROMPT='%F{246}%T%f'
PS2='%F{141}┃%f '
PS4='%F{211}◢%f '
# ── ENV ───────────────────────────────────────────────────────────────────────
export PATH="$PATH:$HOME/.local/bin"
export EDITOR=nvim VISUAL=nvim
export XDG_CONFIG_HOME="$HOME/.config"

# ── HOMEBREW ─────────────────────────────────────────────────────────────────
# eval "$(/opt/homebrew/bin/brew shellenv)"

# ── EZA COLORS (muted 256-color, replaces vivid ANSI defaults) ───────────────
# di=dirs  ln=symlinks  ex=executables  da=dates  sn/sb=sizes  uu/un=user  gu/gn=group
# export EZA_COLORS="di=38;5;109:ln=38;5;173:ex=38;5;114:da=38;5;242:sn=38;5;242:sb=38;5;242:uu=38;5;109:un=38;5;174:gu=38;5;109:gn=38;5;174"

# ── ZINIT ─────────────────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ ! -d $ZINIT_HOME ]] && mkdir -p "$(dirname $ZINIT_HOME)" \
  && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"

zinit wait lucid light-mode for \
  zsh-users/zsh-completions \
  zsh-users/zsh-autosuggestions \
  Aloxaf/fzf-tab \
  zsh-users/zsh-syntax-highlighting    # must be last

# ── COMPLETIONS ───────────────────────────────────────────────────────────────
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi
zinit cdreplay -q

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --color=always {}'
# note: removed list-colors LS_COLORS line — it was pulling vivid Linux colors into completions

# ── KEYBINDINGS ───────────────────────────────────────────────────────────────
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# ── ALIASES ───────────────────────────────────────────────────────────────────
alias ls='eza --icons --color -s old'
alias tre='eza --tree --icons -s old --level'
alias c='clear'

# ── NAVIGATION ────────────────────────────────────────────────────────────────
cd() { builtin cd "$@" || return; echo "$PWD" >> ~/.cd_history; }
