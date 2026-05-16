#!/usr/bin/env bash
# ──────────────────────────────────────────────
# dotfiles setup — configura terminal e Claude Code
# ──────────────────────────────────────────────
set -e

echo "🚀 Iniciando setup do ambiente..."

# ── 1. Oh My Zsh ──────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "📦 Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh já instalado."
fi

# ── 2. Plugins zsh ────────────────────────────
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "📦 Instalando zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "✅ zsh-autosuggestions já instalado."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "📦 Instalando zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "✅ zsh-syntax-highlighting já instalado."
fi

# ── 3. .zshrc ─────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "⚙️  Copiando .zshrc..."
cp "$SCRIPT_DIR/zsh/zshrc" "$HOME/.zshrc"
echo "✅ .zshrc configurado."

# ── 4. Claude Code ────────────────────────────
echo "⚙️  Configurando Claude Code statusline..."
mkdir -p "$HOME/.claude"

cp "$SCRIPT_DIR/claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
chmod +x "$HOME/.claude/statusline-command.sh"

cp "$SCRIPT_DIR/claude/settings.json" "$HOME/.claude/settings.json"
echo "✅ Claude Code configurado."

# ── Fim ───────────────────────────────────────
echo ""
echo "✅ Setup concluído!"
echo ""
echo "👉 Abra uma nova aba do terminal ou rode: source ~/.zshrc"
