import '../../../modul_06/models/sesi_pengguna.dart';

abstract class SesiRepository {
  String get nama;
  String get keterangan;
  bool get bertahanSetelahRestart;

  Future<SesiPengguna?> baca();
  Future<void> simpan(SesiPengguna sesi);
  Future<void> hapus();
  Future<bool> adaSesi();
  Future<String?> intipMentah();
}