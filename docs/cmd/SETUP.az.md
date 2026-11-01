# Windows CMD üçün tam quraşdırma təlimatı

> **Termux Nova v2.x** · **AZ** · [Termux Android](../termux/SETUP.az.md) · [Documentation index](../README.md)

Bu təlimat layihənin **Windows variantı** üçündür: adi `cmd.exe` və Windows Terminal içində CMD profili. Android üçün [Termux quraşdırmasına](../termux/SETUP.az.md) keç. Windows variantı `windows/install.cmd` ilə qurulur; `pkg` Windows əmri deyil.

## Requirements / 01

Windows 10 və ya 11; daxilində olan Windows PowerShell 5.1; Git (və ya ZIP ilə yükləmə); Windows Terminal rəng mövzuları üçün tövsiyə olunur. Adətən administrator hüququ tələb olunmur. Git və `winget` yoxdursa, Git for Windows-u brauzerdən quraşdıra bilərsən.

## 02 — Prepare Command Prompt

**1. Windows CMD-ni hazırla.** Başlat menyusundan `cmd` və ya Windows Terminal → Command Prompt aç. `winget` varsa Git for Windows quraşdır; yoxdursa GitHub-un ZIP üsulundan istifadə et. Git quraşdırıldıqdan sonra **yeni CMD pəncərəsi** aç.

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

**2. Repozitoriyanı kompüterə endir.** Aşağıdakı əmrlər layihəni Downloads qovluğuna klonlayır. `cd /d` həm diski, həm qovluğu dəyişir. `dir` içində `install.cmd`, `install.ps1` və `nova.ps1` görünməlidir.

```cmd
cd /d "%USERPROFILE%\Downloads"
git clone https://github.com/RuslanSharifov/termux-nova.git
cd /d "%USERPROFILE%\Downloads\termux-nova\windows"
dir
```

**Git olmadan ZIP alternativi.** Aşağıdakı ünvanı brauzerdə aç, ZIP-i Downloads-a çıxart, sonra çıxarılan qovluğun `windows` hissəsinə keç. Qovluq adını öz çıxartdığın yerə uyğunlaşdır.

[Download main.zip](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova-main\windows"
dir
```

## 04 — Back up CMD AutoRun

**3. CMD AutoRun ayarını əvvəlcədən yoxla və ehtiyat nüsxəsini götür.** Nova açılış banneri və `doskey` makroları üçün cari istifadəçinin `HKCU\Software\Microsoft\Command Processor\AutoRun` qeydini dəyişir. Əgər burada əvvəlcədən başqa komanda varsa, quraşdırıcı onu **əvəz edə bilər**. `reg query` ilə yoxla; açar varsa `reg export` ehtiyatı yarat. `reg export` açar yoxdursa xəta verə bilər — bu, ilk dəfə üçün normaldır.

```cmd
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg export "HKCU\Software\Microsoft\Command Processor" "%USERPROFILE%\cmd-autostart-before-nova.reg" /y
```

## 05 — Install Windows version

**4. Windows quraşdırıcısını işə sal.** `windows` qovluğunda `install.cmd` çalışdır. Bu, PowerShell 5.1 skriptini yalnız həmin proses üçün `-ExecutionPolicy Bypass` ilə başladır; sistemin ümumi execution-policy ayarı dəyişdirilmir.

```cmd
install.cmd
```

Equivalent manual command (from the `windows` folder):

```cmd
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

Quraşdırıcı `nova.ps1`, `nova.cmd` və `themes.json` fayllarını `%APPDATA%\termux-nova`-ya kopyalayır, bu yolu istifadəçi `PATH`-inə əlavə edir, CMD üçün AutoRun hook-larını qurur, avtomatik bərpa seçimini soruşur (**Enter = bəli**) və `nova-dark` temasını Windows Terminal-a tətbiq etməyə çalışır. **Quraşdırmadan sonra yeni CMD pəncərəsi aç** ki, PATH və AutoRun yüklənsin.

## 06 — Verify and open console

**5. Yoxla və idarəetmə panelini aç.** `where nova` quraşdırılan əmrin yolunu göstərir. `nova console` menyusunda yuxarı/aşağı oxlar və Enter, ya da nömrə + Enter istifadə olunur. `nova doctor` diaqnostika verir.

```cmd
where nova
nova doctor
nova console
nova list
nova current
```

## 07 — Apply themes and control startup

**6. Mövzular və CMD davranışı.** `nova set dracula` Windows Terminal-ın `settings.json` faylındakı rəng sxeminə təsir edir; adi köhnə konsolda eyni rəng dəyişikliyi görünməyə bilər. Windows Terminal-da **Command Prompt** profilini seç: CMD makroları PowerShell profilində işləmir. Açılış və `cls` sonrası banner seçimi `nova console` daxilindədir.

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

**7. Öz komandalarını yarat/dəyiş/sil.** `///` addımları ardıcıllıqla bağlayır. `git` nümunəsi üçün Git lazımdır; `npm` nümunəsi üçün ayrıca Node.js və npm qurulmalıdır. Dəyişiklikdən sonra yeni CMD pəncərəsi aç ki, makrolar yenilənsin.

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

**8. Yeniləmə.** Git ilə yükləmisənsə, repoya keç və `git pull --ff-only` et; sonra quraşdırıcını yenidən işə sal. ZIP istifadə etmisənsə, yeni arxivi endir və yenilənmiş `windows` qovluğundan quraşdır.

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova"
git status
git pull --ff-only
cd windows
install.cmd
```

## 10 — Troubleshooting

1. `'nova' is not recognized` — yeni CMD pəncərəsi aç, `where nova` yoxla, lazım olsa `install.cmd`-ni yenidən işə sal.
2. Rənglər dəyişmir — Windows Terminal istifadə et; `nova doctor` işə sal. `settings.json` içində şərhlər varsa, skript onu parse edə bilməyə bilər.
3. Banner çıxmır — CMD profilini aç, `nova hook` işlə, sonra yeni pəncərə aç. `cmd /d` AutoRun-u bilərəkdən söndürür.
4. `cls` makrosu işləmir — `nova hook` sonrası yeni CMD pəncərəsi aç; PowerShell profilində `doskey` hook-u işləmir.
5. Əvvəlki CMD AutoRun ayarın itdi — quraşdırmadan əvvəl saxladığın `.reg` ehtiyatını nəzərdən keçir; geri qaytarmazdan əvvəl mövcud vəziyyəti də saxla.

## 11 — Uninstall and privacy

**9. Silmək.** Bu versiyada ayrıca Windows uninstaller yoxdur. Əvvəl `nova auto off` et. Sonra `reg query` ilə AutoRun-un Nova tərəfindən yazıldığını yoxla; yalnız bundan sonra onu sil və ya əvvəlki registry backup-unu geri yüklə. `%APPDATA%\termux-nova` qovluğunda saxlanan xüsusi komandalar da silinəcək — ehtiyatını al. İstifadəçi PATH-indən bu qovluğu Windows-un *Environment Variables* panelində əl ilə çıxart. Windows Terminal rənglərini geri qaytarmaq üçün `settings.json.nova-backup`-u yoxla; ardıcıl tema dəyişiklikləri bu backup-u əvəz etmiş ola bilər.

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

Xüsusi komandalar `%APPDATA%\termux-nova\commands` faylında saxlanır; məxfi tokenləri bu fayla qoyma. Qeyd dəftərinə və Windows Terminal ayarlarına dəyişiklikləri quraşdırmadan əvvəl nəzərdən keçirmək tövsiyə olunur.

---

**Müəllif:** rugo · [RuslanSharifov](https://github.com/RuslanSharifov). [Bütün dillər və platformalar](../README.md).
