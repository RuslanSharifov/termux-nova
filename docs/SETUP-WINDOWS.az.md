# termux-nova Windows Quraşdırma Təlimatı (Azərbaycanca)

**rugo** tərəfindən hazırlanmışdır.

termux-nova Windows-da da Termux ilə eyni işləyir: eyni əmrlər, eyni ayarlar menyusu və eyni xüsusi komandalar (`salam`, `npm run full`, ...). Seçim ox düymələri və Enter ilə, ya da nömrə yazıb Enter basmaqla edilir.

## 1. Tələblər

- Windows 10 və ya 11
- **Windows Terminal** (tövsiyə olunur). Tema dəyişmək yalnız Windows Terminal-da işləyir. Windows 11-də hazır gəlir, Windows 10-da Microsoft Store-dan quraşdırıla bilər.
- PowerShell 5.1 (Windows ilə birlikdə gəlir)
- İlk quraşdırma üçün internet (GitHub statistikası və ilk yükləmə)

## 2. Faylları əldə et

Repo-nu (və ya zip-i) endir və `windows` qovluğunu aç:

```
termux-nova\windows\
```

## 3. Quraşdırma skriptini işə sal

`install.cmd` faylına iki dəfə klik et, ya da `windows` qovluğunda PowerShell-də bunu yaz:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

Quraşdırma:

1. `nova.ps1`, `themes.json` və `nova.cmd` fayllarını `%APPDATA%\termux-nova` qovluğuna köçürür
2. Həmin qovluğu istifadəçi PATH-inə əlavə edir, belə ki, hər yeni pəncərədə `nova` işləyir
3. cmd.exe hook-larını quraşdırır (`cls`-dən sonra banner, xüsusi komandalar, avtomatik bərpa)
4. Avtomatik bərpanı soruşur (Enter = bəli)
5. Standart `nova-dark` temasını Windows Terminal-a tətbiq edir

**Quraşdırmadan sonra yeni bir Windows Terminal (və ya cmd) pəncərəsi aç.**

## 4. Ayarlar menyusunu aç

```
nova console
```

Düymələr:

| Düymə | Əməliyyat |
|---|---|
| ↑ / ↓ | Seçimi hərəkət etdir |
| Enter | Seçili elementi seç |
| 1 - 9 sonra Enter | Nömrə ilə seç |
| Esc | Geri qayıt |

## 5. Əmrlər

```
nova list
nova set dracula
nova current
nova auto on
nova auto off
nova banner
nova doctor
```

## 6. Xüsusi komandalar

Menyudan (`nova console` → Custom commands → Add) və ya komanda sətirindən yarat:

```
nova cmd add "salam" "npm i /// npm run dev"
nova cmd add "npm run full" "npm i /// npm run dev"
nova cmd edit "salam" "npm i /// npm run build"
nova cmd rm "salam"
```

Addımlar `///` ilə ayrılır. Hər addım əvvəlkinin uğurlu olmasından sonra işləyir. Yeni cmd pəncərəsi aç və trigger-i yaz, məsələn `salam`.

Qeyd: trigger-in içində `///` ola bilməz, `dir`, `cd`, `cls`, `echo` kimi qorunmuş sözlər də ola bilməz.

## 7. Açılış və təmizləmə davranışı

Hər yeni cmd pəncərəsi ekranı bir dəfə təmizləyir və banner-i göstərir. `cls` yazanda ekran təmizlənir və banner yenidən çıxır. Hər ikisi `nova console` daxilində söndürülə bilər.

## 8. Problemlərin həlli

| Problem | Həll |
|---|---|
| `nova` tanınmır | Yeni pəncərə aç. Hələ də olmursa `install.cmd` faylını yenidən işə sal |
| Skriptlər bloklanır | Yuxarıda göstərildiyi kimi həmişə `-ExecutionPolicy Bypass` ilə başlat |
| Tema dəyişmir | Köhnə konsol pəncərəsi yox, Windows Terminal istifadə et. `nova doctor` ilə `settings.json`-un yerini yoxla |
| Windows Terminal ayarları oxuna bilmədi deyir | `settings.json`-da şərh sətirləri var. Onları sil, ya da `settings.json.nova-backup` faylını geri qoy |
| `cls`-dən sonra banner çıxmır | `nova hook` işə sal, sonra yeni pəncərə aç. `nova doctor` çıxışında `cmd AutoRun : ok` olmalıdır |
| Xüsusi komanda işləmir | Yeni pəncərə aç. `nova cmd` əmrində trigger-in göründüyünü yoxla |

## 9. Silmək

```
nova auto off
```

Sonra hook-u və faylları sil:

```powershell
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Command Processor' -Name AutoRun -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:APPDATA\termux-nova"
```

Windows mühit dəyişənlərindən istifadəçi PATH-indən `termux-nova` qovluğunu da sil.

---

**rugo** tərəfindən hazırlanıb · MIT Lisenziyası
