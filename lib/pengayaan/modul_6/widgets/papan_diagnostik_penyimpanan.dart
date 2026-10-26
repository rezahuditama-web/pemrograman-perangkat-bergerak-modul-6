import 'package:flutter/material.dart';
import '../repositories/sesi_repository.dart';

class PapanDiagnostikPenyimpanan extends StatefulWidget {
  final SesiRepository repository;

  const PapanDiagnostikPenyimpanan({super.key, required this.repository});

  @override
  State<PapanDiagnostikPenyimpanan> createState() =>
      _PapanDiagnostikPenyimpananState();
}

class _PapanDiagnostikPenyimpananState
    extends State<PapanDiagnostikPenyimpanan> {
  String? _hasilIntip;
  bool _sudahIntip = false;
  bool _sedangProses = false;

  Future<void> _intip() async {
    setState(() {
      _sedangProses = true;
    });

    try {
      final hasil = await widget.repository.intipMentah();
      if (!mounted) return;
      setState(() {
        _hasilIntip = hasil;
        _sudahIntip = true;
        _sedangProses = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasilIntip = 'Gagal membaca penyimpanan: $e';
        _sudahIntip = true;
        _sedangProses = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Papan Diagnostik: ${widget.repository.nama}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.repository.keterangan,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _sedangProses ? null : _intip,
              icon: _sedangProses
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(
                _sedangProses ? 'Mengintip...' : 'Intip Isi Penyimpanan Mentah',
              ),
            ),
            if (_sudahIntip) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _hasilIntip ?? '(Null / Dipertahankan Aman oleh Platform)',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}