# Полное руководство по установке в Termux

> **Termux Nova v2.x** · **RU** · [Windows CMD](../cmd/SETUP.ru.md) · [Documentation index](../README.md)

Здесь описаны установка, настройка, обновление, устранение ошибок и удаление termux-nova в **Termux на Android**. Для компьютера Windows откройте [руководство CMD](../cmd/SETUP.ru.md).

## Requirements / 01

Android и актуальная сборка Termux из F-Droid либо официального GitHub, интернет для первой установки и свободное место. Root не требуется. Команды ниже выполняются **в Termux**, а не в Windows CMD.

## 02 — Prepare Termux

**1. Подготовьте Termux.** Запустите приложение, обновите пакеты и установите Git. `pkg` — пакетный менеджер Termux; `git` скачивает репозиторий.


```bash
pkg update && pkg upgrade -y
pkg install -y git
```


## 03 — Download the project (Git)

**2. Клонируйте репозиторий.** `cd ~` переходит в домашний каталог, `git clone` скачивает проект, последний `cd` открывает его папку.

```bash
cd ~
git clone https://github.com/RuslanSharifov/termux-nova.git
cd termux-nova
ls
```

**Альтернатива: ZIP без Git.** Эти команды скачивают архив ветки `main`. Выберите только один способ — Git или ZIP; для обновления ZIP потребуется повторно скачать архив.

```bash
pkg install -y curl unzip
cd ~
curl -fL https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip -o termux-nova.zip
unzip termux-nova.zip
cd termux-nova-main
ls
```

## 04 — Install and activate

**3. Запустите установщик.** Через `ls` проверьте наличие `install.sh`, `nova.sh` и `themes/`, затем запустите Bash-скрипт.

```bash
ls install.sh nova.sh themes
bash install.sh
```

Установщик добавляет `termux-tools` и `curl`, копирует команду `nova` и темы, устанавливает автозапуск в `~/.bashrc`. Он спрашивает, отключить ли конфликтующие UI-инструменты; при согласии создаёт резервные копии rc-файлов с датой. Для автоматического восстановления темы **Enter = да**, `n` = нет. Тема по умолчанию — `nova-dark`. Откройте новую сессию Termux или выполните `source ~/.bashrc` в текущем Bash.

```bash
source ~/.bashrc
```

**Внимание:** внимательно прочитайте предложение отключить другие инструменты оформления. Установщик комментирует соответствующие строки в rc-файлах; сохраните важные настройки отдельно.

## 05 — Verify and configure

**4. Проверьте установку и откройте меню.** `nova doctor` показывает диагностику, `nova console` открывает меню настроек. `nova list` выводит темы, `nova current` — текущую конфигурацию.

```bash
command -v nova
nova doctor
nova console
nova list
nova current
```

## 06 — Themes and startup

**5. Темы и автозапуск.** `nova set dracula` применяет цвета; `nova auto on` восстанавливает выбранную тему при следующих запусках. Большой баннер можно включать при запуске и после `clear` в `nova console`. Программа меняет оформление терминала, **но не кнопки приложения Android**.

```bash
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 07 — Custom commands: create, read, update, delete

**6. Создание своих команд (CRUD).** Триггер может начинаться с имени установленной программы. Разделитель `///` задаёт последовательные шаги; следующий выполнится только после успешного предыдущего. Для примера нужен Git.

```bash
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
source ~/.bashrc
```

Optional Node.js example (requires `pkg install nodejs` and an npm project):

```bash
pkg install -y nodejs
nova cmd add "npm run full" "npm install /// npm run dev"
source ~/.bashrc
npm run full
```

`nova cache clear` rebuilds generated command wrappers if required.

## 08 — Update an existing Git installation

**7. Обновление.** В каталоге клонированного репозитория выполните `git pull --ff-only`, затем `bash install.sh`. Локальные изменения могут блокировать обновление — сначала сохраните их. Установщик может повторно задать вопросы.

```bash
cd ~/termux-nova
git status
git pull --ff-only
bash install.sh
source ~/.bashrc
nova doctor
```

## 09 — Troubleshooting

**8. Устранение неполадок.**

1. `nova: command not found` — повторите `bash install.sh`, проверьте `command -v nova`, откройте новую сессию.
2. Цвета не изменились — выполните `pkg install -y termux-tools` и `nova set dracula`, перезапустите приложение.
3. Тема сбрасывается — проверьте `nova current` и включите `nova auto on`.
4. Своя команда не работает — посмотрите `nova cmd`, выполните `source ~/.bashrc`.
5. Исчез старый prompt — проверьте копии `~/.bashrc.nova-backup-*`; `nova restore` целиком заменяет `.bashrc` последней копией и может стереть более поздние правки.

## 10 — Uninstall and privacy

**9. Удаление и данные.** Отключите автозапуск, удалите строки Nova из `.bashrc` и установленную команду. Последняя строка ниже **безвозвратно удаляет** настройки, пользовательские команды и кэш; пропустите её, чтобы сохранить данные.

```bash
nova auto off
sed -i '/# termux-nova$/d' ~/.bashrc
sed -i '/# termux-nova$/d' ~/.bash_profile
rm -f "$PREFIX/bin/nova"
# OPTIONAL — irreversible data deletion:
rm -rf ~/.config/termux-nova ~/.cache/termux-nova
```

Пользовательские команды находятся в `~/.config/termux-nova/commands`. Не сохраняйте в них пароли и токены: эти значения лежат в локальном файле и исполняются. Текущая версия не реализует SQLite-статистику или ghost-text автодополнение, поэтому они здесь не обещаются.

---

**Автор:** rugo · [RuslanSharifov](https://github.com/RuslanSharifov). [Все языки и платформы](../README.md).
