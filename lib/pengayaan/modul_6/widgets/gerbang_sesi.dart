import 'package:flutter/material.dart';
import '../../../modul_06/models/sesi_pengguna.dart';
import '../controllers/sesi_controller.dart';

class GerbangSesi extends StatelessWidget {
  final SesiController controller;
  final WidgetBuilder form;
  final Widget Function(BuildContext, SesiPengguna) beranda;

  const GerbangSesi({
    super.key,
    required this.controller,
    required this.form,
    required this.beranda,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        switch (controller.status) {
          case StatusSesi.memeriksa:
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Memulihkan sesi tersimpan...'),
                  ],
                ),
              ),
            );
          case StatusSesi.masuk:
            if (controller.sesi != null) {
              return beranda(context, controller.sesi!);
            }
            return form(context);
          case StatusSesi.keluar:
          case StatusSesi.memproses:
          case StatusSesi.gagal:
          case StatusSesi.kedaluwarsa:
            return form(context);
        }
      },
    );
  }
}