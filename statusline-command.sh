#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
ctx=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_hr=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hr_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# 5-char progress bar using partial block elements (~2.5% precision)
bar() {
  local pct=${1:-0}
  pct=$(printf '%.0f' "$pct")
  local chars=("░" "▏" "▎" "▍" "▌" "▋" "▊" "▉" "█")
  local width=5
  local steps=$((width * 8))
  local fill=$(( pct * steps / 100 ))
  local full=$((fill / 8))
  local part=$((fill % 8))
  local empty=$((width - full - (part > 0 ? 1 : 0)))
  local out=""
  for ((i=0; i<full; i++)); do out="${out}█"; done
  if [ "$part" -gt 0 ]; then out="${out}${chars[$part]}"; fi
  for ((i=0; i<empty; i++)); do out="${out}░"; done
  echo "$out"
}

# Build path segment (bold blue)
out="\033[01;34m${cwd}\033[00m"

# Build stats segments
stats=""
if [ -n "$ctx" ]; then
  symbol=$(bar "$ctx")
  stats="${stats} \033[00;33m[ ctx ${symbol} $(printf '%.0f' "$ctx")% ]\033[00m"
fi
if [ -n "$five_hr" ]; then
  symbol=$(bar "$five_hr")
  reset_str=""
  if [ -n "$five_hr_reset" ]; then
    now=$(date +%s)
    remaining=$((five_hr_reset - now))
    if [ "$remaining" -gt 0 ]; then
      hours=$((remaining / 3600))
      mins=$(( (remaining % 3600) / 60 ))
      reset_str=" ${hours}h${mins}m"
    fi
  fi
  stats="${stats} \033[00;36m[ 5h ${symbol} $(printf '%.0f' "$five_hr")%${reset_str} ]\033[00m"
fi
if [ -n "$seven_day" ]; then
  symbol=$(bar "$seven_day")
  stats="${stats} \033[00;32m[ 7d ${symbol} $(printf '%.0f' "$seven_day")% ]\033[00m"
fi

printf "%b%b" "$out" "$stats"
