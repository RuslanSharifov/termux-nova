# Termux Nova — установка для Windows CMD

[← Главный README и демо](../../README.md) · [Руководство Android Termux](../termux/SETUP.ru.md)

## 1. Установка — скачать ZIP и запустить install.cmd

**В Windows не нужно копировать команды установки.** Сделайте 4 шага:

1. **[Скачайте ZIP termux-nova](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)**.
2. Распакуйте ZIP-архив.
3. Откройте папку `termux-nova-main`, затем `windows`.
4. **Дважды щёлкните `install.cmd`**, ответьте на вопросы установщика и **откройте новое окно CMD**.

**Важно:** Если у вас уже есть команды автозапуска CMD, до шага 4 сохраните AutoRun. Nova может перезаписать `HKCU\Software\Microsoft\Command Processor\AutoRun`. Необязательная инструкция ниже.

Установщик через PowerShell копирует Nova в пользовательский каталог и добавляет его в PATH. Для цветовых схем рекомендуется Windows Terminal. Для макросов `doskey` используйте профиль **Command Prompt (CMD)**, а не PowerShell.

## 2. Использование Nova

В новом окне CMD введите `nova console`. Управление: стрелки и Enter либо цифра + Enter.

```cmd
nova console
nova list
nova current
nova doctor
```

## 3. Темы и автозапуск

Темы: `nova-dark`, `dracula`, `gruvbox`, `nord`. Цвета применяются преимущественно к Windows Terminal. `nova auto on` восстанавливает выбранную тему при запуске. Баннер при старте и после `cls` настраивается через `nova console`.

```cmd
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 4. Свои команды — добавить, список, изменить, удалить

`///` разделяет последовательные команды. Для примера ниже требуется установленный Git for Windows. После изменения макросов **откройте новое CMD**.

```cmd
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
```

## 5. Обновление

Скачайте новый [ZIP с GitHub](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip), распакуйте, запустите новый `termux-nova-main/windows/install.cmd` и откройте CMD. Повторная установка тоже может перезаписать AutoRun.

## 6. Необязательно: сохранение CMD AutoRun

**До установки** можно проверить AutoRun в CMD и экспортировать резервную копию ключа реестра этими командами. Если ключа нет, ошибка экспорта нормальна. Перед восстановлением проверьте содержимое `.reg`.

```cmd
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg export "HKCU\Software\Microsoft\Command Processor" "%USERPROFILE%\cmd-autostart-before-nova.reg" /y
```

## 7. Устранение неполадок

1. **`nova` не распознана** — откройте новое CMD, проверьте `where nova` и при необходимости повторите `install.cmd`.
2. **Тема не меняется** — используйте профиль Command Prompt в Windows Terminal и запустите `nova doctor`. Комментарии в `settings.json` могут мешать чтению.
3. **Нет баннера** — выполните `nova hook` в CMD и откройте новое окно; `cmd /d` отключает AutoRun.
4. **Своя команда не работает** — проверьте `nova cmd` и откройте новое CMD.

## 8. Удаление и конфиденциальность {#uninstall}

Сначала отключите автоподстановку темы и проверьте AutoRun. **Удаляйте AutoRun только если он всё ещё принадлежит Nova**, иначе можно повредить другие скрипты запуска. Сохраните пользовательские команды из `%APPDATA%\termux-nova`, затем удалите папку и уберите её из пользовательского PATH через Windows Environment Variables. Кэш `%LOCALAPPDATA%\termux-nova` также можно удалить.

```cmd
nova auto off
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
```

Для возврата цветов Windows Terminal проверьте `settings.json.nova-backup`; неоднократная смена темы могла перезаписать резервную копию. Не сохраняйте пароли и токены в пользовательских командах.

**Область работы:** версия предназначена для Windows CMD/Windows Terminal, а не для изменения родного интерфейса Android.

---

Автор: **rugo · Ruslan Sharifov**. · [GitHub](https://github.com/RuslanSharifov/termux-nova)
