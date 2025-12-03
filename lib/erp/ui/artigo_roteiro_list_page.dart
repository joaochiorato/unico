import 'package:flutter/material.dart';
import '../../core/mock_data_service.dart';
import '../../core/models.dart';
import 'artigo_roteiro_detail_page.dart';

class ArtigoRoteiroListPage extends StatelessWidget {
  ArtigoRoteiroListPage({super.key});

  final _service = MockDataService();

  @override
  Widget build(BuildContext context) {
    final List<ArtigoRoteiro> artigos = _service.getArtigos();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Artigo x Roteiro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vínculos de Artigo x Roteiro Produtivo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Artigo')),
                      DataColumn(label: Text('Classifi')),
                      DataColumn(label: Text('Descrição')),
                      DataColumn(label: Text('Qtde Etapas')),
                    ],
                    rows: artigos
                        .map(
                          (a) => DataRow(
                            cells: [
                              DataCell(Text(a.codProdutoRp)),
                              DataCell(Text(a.codClassif.toString())),
                              DataCell(Text(a.descricaoArtigo)),
                              DataCell(Text(a.etapas.length.toString())),
                            ],
                            onSelectChanged: (selected) {
                              if (selected == true) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ArtigoRoteiroDetailPage(artigo: a),
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
}
