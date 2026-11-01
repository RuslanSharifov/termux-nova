# Полная установка в Windows CMD

> **Termux Nova v2.x** · **RU** · [Termux Android](../termux/SETUP.ru.md) · [Documentation index](../README.md)

Это руководство для **версии Windows**, работающей в `cmd.exe` или профиле Command Prompt приложения Windows Terminal. Для Android используйте [руководство Termux](../termux/SETUP.ru.md). Здесь запускается `windows/install.cmd`; команда `pkg` в Windows не существует.

## Requirements / 01

Windows 10/11, встроенный Windows PowerShell 5.1, Git либо ZIP-архив, желательно Windows Terminal для цветовых тем. Права администратора обычно не нужны. Если `winget` отсутствует, установите Git for Windows официальным установщиком или используйте ZIP.

## 02 — Prepare Command Prompt

**1. Подготовьте CMD.** Откройте Командную строку через Пуск или Windows Terminal → Command Prompt. При наличии `winget` установите Git; иначе используйте ZIP. После установки Git откройте **новое окно CMD**.

```cmd
winget install --id Git.Git -e
```

Check Git in a **new** CMD window:

```cmd
git --version
where git
```

Optional Windows Terminal install (if `winget` is present):

```cmd
winget install --id Microsoft.WindowsTerminal -e
```

## 03 — Download or clone from GitHub

**2. Клонируйте репозиторий на компьютер.** Команды скачивают проект в Downloads. `cd /d` меняет диск и папку. Команда `dir` должна показать `install.cmd`, `install.ps1`, `nova.ps1`.

```cmd
cd /d "%USERPROFILE%\Downloads"
git clone https://github.com/RuslanSharifov/termux-nova.git
cd /d "%USERPROFILE%\Downloads\termux-nova\windows"
dir
```

**Альтернатива: ZIP без Git.** Откройте ссылку в браузере, распакуйте архив в Downloads и перейдите в папку `windows` проекта. Если распаковали в другое место, измените путь.

[Download main.zip](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova-main\windows"
dir
```

## 04 — Back up CMD AutoRun

**3. Проверьте и сохраните CMD AutoRun до установки.** Для баннера и макросов `doskey` Nova изменяет значение `HKCU\Software\Microsoft\Command Processor\AutoRun` текущего пользователя. **Существующее значение может быть перезаписано**. Проверьте `reg query` и экспортируйте ключ через `reg export`, если он существует. Ошибка экспорта отсутствующего ключа допустима.

```cmd
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg export "HKCU\Software\Microsoft\Command Processor" "%USERPROFILE%\cmd-autostart-before-nova.reg" /y
```

## 05 — Install Windows version

**4. Запустите установщик Windows.** Из папки `windows` выполните `install.cmd`. Скрипт запускает PowerShell 5.1 с `-ExecutionPolicy Bypass` только для этого процесса, не меняя глобальную политику системы.

```cmd
install.cmd
```

Equivalent manual command (from the `windows` folder):

```cmd
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

Установщик копирует `nova.ps1`, `nova.cmd`, `themes.json` в `%APPDATA%\termux-nova`, добавляет путь в пользовательский `PATH`, устанавливает CMD AutoRun, спрашивает про автоматическое восстановление (**Enter = да**) и пытается применить `nova-dark` в Windows Terminal. **Откройте новое окно CMD** для обновления PATH и AutoRun.

## 06 — Verify and open console

**5. Проверка и меню.** `where nova` показывает путь к команде. В `nova console` используйте стрелки Вверх/Вниз и Enter либо цифру + Enter. `nova doctor` выводит диагностику.

```cmd
where nova
nova doctor
nova console
nova list
nova current
```

## 07 — Apply themes and control startup

**6. Темы и поведение CMD.** `nova set dracula` меняет цветовую схему в `settings.json` Windows Terminal; старый консольный хост может не отображать изменения. В Windows Terminal выберите профиль **Command Prompt**: макросы CMD не работают в профиле PowerShell. Баннер при старте и после `cls` настраивается в `nova console`.

```cmd
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
nova hook
```

## 08 — Custom commands: create / read / edit / delete

**7. Свои команды: добавить, изменить, удалить.** `///` разделяет последовательные шаги. Для примера Git нужен Git; для дополнительного примера npm нужен отдельно установленный Node.js/npm. После изменения макросов откройте новое CMD.

```cmd
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
nova cache clear
```

Optional example for projects with Node.js/npm already installed:

```cmd
nova cmd add "npm run full" "npm install /// npm run dev"
nova cmd
```

## 09 — Update an existing Git clone

**8. Обновление.** В клонированном репозитории выполните `git pull --ff-only`, затем `install.cmd`. При установке из ZIP повторно скачайте архив и выполните установку из новой папки `windows`.

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova"
git status
git pull --ff-only
cd windows
install.cmd
```

## 10 — Troubleshooting

1. `'nova' is not recognized` — откройте новое окно CMD, выполните `where nova`; при необходимости снова `install.cmd`.
2. Цвета не изменились — используйте Windows Terminal и `nova doctor`. Комментарии в `settings.json` могут мешать чтению.
3. Нет баннера — выберите профиль CMD, выполните `nova hook` и откройте новое окно. `cmd /d` отключает AutoRun.
4. Не работает `cls` — повторите `nova hook` и откройте CMD; макросы `doskey` не действуют в PowerShell.
5. Старое значение AutoRun исчезло — проверьте сохранённый `.reg`-файл и сохраните текущее состояние перед восстановлением.

## 11 — Uninstall and privacy

**9. Удаление.** Отдельного деинсталлятора Windows пока нет. Сначала `nova auto off`. Убедитесь через `reg query`, что значение AutoRun всё ещё относится к Nova, затем удалите его либо восстановите прежнюю резервную копию. В `%APPDATA%\termux-nova` лежат пользовательские команды — сохраните перед удалением. Уберите папку из пользовательского `PATH` в настройках *Environment Variables*. Для восстановления цветов проверьте `settings.json.nova-backup`; повторные смены темы могли перезаписать эту копию.

Run the first command in CMD. **Only delete AutoRun if it contains Nova's hook and you have a backup of any previous value.**

```cmd
nova auto off
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg delete "HKCU\Software\Microsoft\Command Processor" /v AutoRun /f
```

**Optional, irreversible removal of the installed tool and user data** (after exporting any custom commands you need):

```cmd
rmdir /s /q "%APPDATA%\termux-nova"
rmdir /s /q "%LOCALAPPDATA%\termux-nova"
```

Свои команды хранятся в `%APPDATA%\termux-nova\commands`; не добавляйте секретные токены. Перед установкой проверьте возможные изменения реестра и настроек Windows Terminal.

---

**Автор:** rugo · [RuslanSharifov](https://github.com/RuslanSharifov). [Все языки и платформы](../README.md).
