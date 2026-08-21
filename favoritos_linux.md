# Instalar extensão "Favourites in AppGrid" no GNOME 40 (RHEL 9.8)

Prompt pronto para colar em um assistente de IA (ex: Claude Code) rodando
no computador de destino, ou para seguir manualmente como checklist.
Não requer download de `.zip`, `git clone`, `curl` nem `wget` — apenas
criação local de arquivos de texto.

---

## Prompt

```
Preciso instalar uma extensão do GNOME Shell manualmente, sem baixar
arquivos .zip nem usar git clone (rede corporativa restrita). Tenho
apenas o conteúdo de texto dos arquivos. Execute os passos abaixo
exatamente:

1. Crie o diretório da extensão:
   mkdir -p ~/.local/share/gnome-shell/extensions/favourites-in-appgrid@harshadgavali.gitlab.org
   cd ~/.local/share/gnome-shell/extensions/favourites-in-appgrid@harshadgavali.gitlab.org

2. Crie o arquivo metadata.json com este conteúdo exato:

{
  "name": "Favourites in AppGrid",
  "description": "Keep favourite applications in AppGrid",
  "uuid": "favourites-in-appgrid@harshadgavali.gitlab.org",
  "shell-version": ["40", "41", "42", "43", "44"],
  "url": "https://gitlab.gnome.org/harshadgavali/favourites-in-appgrid/",
  "version": 3
}

3. Crie o arquivo extension.js com este conteúdo exato:

/* exported init */

const { GObject } = imports.gi;

const Main = imports.ui.main;
const AppFavorites = imports.ui.appFavorites;
const Dash = imports.ui.dash;
const DND = imports.ui.dnd;
const AppDisplay = imports.ui.appDisplay;

const DashToPanelIconGTypeName = 'Gjs_dash-to-panel_jderose9_github_com_utils_DashToPanel_TaskbarAppIcon';

class DashMod {
    constructor() {
        this._appFavorites = AppFavorites.getAppFavorites();
        this._unmod_getAppFromSource = Dash.getAppFromSource;
    }
    applyMod() {
        Dash.getAppFromSource = this.getAppFromSource.bind(this);
    }
    removeMod() {
        Dash.getAppFromSource = this._unmod_getAppFromSource;
    }
    getAppFromSource(source) {
        if (source instanceof Dash.DashIcon)
            return source.app;
        if (source instanceof AppDisplay.AppIcon) {
            if (this._appFavorites.isFavorite(source.app.get_id()))
                return null;
            return source.app;
        }
        return null;
    }
}

class AppdisplayMod {
    constructor(appDisplay) {
        this._appDisplay = appDisplay;
        this._appFavorites = AppFavorites.getAppFavorites();
        this._unmod_acceptDrop = this._appDisplay.acceptDrop.bind(this._appDisplay);
        this._unmod_connectDnD = this._appDisplay._connectDnD.bind(this._appDisplay);
    }
    applyMod() {
        this._appDisplay.acceptDrop = this.acceptDrop.bind(this);
        this._appDisplay._connectDnD = this._connectDnD.bind(this);
    }
    removeMod() {
        this._appDisplay.acceptDrop = this._unmod_acceptDrop;
        this._appDisplay._connectDnD = this._unmod_connectDnD;
    }
    _connectDnD() {
        this._unmod_connectDnD();
        if (this._appDisplay._dragBeginId > 0) {
            Main.overview.disconnect(this._appDisplay._dragBeginId);
            this._appDisplay._dragBeginId = Main.overview.connect('item-drag-begin', (overview, source) => {
                if (!(source instanceof Dash.DashIcon))
                    this._appDisplay._onDragBegin.call(this._appDisplay, overview, source);
            });
        }
    }
    acceptDrop(source) {
        if (source instanceof Dash.DashIcon || GObject.type_name(source) === DashToPanelIconGTypeName) {
            if (this._appFavorites.isFavorite(source.id))
                this._appFavorites.removeFavorite(source.id);
            return DND.DragDropResult.SUCCESS;
        }
        return this._unmod_acceptDrop(source);
    }
}

class DummyAppFavorites {
    constructor() {
        this._appFavorites = AppFavorites.getAppFavorites();
    }
    isFavorite() {
        return false;
    }
    removeFavorite(id) {
        return this._appFavorites.removeFavorite(id);
    }
    connect(signal, callback) {
        return this._appFavorites.connect(signal, callback);
    }
    disconnect(id) {
        return this._appFavorites.disconnect(id);
    }
}

class FolderViewMod {
    constructor(appDisplay) {
        this._appDisplay = appDisplay;
        this._appFavorites = new DummyAppFavorites();
        this._unmod_redisplay = AppDisplay.FolderView.prototype._redisplay;
    }
    applyMod() {
        this._changeFavorites(this._appFavorites);
    }
    removeMod() {
        this._changeFavorites(AppFavorites.getAppFavorites());
        AppDisplay.FolderView.prototype._redisplay = this._unmod_redisplay;
    }
    _changeFavorites(appFavorites) {
        const _unmod_redisplay = this._unmod_redisplay;
        AppDisplay.FolderView.prototype._redisplay = function (...args) {
            this._appFavorites = appFavorites;
            _unmod_redisplay.call(this, ...args);
        };
        this._appDisplay._redisplay();
    }
}

class Extension {
    constructor() {
        this._mods = [];
        this._appDisplay = Main.overview._overview.controls._appDisplay;
    }
    enable() {
        this._mods = [
            new AppdisplayMod(this._appDisplay),
            new DashMod(),
            new FolderViewMod(this._appDisplay),
        ];
        this._appDisplay._appFavorites = new DummyAppFavorites();
        this._mods.forEach(mod => mod.applyMod());
        this._appDisplay._redisplay();
    }
    disable() {
        this._mods.reverse().forEach(mod => mod.removeMod());
        this._mods = [];
        this._appDisplay._appFavorites = AppFavorites.getAppFavorites();
        this._appDisplay._redisplay();
    }
}

function init() {
    return new Extension();
}

4. Depois de criar os dois arquivos, rode:
   gnome-extensions enable favourites-in-appgrid@harshadgavali.gitlab.org

5. Se estiver em X11, reinicie o Shell com Alt+F2, digite "r", Enter.
   Se estiver em Wayland, será necessário logout/login.

6. Confirme que ativou corretamente:
   gnome-extensions info favourites-in-appgrid@harshadgavali.gitlab.org

7. Se der erro ao habilitar, rode e me mostre a saída de:
   journalctl --user -b 0 /usr/bin/gnome-shell | grep -i favourites-in-appgrid

Não crie nenhum arquivo adicional além de metadata.json e extension.js.
Não use git clone, curl, wget nem nenhum download de arquivo — apenas
crie os arquivos localmente com o conteúdo acima (ex: via heredoc
`cat > arquivo << 'EOF' ... EOF` no terminal).
```

---

## Origem do código

Código-fonte da extensão original **Favourites in AppGrid** (autor:
harshadgavali), versão 3 — última versão com sintaxe legada de
`imports.gi`/`imports.ui`, compatível oficialmente com GNOME Shell
40, 41, 42, 43 e 44, antes da migração do projeto para ES modules
(GNOME 45+). Recuperado do histórico de commits do fork
[brunos3d/pinned-apps-in-appgrid](https://github.com/brunos3d/pinned-apps-in-appgrid)
no GitHub, que preserva o histórico completo do projeto original
hospedado no GitLab do GNOME
(https://gitlab.gnome.org/harshadgavali/favourites-in-appgrid/).

Licença: GPL (herdada do projeto original).
