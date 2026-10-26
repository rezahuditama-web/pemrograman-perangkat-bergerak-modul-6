import 'package:flutter/material.dart';
import '../../../modul_06/models/sesi_pengguna.dart';
import '../../../modul_06/widgets/kartu_sesi.dart';

class ProfilScreen extends StatelessWidget {
  final SesiPengguna sesi;
  final VoidCallback onKeluar;

  const ProfilScreen({
    super.key,
    required this.sesi,
    required this.onKeluar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              sesi.nama.isNotEmpty ? sesi.nama[0].toUpperCase() : 'P',
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            sesi.nama,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sesi.email,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: const Text('Peran Akun'),
                    subtitle: Text(SesiPengguna.labelPeran(sesi.peran)),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.login_outlined),
                    title: const Text('Waktu Masuk'),
                    subtitle: Text(KartuSesi.formatWaktu(sesi.masukPada)),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.key_outlined),
                    title: const Text('Token Sesi'),
                    subtitle: Text(
                      KartuSesi.samarkanToken(sesi.token),
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onKeluar();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Keluar dari Akun'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}