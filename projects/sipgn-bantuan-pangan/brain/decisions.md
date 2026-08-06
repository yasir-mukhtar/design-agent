# Decisions — SIPGN Bantuan Pangan

## 2026-08-06 — Bootstrap decisions
- **Decision:** Arsitektur offline-first: PWA + antrean lokal, sinkronisasi saat koneksi pulih.
- **Why:** Lokasi terpencil tanpa sinyal adalah kebutuhan eksplisit brief.
- **Confidence:** MED — perlu validasi skala & frekuensi sinkronisasi (open question #2)
- **Alternatives rejected:** Web-only (gagal di lokasi terpencil); native app (biaya & distribusi lebih berat)
- **Dissent logged:** —

## 2026-08-06 — Identitas penerima
- **Decision:** Identitas penerima berbasis NIK, dengan fallback identifier.
- **Why:** Standar identitas kependudukan; mendukung audit & pencocokan lintas sistem.
- **Confidence:** MED — perlu konfirmasi basis data BGN (open question #5)
- **Alternatives rejected:** Kartu identitas khusus BGN
- **Dissent logged:** —
