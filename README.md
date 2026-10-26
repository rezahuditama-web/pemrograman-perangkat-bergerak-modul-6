# project_pertama

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Laporan Praktikum Modul 04: Future & REST API Dasar

- *Nama*: Fachreza Huditama
- *NIM*: 362558302102
- *Kelas / Prodi*: 2C / Sarjana Terapan TRPL
- *Mata Kuliah*: Pemrograman Perangkat Bergerak (Semester 3)

---

## 1. Ringkasan Aktivitas
Pada praktikum Fase A (Fundamental) ini, saya telah menyelesaikan implementasi pengambilan data dari server REST API menggunakan `Future`, `FutureBuilder`, dan package `http` murni tanpa tambahan library pihak ketiga. Aktivitas utama yang diselesaikan meliputi:
* Mengirim *request* HTTP GET dengan pembatasan waktu (*timeout*) 10 detik.
* Memetakan respons JSON menjadi model Dart (`Announcement`) menggunakan *factory constructor* `fromJson` yang dilengkapi dengan nilai cadangan (*fallback*).
* Mengelola siklus hidup *state* dengan menyimpan objek `Future` di dalam `initState()` agar UI tidak terus-menerus memuat ulang saat `setState` dipanggil.
* Menutup koneksi jaringan melalui `http.Client.close()` pada blok `dispose()` untuk mencegah kebocoran koneksi.
* Membangun antarmuka yang sanggup menangani dan merender empat keadaan (*states*) secara spesifik.

## 2. Bukti Empat Keadaan UI (Runtime)
Sesuai dengan instruksi modul, berikut adalah bukti implementasi empat keadaan UI yang ditangani oleh `FutureBuilder`:

### A. Keadaan Memuat (Loading)
Ditampilkan selama proses penarikan data dari jaringan sedang berlangsung (`connectionState != ConnectionState.done`).
![Memuat UI](./media/Screenshot%20(93).png)

### B. Keadaan Berhasil (Success)
Ditampilkan saat data berhasil diambil dari *snapshot* dan dirender menjadi *ListView* yang dapat digulir.
![Berhasil UI](./media/Screenshot%20(96).png)

### C. Keadaan Kosong (Empty)
Ditampilkan ketika data berhasil diambil namun hasil penyaringan kategorinya kosong. Pengujian dilakukan dengan mematikan data *dummy* pada kategori tertentu.
![Kosong UI](./media/Screenshot%20(94).png)

### D. Keadaan Gagal (Error)
Ditampilkan saat terjadi kegagalan (*TimeoutException*, *ClientException*, atau status selain 200). Menampilkan pesan error spesifik dan tombol "Coba Lagi".
![Gagal UI](./media/Screenshot%20(95).png)

## 3. Fitur Utama
* **Pull-to-Refresh & Tombol Segarkan:** Menggunakan `RefreshIndicator` dan tombol AppBar untuk mengeksekusi ulang *request* jaringan secara manual.
* **Penyaringan Lokal:** Menyaring pengumuman berdasarkan kategori (*chip filter*) di memori perangkat menggunakan fungsi `where()` tanpa memicu *request* baru ke server.
* **Pesan Error Spesifik:** Menerjemahkan penyebab gagal dari blok `catch` menjadi pesan yang dipahami pengguna (misal: "Koneksi ke server timeout" vs "Gagal terhubung ke server").

## 4. Cara Menjalankan Aplikasi
Aplikasi ini memiliki dua mode eksekusi yang dikontrol melalui *environment variables*:

**Mode Simulasi (Data Lokal Ditunda 1 Detik):**
Berguna untuk menguji transisi *loading* UI tanpa koneksi internet.
```bash
flutter run --dart-define=SIMULASI=true
