import 'package:flutter/material.dart';
import '../../../modul_06/services/auth_api.dart';
import '../../../modul_06/widgets/field_kata_sandi.dart';
import '../controllers/sesi_controller.dart';
import '../widgets/papan_diagnostik_penyimpanan.dart';

class LoginPengayaanScreen extends StatefulWidget {
  final SesiController controller;
  final Widget? selectorWidget;

  const LoginPengayaanScreen({
    super.key,
    required this.controller,
    this.selectorWidget,
  });

  @override
  State<LoginPengayaanScreen> createState() => _LoginPengayaanScreenState();
}

class _LoginPengayaanScreenState extends State<LoginPengayaanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _sandi = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _sandi.dispose();
    super.dispose();
  }

  void _kirim() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.controller.masuk(_email.text, _sandi.text);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final sibuk = widget.controller.status == StatusSesi.memproses;
        final pesan = widget.controller.pesanGagal;

        return Scaffold(
          appBar: AppBar(title: Text('Login Pengayaan (${widget.controller.repository.nama})')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (widget.selectorWidget != null) ...[
                widget.selectorWidget!,
                const SizedBox(height: 24),
              ],
              if (pesan != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(8)),
                  child: Text(pesan, style: const TextStyle(color: Colors.red)),
                ),
                const SizedBox(height: 16),
              ],
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _email,
                      enabled: !sibuk,
                      decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                      validator: (v) => (v == null || !v.contains('@')) ? 'Email tidak valid' : null,
                    ),
                    const SizedBox(height: 16),
                    FieldKataSandi(
                      controller: _sandi,
                      enabled: !sibuk,
                      validator: (v) => (v == null || v.length < 8) ? 'Sandi minimal 8 karakter' : null,
                      onSubmitted: _kirim,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: sibuk ? null : _kirim,
                  child: Text(sibuk ? 'Memproses...' : 'Masuk'),
                ),
              ),
              
              if (sibuk) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: widget.controller.batal,
                  child: const Text('Batal Login'),
                ),
              ],

              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: sibuk ? null : () {
                  _email.text = AuthApi.emailDemo;
                  _sandi.text = AuthApi.sandiDemo;
                },
                child: const Text('Isi Kredensial Demo'),
              ),
              const SizedBox(height: 24),
              PapanDiagnostikPenyimpanan(repository: widget.controller.repository),
            ],
          ),
        );
      },
    );
  }
}