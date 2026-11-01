# termux-nova Quraşdırma Təlimatı (Azərbaycanca)

**rugo** tərəfindən hazırlanmışdır.

## 1. Tələblər

- Termux quraşdırılmış Android (F-Droid və ya GitHub versiyası; köhnə Play Store versiyası köhnədir)
- İlk quraşdırma üçün internet

## 2. Faylları əldə et

```bash
pkg install -y git
git clone https://github.com/RuslanSharifov/termux-nova.git
cd termux-nova
```

Ya da zip ilə: `pkg install -y unzip && unzip termux-nova.zip && cd termux-nova`

## 3. Quraşdırma skriptini işə sal

```bash
bash install.sh
```

Quraşdırma:

1. `termux-tools` paketini quraşdırır (`termux-reload-settings` üçün)
2. `nova` əmrini və temaları Termux-a kopyalayır
3. Starship, Oh My Posh kimi digər prompt/UI alətlərini söndürmək istəyib-istəmədiyini soruşur. Əvvəl `~/.bashrc` faylının ehtiyat nüsxəsi götürülür.
4. `~/.bashrc` hook-larını quraşdırır
5. Avtomatik bərpanı soruşur (Enter = bəli)
6. Standart `nova-dark` temasını tətbiq edir

## 4. Ayarlar panelini aç

```bash
nova console
```

Paneldən temanı dəyişə, avtomatik bərpanı və banner-ləri aça/bağlaya, xüsusi komandaları idarə edə, cache-i təmizləyə, ayarları sıfırlaya və `~/.bashrc`-ni bərpa edə bilərsən.

## 5. İstifadə

```bash
nova list
nova set dracula
nova current
```

## 6. Xüsusi komandalar

```bash
nova cmd add "npm run full" "npm i && npm run dev"
nova cmd
nova cmd edit "npm run full" "npm i && npm run build"
nova cmd rm "npm run full"
```

Dəyişiklikdən sonra yeni sessiya aç və ya `source ~/.bashrc` yaz. Bundan sonra `npm run full` istənilən qovluqda işləyəcək.

## 7. Açılış davranışı

Termux-un hər yeni sessiyasında əvvəl `clear` işləyir, sonra NOVA banner-i çıxır. `clear` yazanda banner yenidən görünür. Hər ikisi `nova console` daxilində söndürülə bilər.

## 8. Problemlərin həlli

| Problem | Həll |
|---|---|
| `nova: command not found` | `bash install.sh` əmrini yenidən işə sal və ya Termux-u yenidən başlat |
| Rənglər dəyişmədi | `nova set <tema>` əmrini yenidən işə sal |
| `termux-reload-settings: not found` | `pkg install termux-tools` |
| Tema açılanda sıfırlanır | `nova current` ilə yoxla, auto restore söndürülüdürsə `nova auto on` |
| Xüsusi komanda işləmir | Yeni sessiya aç və ya `source ~/.bashrc` yaz |

## 9. Silmək

```bash
nova auto off
sed -i '/# termux-nova$/d' ~/.bashrc
rm -f "$PREFIX/bin/nova"
rm -rf ~/.config/termux-nova ~/.cache/termux-nova
```

---

**rugo** tərəfindən hazırlanıb · MIT Lisenziyası
