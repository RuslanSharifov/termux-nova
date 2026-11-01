# termux-nova Kurulum Rehberi (Türkçe)

**rugo** tarafından hazırlanmıştır.

## 1. Gereksinimler

- Termux yüklü Android cihaz (F-Droid veya GitHub sürümü; eski Play Store sürümü güncel değil)
- İlk kurulum için internet

## 2. Dosyaları al

```bash
pkg install -y git
git clone https://github.com/RuslanSharifov/termux-nova.git
cd termux-nova
```

Ya da zip ile: `pkg install -y unzip && unzip termux-nova.zip && cd termux-nova`

## 3. Kurulum scriptini çalıştır

```bash
bash install.sh
```

Kurulum:

1. `termux-tools` paketini kurar (`termux-reload-settings` için)
2. `nova` komutunu ve temaları Termux'a kopyalar
3. Starship, Oh My Posh gibi diğer prompt/UI araçlarını kapatmak isteyip istemediğini sorar. Önce `~/.bashrc` yedeği alınır.
4. `~/.bashrc` hook'larını kurar
5. Otomatik geri yüklemeyi sorar (Enter = evet)
6. Varsayılan `nova-dark` temasını uygular

## 4. Ayar panelini aç

```bash
nova console
```

Panelden tema seçebilir, otomatik geri yüklemeyi ve banner'ları açıp kapatabilir, xüsusi komutları yönetebilir, cache'i temizleyebilir, ayarları sıfırlayabilir ve `~/.bashrc`'yi geri yükleyebilirsin.

## 5. Kullanım

```bash
nova list
nova set dracula
nova current
```

## 6. Özel komutlar

```bash
nova cmd add "npm run full" "npm i && npm run dev"
nova cmd
nova cmd edit "npm run full" "npm i && npm run build"
nova cmd rm "npm run full"
```

Değişiklikten sonra yeni bir oturum aç veya `source ~/.bashrc` çalıştır. Böylece `npm run full` her klasörde çalışır.

## 7. Açılış davranışı

Termux'un her yeni oturumunda `clear` çalışır ve ardından NOVA banner'ı çıkar. `clear` yazınca banner tekrar görünür. İkisi de `nova console` içinden kapatılabilir.

## 8. Sorun giderme

| Sorun | Çözüm |
|---|---|
| `nova: command not found` | `bash install.sh` komutunu tekrar çalıştır veya Termux'u yeniden başlat |
| Renkler değişmedi | `nova set <tema>` komutunu tekrar çalıştır |
| `termux-reload-settings: not found` | `pkg install termux-tools` |
| Tema açılışta sıfırlanıyor | `nova current` ile kontrol et, otomatik geri yükleme kapalıysa `nova auto on` |
| Özel komut çalışmıyor | Yeni oturum aç veya `source ~/.bashrc` çalıştır |

## 9. Kaldırma

```bash
nova auto off
sed -i '/# termux-nova$/d' ~/.bashrc
rm -f "$PREFIX/bin/nova"
rm -rf ~/.config/termux-nova ~/.cache/termux-nova
```

---

**rugo** tarafından yapıldı · MIT Lisansı
