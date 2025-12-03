import 'package:flutter/material.dart';
import '../core/mock_data_service.dart';
import 'ui/ordem_producao_list_page.dart';
import 'ui/artigo_roteiro_list_page.dart';

class CurtumeErpApp extends StatelessWidget {
  const CurtumeErpApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializa mocks em memória (roteiro + ORP CSA001)
    MockDataService();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Protótipo ERP Curtume',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
      ),
      home: const ErpHomeMenuPage(),
    );
  }
}

/// Tela inicial no padrão dos protótipos antigos (cards de menu)
class ErpHomeMenuPage extends StatelessWidget {
  const ErpHomeMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Curtume - ERP ATAK'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ErpMenuButton(
                icon: Icons.list_alt,
                title: 'Ordens de Produção (Semi-Acabado)',
                subtitle: 'Emissão, consulta e edição da ORP CSA001 + Classifi',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrdemProducaoListPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _ErpMenuButton(
                icon: Icons.settings_input_component,
                title: 'Cadastro de Roteiro Produtivo',
                subtitle:
                    'Configuração das etapas, parâmetros e variáveis do roteiro',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ArtigoRoteiroListPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErpMenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ErpMenuButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
