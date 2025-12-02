import 'package:flutter/material.dart';
import 'artigo_list_page.dart';
import 'operacao_list_page.dart';
import 'roteiro_list_page.dart';
import 'artigo_roteiro_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CADASTRO DE ROTEIRO PRODUTIVO'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueGrey.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.settings, size: 48, color: Colors.blueGrey.shade700),
                  const SizedBox(height: 8),
                  const Text(
                    'Sistema Curtume',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Módulo: Roteiro Produtivo',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu
            Expanded(
              child: ListView(
                children: [
                  _MenuCard(
                    icon: Icons.category,
                    title: 'Cadastro de Artigo',
                    subtitle: 'Cadastro de artigos (tbClassifAnimal)',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ArtigoListPage()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _MenuCard(
                    icon: Icons.build_circle,
                    title: 'Cadastro de Operação',
                    subtitle: 'Cadastro de operações (tbCodOperacao)',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OperacaoListPage()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _MenuCard(
                    icon: Icons.tune,
                    title: 'Cadastro de Roteiro Produtivo',
                    subtitle: 'Configuração de variáveis e químicos por operação',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RoteiroListPage()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _MenuCard(
                    icon: Icons.link,
                    title: 'Cadastro Artigo x Roteiro',
                    subtitle: 'Vincula artigo às operações do roteiro (tbSeqOperacao)',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ArtigoRoteiroListPage()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 28, color: Colors.blueGrey.shade700),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
