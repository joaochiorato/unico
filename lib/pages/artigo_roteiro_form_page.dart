import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'artigo_list_page.dart';
import 'roteiro_list_page.dart';
import 'artigo_roteiro_list_page.dart';

class ArtigoRoteiroFormPage extends StatefulWidget {
  final ArtigoRoteiroVinculo? vinculo;

  const ArtigoRoteiroFormPage({super.key, this.vinculo});

  @override
  State<ArtigoRoteiroFormPage> createState() => _ArtigoRoteiroFormPageState();
}

class _ArtigoRoteiroFormPageState extends State<ArtigoRoteiroFormPage> {
  Artigo? _artigoSel;
  List<SeqOperacaoEditavel> _operacoes = [];

  @override
  void initState() {
    super.initState();
    final v = widget.vinculo;
    if (v != null) {
      _artigoSel = v.artigo;
      _operacoes = v.operacoes.map((o) => SeqOperacaoEditavel.fromSeqOperacao(o)).toList();
    }
  }

  void _onArtigoChanged(Artigo? artigo) {
    if (artigo == null) return;
    setState(() {
      _artigoSel = artigo;
      // Carrega operações existentes para este artigo
      final existentes = getRoteiroPorArtigo(artigo.codProdutoRP);
      _operacoes = existentes.map((o) => SeqOperacaoEditavel.fromSeqOperacao(o)).toList();
    });
  }

  void _adicionarOperacao() async {
    if (_artigoSel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um artigo primeiro')),
      );
      return;
    }

    // Filtra roteiros que ainda não foram adicionados
    final roteirosDisponiveis = roteirosEditaveis.where((r) {
      return !_operacoes.any((o) => o.codOperacao == r.codOperacao);
    }).toList();

    if (roteirosDisponiveis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todas as operações já foram adicionadas')),
      );
      return;
    }

    final selecionado = await showDialog<RoteiroConfig>(
      context: context,
      builder: (ctx) => _DialogSelecionarRoteiro(roteiros: roteirosDisponiveis),
    );

    if (selecionado != null) {
      setState(() {
        final proxSeq = _operacoes.isEmpty ? 1 : _operacoes.length + 1;
        _operacoes.add(SeqOperacaoEditavel(
          seq: proxSeq,
          codOperacao: selecionado.codOperacao,
          descOperacao: selecionado.descOperacao,
          codPosto: selecionado.codPosto,
        ));
      });
    }
  }

  void _removerOperacao(int index) {
    setState(() {
      _operacoes.removeAt(index);
      // Reordena sequência
      for (int i = 0; i < _operacoes.length; i++) {
        _operacoes[i].seq = i + 1;
      }
    });
  }

  void _moverParaCima(int index) {
    if (index <= 0) return;
    setState(() {
      final item = _operacoes.removeAt(index);
      _operacoes.insert(index - 1, item);
      // Reordena sequência
      for (int i = 0; i < _operacoes.length; i++) {
        _operacoes[i].seq = i + 1;
      }
    });
  }

  void _moverParaBaixo(int index) {
    if (index >= _operacoes.length - 1) return;
    setState(() {
      final item = _operacoes.removeAt(index);
      _operacoes.insert(index + 1, item);
      // Reordena sequência
      for (int i = 0; i < _operacoes.length; i++) {
        _operacoes[i].seq = i + 1;
      }
    });
  }

  void _salvar() {
    if (_artigoSel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um artigo')),
      );
      return;
    }

    final vinculo = ArtigoRoteiroVinculo(
      artigo: _artigoSel!,
      operacoes: _operacoes.map((o) => o.toSeqOperacao(_artigoSel!.codProdutoRP)).toList(),
    );

    Navigator.pop(context, vinculo);
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.vinculo != null;

    // Filtra artigos que ainda não têm vínculo (exceto o atual em edição)
    final artigosDisponiveis = artigosEditaveis.where((a) {
      if (isEdicao && a.codProdutoRP == widget.vinculo?.artigo.codProdutoRP) {
        return true;
      }
      return !vinculosEditaveis.any((v) => v.artigo.codProdutoRP == a.codProdutoRP);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'EDITAR ARTIGO X ROTEIRO' : 'NOVO ARTIGO X ROTEIRO'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _salvar),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SEÇÃO: Selecionar Artigo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selecione o Artigo',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    artigosDisponiveis.isEmpty
                        ? _buildEmptyArtigos()
                        : DropdownButtonFormField<Artigo>(
                            value: _artigoSel,
                            decoration: const InputDecoration(labelText: 'Artigo *'),
                            hint: const Text('Selecione...'),
                            items: artigosDisponiveis
                                .map((a) => DropdownMenuItem(
                                      value: a,
                                      child: Text(a.descricaoCompleta),
                                    ))
                                .toList(),
                            onChanged: isEdicao ? null : _onArtigoChanged,
                          ),
                    if (_artigoSel != null) ...[
                      const SizedBox(height: 12),
                      Container(
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
                                'Cod. Classif: ${_artigoSel!.codClassif} | Cod. Ref: ${_artigoSel!.codRefRP}',
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // SEÇÃO: Operações do Roteiro
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Operações do Roteiro (SEQ. ROTEIRO)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton.icon(
                          onPressed: _adicionarOperacao,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Adicionar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildOperacoesTable(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botão Salvar
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.save),
                label: const Text('SALVAR VÍNCULO'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyArtigos() {
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
          Expanded(
            child: Text('Todos os artigos já possuem vínculo ou não há artigos cadastrados.'),
          ),
        ],
      ),
    );
  }

  Widget _buildOperacoesTable() {
    if (_artigoSel == null) {
      return Text('Selecione um artigo', style: TextStyle(color: Colors.grey.shade600));
    }
    if (_operacoes.isEmpty) {
      return Text(
        'Nenhuma operação vinculada. Clique em "Adicionar" para vincular operações.',
        style: TextStyle(color: Colors.grey.shade600),
      );
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _operacoes.length,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) newIndex--;
          final item = _operacoes.removeAt(oldIndex);
          _operacoes.insert(newIndex, item);
          // Reordena sequência
          for (int i = 0; i < _operacoes.length; i++) {
            _operacoes[i].seq = i + 1;
          }
        });
      },
      itemBuilder: (context, index) {
        final op = _operacoes[index];
        return Card(
          key: ValueKey(op.codOperacao),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey.shade100,
              child: Text(op.seq.toString()),
            ),
            title: Text(op.descOperacao, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Cod. Op.: ${op.codOperacao} | Posto: ${op.codPosto}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward, size: 20),
                  onPressed: index > 0 ? () => _moverParaCima(index) : null,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, size: 20),
                  onPressed: index < _operacoes.length - 1 ? () => _moverParaBaixo(index) : null,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () => _removerOperacao(index),
                ),
                const Icon(Icons.drag_handle),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CLASSES AUXILIARES
// ═══════════════════════════════════════════════════════════════════════════

class SeqOperacaoEditavel {
  int seq;
  final int codOperacao;
  final String descOperacao;
  final String codPosto;

  SeqOperacaoEditavel({
    required this.seq,
    required this.codOperacao,
    required this.descOperacao,
    required this.codPosto,
  });

  factory SeqOperacaoEditavel.fromSeqOperacao(SeqOperacao s) {
    return SeqOperacaoEditavel(
      seq: 0, // Será definido na ordem da lista
      codOperacao: s.codOperacao,
      descOperacao: s.descOperacao,
      codPosto: s.codPosto,
    );
  }

  SeqOperacao toSeqOperacao(String codProduto) {
    return SeqOperacao(
      codProduto: codProduto,
      codRef: 0,
      codOperacao: codOperacao,
      descOperacao: '${seq}A $descOperacao',
      codPosto: codPosto,
      opcaoPcp: 0,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DIALOG SELECIONAR ROTEIRO
// ═══════════════════════════════════════════════════════════════════════════

class _DialogSelecionarRoteiro extends StatelessWidget {
  final List<RoteiroConfig> roteiros;

  const _DialogSelecionarRoteiro({required this.roteiros});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecionar Operação'),
      content: SizedBox(
        width: 400,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: roteiros.length,
          itemBuilder: (context, index) {
            final r = roteiros[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueGrey.shade100,
                child: Text(r.codOperacao.toString().substring(0, 2)),
              ),
              title: Text(r.descOperacao),
              subtitle: Text('Código: ${r.codOperacao} | Posto: ${r.codPosto} | TMV: ${r.codTipoMv}'),
              onTap: () => Navigator.pop(context, r),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
