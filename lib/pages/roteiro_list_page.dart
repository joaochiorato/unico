import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'operacao_list_page.dart';
import 'roteiro_form_page.dart';

// Classe para configuração de roteiro (variáveis e químicos por operação)
class RoteiroConfig {
  final int codOperacao;
  final String descOperacao;
  final String codTipoMv;
  final String codPosto;
  final String tempoSetup;
  final String tempoEspera;
  final String tempoRepouso;
  final String tempoInicio;
  final int status;
  final List<VariavelApontamento> variaveis;
  final List<ProdutoQuimico> quimicos;

  RoteiroConfig({
    required this.codOperacao,
    required this.descOperacao,
    required this.codTipoMv,
    required this.codPosto,
    this.tempoSetup = '00:00',
    this.tempoEspera = '00:00',
    this.tempoRepouso = '00:00',
    this.tempoInicio = '00:00',
    this.status = 1,
    this.variaveis = const [],
    this.quimicos = const [],
  });

  String get statusTexto => status == 1 ? 'Ativo' : 'Inativo';
}

// Lista editável de roteiros configurados
final List<RoteiroConfig> roteirosEditaveis = [
  RoteiroConfig(
    codOperacao: 1000,
    descOperacao: 'REMOLHO',
    codTipoMv: 'C901',
    codPosto: 'ENX',
    variaveis: getVariaveisPorOperacao(1000),
    quimicos: getQuimicosPorOperacao(1000),
  ),
  RoteiroConfig(
    codOperacao: 1001,
    descOperacao: 'ENXUGADEIRA',
    codTipoMv: 'C902',
    codPosto: 'RML',
    variaveis: getVariaveisPorOperacao(1001),
    quimicos: [],
  ),
  RoteiroConfig(
    codOperacao: 1002,
    descOperacao: 'DIVISORA',
    codTipoMv: 'C903',
    codPosto: 'DIV',
    variaveis: getVariaveisPorOperacao(1002),
    quimicos: [],
  ),
];

class RoteiroListPage extends StatefulWidget {
  const RoteiroListPage({super.key});

  @override
  State<RoteiroListPage> createState() => _RoteiroListPageState();
}

class _RoteiroListPageState extends State<RoteiroListPage> {
  void _abrirForm({RoteiroConfig? roteiro, int? index}) async {
    final resultado = await Navigator.push<RoteiroConfig>(
      context,
      MaterialPageRoute(builder: (_) => RoteiroFormPage(roteiro: roteiro)),
    );

    if (resultado != null) {
      setState(() {
        if (index != null) {
          roteirosEditaveis[index] = resultado;
        } else {
          // Verifica se já existe
          final existente = roteirosEditaveis.indexWhere(
            (r) => r.codOperacao == resultado.codOperacao,
          );
          if (existente >= 0) {
            roteirosEditaveis[existente] = resultado;
          } else {
            roteirosEditaveis.add(resultado);
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
        content: Text('Remover roteiro "${roteirosEditaveis[index].descOperacao}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              setState(() => roteirosEditaveis.removeAt(index));
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
        title: const Text('CADASTRO DE ROTEIRO PRODUTIVO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _abrirForm(),
            tooltip: 'Novo Roteiro',
          ),
        ],
      ),
      body: roteirosEditaveis.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tune, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('Nenhum roteiro configurado'),
                  const SizedBox(height: 8),
                  Text(
                    'Configure variáveis e químicos por operação',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _abrirForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Novo Roteiro'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Cod. Op.')),
                    DataColumn(label: Text('Descrição')),
                    DataColumn(label: Text('Tipo MV')),
                    DataColumn(label: Text('Posto')),
                    DataColumn(label: Text('Variáveis')),
                    DataColumn(label: Text('Químicos')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Ações')),
                  ],
                  rows: roteirosEditaveis.asMap().entries.map((entry) {
                    final i = entry.key;
                    final r = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text(r.codOperacao.toString())),
                        DataCell(Text(r.descOperacao)),
                        DataCell(Text(r.codTipoMv)),
                        DataCell(Text(r.codPosto)),
                        DataCell(Text('${r.variaveis.length}')),
                        DataCell(Text('${r.quimicos.length}')),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: r.status == 1 ? Colors.green.shade100 : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              r.statusTexto,
                              style: TextStyle(
                                fontSize: 12,
                                color: r.status == 1 ? Colors.green.shade800 : Colors.red.shade800,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _abrirForm(roteiro: r, index: i),
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
      floatingActionButton: roteirosEditaveis.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _abrirForm(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
