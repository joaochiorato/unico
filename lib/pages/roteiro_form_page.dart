import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'operacao_list_page.dart';
import 'roteiro_list_page.dart';

class RoteiroFormPage extends StatefulWidget {
  final RoteiroConfig? roteiro;

  const RoteiroFormPage({super.key, this.roteiro});

  @override
  State<RoteiroFormPage> createState() => _RoteiroFormPageState();
}

class _RoteiroFormPageState extends State<RoteiroFormPage> {
  final _formKey = GlobalKey<FormState>();

  Operacao? _operacaoSel;
  String _codPosto = 'ENX';
  int _status = 1;

  late TextEditingController _tempoSetupCtrl;
  late TextEditingController _tempoEsperaCtrl;
  late TextEditingController _tempoRepousoCtrl;
  late TextEditingController _tempoInicioCtrl;
  late TextEditingController _observacaoCtrl;

  List<VariavelEditavel> _variaveis = [];
  List<QuimicoEditavel> _quimicos = [];

  @override
  void initState() {
    super.initState();
    final r = widget.roteiro;

    _tempoSetupCtrl = TextEditingController(text: r?.tempoSetup ?? '00:00');
    _tempoEsperaCtrl = TextEditingController(text: r?.tempoEspera ?? '00:00');
    _tempoRepousoCtrl = TextEditingController(text: r?.tempoRepouso ?? '00:00');
    _tempoInicioCtrl = TextEditingController(text: r?.tempoInicio ?? '00:00');
    _observacaoCtrl = TextEditingController();

    if (r != null) {
      _operacaoSel = operacoesEditaveis.firstWhere(
        (o) => o.codOperacao == r.codOperacao,
        orElse: () => operacoesEditaveis.first,
      );
      _codPosto = r.codPosto;
      _status = r.status;
      _carregarVariaveisEQuimicos(r.codOperacao);
    }
  }

  void _carregarVariaveisEQuimicos(int codOperacao) {
    _variaveis = getVariaveisPorOperacao(codOperacao)
        .map((v) => VariavelEditavel.fromVariavel(v))
        .toList();
    _quimicos = getQuimicosPorOperacao(codOperacao)
        .map((q) => QuimicoEditavel.fromQuimico(q))
        .toList();
  }

  void _onOperacaoChanged(Operacao? op) {
    if (op == null) return;
    setState(() {
      _operacaoSel = op;
      _codPosto = _getPostoPadrao(op.codOperacao);
      _carregarVariaveisEQuimicos(op.codOperacao);
    });
  }

  String _getPostoPadrao(int codOp) {
    switch (codOp) {
      case 1000: return 'ENX';
      case 1001: return 'RML';
      case 1002: return 'DIV';
      default: return 'ENX';
    }
  }

  @override
  void dispose() {
    _tempoSetupCtrl.dispose();
    _tempoEsperaCtrl.dispose();
    _tempoRepousoCtrl.dispose();
    _tempoInicioCtrl.dispose();
    _observacaoCtrl.dispose();
    super.dispose();
  }

  void _adicionarVariavel() async {
    final proxSeq = _variaveis.isEmpty ? 1 : _variaveis.last.seq + 1;
    final nova = await showDialog<VariavelEditavel>(
      context: context,
      builder: (ctx) => _DialogVariavel(proximaSeq: proxSeq),
    );
    if (nova != null) {
      setState(() => _variaveis.add(nova));
    }
  }

  void _adicionarQuimico() async {
    final proxSeq = _quimicos.isEmpty ? 1 : _quimicos.last.seq + 1;
    final novo = await showDialog<QuimicoEditavel>(
      context: context,
      builder: (ctx) => _DialogQuimico(proximaSeq: proxSeq),
    );
    if (novo != null) {
      setState(() => _quimicos.add(novo));
    }
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    if (_operacaoSel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma operação')),
      );
      return;
    }

    final roteiro = RoteiroConfig(
      codOperacao: _operacaoSel!.codOperacao,
      descOperacao: _operacaoSel!.descOperacao,
      codTipoMv: _operacaoSel!.codTipoMv,
      codPosto: _codPosto,
      tempoSetup: _tempoSetupCtrl.text,
      tempoEspera: _tempoEsperaCtrl.text,
      tempoRepouso: _tempoRepousoCtrl.text,
      tempoInicio: _tempoInicioCtrl.text,
      status: _status,
      variaveis: _variaveis.map((v) => v.toVariavel(_operacaoSel!.codOperacao)).toList(),
      quimicos: _quimicos.map((q) => q.toQuimico(_operacaoSel!.codOperacao)).toList(),
    );

    Navigator.pop(context, roteiro);
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.roteiro != null;

    // Filtra operações disponíveis
    final operacoesDisponiveis = isEdicao
        ? operacoesEditaveis.where((o) => o.status == 1).toList()
        : operacoesEditaveis.where((o) {
            if (o.status != 1) return false;
            return !roteirosEditaveis.any((r) => r.codOperacao == o.codOperacao);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'EDITAR ROTEIRO PRODUTIVO' : 'NOVO ROTEIRO PRODUTIVO'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _salvar),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SEÇÃO: Selecionar Operação
              _buildSection(
                title: 'Selecione a Operação',
                child: operacoesDisponiveis.isEmpty
                    ? _buildEmptyOperacoes()
                    : DropdownButtonFormField<Operacao>(
                        value: _operacaoSel,
                        decoration: const InputDecoration(labelText: 'Operação *'),
                        hint: const Text('Selecione...'),
                        items: operacoesDisponiveis
                            .map((o) => DropdownMenuItem(value: o, child: Text(o.operacaoFormatada)))
                            .toList(),
                        onChanged: isEdicao ? null : _onOperacaoChanged,
                        validator: (v) => v == null ? 'Selecione uma operação' : null,
                      ),
              ),

              if (_operacaoSel != null) ...[
                const SizedBox(height: 8),
                _buildOperacaoInfo(),
              ],

              const SizedBox(height: 16),

              // SEÇÃO: Configurações
              _buildSection(
                title: 'Configurações',
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _codPosto,
                            decoration: const InputDecoration(labelText: 'Posto de Trabalho'),
                            items: postosMock
                                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                                .toList(),
                            onChanged: (v) => setState(() => _codPosto = v ?? 'ENX'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _status,
                            decoration: const InputDecoration(labelText: 'Status'),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('Ativo')),
                              DropdownMenuItem(value: 0, child: Text('Inativo')),
                            ],
                            onChanged: (v) => setState(() => _status = v ?? 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildTimeField(_tempoSetupCtrl, 'Tempo Setup')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTimeField(_tempoEsperaCtrl, 'Tempo Espera')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTimeField(_tempoRepousoCtrl, 'Tempo Repouso')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTimeField(_tempoInicioCtrl, 'Tempo Início')),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // SEÇÃO: Variáveis de Controle
              _buildSection(
                title: 'Variáveis de Controle',
                trailing: ElevatedButton.icon(
                  onPressed: _operacaoSel != null ? _adicionarVariavel : null,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Adicionar'),
                ),
                child: _buildVariaveisTable(),
              ),

              const SizedBox(height: 16),

              // SEÇÃO: Produtos Químicos
              _buildSection(
                title: 'Produtos Químicos',
                trailing: ElevatedButton.icon(
                  onPressed: _operacaoSel != null ? _adicionarQuimico : null,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Adicionar'),
                ),
                child: _buildQuimicosTable(),
              ),

              const SizedBox(height: 24),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.save),
                  label: const Text('SALVAR ROTEIRO'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child, Widget? trailing}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (trailing != null) trailing,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyOperacoes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning, color: Colors.amber),
          SizedBox(width: 12),
          Expanded(child: Text('Todas as operações já possuem roteiro configurado.')),
        ],
      ),
    );
  }

  Widget _buildOperacaoInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Operação: ${_operacaoSel!.descOperacao} | Tipo MV: ${_operacaoSel!.codTipoMv}',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField(TextEditingController ctrl, String label) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildVariaveisTable() {
    if (_operacaoSel == null) {
      return Text('Selecione uma operação', style: TextStyle(color: Colors.grey.shade600));
    }
    if (_variaveis.isEmpty) {
      return Text('Nenhuma variável cadastrada', style: TextStyle(color: Colors.grey.shade600));
    }

    return Table(
      columnWidths: const {
        0: FixedColumnWidth(50),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FixedColumnWidth(80),
        4: FixedColumnWidth(50),
      },
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            _TableHeader('Seq'),
            _TableHeader('Descrição'),
            _TableHeader('Padrão'),
            _TableHeader('Unidade'),
            _TableHeader(''),
          ],
        ),
        ..._variaveis.asMap().entries.map((e) {
          final v = e.value;
          return TableRow(
            children: [
              _TableCell(v.seq.toString()),
              _TableCell(v.descricao),
              _TableCell(v.padrao),
              _TableCell(v.unidade),
              Padding(
                padding: const EdgeInsets.all(4),
                child: IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  onPressed: () => setState(() => _variaveis.removeAt(e.key)),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildQuimicosTable() {
    if (_operacaoSel == null) {
      return Text('Selecione uma operação', style: TextStyle(color: Colors.grey.shade600));
    }
    if (_quimicos.isEmpty) {
      return Text('Nenhum químico cadastrado', style: TextStyle(color: Colors.grey.shade600));
    }

    return Table(
      columnWidths: const {
        0: FixedColumnWidth(50),
        1: FixedColumnWidth(100),
        2: FlexColumnWidth(2),
        3: FixedColumnWidth(80),
        4: FixedColumnWidth(50),
      },
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: const [
            _TableHeader('Seq'),
            _TableHeader('Código'),
            _TableHeader('Descrição'),
            _TableHeader('Unidade'),
            _TableHeader(''),
          ],
        ),
        ..._quimicos.asMap().entries.map((e) {
          final q = e.value;
          return TableRow(
            children: [
              _TableCell(q.seq.toString()),
              _TableCell(q.codProduto),
              _TableCell(q.descricao),
              _TableCell(q.unidade),
              Padding(
                padding: const EdgeInsets.all(4),
                child: IconButton(
                  icon: const Icon(Icons.delete, size: 18),
                  onPressed: () => setState(() => _quimicos.removeAt(e.key)),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CLASSES AUXILIARES
// ═══════════════════════════════════════════════════════════════════════════

class VariavelEditavel {
  int seq;
  String descricao;
  String padrao;
  String unidade;

  VariavelEditavel({
    required this.seq,
    required this.descricao,
    required this.padrao,
    required this.unidade,
  });

  factory VariavelEditavel.fromVariavel(VariavelApontamento v) {
    return VariavelEditavel(
      seq: v.seq,
      descricao: v.descPrm,
      padrao: v.descPadrao,
      unidade: v.descUnidade,
    );
  }

  VariavelApontamento toVariavel(int codOperacao) {
    return VariavelApontamento(
      id: 0,
      codProduto: 'PRP001',
      codRef: 0,
      opcaoPcp: 0,
      codOperacao: codOperacao,
      seq: seq,
      descPrm: descricao,
      descPadrao: padrao,
      descUnidade: unidade,
    );
  }
}

class QuimicoEditavel {
  int seq;
  String codProduto;
  String descricao;
  String unidade;

  QuimicoEditavel({
    required this.seq,
    required this.codProduto,
    required this.descricao,
    required this.unidade,
  });

  factory QuimicoEditavel.fromQuimico(ProdutoQuimico q) {
    return QuimicoEditavel(
      seq: q.seq,
      codProduto: q.codProdutoComp,
      descricao: q.descricao,
      unidade: q.unidade,
    );
  }

  ProdutoQuimico toQuimico(int codOperacao) {
    return ProdutoQuimico(
      codProduto: 'PRP001',
      codRef: 0,
      codOperacao: codOperacao,
      codProdutoComp: codProduto,
      codRefComp: 0,
      seq: seq,
      descricao: descricao,
      unidade: unidade,
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  const _TableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DIALOGS
// ═══════════════════════════════════════════════════════════════════════════

class _DialogVariavel extends StatefulWidget {
  final int proximaSeq;
  const _DialogVariavel({required this.proximaSeq});

  @override
  State<_DialogVariavel> createState() => _DialogVariavelState();
}

class _DialogVariavelState extends State<_DialogVariavel> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _seqCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _padraoCtrl;
  late TextEditingController _unidadeCtrl;

  @override
  void initState() {
    super.initState();
    _seqCtrl = TextEditingController(text: widget.proximaSeq.toString());
    _descCtrl = TextEditingController();
    _padraoCtrl = TextEditingController();
    _unidadeCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _seqCtrl.dispose();
    _descCtrl.dispose();
    _padraoCtrl.dispose();
    _unidadeCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    final variavel = VariavelEditavel(
      seq: int.tryParse(_seqCtrl.text) ?? widget.proximaSeq,
      descricao: _descCtrl.text,
      padrao: _padraoCtrl.text,
      unidade: _unidadeCtrl.text,
    );
    Navigator.pop(context, variavel);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Variável'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: _seqCtrl,
                      decoration: const InputDecoration(labelText: 'Seq'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(labelText: 'Descrição *'),
                      validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _padraoCtrl,
                      decoration: const InputDecoration(labelText: 'Padrão'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _unidadeCtrl,
                      decoration: const InputDecoration(labelText: 'Unidade'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(onPressed: _salvar, child: const Text('Adicionar')),
      ],
    );
  }
}

class _DialogQuimico extends StatefulWidget {
  final int proximaSeq;
  const _DialogQuimico({required this.proximaSeq});

  @override
  State<_DialogQuimico> createState() => _DialogQuimicoState();
}

class _DialogQuimicoState extends State<_DialogQuimico> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _seqCtrl;
  late TextEditingController _codProdCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _unidadeCtrl;

  @override
  void initState() {
    super.initState();
    _seqCtrl = TextEditingController(text: widget.proximaSeq.toString());
    _codProdCtrl = TextEditingController();
    _descCtrl = TextEditingController();
    _unidadeCtrl = TextEditingController(text: 'kg');
  }

  @override
  void dispose() {
    _seqCtrl.dispose();
    _codProdCtrl.dispose();
    _descCtrl.dispose();
    _unidadeCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    final quimico = QuimicoEditavel(
      seq: int.tryParse(_seqCtrl.text) ?? widget.proximaSeq,
      codProduto: _codProdCtrl.text,
      descricao: _descCtrl.text,
      unidade: _unidadeCtrl.text,
    );
    Navigator.pop(context, quimico);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Químico'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: _seqCtrl,
                      decoration: const InputDecoration(labelText: 'Seq'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _codProdCtrl,
                      decoration: const InputDecoration(labelText: 'Código *'),
                      validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descrição *'),
                validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _unidadeCtrl,
                decoration: const InputDecoration(labelText: 'Unidade'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(onPressed: _salvar, child: const Text('Adicionar')),
      ],
    );
  }
}
