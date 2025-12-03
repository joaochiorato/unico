import 'package:flutter/material.dart';
import '../../core/models.dart';
import '../data/apontamento_store.dart';

class ApontamentoHistoricoPage extends StatelessWidget {
  final OrdemProducao ordem;

  const ApontamentoHistoricoPage({super.key, required this.ordem});

  @override
  Widget build(BuildContext context) {
    final store = ApontamentoStore.instance;
    final lista = store.getByOrdem(ordem.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico – ORP ${ordem.id}'),
      ),
      body: lista.isEmpty
          ? const Center(
              child: Text('Nenhum apontamento registrado para esta ORP.'),
            )
          : ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final a = lista[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.assignment_turned_in),
                    title: Text(
                        '${a.seqEtapa}ª – ${a.descricaoEtapa}'),
                    subtitle: Text(a.textoConsolidado),
                    trailing: Text(
                      '${a.dataHora.hour.toString().padLeft(2, '0')}:${a.dataHora.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
