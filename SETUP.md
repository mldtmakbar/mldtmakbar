# Profile README — mldtmakbar

Meniru gaya profil rekan (Sushmitadasari): sebuah SVG banner animasi bertema
terminal (panel WORLD.MAP + SYSTEM.INFO, warna hijau), plus animasi "jet"
yang terbang di atas grid kontribusi GitHub asli.

## Isi repo

- `dark.svg` / `light.svg` — banner statis (panel terminal). Diedit manual.
- `generate.mjs` — meng-generate `dist/github-jet.svg` dari kalender
  kontribusi GitHub asli (jet + peluru + flash di hari tersibuk).
- `gen-headers.mjs` — meng-generate chip judul terminal (`$ command ...`)
  ke folder `assets/` untuk tiap section di `README.md`.
- `package.json` — script `npm run generate` dan `npm run headers`.
- `preview-test.mjs` — uji lokal generate.mjs tanpa token (pakai data mock).
- `.github/workflows/jet-heatmap.yml` — Action harian yang regenerate SVG jet.
- `.github/workflows/snake.yml` — Action yang men-generate animasi snake
  kontribusi (`Platane/snk`) ke branch `output`.
- `README.md` — menampilkan semuanya di profil (banner, telemetry, snake,
  tech stack, Spotify, kontak).

## Cara pakai (satu kali)

1. Buat / buka repo spesial `github.com/mldtmakbar/mldtmakbar` (nama repo
   HARUS sama dengan username). README repo itulah yang tampil di profil.
2. Salin SEMUA file ini ke repo tersebut:
   - `README.md`, `dark.svg`, `light.svg`
   - `generate.mjs`, `package.json`, `preview-test.mjs`
   - `.github/workflows/jet-heatmap.yml`
3. Di repo: `Settings -> Actions -> General -> Workflow permissions` ->
   pilih **Read and write permissions**.
4. Tab `Actions` -> "Update jet heatmap SVG" -> **Run workflow**. Ini membuat
   `dist/github-jet.svg` dan otomatis commit. Action jalan lagi tiap hari.

Tidak perlu secret tambahan untuk kontribusi publik — workflow memakai
`GITHUB_TOKEN` bawaan.

## Uji lokal

```bash
node preview-test.mjs                       # pakai data mock -> dist/preview.svg
# atau data asli:
$env:GH_USERNAME="mldtmakbar"; $env:GH_TOKEN="<token>"; node generate.mjs
```

## Kustomisasi

- Teks panel SYSTEM.INFO dan peta ada di `dark.svg` (dan `light.svg`).
- Warna aksen / durasi jet: konstanta di atas `generate.mjs`
  (`FLASH_COLOR`, `BULLET_COLOR`, `LOOP_DUR`, `MAX_TARGETS`, dll).
- Chip judul section: daftar `HEADERS` di `gen-headers.mjs`. Setelah
  diubah, jalankan `node gen-headers.mjs` lalu commit folder `assets/`.

## Contribution snake

Animasi ular yang "memakan" grid kontribusi dibuat oleh Action
`.github/workflows/snake.yml` (memakai `Platane/snk`).

1. Pastikan `Settings -> Actions -> General -> Workflow permissions`
   memakai **Read and write permissions**.
2. Tab `Actions` -> "Generate Snake" -> **Run workflow**. Ini men-generate
   `github-snake-dark.svg` + `github-snake.svg` dan push ke branch `output`.
3. `README.md` sudah menunjuk ke branch `output` tersebut, jadi tidak perlu
   diubah lagi. Action akan jalan otomatis tiap 12 jam.

## Tech stack icons

Ikon memakai <https://skillicons.dev> (query `?i=...`). Untuk menamb/mengurangi,
edit daftar setelah `i=` pada URL section TECH STACK di `README.md`.
