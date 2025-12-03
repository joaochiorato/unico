import 'package:flutter/material.dart';
import '../../core/mock_data_service.dart';
import '../../core/models.dart';

class OrdemProducaoDetailPage extends StatefulWidget {
  final OrdemProducao ordem;

  const OrdemProducaoDetailPage({super.key, required this.ordem});

  @override
  State<OrdemProducaoDetailPage> createState() =>
      _OrdemProducaoDetailPageState();
}

class _OrdemProducaoDetailPageState extends State<OrdemProducaoDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _obsController;
  final _service = MockDataService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _obsController = TextEditingController(text: widget.ordem.observacao);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  void _salvar({bool fechar = false}) {
    setState(() {
      widget.ordem.observacao = _obsController.text;
    });
    _service.salvarOrdem(widget.ordem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ordem salva (em memória).')),
    );

    if (fechar) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordem = widget.ordem;

    return Scaffold(
      appBar: AppBar(
        title: Text('ORP ${ordem.filial}-${ordem.documento}-${ordem.serie}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(ordem),
            const SizedBox(height: 12),
            _buildParticipanteELinha(ordem),
            const SizedBox(height: 12),
            _buildToolbar(),
            const SizedBox(height: 12),
            _buildTabs(ordem),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(OrdemProducao ordem) {
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
                  const Text(
                    'C900 – Ordem de Produção (Semi – Acabado)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Text('Filial: ${ordem.filial}'),
                      Text('Documento: ${ordem.documento}'),
                      Text('Série: ${ordem.serie}'),
                      Text('Número: ${ordem.numero}'),
                      Text('ID (chave_fato): ${ordem.id}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Text('Dt. movto.: ${DateFormats.formatDate(ordem.dataMovimento)}'),
                      Text('Dt. produção: ${DateFormats.formatDate(ordem.dataProducao)}'),
                      Text('Dt. estoque: ${DateFormats.formatDate(ordem.dataEstoque)}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipanteELinha(OrdemProducao ordem) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 32,
          runSpacing: 12,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Participante',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('Código: ${ordem.codCliente}'),
                Text('Nome: ${ordem.nomeCliente}'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Linha de Produção',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(ordem.linhaProducao),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Row(
      children: [
        FilledButton(
          onPressed: () => _salvar(),
          child: const Text('Salvar'),
        ),
        const SizedBox(width: 8),
        FilledButton.tonal(
          onPressed: () => _salvar(fechar: true),
          child: const Text('Salvar e Fechar'),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ação "Atualizar Documento" mockada.')),
            );
          },
          child: const Text('Atualizar Documento'),
        ),
      ],
    );
  }

  Widget _buildTabs(OrdemProducao ordem) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Documento'),
              Tab(text: 'Itens'),
              Tab(text: 'Rastreabilidades'),
              Tab(text: 'Observação'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabDocumento(ordem),
                _buildTabItens(ordem),
                _buildTabRastreabilidade(ordem),
                _buildTabObservacao(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabDocumento(OrdemProducao ordem) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dados do Documento',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _buildReadOnlyField('Produto', '${ordem.codProduto} - ${ordem.descricaoProduto}'),
              _buildReadOnlyField('Classifi', ordem.codClassif.toString()),
              _buildReadOnlyField('Roteiro (Artigo)', ordem.roteiro.codProdutoRp),
              _buildReadOnlyField('Descrição Roteiro', ordem.roteiro.descricaoArtigo),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabItens(OrdemProducao ordem) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 1,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Item')),
              DataColumn(label: Text('Produto')),
              DataColumn(label: Text('Descrição')),
              DataColumn(label: Text('Quantidade')),
            ],
            rows: ordem.itens
                .map(
                  (i) => DataRow(
                    cells: [
                      DataCell(Text(i.numItem.toString())),
                      DataCell(Text(i.codProduto)),
                      DataCell(Text(i.descricaoProduto)),
                      DataCell(Text(i.quantidade.toStringAsFixed(2))),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabRastreabilidade(OrdemProducao ordem) {
    final etapas = ordem.roteiro.etapas;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 1,
        child: ListView.builder(
          itemCount: etapas.length,
          itemBuilder: (context, index) {
            final e = etapas[index];
            return ListTile(
              title: Text(
                '${e.seq}ª - ${e.descricaoOperacao}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                  'Operação ${e.codOperacao} | Posto: ${e.codPosto} | Qtde parâmetros: ${e.variaveis.length}'),
              leading: const Icon(Icons.route),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabObservacao() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _obsController,
        maxLines: null,
        decoration: const InputDecoration(
          labelText: 'Observação',
          border: OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return SizedBox(
      width: 260,
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
