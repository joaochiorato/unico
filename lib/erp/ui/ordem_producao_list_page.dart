import 'package:flutter/material.dart';
import '../../core/mock_data_service.dart';
import '../../core/models.dart';
import 'ordem_producao_detail_page.dart';

class OrdemProducaoListPage extends StatelessWidget {
  OrdemProducaoListPage({super.key});

  final _service = MockDataService();

  @override
  Widget build(BuildContext context) {
    final List<OrdemProducao> ordens = _service.getOrdens();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordens de Produção (Semi-Acabado)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildToolbar(context),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Filial')),
                      DataColumn(label: Text('Docto.')),
                      DataColumn(label: Text('Série')),
                      DataColumn(label: Text('Número')),
                      DataColumn(label: Text('Dt. movto.')),
                      DataColumn(label: Text('Dt. prod.')),
                      DataColumn(label: Text('Linha de produção')),
                      DataColumn(label: Text('Nome')),
                    ],
                    rows: ordens
                        .map(
                          (o) => DataRow(
                            cells: [
                              DataCell(Text(o.filial)),
                              DataCell(Text(o.documento)),
                              DataCell(Text(o.serie)),
                              DataCell(Text(o.numero.toString())),
                              DataCell(
                                  Text(DateFormats.formatDate(o.dataMovimento))),
                              DataCell(
                                  Text(DateFormats.formatDate(o.dataProducao))),
                              DataCell(Text(o.linhaProducao)),
                              DataCell(Text(o.descricaoProduto)),
                            ],
                            onSelectChanged: (selected) {
                              if (selected == true) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OrdemProducaoDetailPage(ordem: o),
                                  ),
                                );
                              }
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Lista de Ordens de Produção',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        FilledButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ação "Novo" mockada apenas para layout.'),
              ),
            );
          },
          child: const Text('Novo'),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ação "PDF" mockada.')),
            );
          },
          child: const Text('PDF'),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ação "HTML" mockada.')),
            );
          },
          child: const Text('HTML'),
        ),
      ],
    );
  }
}
