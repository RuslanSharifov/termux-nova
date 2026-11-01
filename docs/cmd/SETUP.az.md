# Termux Nova — Windows CMD quraşdırması

[← Əsas README və demo](../../README.md) · [Android Termux təlimatı](../termux/SETUP.az.md)

## 1. Quraşdırma — ZIP endir və install.cmd faylına kliklə

**Windows üçün quraşdırma əmrlərini kopyalamağa ehtiyac yoxdur.** Bu 4 addımı et:

1. **[termux-nova ZIP faylını endir](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)**.
2. ZIP arxivini çıxart (Extract All).
3. Açılan `termux-nova-main` qovluğunda `windows` qovluğunu aç.
4. **`install.cmd` faylına iki dəfə kliklə**, çıxan sualları cavablandır və sonda **yeni CMD pəncərəsi aç**.

**Vacib:** Əvvəldən CMD açılış komandaların varsa, 4-cü addımdan qabaq AutoRun ayarını ehtiyatla saxla. Nova `HKCU\Software\Microsoft\Command Processor\AutoRun` dəyərini əvəz edə bilər. Aşağıda istəyə bağlı backup üsulu var.

Quraşdırıcı PowerShell vasitəsilə işləyir, Nova-nı istifadəçi qovluğuna kopyalayır və PATH-ə əlavə edir. Windows Terminal rəng mövzuları üçün tövsiyə olunur. **CMD (Command Prompt) profilini** aç; PowerShell profilində `doskey` qısayolları işləmir.

## 2. Nova-dan istifadə

Yeni CMD pəncərəsində `nova console` yaz. Menyuda ox düymələri və Enter, yaxud rəqəm + Enter ilə seçim edə bilərsən.

```cmd
nova console
nova list
nova current
nova doctor
```

## 3. Rəng mövzuları və avtomatik açılış

Mövzular: `nova-dark`, `dracula`, `gruvbox`, `nord`. Rənglər əsasən Windows Terminal üçün tətbiq olunur. `nova auto on` seçilən mövzunu növbəti açılışda bərpa edir; banner və `cls` ayarları `nova console` daxilindədir.

```cmd
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 4. Öz komandalarını yarat, bax, dəyiş, sil

`///` addımların ardıcıl yerinə yetirilməsini təmin edir. Aşağıdakı misal üçün Git for Windows əvvəlcədən quraşdırılmalıdır. Dəyişiklikdən sonra **yeni CMD** aç ki, makrolar yenilənsin.

```cmd
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
```

## 5. Yeniləmə

Yenidən [GitHub ZIP](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip) endir, arxivi çıxart, yeni `termux-nova-main/windows/install.cmd` faylını işə sal və yeni CMD aç. Təkrar quraşdırma da AutoRun ayarını yenidən yaza bilər.

## 6. İstəyə bağlı: CMD AutoRun ehtiyat nüsxəsi

CMD-də quraşdırmadan **əvvəl** aşağıdakı əmrlərlə AutoRun dəyərini yoxlaya və açarın ehtiyatını saxlaya bilərsən. Açar yoxdursa, export xətası normaldır. Əvvəlki AutoRun ayarını qaytarmaq üçün `.reg` faylını nəzərdən keçir.

```cmd
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg export "HKCU\Software\Microsoft\Command Processor" "%USERPROFILE%\cmd-autostart-before-nova.reg" /y
```

## 7. Problemlərin həlli

1. **`nova` tanınmır** — yeni CMD aç, `where nova` yoxla, lazım olsa `install.cmd` yenidən işə sal.
2. **Tema dəyişmir** — Windows Terminal-da Command Prompt profili aç; `nova doctor` yoxla. `settings.json`-dakı şərhlər skriptin onu oxumasına mane ola bilər.
3. **Banner görünmür** — CMD-də `nova hook` işlə və pəncərəni yenilə; `cmd /d` AutoRun-u söndürür.
4. **Öz komandam işləmir** — `nova cmd` siyahısını yoxla və yeni CMD aç.

## 8. Silmə və məxfilik {#uninstall}

Əvvəl avtomatik bərpanı söndür və AutoRun dəyərini yoxla. **Yalnız AutoRun dəyəri Nova-ya məxsusdursa** onu sil, yoxsa əvvəlki quraşdırmanı poza bilərsən. Sonra `%APPDATA%\termux-nova` qovluğunun ehtiyatını saxlayıb sil və Windows Environment Variables-də istifadəçi PATH-dən həmin qovluğu çıxart. `%LOCALAPPDATA%\termux-nova` cache qovluğu da istəyə görə silinə bilər.

```cmd
nova auto off
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
```

Windows Terminal ayarlarını bərpa etmək üçün `settings.json.nova-backup` faylını yoxla; bir neçə dəfə tema dəyişmisənsə backup əvəz olunmuş ola bilər. Şifrələri və tokenləri xüsusi komanda təriflərində saxlamamalısan.

**Qeyd:** Bu versiya Windows CMD və Windows Terminal üçün işləyir, Android-in native interfeysini dəyişmir.

---

Hazırladı: **rugo · Ruslan Sharifov**. · [GitHub](https://github.com/RuslanSharifov/termux-nova)
