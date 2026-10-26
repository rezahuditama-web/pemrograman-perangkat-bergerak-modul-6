import 'dart:convert';
import '../../../modul_06/models/sesi_pengguna.dart';
import '../storage/penyimpanan_aman.dart';
import 'sesi_repository.dart';

class AmanSesiRepository implements SesiRepository {
  static const String kunciSesi = 'modul_06_sesi_aman';
  final PenyimpananAman penyimpanan;

  AmanSesiRepository({required this.penyimpanan});

  @override
  String get nama => 'Secure Storage';
  @override
  String get keterangan => 'Bertahan & dienkripsi platform (Keychain/Keystore)';
  @override
  bool get bertahanSetelahRestart => true;

  @override
  Future<SesiPengguna?> baca() async {
    final mentah = await penyimpanan.baca(kunciSesi);
    if (mentah == null) return null;
    try {
      final map = jsonDecode(mentah) as Map<String, dynamic>;
      return SesiPengguna.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> simpan(SesiPengguna sesi) async {
    final mentah = jsonEncode(sesi.toJson());
    await penyimpanan.tulis(kunciSesi, mentah);
  }

  @override
  Future<void> hapus() async {
    await penyimpanan.hapus(kunciSesi);
  }

  @override
  Future<bool> adaSesi() async {
    final mentah = await penyimpanan.baca(kunciSesi);
    return mentah != null;
  }

  @override
  Future<String?> intipMentah() async {
    return await penyimpanan.bacaMentah(kunciSesi);
  }
}