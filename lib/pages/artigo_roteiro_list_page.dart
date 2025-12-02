import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'artigo_list_page.dart';
import 'roteiro_list_page.dart';
import 'artigo_roteiro_form_page.dart';

// Classe para o vínculo Artigo x Roteiro
class ArtigoRoteiroVinculo {
  final Artigo artigo;
  final List<SeqOperacao> operacoes;

  ArtigoRoteiroVinculo({
    required this.artigo,
    required this.operacoes,
  });
}

// Lista editável de vínculos
final List<ArtigoRoteiroVinculo> vinculosEditaveis = [
  ArtigoRoteiroVinculo(
    artigo: artigosMock.first,
    operacoes: List.from(seqOperacoesMock),
  ),
];

class ArtigoRoteiroListPage extends StatefulWidget {
  const ArtigoRoteiroListPage({super.key});

  @override
  State<ArtigoRoteiroListPage> createState() => _ArtigoRoteiroListPageState();
}

class _ArtigoRoteiroListPageState extends State<ArtigoRoteiroListPage> {
  void _abrirForm({ArtigoRoteiroVinculo? vinculo, int? index}) async {
    final resultado = await Navigator.push<ArtigoRoteiroVinculo>(
      context,
      MaterialPageRoute(builder: (_) => ArtigoRoteiroFormPage(vinculo: vinculo)),
    );

    if (resultado != null) {
      setState(() {
        if (index != null) {
          vinculosEditaveis[index] = resultado;
        } else {
          // Verifica se já existe vínculo para este artigo
          final existente = vinculosEditaveis.indexWhere(
            (v) => v.artigo.codProdutoRP == resultado.artigo.codProdutoRP,
          );
          if (existente >= 0) {
            vinculosEditaveis[existente] = resultado;
          } else {
            vinculosEditaveis.add(resultado);
          }
        }
      });
    }
  }

  void _remover(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Remover vínculo do artigo "${vinculosEditaveis[index].artigo.nomeArtigo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              setState(() => vinculosEditaveis.removeAt(index));
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
        title: const Text('CADASTRO ARTIGO X ROTEIRO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _abrirForm(),
            tooltip: 'Novo Vínculo',
          ),
        ],
      ),
      body: vinculosEditaveis.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.link_off, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('Nenhum vínculo cadastrado'),
                  const SizedBox(height: 8),
                  Text(
                    'Vincule artigos às operações do roteiro',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _abrirForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Novo Vínculo'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vinculosEditaveis.length,
              itemBuilder: (context, index) {
                final v = vinculosEditaveis[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey.shade100,
                      child: Text(v.artigo.codClassif.toString()),
                    ),
                    title: Text(
                      '${v.artigo.codProdutoRP} - ${v.artigo.nomeArtigo}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${v.operacoes.length} operação(ões) configurada(s)'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _abrirForm(vinculo: v, index: index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _remover(index),
                        ),
                      ],
                    ),
                    children: [
                      if (v.operacoes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Nenhuma operação vinculada'),
                        )
                      else
                        DataTable(
                          columns: const [
                            DataColumn(label: Text('Seq')),
                            DataColumn(label: Text('Cod. Op.')),
                            DataColumn(label: Text('Descrição')),
                            DataColumn(label: Text('Posto')),
                          ],
                          rows: v.operacoes.asMap().entries.map((e) {
                            final seq = e.key + 1;
                            final op = e.value;
                            return DataRow(cells: [
                              DataCell(Text(seq.toString())),
                              DataCell(Text(op.codOperacao.toString())),
                              DataCell(Text(op.descOperacao)),
                              DataCell(Text(op.codPosto)),
                            ]);
                          }).toList(),
                        ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: vinculosEditaveis.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _abrirForm(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
