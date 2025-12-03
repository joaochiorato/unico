import 'package:flutter/material.dart';
import '../core/mock_data_service.dart';
import 'ui/home_page.dart';

class ColetorApp extends StatelessWidget {
  const ColetorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Garante inicialização dos dados mockados
    MockDataService();

    return MaterialApp(
      title: 'Coletor Curtume – Apontamento',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const ColetorHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
