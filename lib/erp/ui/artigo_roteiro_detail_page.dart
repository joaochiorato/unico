import 'package:flutter/material.dart';
import '../../core/models.dart';

class ArtigoRoteiroDetailPage extends StatelessWidget {
  final ArtigoRoteiro artigo;

  const ArtigoRoteiroDetailPage({super.key, required this.artigo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roteiro - ${artigo.codProdutoRp}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            Expanded(child: _buildEtapas()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${artigo.codProdutoRp} - ${artigo.descricaoArtigo}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Classificação: ${artigo.codClassif}'),
                  const SizedBox(height: 4),
                  Text('Quantidade de etapas: ${artigo.etapas.length}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEtapas() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: artigo.etapas.length,
          itemBuilder: (context, index) {
            final etapa = artigo.etapas[index];
            return ExpansionTile(
              title: Text(
                '${etapa.seq}ª - ${etapa.descricaoOperacao}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('Operação ${etapa.codOperacao} | Posto: ${etapa.codPosto}'),
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Variáveis de apontamento:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Seq')),
                      DataColumn(label: Text('Descrição')),
                      DataColumn(label: Text('Padrão')),
                      DataColumn(label: Text('Unidade')),
                    ],
                    rows: etapa.variaveis
                        .map(
                          (v) => DataRow(
                            cells: [
                              DataCell(Text(v.seq.toString())),
                              DataCell(Text(v.descricao)),
                              DataCell(Text(v.valorPadrao)),
                              DataCell(Text(v.unidade)),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}
