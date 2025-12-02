import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'artigo_form_page.dart';

// Lista editável de artigos
final List<Artigo> artigosEditaveis = List.from(artigosMock);

class ArtigoListPage extends StatefulWidget {
  const ArtigoListPage({super.key});

  @override
  State<ArtigoListPage> createState() => _ArtigoListPageState();
}

class _ArtigoListPageState extends State<ArtigoListPage> {
  void _abrirForm({Artigo? artigo, int? index}) async {
    final resultado = await Navigator.push<Artigo>(
      context,
      MaterialPageRoute(builder: (_) => ArtigoFormPage(artigo: artigo)),
    );

    if (resultado != null) {
      setState(() {
        if (index != null) {
          artigosEditaveis[index] = resultado;
        } else {
          artigosEditaveis.add(resultado);
        }
      });
    }
  }

  void _remover(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Remover artigo "${artigosEditaveis[index].nomeArtigo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              setState(() => artigosEditaveis.removeAt(index));
              Navigator.pop(ctx);
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CADASTRO DE ARTIGO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _abrirForm(),
            tooltip: 'Novo Artigo',
          ),
        ],
      ),
      body: artigosEditaveis.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('Nenhum artigo cadastrado'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _abrirForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Novo Artigo'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Cod. Classif')),
                    DataColumn(label: Text('Cod. Produto RP')),
                    DataColumn(label: Text('Cod. Ref')),
                    DataColumn(label: Text('Artigo')),
                    DataColumn(label: Text('Ações')),
                  ],
                  rows: artigosEditaveis.asMap().entries.map((entry) {
                    final i = entry.key;
                    final a = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text(a.codClassif.toString())),
                        DataCell(Text(a.codProdutoRP)),
                        DataCell(Text(a.codRefRP.toString())),
                        DataCell(Text(a.nomeArtigo)),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _abrirForm(artigo: a, index: i),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              onPressed: () => _remover(i),
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
      floatingActionButton: artigosEditaveis.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _abrirForm(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
