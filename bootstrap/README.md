# dev-bootstrap — възстановяване на средата след преинсталация

Генерирано от реалната машина (12.10.2026). Стартирайте:

```powershell
powershell -ExecutionPolicy Bypass -File D:\Projects\dev-bootstrap\setup.ps1
```

## Структура (по езици)

| Папка | Какво инсталира и възстановява | Манифест |
|---|---|---|
| `node/` | Node.js LTS + глобални npm пакети | `npm-globals.txt` |
| `python/` | Python 3.12 + 141 pip пакета | `requirements.txt` |
| `dotnet/` | .NET SDK 6 и 10 | — |
| `java/` | Temurin 22 JDK | — |
| `powershell/` | PowerShell 7 + модули + **пълният профил** (`Documents\PowerShell` + `profile\` скриптове) + **cobalt2 тема** | `modules.txt` |
| `choco/` | Chocolatey + 33 пакета | `packages.txt` |
| `vscode/` | VS Code + 57 разширения + **settings.json, chatLanguageModels.json, mcp.json, workspace файлове** | `extensions.txt` |

`setup.ps1` инсталира и базовите инструменти (git, gh, Ollama, Windows Terminal, zoxide).

## Бележки
- `vscode/workspace-hapi.settings.json` — цветовете на hAPI workspace; копирайте в `<репо>\.vscode\settings.json` след клониране;
- `powershell/Documents-PowerShell/` — loader-ът + `profile\*.ps1` (зареждат се по азбучен ред);
- python: локалният `bitcoinlib` е сведен до име (PyPI);
- choco: системните KB и вътрешните пакети са пропуснати.
