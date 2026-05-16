# dotfiles

Configuração do terminal e do Claude Code para qualquer máquina nova.

## O que inclui

### Terminal (zsh)
- **Oh My Zsh** com tema `agnoster`
- **Plugins:**
  - `zsh-autosuggestions` — sugestões em cinza enquanto digita, aceite com `→`
  - `zsh-syntax-highlighting` — comandos ficam verdes (válido) ou vermelhos (inválido) em tempo real
  - `macos` — atalhos úteis para macOS
  - `git` — aliases e info de branch no prompt

### Claude Code
- **Statusline personalizada** com animação, ícones e informações de contexto
- **CLAUDE.md** gerado a partir de template com merge automático de novas seções

---

## Instalação

```bash
git clone https://github.com/FelipeMira/dotfiles
cd dotfiles
chmod +x setup.sh
./setup.sh
```

O script instala e configura tudo automaticamente. Após o setup:

```bash
source ~/.zshrc
```

---

## Estrutura

```
dotfiles/
├── setup.sh                    # script de instalação
├── zsh/
│   └── zshrc                   # configuração base do zsh / Oh My Zsh
└── claude/
    ├── settings.json           # tema e comando da statusline
    ├── statusline-command.sh   # script da statusline personalizada
    └── CLAUDE.md.example       # template de instruções para o Claude
```

### Arquivos locais (não versionados)

Estes arquivos ficam apenas na sua máquina e nunca sobem para o repositório:

| Arquivo | Descrição |
|---|---|
| `~/.zshrc.local` | Paths e aliases específicos da máquina (SDKs, ferramentas, etc.) |
| `~/.claude/CLAUDE.md` | Instruções pessoais para o Claude (tom, preferências, contexto local) |

O `~/.zshrc` carrega o `~/.zshrc.local` automaticamente se ele existir.

### CLAUDE.md — comportamento do setup

- **Primeira execução:** cria `~/.claude/CLAUDE.md` a partir do `CLAUDE.md.example`
- **Execuções seguintes:** compara seção por seção (`## Cabeçalho`) e adiciona ao final apenas as seções que ainda não existem no arquivo — o conteúdo existente nunca é alterado

---

## Statusline do Claude Code

A barra inferior do Claude Code exibe em tempo real:

```
Sonnet 4.6 │ 📂 ~/…/github/dotfiles │ 🌿 main │ 🧩 ctx: ████░░ 37% 74k/200k │ 💬 48k │ ⏱️ 5h 9% · 7d 1%
```

| Segmento | Ícone | Descrição |
|---|---|---|
| Modelo | — | Nome do modelo ativo (ex: Sonnet 4.6) |
| Pasta | 📂 | Diretório de trabalho atual — caminhos longos são truncados no formato `~/…/pai/atual` |
| Branch | 🌿 | Branch git atual (só aparece em repositórios git) |
| Contexto | 🧩 | Barra + percentual + tokens usados/total da janela de contexto (muda de cor: verde → amarelo → vermelho) |
| Tokens da sessão | 💬 | Total acumulado (input + output) na conversa atual |
| Rate limits | ⏱️ | Uso das cotas de 5h e 7d separados por `·` (quando disponível) |

---

## Personalização

### Adicionar configs locais ao terminal

Crie ou edite `~/.zshrc.local`:

```bash
# Exemplo: Java, Python, Android SDK
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export ANDROID_HOME=$HOME/Library/Android/sdk
alias python="python3.11"
```

### Personalizar instruções do Claude

Edite `~/.claude/CLAUDE.md` com suas preferências pessoais — tom de resposta, idioma, contexto de projetos, restrições, etc. Use o `CLAUDE.md.example` como referência de estrutura.
