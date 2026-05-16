# dotfiles

Configuração do terminal e do Claude Code para qualquer máquina nova.

## O que inclui

- **Oh My Zsh** com tema `agnoster`
- **MesloLGS Nerd Font** — necessária para renderizar os ícones do tema corretamente
- **Plugins zsh:**
  - `zsh-autosuggestions` — sugestões enquanto digita (aceite com `→`)
  - `zsh-syntax-highlighting` — comandos ficam verdes (válido) ou vermelhos (inválido)
  - `macos` — atalhos úteis para macOS
  - `git` — info de branch no prompt
- **Claude Code statusline** — modelo, pasta, branch, barra de contexto e uso de rate limits

## Instalação

```bash
git clone https://github.com/FelipeMira/dotfiles
cd dotfiles
chmod +x setup.sh
./setup.sh
```

Após o setup, configure a fonte **MesloLGS NF** no seu terminal (Preferências → Perfis → Fonte) e abra uma nova aba ou rode:

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
✦ Claude Sonnet 4 │  ~/pasta │  main │  ctx: ████░░░░░░ 42%
```

| Segmento | Descrição |
|---|---|
| `✦ Modelo` | Nome do modelo ativo |
| ` Pasta` | Diretório de trabalho atual |
| ` Branch` | Branch git atual |
| `ctx: ████░░` | Uso da janela de contexto (verde → amarelo → vermelho) |
| `5h / 7d` | Uso de rate limits (quando disponível) |
