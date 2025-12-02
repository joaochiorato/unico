import 'package:flutter/material.dart';
import '../data/mock_data.dart';

class OperacaoFormPage extends StatefulWidget {
  final Operacao? operacao;

  const OperacaoFormPage({super.key, this.operacao});

  @override
  State<OperacaoFormPage> createState() => _OperacaoFormPageState();
}

class _OperacaoFormPageState extends State<OperacaoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codOperacaoCtrl;
  late TextEditingController _descOperacaoCtrl;
  String _codTipoMv = 'C901';
  int _status = 1;

  @override
  void initState() {
    super.initState();
    _codOperacaoCtrl = TextEditingController(text: widget.operacao?.codOperacao.toString() ?? '');
    _descOperacaoCtrl = TextEditingController(text: widget.operacao?.descOperacao ?? '');
    _codTipoMv = widget.operacao?.codTipoMv ?? 'C901';
    _status = widget.operacao?.status ?? 1;
  }

  @override
  void dispose() {
    _codOperacaoCtrl.dispose();
    _descOperacaoCtrl.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final operacao = Operacao(
      codOperacao: int.tryParse(_codOperacaoCtrl.text) ?? 0,
      codTipoMv: _codTipoMv,
      descOperacao: _descOperacaoCtrl.text.trim().toUpperCase(),
      status: _status,
    );

    Navigator.pop(context, operacao);
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.operacao != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'EDITAR OPERAÇÃO' : 'NOVA OPERAÇÃO'),
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
                    'Dados da Operação',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _codOperacaoCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Cod. Operação *',
                            hintText: 'Ex: 1000',
                          ),
                          keyboardType: TextInputType.number,
                          readOnly: isEdicao,
                          validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _codTipoMv,
                          decoration: const InputDecoration(labelText: 'Tipo Movimento'),
                          items: ['C901', 'C902', 'C903', 'C904', 'C905']
                              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                              .toList(),
                          onChanged: (v) => setState(() => _codTipoMv = v ?? 'C901'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _descOperacaoCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Descrição *',
                            hintText: 'Ex: REMOLHO',
                          ),
                          textCapitalization: TextCapitalization.characters,
                          validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
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
