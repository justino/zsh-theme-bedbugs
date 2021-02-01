# ZSH 'Bedbugs' Theme

PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
SIGIL="\u25b6"
LIGHTNING="\u26a1"

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"

  print -n "%{$bg%}%{$fg%}"

  [[ -n $3 ]] && print -n " $3 "
}

# End the prompt, indicate status of last run command and root user
prompt_sigil() {
  local color='green'
  local sigil=$SIGIL

  [[ $RETVAL -ne 0 ]] && color='red'
  [[ $UID -eq 0 ]] && sigil=$LIGHTNING

  prompt_segment none $color $sigil
  print -n "%{%f%}"
}

# Context: user@hostname (who am I and where am I)
prompt_whoami() {
  prompt_segment black default "%(!.%{%F{yellow}%}.)%n@%m"
}

# Git: branch/detached head, dirty status
prompt_git() {
  local color ref

  stashes=$(git stash list 2> /dev/null | wc -l)
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }

  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    if is_dirty; then
      color=yellow
      ref="${ref} $PLUSMINUS"
    else
      color=green
      ref="${ref}"
    fi
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH $ref"
    else
      ref="$DETACHED ${ref/.../}"
    fi

    prompt_segment $color black $ref
    [[ $stashes -ne 0 ]] && prompt_segment cyan black "💼: $stashes"
  fi
}

# Pwd: present working directory
prompt_pwd() {
  prompt_segment blue black '%~'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment blue black "VENV: `basename $virtualenv_path`"
  fi
}

# Jobs: current count of running jobs
prompt_jobs() {
  local jobs=$(jobs -l | wc -l)
  [[ $jobs -gt 0 ]] && prompt_segment magenta white "Jobs: $jobs"
}

## Main prompt
build_prompt() {
  RETVAL=$?

  # Start with a new line, this helps separate command
  # output from prompt
  print

  prompt_whoami
  prompt_jobs
  prompt_pwd

  # Start 2nd line
  print

  prompt_virtualenv
  prompt_git
  prompt_sigil
}

theme_precmd() {
  vcs_info
  PROMPT='%{%f%b%k%}$(build_prompt)'
}

theme_setup() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  prompt_opts=(cr subst percent)

  add-zsh-hook precmd theme_precmd

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes false
  zstyle ':vcs_info:git*' formats '%b'
  zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

theme_setup "$@"
