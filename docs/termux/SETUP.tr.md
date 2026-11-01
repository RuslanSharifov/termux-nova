# Termux için ayrıntılı kurulum rehberi

> **Termux Nova v2.x** · **TR** · [Windows CMD](../cmd/SETUP.tr.md) · [Documentation index](../README.md)

Bu rehber Android **Termux** üzerinde termux-nova'nın kurulumu, ayarları, güncellenmesi, sorun giderme ve kaldırma işlemlerini açıklar. Windows kullanıyorsan [CMD rehberine](../cmd/SETUP.tr.md) geç.

## Requirements / 01

F-Droid veya resmi GitHub dağıtımından güncel Termux, ilk kurulum için internet ve yeterli boş alan gerekir. Root gerekmez. Aşağıdaki komutları **Termux içinde** çalıştır; Windows CMD'de değil.

## 02 — Prepare Termux

**1. Termux'u hazırla.** Uygulamayı aç, paket listesini güncelle ve Git yükle. `pkg` Termux paket yöneticisidir; `git` depoyu indirir.


```bash
pkg update && pkg upgrade -y
pkg install -y git
```


## 03 — Download the project (Git)

**2. Depoyu klonla.** `cd ~` ana klasöre geçer, `git clone` dosyaları indirir, son `cd` proje klasörünü açar.

```bash
cd ~
git clone https://github.com/RuslanSharifov/termux-nova.git
cd termux-nova
ls
```

**Alternatif: Git kullanmadan ZIP indir.** Aşağıdaki yöntem `main` dalının arşivini indirir. Git veya ZIP yönteminden yalnızca birini seç; ZIP güncellemesi için arşivi yeniden indirmelisin.

```bash
pkg install -y curl unzip
cd ~
curl -fL https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip -o termux-nova.zip
unzip termux-nova.zip
cd termux-nova-main
ls
```

## 04 — Install and activate

**3. Kurulum betiğini çalıştır.** `ls` ile `install.sh`, `nova.sh`, `themes/` dosyalarını kontrol et; sonra Bash betiğini başlat.

```bash
ls install.sh nova.sh themes
bash install.sh
```

Kurucu `termux-tools` ve `curl` yükler, `nova` komutuyla temaları kopyalar ve `~/.bashrc` başlangıç kancalarını ekler. Başka prompt/UI araçlarını devre dışı bırakmak için izin ister; kabul edersen tarih damgalı rc yedekleri oluşturur. Otomatik tema geri yükleme sorusunda **Enter = evet**, `n` = hayır. Varsayılan tema `nova-dark`. Yeni Termux oturumu aç veya mevcut Bash oturumunda `source ~/.bashrc` çalıştır.

```bash
source ~/.bashrc
```

**Uyarı:** diğer UI araçlarını devre dışı bırakma sorusunu okumadan onaylama; eşleşen rc satırları yorum satırı yapılır. Önemli kabuk ayarlarını ayrıca yedekle.

## 05 — Verify and configure

**4. Kurulumu kontrol et ve menüyü aç.** `nova doctor` tanılama yapar, `nova console` numaralı ayar panelini açar. `nova list` temaları, `nova current` kayıtlı ayarları gösterir.

```bash
command -v nova
nova doctor
nova console
nova list
nova current
```

## 06 — Themes and startup

**5. Tema ve başlangıç ayarları.** `nova set dracula` renkleri değiştirir; `nova auto on` sonraki açılışlarda kayıtlı temayı uygular. Büyük afiş başlangıçta ve `clear` komutundan sonra görünebilir; iki seçenek de `nova console` menüsünden değişir. Nova Android uygulamasının yerel düğmelerini değiştirmez.

```bash
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 07 — Custom commands: create, read, update, delete

**6. Özel komut oluştur (CRUD).** Tetikleyici mevcut bir çalıştırılabilir komut adıyla başlayabilir. `///` sıralı adımları ayırır; önceki başarılı olursa sonraki çalışır. Git örneği için Git kurulmalıdır.

```bash
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
source ~/.bashrc
```

Optional Node.js example (requires `pkg install nodejs` and an npm project):

```bash
pkg install -y nodejs
nova cmd add "npm run full" "npm install /// npm run dev"
source ~/.bashrc
npm run full
```

`nova cache clear` rebuilds generated command wrappers if required.

## 08 — Update an existing Git installation

**7. Güncelle.** Git ile klonladığın dizinde `git pull --ff-only` ardından `bash install.sh` çalıştır. Yerel değişiklikler güncellemeyi engelleyebilir; önce yedekle. Kurulum soruları tekrar sorulabilir.

```bash
cd ~/termux-nova
git status
git pull --ff-only
bash install.sh
source ~/.bashrc
nova doctor
```

## 09 — Troubleshooting

**8. Sorun giderme.**

1. `nova: command not found` — `bash install.sh` komutunu tekrar çalıştır, `command -v nova` kontrol et, yeni oturum aç.
2. Renkler değişmedi — `pkg install -y termux-tools` ve `nova set dracula` çalıştır, uygulamayı yeniden aç.
3. Tema sıfırlanıyor — `nova current` ve `nova auto on` komutlarını dene.
4. Özel komut çalışmıyor — `nova cmd` listesini kontrol et, `source ~/.bashrc` çalıştır.
5. Önceki prompt kayboldu — `~/.bashrc.nova-backup-*` yedeklerine bak; `nova restore` en son yedeği tüm `.bashrc` dosyasının üzerine yazar ve sonradan yapılan değişiklikleri silebilir.

## 10 — Uninstall and privacy

**9. Kaldırma ve veriler.** Otomatik tema geri yüklemeyi kapat, Nova kancalarını ve komut dosyasını kaldır. Aşağıdaki son satır ayarları, özel komutları ve önbelleği **kalıcı olarak siler**; saklamak istiyorsan çalıştırma.

```bash
nova auto off
sed -i '/# termux-nova$/d' ~/.bashrc
sed -i '/# termux-nova$/d' ~/.bash_profile
rm -f "$PREFIX/bin/nova"
# OPTIONAL — irreversible data deletion:
rm -rf ~/.config/termux-nova ~/.cache/termux-nova
```

Özel komutlar `~/.config/termux-nova/commands` içinde tutulur. Tanımlara parola veya token koyma; komutlar yerel dosyada saklanır ve yürütülebilir. Mevcut sürümde SQLite kullanım sayacı veya hayalet metin önerileri bulunmadığı için bu özellikler burada vaat edilmez.

---

**Geliştirici:** rugo · [RuslanSharifov](https://github.com/RuslanSharifov). [Bütün diller ve platformlar](../README.md).
