import 'package:flutter/material.dart';
import '../../../modul_06/services/auth_api.dart';
import '../../../modul_06/services/sesi_memori.dart';
import 'storage/penyimpanan_aman_platform.dart';
import 'repositories/sesi_repository.dart';
import 'repositories/memori_sesi_repository.dart';
import 'repositories/prefs_sesi_repository.dart';
import 'repositories/aman_sesi_repository.dart';
import 'controllers/sesi_controller.dart';
import 'widgets/gerbang_sesi.dart';
import 'screens/login_pengayaan_screen.dart';
import 'screens/beranda_pengayaan_screen.dart';

enum OpsiPenyimpanan { memori, prefs, aman }

class Modul06PengayaanApp extends StatefulWidget {
  const Modul06PengayaanApp({super.key});

  @override
  State<Modul06PengayaanApp> createState() => _Modul06PengayaanAppState();
}

class _Modul06PengayaanAppState extends State<Modul06PengayaanApp> {
  late final AuthApi _api = const AuthApi(tunda: Duration(seconds: 10));
  OpsiPenyimpanan _opsi = OpsiPenyimpanan.prefs; // Default diatur ke prefs sesuai gambar

  late final SesiRepository _repoMemori = MemoriSesiRepository(memori: SesiMemori());
  late final SesiRepository _repoPrefs = PrefsSesiRepository();
  late final SesiRepository _repoAman = AmanSesiRepository(penyimpanan: PenyimpananAmanPlatform());

  SesiRepository get _repoAktif {
    switch (_opsi) {
      case OpsiPenyimpanan.memori: return _repoMemori;
      case OpsiPenyimpanan.prefs: return _repoPrefs;
      case OpsiPenyimpanan.aman: return _repoAman;
    }
  }

  late SesiController _controller = SesiController(api: _api, repository: _repoAktif)..pulihkan();

  void _gantiPenyimpanan(OpsiPenyimpanan baru) {
    if (_opsi == baru) return;
    setState(() {
      _opsi = baru;
      _controller = SesiController(api: _api, repository: _repoAktif)..pulihkan();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Widget tombol pilihan yang akan dilempar ke dalam layar
    final widgetPemilih = SegmentedButton<OpsiPenyimpanan>(
      segments: const [
        ButtonSegment(value: OpsiPenyimpanan.memori, icon: Icon(Icons.memory), label: Text('Memori')),
        ButtonSegment(value: OpsiPenyimpanan.prefs, icon: Icon(Icons.folder_open), label: Text('Prefs')),
        ButtonSegment(value: OpsiPenyimpanan.aman, icon: Icon(Icons.security), label: Text('Secure')),
      ],
      selected: {_opsi},
      onSelectionChanged: (set) => _gantiPenyimpanan(set.first),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modul 06 Pengayaan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0284C7)),
        useMaterial3: true,
      ),
      home: GerbangSesi(
        key: ValueKey(_opsi),
        controller: _controller,
        form: (context) => LoginPengayaanScreen(
          controller: _controller,
          selectorWidget: widgetPemilih,
        ),
        beranda: (context, sesi) => BerandaPengayaanScreen(
          controller: _controller,
          sesi: sesi,
          selectorWidget: widgetPemilih,
        ),
      ),
    );
  }
}