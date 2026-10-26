import 'package:flutter/foundation.dart';
import '../../../modul_06/models/sesi_pengguna.dart';
import '../../../modul_06/services/auth_api.dart';
import '../repositories/sesi_repository.dart';

enum StatusSesi { memeriksa, keluar, memproses, masuk, gagal, kedaluwarsa }

class SesiController extends ChangeNotifier {
  final AuthApi api;
  final SesiRepository repository;
  final DateTime Function() jam;

  StatusSesi _status = StatusSesi.memeriksa;
  SesiPengguna? _sesi;
  String? _pesanGagal;
  bool _dibatalkan = false;

  SesiController({
    required this.api,
    required this.repository,
    this.jam = DateTime.now,
  });

  StatusSesi get status => _status;
  SesiPengguna? get sesi => _sesi;
  String? get pesanGagal => _pesanGagal;

  void _ubah(StatusSesi statusBaru, {SesiPengguna? sesi, String? pesan, bool bersihkanPesan = false}) {
    _status = statusBaru;
    if (sesi != null || statusBaru == StatusSesi.keluar) _sesi = sesi;
    if (bersihkanPesan) _pesanGagal = null;
    if (pesan != null) _pesanGagal = pesan;
    notifyListeners();
  }

  Future<void> pulihkan() async {
    _ubah(StatusSesi.memeriksa, bersihkanPesan: true);
    final tersimpan = await repository.baca();

    if (tersimpan == null) {
      _ubah(StatusSesi.keluar, sesi: null);
      return;
    }

    if (tersimpan.sudahKedaluwarsa(jam())) {
      await repository.hapus();
      _ubah(StatusSesi.kedaluwarsa, sesi: null, pesan: 'Sesi Anda telah berakhir. Silakan login lagi.');
      return;
    }

    _ubah(StatusSesi.masuk, sesi: tersimpan);
  }

  void batal() {
    if (_status == StatusSesi.memproses) {
      _dibatalkan = true;
      _ubah(StatusSesi.keluar, bersihkanPesan: true, pesan: 'Proses login dibatalkan pengguna.');
    }
  }

  Future<bool> masuk(String email, String sandi) async {
    if (_status == StatusSesi.memproses) return false;
    _ubah(StatusSesi.memproses, bersihkanPesan: true);
    _dibatalkan = false;

    try {
      final hasil = await api.masuk(email: email, sandi: sandi);
      
      // Abaikan hasil jika pengguna menekan tombol batal selama proses await
      if (_dibatalkan) return false;

      await repository.simpan(hasil);
      _ubah(StatusSesi.masuk, sesi: hasil);
      return true;
    } on AuthException catch (e) {
      if (_dibatalkan) return false;
      _ubah(StatusSesi.gagal, pesan: e.pesan);
      return false;
    } catch (_) {
      if (_dibatalkan) return false;
      _ubah(StatusSesi.gagal, pesan: 'Terjadi kesalahan sistem.');
      return false;
    }
  }

  Future<void> keluar() async {
    await repository.hapus();
    _ubah(StatusSesi.keluar, sesi: null, bersihkanPesan: true);
  }

  Future<void> perbaruiSesi({Duration masaBerlaku = const Duration(hours: 2)}) async {
    final sekarang = _sesi;
    if (sekarang == null) return;

    if (sekarang.sudahKedaluwarsa(jam())) {
      await repository.hapus();
      _ubah(StatusSesi.kedaluwarsa, sesi: null, pesan: 'Sesi sudah berakhir dan tidak dapat diperbarui.');
      return;
    }

    final baru = await api.perbaruiSesi(sekarang, masaBerlaku: masaBerlaku);
    await repository.simpan(baru);
    _ubah(StatusSesi.masuk, sesi: baru);
  }
}