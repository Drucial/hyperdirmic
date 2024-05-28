#!/bin/zsh

# Production Aliases
alias organize='source ./scripts/venv/bin/activate && PYTHONPATH=./scripts python -m src.main'
alias xd='find ~/Downloads -mindepth 1 -exec osascript -e "tell application \"Finder\" to move (POSIX file \"{}\" as alias) to trash" \;'

# Dev Aliases
alias kill_hyperdirmic='pkill -f "hyperdirmic"'
alias log_hyperdirmic='cat /tmp/com.drucial.hyperdirmic.out'
alias error_hyperdirmic='cat /tmp/com.drucial.hyperdirmic.err'
alias debug_hyperdirmic='cat /tmp/com.drucial.hyperdirmic.debug.log'
alias all_hyperdirmic_logs='cat /tmp/hyperdirmic.log /tmp/com.drucial.hyperdirmic.out /tmp/com.drucial.hyperdirmic.err /tmp/com.drucial.hyperdirmic.debug.log'

alias run_hyperdirmic_dev="$(pwd)/scripts/run_dev.sh"
alias run_hyperdirmic="$(pwd)/scripts/run.sh"
alias test_hyperdirmic="$(pwd)/scripts/test.sh"
alias lint_hyperdirmic="$(pwd)/scripts/lint.sh"
alias format_hyperdirmic="$(pwd)/scripts/format.sh"
alias activate_hyperdirmic_env="source $(pwd)/venv/bin/activate"

echo "Aliases for Hyperdirmic development scripts have been set."

