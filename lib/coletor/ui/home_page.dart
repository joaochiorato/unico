import 'package:flutter/material.dart';
import '../../core/mock_data_service.dart';
import '../../core/models.dart';
import 'etapas_list_page.dart';
import 'apontamento_historico_page.dart';

class ColetorHomePage extends StatefulWidget {
  const ColetorHomePage({super.key});

  @override
  State<ColetorHomePage> createState() => _ColetorHomePageState();
}

class _ColetorHomePageState extends State<ColetorHomePage> {
  final TextEditingController _ordemController =
      TextEditingController(text: 'XYD459939');
  final _service = MockDataService();

  @override
  void dispose() {
    _ordemController.dispose();
    super.dispose();
  }

  void _carregarOrdem() {
    final id = _ordemController.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe a chave da Ordem de Produção.')),
      );
      return;
    }

    final OrdemProducao? ordem = _service.getOrdemById(id);
    if (ordem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ORP $id não encontrada (mock).')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EtapasListPage(ordem: ordem),
      ),
    );
  }

  void _abrirHistorico() {
    final id = _ordemController.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Informe a chave da ORP para ver o histórico.')),
      );
      return;
    }

    final ordem = _service.getOrdemById(id);
    if (ordem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ORP $id não encontrada (mock).')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ApontamentoHistoricoPage(ordem: ordem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coletor Curtume – Apontamento'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Selecionar Ordem de Produção',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _ordemController,
                    decoration: const InputDecoration(
                      labelText: 'Chave da ORP (chave_fato)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: _carregarOrdem,
                          child: const Text('Carregar ORP'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _abrirHistorico,
                          child: const Text('Histórico de Apontamentos'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
