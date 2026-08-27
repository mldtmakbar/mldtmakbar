# Profile README — mldtmakbar

Meniru gaya profil rekan (Sushmitadasari): sebuah SVG banner animasi bertema
terminal (panel WORLD.MAP + SYSTEM.INFO, warna hijau), plus animasi "jet"
yang terbang di atas grid kontribusi GitHub asli.

## Isi repo

- `dark.svg` / `light.svg` — banner statis (panel terminal). Diedit manual.
- `generate.mjs` — meng-generate `dist/github-jet.svg` dari kalender
  kontribusi GitHub asli (jet + peluru + flash di hari tersibuk).
- `package.json` — script `npm run generate`.
- `preview-test.mjs` — uji lokal generate.mjs tanpa token (pakai data mock).
- `.github/workflows/jet-heatmap.yml` — Action harian yang regenerate SVG.
- `README.md` — menampilkan ketiganya di profil.

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
