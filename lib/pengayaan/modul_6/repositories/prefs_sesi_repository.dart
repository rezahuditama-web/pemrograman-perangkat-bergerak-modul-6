import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../modul_06/models/sesi_pengguna.dart';
import 'sesi_repository.dart';

class PrefsSesiRepository implements SesiRepository {
  static const String kunciSesi = 'modul_06_sesi_prefs';

  @override
  String get nama => 'SharedPreferences';
  @override
  String get keterangan => 'Bertahan, tetapi tidak aman (teks mentah)';
  @override
  bool get bertahanSetelahRestart => true;

  @override
  Future<SesiPengguna?> baca() async {
    final prefs = await SharedPreferences.getInstance();
    final mentah = prefs.getString(kunciSesi);
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
    final prefs = await SharedPreferences.getInstance();
    final mentah = jsonEncode(sesi.toJson());
    await prefs.setString(kunciSesi, mentah);
  }

  @override
  Future<void> hapus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kunciSesi);
  }

  @override
  Future<bool> adaSesi() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(kunciSesi);
  }

  @override
  Future<String?> intipMentah() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kunciSesi);
  }
}