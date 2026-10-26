import 'dart:async';
import 'package:flutter/material.dart';

import '../models/sesi_pengguna.dart';

class KartuSesi extends StatefulWidget {
  final SesiPengguna sesi;
  final DateTime sekarang;
  final VoidCallback? onKeluar;
  final bool sedangKeluar;
  final bool tampilkanToken;

  const KartuSesi({
    super.key,
    required this.sesi,
    required this.sekarang,
    this.onKeluar,
    this.sedangKeluar = false,
    this.tampilkanToken = false,
  });

  static String samarkanToken(String token) {
    if (token.isEmpty) return '(kosong)';

    if (token.length <= 6) {
      return _titik(token.length);
    }

    return '${token.substring(0, 6)}${_titik(12)}';
  }

  static String _titik(int jumlah) =>
      List<String>.filled(jumlah, '\u2022').join();

  static String formatWaktu(String iso) {
    const List<String> bulan = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];

    final DateTime? waktu = DateTime.tryParse(iso);

    if (waktu == null) return 'tidak diketahui';

    final String jam =
        waktu.hour.toString().padLeft(2, '0');
    final String menit =
        waktu.minute.toString().padLeft(2, '0');

    return '${waktu.day} ${bulan[waktu.month - 1]} '
        '${waktu.year}, $jam:$menit';
  }

  static String formatSisa(Duration sisa) {
    if (sisa.inSeconds <= 0) return 'sudah berakhir';

    if (sisa.inMinutes < 1) {
      return '${sisa.inSeconds} detik';
    }

    if (sisa.inHours < 1) {
      return '${sisa.inMinutes} menit ${sisa.inSeconds % 60} detik';
    }

    final int menit = sisa.inMinutes.remainder(60);

    return menit == 0
        ? '${sisa.inHours} jam'
        : '${sisa.inHours} jam $menit menit';
  }

  @override
  State<KartuSesi> createState() => _KartuSesiState();
}

class _KartuSesiState extends State<KartuSesi> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Memperbarui UI setiap detik
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Wajib dibatalkan agar tidak memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan waktu saat ini agar hitung mundur berjalan
    final Duration sisa = widget.sesi.sisaWaktu(DateTime.now());
    final bool hampirHabis = sisa.inMinutes < 5 && sisa.inSeconds > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Informasi Sesi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _baris('Nama', widget.sesi.nama),
            _baris('Email', widget.sesi.email),
            _baris(
              'Peran',
              SesiPengguna.labelPeran(widget.sesi.peran),
            ),
            _baris(
              'Waktu masuk',
              KartuSesi.formatWaktu(widget.sesi.masukPada),
            ),
            _baris(
              'Sisa masa berlaku',
              KartuSesi.formatSisa(sisa),
              warnaTeks: hampirHabis ? Colors.red : null,
            ),
            _baris(
              'Token',
              widget.tampilkanToken
                  ? widget.sesi.token
                  : KartuSesi.samarkanToken(widget.sesi.token),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: widget.sedangKeluar ? null : widget.onKeluar,
                icon: widget.sedangKeluar
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.logout_rounded),
                label: Text(
                  widget.sedangKeluar ? 'Keluar...' : 'Keluar',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _baris(String label, String nilai, {Color? warnaTeks}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            nilai,
            style: warnaTeks != null
                ? TextStyle(color: warnaTeks, fontWeight: FontWeight.bold)
                : null,
          ),
        ],
      ),
    );
  }
}