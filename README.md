# dotfiles

Configuração do terminal e do Claude Code para qualquer máquina nova.

## O que inclui

- **Oh My Zsh** com tema `agnoster`
- **Plugins zsh:**
  - `zsh-autosuggestions` — sugestões enquanto digita (aceite com `→`)
  - `zsh-syntax-highlighting` — comandos ficam verdes (válido) ou vermelhos (inválido)
  - `macos` — atalhos úteis para macOS
  - `git` — info de branch no prompt
- **Claude Code statusline** — modelo, pasta, branch, barra de contexto e uso de rate limits
  - Animação de pensamento com emojis ciclando a cada segundo

## Instalação

```bash
git clone https://github.com/FelipeMira/dotfiles
cd dotfiles
chmod +x setup.sh
./setup.sh
```

Após o setup, abra uma nova aba do terminal ou rode:

```bash
source ~/.zshrc
```

## Estrutura

```
dotfiles/
├── setup.sh                    # script de instalação
├── zsh/
│   └── zshrc                   # configuração do zsh / Oh My Zsh
└── claude/
    ├── settings.json           # configurações do Claude Code
    └── statusline-command.sh   # statusline personalizada
```

## Statusline do Claude Code

A barra inferior do Claude Code exibe:

```
🤔 Claude Sonnet 4 │ 📂 ~/pasta │ 🌿 main │ 🧩 ctx: ████░░░░░░ 42% │ ⏱️ 5h 9% · 7d 1%
```

| Segmento | Descrição |
|---|---|
| Emoji animado | Cicla a cada segundo: 🤔 💭 🧠 ✨ 💡 ⚡ 🔮 🌀 |
| `📂 Pasta` | Diretório de trabalho atual |
| `🌿 Branch` | Branch git atual |
| `🧩 ctx: ████░░` | Uso da janela de contexto (verde → amarelo → vermelho) |
| `⏱️ 5h X% · 7d X%` | Uso de rate limits agrupados (quando disponível) |
