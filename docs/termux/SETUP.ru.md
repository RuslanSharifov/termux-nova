# Termux Nova — установка в Android Termux

[← Главный README и демо](../../README.md) · [Инструкция Windows CMD](../cmd/SETUP.ru.md)

## 1. Установка — один блок для вставки

**Скопируйте весь блок ниже и один раз вставьте в Termux.** Он скачает репозиторий, установит Nova и в конце выполнит `clear`.

```bash
pkg update -y && pkg install -y git && \
cd "$HOME" && \
git clone https://github.com/RuslanSharifov/termux-nova.git && \
cd termux-nova && \
bash install.sh && \
source "$HOME/.bashrc" && \
clear
```

При установке могут появиться вопросы об отключении других инструментов оформления и автоматическом восстановлении темы. Внимательно прочитайте их; **Enter = да** для авто-восстановления. В следующих интерактивных сессиях Termux Nova запускается автоматически.

> Если `~/termux-nova` уже существует, `git clone` остановится. В этом случае используйте раздел **Обновление** ниже.

## 2. Как пользоваться Nova

Снова откройте Termux или выполните эти команды после установки. Меню настроек открывается через `nova console`.

```bash
nova console
nova list
nova current
nova doctor
```

## 3. Темы и автозапуск

Встроенные темы: `nova-dark`, `dracula`, `nord`, `gruvbox`. `nova auto on` восстанавливает сохранённую тему при новом запуске. Баннер при запуске и после `clear` настраивается через `nova console`.

```bash
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 4. Свои команды — добавить, список, изменить, удалить

`///` разделяет последовательные шаги. Следующий выполняется только после успешного предыдущего. Пример использует Git (ставится при установке).

```bash
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
```

После изменения пользовательских команд откройте Termux снова или выполните `source ~/.bashrc`. Не храните пароли и токены в командах.

## 5. Обновление установленной версии

Если репозиторий уже скачан через Git, не клонируйте его повторно. Вставьте один блок обновления. Установщик может повторить вопросы.

```bash
cd ~/termux-nova && git pull --ff-only && bash install.sh && source ~/.bashrc && clear
```

## 6. Устранение неполадок

1. **`nova: command not found`** — снова откройте Termux; при необходимости `cd ~/termux-nova && bash install.sh`.
2. **Цвета не изменились** — `pkg install -y termux-tools`, затем `nova set dracula`.
3. **Тема сбрасывается** — проверьте `nova current` и включите `nova auto on`.
4. **Своя команда не работает** — проверьте `nova cmd` и выполните `source ~/.bashrc`.
5. **Предыдущее оформление изменилось** — проверьте копии `.nova-backup-*`. `nova restore` полностью заменяет `~/.bashrc` последней копией и может удалить более поздние правки.

## 7. Удаление и безопасность {#uninstall}

Этот блок отключает восстановление темы и удаляет автозапуск/команду Nova. Прежние цвета терминала автоматически не восстанавливаются.

```bash
nova auto off
[ -f "$HOME/.bashrc" ] && sed -i '/# termux-nova$/d' "$HOME/.bashrc"
[ -f "$HOME/.bash_profile" ] && sed -i '/# termux-nova$/d' "$HOME/.bash_profile"
rm -f "$PREFIX/bin/nova"
```

**Необязательное полное удаление данных:** сначала сохраните нужные файлы, затем выполните `rm -rf ~/.config/termux-nova ~/.cache/termux-nova`.

**Примечание:** текущая версия на Bash управляет темами и пользовательскими командами. Статистика SQLite, серые подсказки и принятие по Tab ещё не реализованы. Кнопки и меню Android не изменяются.

---

Автор: **rugo · Ruslan Sharifov**. · [GitHub](https://github.com/RuslanSharifov/termux-nova)
