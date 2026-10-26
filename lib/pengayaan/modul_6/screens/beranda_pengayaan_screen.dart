import 'package:flutter/material.dart';
import '../../../modul_06/models/sesi_pengguna.dart';
import '../../../modul_06/widgets/kartu_sesi.dart';
import '../controllers/sesi_controller.dart';
import '../widgets/papan_diagnostik_penyimpanan.dart';
import 'profil_screen.dart';

class BerandaPengayaanScreen extends StatelessWidget {
  final SesiController controller;
  final SesiPengguna sesi;
  final Widget? selectorWidget;

  const BerandaPengayaanScreen({
    super.key,
    required this.controller,
    required this.sesi,
    this.selectorWidget,
  });

  void _bukaProfil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilScreen(
          sesi: sesi,
          onKeluar: () => controller.keluar(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Sesi Persisten'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Lihat Profil',
            onPressed: () => _bukaProfil(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Perbarui Sesi',
            onPressed: () => controller.perbaruiSesi(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (selectorWidget != null) ...[
            selectorWidget!,
            const SizedBox(height: 24),
          ],
          KartuSesi(
            sesi: sesi,
            sekarang: controller.jam(),
            onKeluar: () => controller.keluar(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _bukaProfil(context),
              icon: const Icon(Icons.account_circle),
              label: const Text('Buka Layar Profil'),
            ),
          ),
          const SizedBox(height: 16),
          PapanDiagnostikPenyimpanan(repository: controller.repository),
        ],
      ),
    );
  }
}