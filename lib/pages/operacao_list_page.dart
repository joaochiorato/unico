import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'operacao_form_page.dart';

// Lista editável de operações
final List<Operacao> operacoesEditaveis = List.from(operacoesMock);

class OperacaoListPage extends StatefulWidget {
  const OperacaoListPage({super.key});

  @override
  State<OperacaoListPage> createState() => _OperacaoListPageState();
}

class _OperacaoListPageState extends State<OperacaoListPage> {
  void _abrirForm({Operacao? operacao, int? index}) async {
    final resultado = await Navigator.push<Operacao>(
      context,
      MaterialPageRoute(builder: (_) => OperacaoFormPage(operacao: operacao)),
    );

    if (resultado != null) {
      setState(() {
        if (index != null) {
          operacoesEditaveis[index] = resultado;
        } else {
          operacoesEditaveis.add(resultado);
        }
      });
    }
  }

  void _remover(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Remover operação "${operacoesEditaveis[index].descOperacao}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              setState(() => operacoesEditaveis.removeAt(index));
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
        title: const Text('CADASTRO DE OPERAÇÃO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _abrirForm(),
            tooltip: 'Nova Operação',
          ),
        ],
      ),
      body: operacoesEditaveis.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.build_circle_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('Nenhuma operação cadastrada'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _abrirForm(),
                    icon: const Icon(Icons.add),
                    label: const Text('Nova Operação'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Cod. Operação')),
                    DataColumn(label: Text('Cod. Tipo MV')),
                    DataColumn(label: Text('Descrição')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Ações')),
                  ],
                  rows: operacoesEditaveis.asMap().entries.map((entry) {
                    final i = entry.key;
                    final o = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text(o.codOperacao.toString())),
                        DataCell(Text(o.codTipoMv)),
                        DataCell(Text(o.descOperacao)),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: o.status == 1 ? Colors.green.shade100 : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              o.statusTexto,
                              style: TextStyle(
                                fontSize: 12,
                                color: o.status == 1 ? Colors.green.shade800 : Colors.red.shade800,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _abrirForm(operacao: o, index: i),
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
      floatingActionButton: operacoesEditaveis.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _abrirForm(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
