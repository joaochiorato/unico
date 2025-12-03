import 'package:flutter/material.dart';
import '../../core/models.dart';
import '../data/apontamento_store.dart';

class ApontamentoFormPage extends StatefulWidget {
  final OrdemProducao ordem;
  final EtapaRoteiro etapa;

  const ApontamentoFormPage({
    super.key,
    required this.ordem,
    required this.etapa,
  });

  @override
  State<ApontamentoFormPage> createState() => _ApontamentoFormPageState();
}

class _ApontamentoFormPageState extends State<ApontamentoFormPage> {
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.etapa.variaveis
        .map((v) => TextEditingController(text: v.valorPadrao))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _salvar() {
    final variaveis = widget.etapa.variaveis;
    final map = <VariavelApontamento, String>{};

    for (int i = 0; i < variaveis.length; i++) {
      map[variaveis[i]] = _controllers[i].text.trim();
    }

    ApontamentoStore.instance.registrarApontamento(
      ordem: widget.ordem,
      etapa: widget.etapa,
      valores: map,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apontamento registrado em memória.')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final etapa = widget.etapa;

    return Scaffold(
      appBar: AppBar(
        title: Text('Apontar – ${etapa.seq}ª ${etapa.descricaoOperacao}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: etapa.variaveis.length,
                itemBuilder: (context, index) {
                  final v = etapa.variaveis[index];
                  final c = _controllers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TextField(
                      controller: c,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText:
                            '${v.seq}. ${v.descricao} (${v.unidade.isEmpty ? '-' : v.unidade})',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _salvar,
                    child: const Text('Salvar Apontamento'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ORP ${widget.ordem.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Etapa ${widget.etapa.seq} – ${widget.etapa.descricaoOperacao}',
            ),
          ],
        ),
      ),
    );
  }
}
