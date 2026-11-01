# Termux üçün tam quraşdırma təlimatı

> **Termux Nova v2.x** · **AZ** · [Windows CMD](../cmd/SETUP.az.md) · [Documentation index](../README.md)

Bu sənəd Android-də **Termux** tətbiqində termux-nova-nın sıfırdan quraşdırılmasını, sazlanmasını, yenilənməsini və silinməsini izah edir. Windows kompüterindən istifadə edirsənsə, [CMD təlimatına](../cmd/SETUP.az.md) keç.

## Requirements / 01

Android cihaz, Termux-un aktual F-Droid/GitHub buraxılışı, ilk quraşdırma üçün internet bağlantısı və təxminən bir neçə on MB boş yer. Root tələb olunmur. Aşağıdakı kodlar **Termux daxilində** yazılır; Windows CMD-də deyil.

## 02 — Prepare Termux

**1. Termux-u hazırla.** Tətbiqi aç və paket siyahısını yenilə. `pkg` Termux-un paket meneceridir; `git` GitHub repozitoriyasını endirir.


```bash
pkg update && pkg upgrade -y
pkg install -y git
```


## 03 — Download the project (Git)

**2. Repozitoriyanı klonla.** `cd ~` səni şəxsi qovluğa keçirir, `git clone` layihənin fayllarını yükləyir, sonuncu `cd` isə layihə qovluğuna daxil olur.

```bash
cd ~
git clone https://github.com/RuslanSharifov/termux-nova.git
cd termux-nova
ls
```

**Git istifadə etmədən ZIP variantı.** GitHub `main` budağının arxivini endirmək üçün aşağıdakı alternativ əmrləri işlət. Yalnız iki üsuldan birini seç. ZIP ilə yeniləmək üçün arxivi yenidən endirmək lazımdır.

```bash
pkg install -y curl unzip
cd ~
curl -fL https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip -o termux-nova.zip
unzip termux-nova.zip
cd termux-nova-main
ls
```

## 04 — Install and activate

**3. Quraşdırıcını işə sal.** Əvvəl cari qovluqda `install.sh`, `nova.sh` və `themes/` olduğunu `ls` ilə yoxla. Sonra Bash quraşdırıcısını başlad.

```bash
ls install.sh nova.sh themes
bash install.sh
```

Quraşdırıcı `termux-tools` və `curl` qurur, `nova` əmri ilə mövzuları Termux-a köçürür və açılış üçün `~/.bashrc` hook-larını əlavə edir. Digər prompt/UI alətlərini söndürməyə icazə soruşur; razılaşsan, rc fayllarının zaman damğalı ehtiyat nüsxələrini yaradır. Avtomatik tema bərpası üçün **Enter = bəli**, `n` = xeyr. Standart tema `nova-dark`-dır. Quraşdırma cari Bash sessiyasında dərhal aktiv görünməyə bilər: yeni Termux sessiyası aç və ya `source ~/.bashrc` işlə.

```bash
source ~/.bashrc
```

**Diqqət:** başqa prompt alətlərini deaktiv etmə sualını oxumadan təsdiqləmə. Bu seçim rc fayllarındakı uyğun sətrləri şərhə çevirir. Quraşdırmadan əvvəl vacib özəlləşdirmələrini ayrıca saxla.

## 05 — Verify and configure

**4. İşlədiyini yoxla və paneli aç.** `nova doctor` quraşdırmanı yoxlayır; `nova console` nömrəli ayarlar menyusunu açır. `nova list` mövzuları göstərir, `nova current` saxlanmış vəziyyəti göstərir.

```bash
command -v nova
nova doctor
nova console
nova list
nova current
```

## 06 — Themes and startup

**5. Mövzu və açılış ayarları.** `nova set dracula` rəngləri dəyişir; `nova auto on` seçilən temanı sonrakı girişlərdə saxlayır. Banner hər açılışda və `clear` əmrindən sonra görünə bilər; hər iki seçim `nova console` daxilində dəyişdirilir. Bu proqram Android-in düymələrini deyil, terminalın rənglərini və shell davranışını dəyişir.

```bash
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 07 — Custom commands: create, read, update, delete

**6. Öz komandalarını yarat (CRUD).** Əmr tetikleyicisi mövcud icra olunan alətin adı ilə başlaya bilər. `///` ardıcıl addımları ayırır; əvvəlki addım uğurlu olarsa növbəti başlayır. `git` üçün nümunə Git-in quraşdırılmış olmasını tələb edir.

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

**7. Yenilə.** Git ilə klonlanan layihəyə daxil olub `git pull --ff-only` et, sonra `bash install.sh` yenidən işlət. Dəyişmiş yerli fayllar `git pull`-u dayandıra bilər: dəyişikliklərini əvvəlcə saxla. Quraşdırıcı bəzi ayarları yenidən soruşa bilər.

```bash
cd ~/termux-nova
git status
git pull --ff-only
bash install.sh
source ~/.bashrc
nova doctor
```

## 09 — Troubleshooting

**8. Tez-tez rast gəlinən problemlər.**

1. `nova: command not found` — `bash install.sh`-ı yenidən işə sal, `command -v nova` yoxla və yeni Termux sessiyası aç.
2. Rənglər dəyişmədi — `pkg install -y termux-tools` və `nova set dracula` işlə; tətbiqi yenidən aç.
3. Açılışda köhnə tema qayıdır — `nova current` yoxla, `nova auto on` et.
4. Xüsusi komanda görünmür — `nova cmd` ilə siyahını yoxla, sonra `source ~/.bashrc` işlə.
5. Əvvəlki prompt itdi — quraşdırıcının saxladığı `~/.bashrc.nova-backup-*` fayllarını nəzərdən keçir; `nova restore` ən son backup-u tam geri yazır və sonrakı əl dəyişikliklərini əvəz edə bilər.

## 10 — Uninstall and privacy

**9. Silmək və şəxsi məlumatlar.** Əvvəl avtomatik bərpanı söndür, sonra Nova hook sətrlərini və CLI-ni sil. Aşağıdakı son sətr konfiqurasiya, öz komandaların və cache-i **birdəfəlik silir**; lazım deyilsə onu işlətmə.

```bash
nova auto off
sed -i '/# termux-nova$/d' ~/.bashrc
sed -i '/# termux-nova$/d' ~/.bash_profile
rm -f "$PREFIX/bin/nova"
# OPTIONAL — irreversible data deletion:
rm -rf ~/.config/termux-nova ~/.cache/termux-nova
```

Xüsusi komandaların məzmununu `~/.config/termux-nova/commands` faylında yoxlaya bilərsən. Komandaya token və şifrə əlavə etmə: şəxsi məlumatlar diskdə qalır və yazılan komandalar icra olunur. Bu versiyada SQLite komanda tezliyi/ghost-autosuggestion funksiyası sənədləşdirilmir, çünki hazırkı kodda yoxdur.

---

**Müəllif:** rugo · [RuslanSharifov](https://github.com/RuslanSharifov). [Bütün dillər və platformalar](../README.md).
