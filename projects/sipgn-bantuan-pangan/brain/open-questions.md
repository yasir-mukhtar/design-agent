# Open Questions — SIPGN Bantuan Pangan

Assumptions banked at bootstrap (6 Aug 2026). Graduate answered ones to decisions.md.

| # | Question | Assumption (if any) | Confidence | De-risk plan |
|---|---|---|---|---|
| 1 | Kanal warga untuk cek status? | Web portal + lookup NIK | MED | Validasi cepat dengan tim program; bandingkan WhatsApp/SMS untuk daerah tanpa internet |
| 2 | Skala penyaluran per lokasi & frekuensi sinkronisasi? | Ratusan penerima/lokasi; sync harian | MED | Pilot 1 kecamatan; ukur antrean sync |
| 3 | Konflik data saat offline (2 petugas, 1 penerima)? | Last-write-wins + log | LOW | Rancang conflict resolution sebelum build |
| 4 | Regulasi/SOP BGN yang mengikat? | UU PDP + SOP distribusi BGN | MED | Minta SOP dari tim program; jalankan audit legal |
| 5 | Integrasi sistem BGN existing (basis data penerima)? | Belum ada integrasi; entri manual | LOW | Inventaris sistem BGN; tentukan sumber data penerima |
| 6 | Infrastruktur: Supabase cukup? | Ya — RLS untuk peran & audit | MED | Prototipe policy RLS lebih dulu |
| 7 | Definisi "audit" — apa yang harus terekam? | Append-only log: siapa, apa, kapan, di mana, perangkat | HIGH | Konfirmasi kebutuhan auditor |
| 8 | Perangkat petugas lapangan? | Android (BYOD/unit) | LOW | Cek pengadaan perangkat BGN |

## Answered
- (none yet)
