#!/usr/bin/env bash
# Claude Code Status Line — beautiful & colorful

input=$(cat)

# ── ANSI colors ──
RESET="\033[0m"
BOLD="\033[1m"

C_PURPLE="\033[35m"
C_CYAN="\033[36m"
C_YELLOW="\033[33m"
C_GREEN="\033[32m"
C_BLUE="\033[34m"
C_RED="\033[31m"
C_WHITE="\033[37m"
C_MAGENTA="\033[95m"

# ── Separator (definido antes de tudo) ──
SEP=$(printf "${C_WHITE}│${RESET}")

# ── Extract data from JSON ──
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "~"')
session_name=$(echo "$input" | jq -r '.session_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
five_hr=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
git_worktree=$(echo "$input" | jq -r '.workspace.git_worktree // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# ── Shorten cwd: replace $HOME with ~ ──
cwd_display="${cwd/#$HOME/~}"

# ── Git branch ──
git_branch=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
fi

# ── Context bar (10 chars wide) ──
context_bar=""
if [ -n "$used_pct" ]; then
  filled=$(echo "$used_pct" | awk '{printf "%d", ($1 / 10) + 0.5}')
  empty=$((10 - filled))
  bar=""
  for i in $(seq 1 $filled); do bar="${bar}█"; done
  for i in $(seq 1 $empty); do bar="${bar}░"; done
  if [ "$filled" -ge 9 ]; then
    bar_color="$C_RED"
  elif [ "$filled" -ge 7 ]; then
    bar_color="$C_YELLOW"
  else
    bar_color="$C_GREEN"
  fi
  pct_rounded=$(printf '%.0f' "$used_pct")

  ctx_tokens_display=""
  if [ -n "$ctx_size" ] && [ "$ctx_size" -gt 0 ] 2>/dev/null; then
    ctx_used_k=$(echo "$used_pct $ctx_size" | awk '{printf "%.0f", ($1/100 * $2)/1000}')
    ctx_total_k=$(echo "$ctx_size" | awk '{printf "%.0f", $1/1000}')
    ctx_tokens_display=" ${ctx_used_k}k/${ctx_total_k}k"
  fi

  context_bar=$(printf "${bar_color}${bar}${RESET} ${pct_rounded}%%")$(printf "%s" "${ctx_tokens_display}")
fi

# ── Build parts ──
model_part=$(printf "${C_MAGENTA}${BOLD}${model}${RESET}")
dir_part=$(printf "${C_CYAN}📂 ${BOLD}${cwd_display}${RESET}")

git_part=""
[ -n "$git_branch" ] && git_part=$(printf " ${SEP} ${C_YELLOW}🌿 ${git_branch}${RESET}")

worktree_part=""
[ -n "$git_worktree" ] && worktree_part=$(printf " ${SEP} ${C_BLUE}⎇ ${git_worktree}${RESET}")

session_part=""
[ -n "$session_name" ] && session_part=$(printf " ${SEP} ${C_PURPLE} ${session_name}${RESET}")

ctx_part=""
[ -n "$context_bar" ] && ctx_part=$(printf "${SEP} ${C_WHITE}🧩 ctx:${RESET} ")$(printf "%s" "${context_bar}")

session_tokens=""
if [ -n "$total_in" ] && [ -n "$total_out" ]; then
  total_tokens_k=$(echo "$total_in $total_out" | awk '{printf "%.0f", ($1+$2)/1000}')
  session_tokens=$(printf " ${SEP} ${C_PURPLE}💬 ${total_tokens_k}k${RESET}")
fi

rate_part=""
if [ -n "$five_hr" ] || [ -n "$seven_day" ]; then
  rate_part=$(printf " ${SEP} ⏱️ ")
  if [ -n "$five_hr" ]; then
    five_rounded=$(printf '%.0f' "$five_hr")
    rate_part="${rate_part}$(printf "${C_YELLOW}5h ${five_rounded}%%${RESET}")"
  fi
  if [ -n "$five_hr" ] && [ -n "$seven_day" ]; then
    rate_part="${rate_part}$(printf " ${C_WHITE}·${RESET} ")"
  fi
  if [ -n "$seven_day" ]; then
    seven_rounded=$(printf '%.0f' "$seven_day")
    rate_part="${rate_part}$(printf "${C_BLUE}7d ${seven_rounded}%%${RESET}")"
  fi
fi

vim_part=""
if [ -n "$vim_mode" ]; then
  if [ "$vim_mode" = "NORMAL" ]; then
    vim_part=$(printf " ${SEP} ${C_GREEN}[N]${RESET}")
  else
    vim_part=$(printf " ${SEP} ${C_YELLOW}[I]${RESET}")
  fi
fi

# ── Linha 1: identidade  |  Linha 2: métricas ──
line1="${model_part} ${SEP} ${dir_part}${git_part}${worktree_part}${session_part}"
line2="${ctx_part}${session_tokens}${rate_part}${vim_part}"

# ── Assemble em duas linhas ──
printf "%s\n%s" "${line1}" "${line2}"
