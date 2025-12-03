import 'package:flutter/material.dart';
import '../../core/models.dart';
import '../data/apontamento_store.dart';
import 'apontamento_form_page.dart';
import 'apontamento_historico_page.dart';

class EtapasListPage extends StatelessWidget {
  final OrdemProducao ordem;

  const EtapasListPage({super.key, required this.ordem});

  @override
  Widget build(BuildContext context) {
    final etapas = ordem.roteiro.etapas;
    final store = ApontamentoStore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('ORP ${ordem.id} – Etapas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Histórico de Apontamentos',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ApontamentoHistoricoPage(ordem: ordem),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: etapas.length,
        itemBuilder: (context, index) {
          final etapa = etapas[index];
          final apontamentos =
              store.getByOrdemEtapa(ordem.id, etapa.seq);
          final concluido = apontamentos.isNotEmpty;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(
                concluido ? Icons.check_circle : Icons.radio_button_unchecked,
              ),
              title: Text(
                '${etapa.seq}ª – ${etapa.descricaoOperacao}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Operação ${etapa.codOperacao} | Posto: ${etapa.codPosto} | Parâmetros: ${etapa.variaveis.length}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ApontamentoFormPage(ordem: ordem, etapa: etapa),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
