export FZF_WIDGET_ROOT="$0:a:h"
export FZF_WIDGET_TMUX=0
typeset -gA FZF_WIDGET_OPTS

if [[ -z $FZF_WIDGET_CACHE ]]; then
  export FZF_WIDGET_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/fzf-widgets"
fi

: "Create cache directory" && () {
  [[ ! -d $FZF_WIDGET_CACHE ]] && mkdir -p $FZF_WIDGET_CACHE
}

: "Autoload functions and Create widgets" && () {
  local dir="$FZF_WIDGET_ROOT/autoload"
  fpath=($dir/**/*(N-/) $fpath)

  autoload -Uz `ls -F $dir/**/* | grep -v /`

  local w
  for w in `ls $dir/widgets/`; do zle -N $w; done
}

# Support zsh-autosuggestions
if [[ -n ZSH_AUTOSUGGEST_IGNORE_WIDGETS ]]; then
  ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(
    $ZSH_AUTOSUGGEST_IGNORE_WIDGETS
    `ls $FZF_WIDGET_ROOT/autoload/widgets/`
  )
fi

  # Map widgets to key
  bindkey '^T'  fzf-select-widget
  bindkey '^T.' fzf-edit-dotfiles
  bindkey '^Tc' fzf-change-directory
  bindkey '^Tn' fzf-change-named-directory
  bindkey '^Tf' fzf-edit-files
  bindkey '^Tk' fzf-kill-processes
  # bindkey '^Ts' fzf-exec-ssh
  bindkey '^\'  fzf-change-recent-directory
  bindkey '^r'  fzf-insert-history
  bindkey '^xf' fzf-insert-files
  bindkey '^xd' fzf-insert-directory
  bindkey '^xn' fzf-insert-named-directory

  ## Git
  bindkey '^Tg'  fzf-select-git-widget
  bindkey '^Tga' fzf-git-add-files
  bindkey '^Tgc' fzf-git-change-repository

  # GitHub
  # bindkey '^Th'  fzf-select-github-widget
  # bindkey '^Ths' fzf-github-show-issue
  # bindkey '^Thc' fzf-github-close-issue

  ## Docker
  # bindkey '^Td'  fzf-select-docker-widget
  # bindkey '^Tdc' fzf-docker-remove-containers
  # bindkey '^Tdi' fzf-docker-remove-images
  # bindkey '^Tdv' fzf-docker-remove-volumes

  # Enable Exact-match by fzf-insert-history
  FZF_WIDGET_OPTS[insert-history]='--exact'

  # Start fzf in a tmux pane
  FZF_WIDGET_TMUX=1
