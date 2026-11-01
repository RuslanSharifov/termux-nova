# Windows CMD için ayrıntılı kurulum rehberi

> **Termux Nova v2.x** · **TR** · [Termux Android](../termux/SETUP.tr.md) · [Documentation index](../README.md)

Bu rehber **Windows sürümü** içindir: `cmd.exe` veya Windows Terminal içindeki Command Prompt profili. Android için [Termux rehberine](../termux/SETUP.tr.md) geç. Windows'ta `windows/install.cmd` kullanılır; `pkg` bir Windows komutu değildir.

## Requirements / 01

Windows 10/11, sistemde bulunan Windows PowerShell 5.1, Git (veya ZIP), renk şemaları için isteğe bağlı Windows Terminal. Genellikle yönetici yetkisi gerekmez. `winget` yoksa Git for Windows'u resmi kurulum dosyasıyla yükleyebilir veya ZIP yöntemini seçebilirsin.

## 02 — Prepare Command Prompt

**1. CMD'yi hazırla.** Başlat menüsünden Komut İstemi'ni veya Windows Terminal → Command Prompt'u aç. Varsa `winget` ile Git kur; yoksa ZIP yöntemini kullan. Git kurduktan sonra **yeni CMD penceresi** aç.

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

**2. Depoyu bilgisayara klonla.** Aşağıdaki komutlar projeyi Downloads klasörüne indirir. `cd /d` sürücüyü ve dizini değiştirir. `dir` çıktısında `install.cmd`, `install.ps1`, `nova.ps1` görünmelidir.

```cmd
cd /d "%USERPROFILE%\Downloads"
git clone https://github.com/RuslanSharifov/termux-nova.git
cd /d "%USERPROFILE%\Downloads\termux-nova\windows"
dir
```

**Alternatif: Git olmadan ZIP.** Bağlantıyı tarayıcıda aç, ZIP'i Downloads içine çıkar ve açılan projenin `windows` klasörüne gir. Farklı dizine çıkardıysan yolu değiştir.

[Download main.zip](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova-main\windows"
dir
```

## 04 — Back up CMD AutoRun

**3. Kurulumdan önce CMD AutoRun'ı kontrol et ve yedekle.** Nova açılış afişi ve `doskey` makroları için `HKCU\Software\Microsoft\Command Processor\AutoRun` kullanıcı kayıt değerini ayarlar. Önceden var olan AutoRun komutunun **üzerine yazabilir**. `reg query` ile kontrol et, anahtar mevcutsa `reg export` ile yedekle. Anahtar yoksa export hatası normaldir.

```cmd
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg export "HKCU\Software\Microsoft\Command Processor" "%USERPROFILE%\cmd-autostart-before-nova.reg" /y
```

## 05 — Install Windows version

**4. Windows kurulumunu başlat.** `windows` klasöründe `install.cmd` çalıştır. Bu dosya PowerShell 5.1'i yalnızca o işlem için `-ExecutionPolicy Bypass` ile başlatır; genel sistem ilkesini kalıcı değiştirmez.

```cmd
install.cmd
```

Equivalent manual command (from the `windows` folder):

```cmd
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

Kurulum `nova.ps1`, `nova.cmd`, `themes.json` dosyalarını `%APPDATA%\termux-nova` içine kopyalar, dizini kullanıcı `PATH`'ine ekler, CMD AutoRun kancalarını kurar, otomatik geri yüklemeyi sorar (**Enter = evet**) ve Windows Terminal'de `nova-dark` temasını uygulamayı dener. **Kurulumdan sonra yeni CMD penceresi aç.**

## 06 — Verify and open console

**5. Kurulumu denetle ve ayarlar menüsünü aç.** `where nova` kurulu başlatıcıyı gösterir. `nova console` içinde Yukarı/Aşağı ve Enter veya numara + Enter kullanılır. `nova doctor` tanı bilgisi verir.

```cmd
where nova
nova doctor
nova console
nova list
nova current
```

## 07 — Apply themes and control startup

**6. Temalar ve CMD davranışı.** `nova set dracula`, Windows Terminal `settings.json` renk şemasını düzenler; eski konsolda aynı görünüm olmayabilir. Windows Terminal'de **Command Prompt** profilini seç: CMD makroları PowerShell profilinde çalışmaz. Başlangıçta ve `cls` sonrası afişi `nova console` ile ayarla.

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

**7. Özel komutları oluştur, düzenle, sil.** `///` sıralı adımları ayırır. Git örneği için Git, isteğe bağlı npm örneği için Node.js/npm gerekir. Makro değişikliklerinden sonra yeni CMD penceresi aç.

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

**8. Güncelle.** Git klonunda `git pull --ff-only` ardından `install.cmd` çalıştır. ZIP kurulumunda arşivi yeniden indirip yeni `windows` klasöründen kur.

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova"
git status
git pull --ff-only
cd windows
install.cmd
```

## 10 — Troubleshooting

1. `'nova' is not recognized` — yeni CMD aç, `where nova` kontrol et, gerekirse `install.cmd` çalıştır.
2. Renkler değişmiyor — Windows Terminal kullan ve `nova doctor` çalıştır. `settings.json` içindeki yorum satırları ayrıştırmayı engelleyebilir.
3. Afiş yok — CMD profili aç, `nova hook` çalıştır, yeni pencere aç. `cmd /d` AutoRun'ı devre dışı bırakır.
4. `cls` makrosu çalışmıyor — `nova hook` sonrasında yeni CMD aç; `doskey` PowerShell profilinde geçerli değildir.
5. Eski CMD AutoRun kayboldu — kurulum öncesi `.reg` yedeğini incele; geri yüklemeden önce güncel kayıt durumunu da yedekle.

## 11 — Uninstall and privacy

**9. Kaldırma.** Bu sürümde ayrı Windows kaldırıcı yoktur. Önce `nova auto off` çalıştır. `reg query` ile AutoRun'ın hâlâ Nova'ya ait olduğunu doğrula; sonra sil veya önceki kayıt yedeğini yükle. `%APPDATA%\termux-nova` özel komutları içerir; silmeden önce yedekle. Kullanıcı PATH'inden dizini Windows *Environment Variables* ekranından kaldır. Windows Terminal renklerini geri almak için `settings.json.nova-backup` dosyasını kontrol et; çoklu tema değişimleri yedeğin üzerine yazmış olabilir.

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

Özel komutlar `%APPDATA%\termux-nova\commands` dosyasındadır; gizli token ekleme. Kayıt defteri ve Windows Terminal ayarlarına yapılacak değişiklikleri önceden incele.

---

**Geliştirici:** rugo · [RuslanSharifov](https://github.com/RuslanSharifov). [Tüm diller ve platformlar](../README.md).
