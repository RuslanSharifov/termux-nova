# termux-nova Windows Kurulum Rehberi (Türkçe)

**rugo** tarafından hazırlanmıştır.

termux-nova Windows'ta da Termux ile aynı şekilde çalışır: aynı komutlar, aynı ayarlar menüsü ve aynı özel komutlar (`salam`, `npm run full`, ...). Seçim ok tuşları ve Enter ile yapılır, ya da numara yazıp Enter'a basılır.

## 1. Gereksinimler

- Windows 10 veya 11
- **Windows Terminal** (önerilir). Tema değiştirme yalnızca Windows Terminal'de çalışır. Windows 11'de hazır gelir, Windows 10'da Microsoft Store'dan kurulabilir.
- PowerShell 5.1 (Windows ile birlikte gelir)
- İlk kurulum için internet (GitHub istatistikleri ve ilk indirme)

## 2. Dosyaları al

Depoyu (ya da zip'i) indir ve `windows` klasörünü aç:

```
termux-nova\windows\
```

## 3. Kurulum scriptini çalıştır

`install.cmd` dosyasına çift tıkla, ya da `windows` klasöründe PowerShell'de şunu çalıştır:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

Kurulum:

1. `nova.ps1`, `themes.json` ve `nova.cmd` dosyalarını `%APPDATA%\termux-nova` klasörüne kopyalar
2. Bu klasörü kullanıcı PATH'ine ekler, böylece her yeni pencerede `nova` çalışır
3. cmd.exe hook'larını kurar (`cls` sonrası banner, özel komutlar, otomatik geri yükleme)
4. Otomatik geri yüklemeyi sorar (Enter = evet)
5. Varsayılan `nova-dark` temasını Windows Terminal'e uygular

**Kurulumdan sonra yeni bir Windows Terminal (veya cmd) penceresi aç.**

## 4. Ayarlar menüsünü aç

```
nova console
```

Tuşlar:

| Tuş | İşlem |
|---|---|
| ↑ / ↓ | Seçimi taşı |
| Enter | Seçili öğeyi seç |
| 1 - 9 sonra Enter | Numara ile seç |
| Esc | Geri dön |

## 5. Komutlar

```
nova list
nova set dracula
nova current
nova auto on
nova auto off
nova banner
nova doctor
```

## 6. Özel komutlar

Menüden (`nova console` → Custom commands → Add) ya da komut satırından oluştur:

```
nova cmd add "salam" "npm i /// npm run dev"
nova cmd add "npm run full" "npm i /// npm run dev"
nova cmd edit "salam" "npm i /// npm run build"
nova cmd rm "salam"
```

Adımlar `///` ile ayrılır. Her adım, öncekinin başarılı olmasından sonra çalışır. Yeni bir cmd penceresi aç ve trigger'ı yaz, örneğin `salam`.

Not: trigger içinde `///` olamaz ve `dir`, `cd`, `cls`, `echo` gibi ayrılmış kelime olamaz.

## 7. Açılış ve temizleme davranışı

Her yeni cmd penceresi bir kez ekranı temizler ve banner'ı gösterir. `cls` yazınca ekran temizlenir ve banner tekrar çıkar. İkisi de `nova console` içinden kapatılabilir.

## 8. Sorun giderme

| Sorun | Çözüm |
|---|---|
| `nova` tanınmıyor | Yeni pencere aç. Hâlâ olmuyorsa `install.cmd` dosyasını tekrar çalıştır |
| Scriptler engelleniyor | Yukarıda gösterildiği gibi her zaman `-ExecutionPolicy Bypass` ile başlat |
| Tema değişmiyor | Eski konsol penceresi yerine Windows Terminal kullan. `nova doctor` ile `settings.json` konumunu gör |
| Windows Terminal ayarları okunamadı diyor | `settings.json` içinde yorum satırı var. Onları sil ya da `settings.json.nova-backup` dosyasını geri koy |
| `cls` sonrası banner çıkmıyor | `nova hook` çalıştır, sonra yeni pencere aç. `nova doctor` çıktısında `cmd AutoRun : ok` olmalı |
| Özel komut çalışmıyor | Yeni pencere aç. `nova cmd` komutunda trigger'ın göründüğünü kontrol et |

## 9. Kaldırma

```
nova auto off
```

Sonra hook'u ve dosyaları sil:

```powershell
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Command Processor' -Name AutoRun -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:APPDATA\termux-nova"
```

Windows ortam değişkenlerinden kullanıcı PATH'inde `termux-nova` klasörünü de kaldır.

---

**rugo** tarafından yapıldı · MIT Lisansı
