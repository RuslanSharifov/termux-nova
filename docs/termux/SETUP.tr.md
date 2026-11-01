# Termux Nova — Android Termux kurulumu

[← Ana README ve demo](../../README.md) · [Windows CMD rehberi](../cmd/SETUP.tr.md)

## 1. Kurulum — tek seferde kopyala-yapıştır

**Aşağıdaki bloğun tamamını bir kez kopyalayıp Termux'a yapıştır.** Depo indirilir, Nova yüklenir ve en sonda `clear` çalışır.

```bash
pkg update -y && pkg install -y git && \
cd "$HOME" && \
git clone https://github.com/RuslanSharifov/termux-nova.git && \
cd termux-nova && \
bash install.sh && \
source "$HOME/.bashrc" && \
clear
```

Kurulum sırasında diğer UI/prompt araçlarını kapatmak ve temayı her başlangıçta geri yüklemek için sorular çıkabilir. Önce soruları oku; otomatik geri yükleme için **Enter = evet**. Sonraki Termux oturumlarında Nova otomatik yüklenir.

> `~/termux-nova` zaten varsa `git clone` durur. Bu durumda alttaki **Güncelleme** bölümünü kullan.

## 2. Nova nasıl kullanılır?

Kurulumdan sonra Termux'u yeniden aç veya şu komutları çalıştır. Ayar menüsü için `nova console` kullan.

```bash
nova console
nova list
nova current
nova doctor
```

## 3. Temalar ve başlangıç

Yerleşik temalar: `nova-dark`, `dracula`, `nord`, `gruvbox`. `nova auto on` kayıtlı temayı yeni oturumda uygular. Açılış afişi ve `clear` sonrası afiş `nova console` içinden ayarlanır.

```bash
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 4. Özel komutlar — ekle, listele, düzenle, sil

`///` sıralı adımları ayırır. Önceki adım başarılıysa sonraki çalışır. Örnekte Git kullanılır (kurulum sırasında yüklenir).

```bash
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
```

Özel komutları değiştirdikten sonra Termux'u yeniden aç veya `source ~/.bashrc` çalıştır. Komutlara parola veya token koyma.

## 5. Kurulu sürümü güncelle

Depo zaten varsa yeniden klonlama. Bu güncelleme bloğunu yapıştır. Kurulum soruları yeniden çıkabilir.

```bash
cd ~/termux-nova && git pull --ff-only && bash install.sh && source ~/.bashrc && clear
```

## 6. Sorun giderme

1. **`nova: command not found`** — Termux'u yeniden aç; gerekirse `cd ~/termux-nova && bash install.sh` çalıştır.
2. **Renkler değişmiyor** — `pkg install -y termux-tools` ve ardından `nova set dracula` çalıştır.
3. **Tema sıfırlanıyor** — `nova current` kontrol et ve `nova auto on` aç.
4. **Özel komut çalışmıyor** — `nova cmd` listesini kontrol et ve `source ~/.bashrc` çalıştır.
5. **Eski prompt değişti** — kurulumda oluşan `.nova-backup-*` dosyalarını incele. `nova restore` tüm `~/.bashrc` dosyasını son yedekle değiştirir ve daha yeni değişiklikleri silebilir.

## 7. Kaldırma ve güvenlik

Otomatik tema geri yüklemesini kapatmak ve Nova başlangıç satırlarıyla komutunu kaldırmak için bu bloğu çalıştır. Önceki terminal renkleri otomatik olarak geri gelmez.

```bash
nova auto off
[ -f "$HOME/.bashrc" ] && sed -i '/# termux-nova$/d' "$HOME/.bashrc"
[ -f "$HOME/.bash_profile" ] && sed -i '/# termux-nova$/d' "$HOME/.bash_profile"
rm -f "$PREFIX/bin/nova"
```

**İsteğe bağlı kalıcı veri silme:** gerekenleri yedekledikten sonra `rm -rf ~/.config/termux-nova ~/.cache/termux-nova` çalıştır.

**Not:** Bu sürüm Bash tabanlı tema/komut yöneticisidir. SQLite komut sayacı, soluk metin önerisi ve Tab kabulü henüz yoktur. Android'in yerel düğme ve menüleri değişmez.

---

Geliştirici: **rugo · Ruslan Sharifov**. · [GitHub](https://github.com/RuslanSharifov/termux-nova)
