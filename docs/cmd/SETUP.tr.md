# Termux Nova — Windows CMD kurulumu

[← Ana README ve demo](../../README.md) · [Android Termux rehberi](../termux/SETUP.tr.md)

## 1. Kurulum — ZIP indir ve install.cmd dosyasına çift tıkla

**Windows'ta kurulum komutu kopyalaman gerekmez.** Şu 4 adımı izle:

1. **[termux-nova ZIP dosyasını indir](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)**.
2. ZIP arşivini çıkar (Tümünü ayıkla).
3. Açılan `termux-nova-main` klasöründeki `windows` klasörünü aç.
4. **`install.cmd` dosyasına çift tıkla**, kurulum sorularını yanıtla ve sonra **yeni CMD penceresi aç**.

**Önemli:** Başlangıçta başka CMD betiklerin varsa 4. adımdan önce AutoRun'ı yedekle. Nova `HKCU\Software\Microsoft\Command Processor\AutoRun` değerinin üzerine yazabilir. İsteğe bağlı yedekleme aşağıda.

Kurucu PowerShell ile Nova'yı kullanıcı klasörüne kopyalar ve PATH'e ekler. Renkler için Windows Terminal önerilir. `doskey` kısa komutları için **Command Prompt (CMD) profili** kullan; PowerShell profili değil.

## 2. Nova nasıl kullanılır?

Yeni CMD penceresinde `nova console` yaz. Menüde yön tuşları + Enter veya numara + Enter kullan.

```cmd
nova console
nova list
nova current
nova doctor
```

## 3. Temalar ve otomatik başlangıç

Temalar: `nova-dark`, `dracula`, `gruvbox`, `nord`. Renkler esas olarak Windows Terminal'de uygulanır. `nova auto on` seçilen temayı açılışta geri yükler. Başlangıç ve `cls` sonrası afiş `nova console` ile ayarlanır.

```cmd
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 4. Özel komutlar — ekle, listele, düzenle, sil

`///` sıralı çalıştırılacak komutları ayırır. Örnek için Git for Windows kurulmalıdır. Makroları güncellemek için değişiklikten sonra **yeni CMD penceresi aç**.

```cmd
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
```

## 5. Güncelleme

Yeni [GitHub ZIP](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip) indir, arşivi çıkar, yeni `termux-nova-main/windows/install.cmd` dosyasını çalıştır ve yeni CMD aç. Yeniden kurulum AutoRun değerini tekrar değiştirebilir.

## 6. İsteğe bağlı: CMD AutoRun yedeği

Kurulumdan **önce** CMD'de bu komutlarla AutoRun'ı kontrol edip kayıt anahtarını yedekleyebilirsin. Anahtar yoksa export hatası normaldir. İleride geri almadan önce `.reg` dosyasını incele.

```cmd
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg export "HKCU\Software\Microsoft\Command Processor" "%USERPROFILE%\cmd-autostart-before-nova.reg" /y
```

## 7. Sorun giderme

1. **`nova` tanınmıyor** — yeni CMD aç, `where nova` kontrol et, gerekirse `install.cmd` çalıştır.
2. **Tema değişmiyor** — Windows Terminal Command Prompt profili kullan ve `nova doctor` çalıştır. `settings.json` yorum satırları ayrıştırmayı engelleyebilir.
3. **Afiş görünmüyor** — CMD'de `nova hook` çalıştır ve yeni pencere aç; `cmd /d` AutoRun'ı devre dışı bırakır.
4. **Özel komut çalışmıyor** — `nova cmd` listesini kontrol et ve yeni CMD aç.

## 8. Kaldırma ve gizlilik

Önce otomatik geri yüklemeyi kapat ve AutoRun'ı kontrol et. **AutoRun'ı yalnızca hâlâ Nova'ya aitse sil**; yoksa başka başlangıç betiklerini bozabilirsin. `%APPDATA%\termux-nova` klasöründeki özel komutları yedekle, sonra klasörü kaldır ve kullanıcı PATH'inden Windows Environment Variables içinden çıkar. `%LOCALAPPDATA%\termux-nova` önbelleği de silinebilir.

```cmd
nova auto off
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
```

Windows Terminal renklerini geri almak için `settings.json.nova-backup` dosyasını incele; tekrarlanan tema değişimleri yedeği ezmiş olabilir. Özel komutlara parola veya token ekleme.

**Kapsam:** Bu sürüm Windows CMD/Windows Terminal için çalışır; Android'in yerel uygulama arayüzünü değiştirmez.

---

Geliştirici: **rugo · Ruslan Sharifov**. · [GitHub](https://github.com/RuslanSharifov/termux-nova)
