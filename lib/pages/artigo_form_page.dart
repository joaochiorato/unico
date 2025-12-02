import 'package:flutter/material.dart';
import '../data/mock_data.dart';

class ArtigoFormPage extends StatefulWidget {
  final Artigo? artigo;

  const ArtigoFormPage({super.key, this.artigo});

  @override
  State<ArtigoFormPage> createState() => _ArtigoFormPageState();
}

class _ArtigoFormPageState extends State<ArtigoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codClassifCtrl;
  late TextEditingController _codProdutoRPCtrl;
  late TextEditingController _codRefRPCtrl;
  late TextEditingController _nomeArtigoCtrl;

  @override
  void initState() {
    super.initState();
    _codClassifCtrl = TextEditingController(text: widget.artigo?.codClassif.toString() ?? '');
    _codProdutoRPCtrl = TextEditingController(text: widget.artigo?.codProdutoRP ?? '');
    _codRefRPCtrl = TextEditingController(text: widget.artigo?.codRefRP.toString() ?? '0');
    _nomeArtigoCtrl = TextEditingController(text: widget.artigo?.nomeArtigo ?? '');
  }

  @override
  void dispose() {
    _codClassifCtrl.dispose();
    _codProdutoRPCtrl.dispose();
    _codRefRPCtrl.dispose();
    _nomeArtigoCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final artigo = Artigo(
      codClassif: int.tryParse(_codClassifCtrl.text) ?? 0,
      codProdutoRP: _codProdutoRPCtrl.text.trim().toUpperCase(),
      codRefRP: int.tryParse(_codRefRPCtrl.text) ?? 0,
      nomeArtigo: _nomeArtigoCtrl.text.trim().toUpperCase(),
    );

    Navigator.pop(context, artigo);
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.artigo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'EDITAR ARTIGO' : 'NOVO ARTIGO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvar,
            tooltip: 'Salvar',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dados do Artigo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codClassifCtrl,
                          decoration: const InputDecoration(labelText: 'Cod. Classif *'),
                          keyboardType: TextInputType.number,
                          validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _codRefRPCtrl,
                          decoration: const InputDecoration(labelText: 'Cod. Ref'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codProdutoRPCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Cod. Produto RP *',
                            hintText: 'Ex: PRP001',
                          ),
                          textCapitalization: TextCapitalization.characters,
                          validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _nomeArtigoCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nome do Artigo *',
                            hintText: 'Ex: QUARTZO',
                          ),
                          textCapitalization: TextCapitalization.characters,
                          validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _salvar,
                      icon: const Icon(Icons.save),
                      label: const Text('SALVAR'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
