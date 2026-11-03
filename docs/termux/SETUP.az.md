# Termux Nova — Android Termux quraşdırması

[← Əsas README və demo](../../README.md) · [Windows CMD təlimatı](../cmd/SETUP.az.md)

## 1. Quraşdırma — bir dəfə kopyala-yapışdır

**Aşağıdakı bütün bloku bir dəfə kopyalayıb Termux-a yapışdır.** Repo endiriləcək, quraşdırılacaq və sonunda ekran `clear` ilə təmizlənəcək.

```bash
pkg update -y && pkg install -y git && \
cd "$HOME" && \
git clone https://github.com/RuslanSharifov/termux-nova.git && \
cd termux-nova && \
bash install.sh && \
source "$HOME/.bashrc" && \
clear
```

Quraşdırma zamanı başqa UI/prompt alətlərini söndürmək və temanı hər açılışda avtomatik bərpa etmək barədə suallar görünə bilər. Seçimləri oxuyub cavablandır; avtomatik bərpa sualında **Enter = bəli**. Sonrakı Termux sessiyalarında Nova avtomatik aktiv olacaq.

> Əgər `~/termux-nova` artıq mövcuddursa, `git clone` dayanacaq. Bu halda aşağıdakı **Yeniləmə** bölməsindən istifadə et.

## 2. Nova-dan necə istifadə edilir?

Termux-u yenidən aç və ya quraşdırmadan sonra aşağıdakı əmrləri ayrıca işlət. İlk öncə `nova console` ayarlar menyusunu açır.

```bash
nova console
nova list
nova current
nova doctor
```

## 3. Temalar və açılış

Daxili temalar: `nova-dark`, `dracula`, `nord`, `gruvbox`. `nova auto on` seçilmiş temanı yeni sessiyada bərpa edir. Başlanğıc banneri və `clear` sonrası banner üçün `nova console` menyusundan istifadə et.

```bash
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

### Böyük NOVA yazısını dəyiş

`nova console` menyusunda **9) Change banner text** seç. İstədiyin yazını daxil et və Enter bas. Böyük/kiçik hərflər, rəqəmlər, bütün əsas ASCII simvolları və bir sıra Azərbaycan/Unicode hərfləri bloklarla göstərilir. Dəstəklənməyən işarələr `?` olur. Maksimum 64 simvol; uzun mətn sətirlərə bölünür. Boş Enter əvvəlki NOVA yazısını qaytarır.

```bash
nova banner set "RUSLAN 2026!"
nova banner
nova banner reset
```

## 4. Xüsusi komandalar — əlavə et, bax, dəyiş, sil

`///` ardıcıl addımları ayırır. Əvvəlki addım uğurlu olarsa, sonrakı işləyir. Aşağıdakı nümunə Git istifadə edir (quraşdırma zamanı Git qurulur).

```bash
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
```

Komandanı dəyişdikdən sonra yeni Termux sessiyası aç və ya `source ~/.bashrc` yaz. Öz komandalarına şifrə və token əlavə etmə.

## 5. Yeniləmə — mövcud quraşdırma

Repo artıq klonlanıbsa, onu yenidən klonlama. Bu bir bloku işlət. Quraşdırıcı sualları təkrar verə bilər.

```bash
cd ~/termux-nova && git pull --ff-only && bash install.sh && source ~/.bashrc && clear
```

## 6. Problemlərin həlli

1. **`nova: command not found`** — Termux-u yenidən aç; lazım olsa `cd ~/termux-nova && bash install.sh` işlə.
2. **Rənglər dəyişmədi** — `pkg install -y termux-tools`, sonra `nova set dracula` işlə.
3. **Tema sıfırlanır** — `nova current` yoxla və `nova auto on` yaz.
4. **Xüsusi komanda işləmir** — `nova cmd` ilə siyahını yoxla və `source ~/.bashrc` işlə.
5. **Başqa prompt dəyişdi** — quraşdırıcının `.nova-backup-*` nüsxələrini yoxla. `nova restore` bütün `~/.bashrc`-ni son ehtiyat nüsxəsi ilə əvəz edir; sonrakı dəyişikliklərin itə bilər.

## 7. Silmə və təhlükəsizlik

Nova-nın avtomatik aktivləşməsini söndürmək və quraşdırma hook-larını silmək üçün bu blokdan istifadə et. Bu addımlar mövcud terminal rənglərini avtomatik əvvəlki hala qaytarmır.

```bash
nova auto off
[ -f "$HOME/.bashrc" ] && sed -i '/# termux-nova$/d' "$HOME/.bashrc"
[ -f "$HOME/.bash_profile" ] && sed -i '/# termux-nova$/d' "$HOME/.bash_profile"
rm -f "$PREFIX/bin/nova"
```

**İstəyə bağlı — şəxsi ayar və xüsusi komandaları həmişəlik silmək:** yalnız ehtiyat nüsxəsini saxladıqdan sonra `rm -rf ~/.config/termux-nova ~/.cache/termux-nova` işlət.

**Qeyd:** Bu versiya Bash əsaslı tema/komanda meneceridir. Hazırkı kodda SQLite komanda sayı, boz autosuggestion və Tab ilə qəbul funksiyası yoxdur. Android-in yerli düymələri və menyuları da dəyişdirilmir.

---

Hazırladı: **rugo · Ruslan Sharifov**. · [GitHub](https://github.com/RuslanSharifov/termux-nova)
