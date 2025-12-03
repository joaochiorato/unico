import '../../core/models.dart';

class ValorApontado {
  final VariavelApontamento variavel;
  final String valor;

  ValorApontado({
    required this.variavel,
    required this.valor,
  });
}

class ApontamentoEtapa {
  final String id;
  final String ordemId;
  final int seqEtapa;
  final String descricaoEtapa;
  final DateTime dataHora;
  final List<ValorApontado> valores;

  ApontamentoEtapa({
    required this.id,
    required this.ordemId,
    required this.seqEtapa,
    required this.descricaoEtapa,
    required this.dataHora,
    required this.valores,
  });

  /// Monta um texto consolidado no padrão do teste de mesa:
  /// "Volume:80 / Temp:55 / Tenso:5"
  String get textoConsolidado {
    return valores
        .map((v) {
          final primeiraPalavra = v.variavel.descricao.split(' ').first;
          return '${primeiraPalavra}:${v.valor}';
        })
        .join(' / ');
  }
}

class ApontamentoStore {
  ApontamentoStore._internal();
  static final ApontamentoStore instance = ApontamentoStore._internal();

  final List<ApontamentoEtapa> _apontamentos = [];

  void registrarApontamento({
    required OrdemProducao ordem,
    required EtapaRoteiro etapa,
    required Map<VariavelApontamento, String> valores,
  }) {
    final listValores = valores.entries
        .map(
          (e) => ValorApontado(
            variavel: e.key,
            valor: e.value,
          ),
        )
        .toList();

    final apont = ApontamentoEtapa(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      ordemId: ordem.id,
      seqEtapa: etapa.seq,
      descricaoEtapa: etapa.descricaoOperacao,
      dataHora: DateTime.now(),
      valores: listValores,
    );

    _apontamentos.add(apont);
  }

  List<ApontamentoEtapa> getByOrdem(String ordemId) {
    final lista = _apontamentos.where((a) => a.ordemId == ordemId).toList();
    lista.sort((a, b) => a.dataHora.compareTo(b.dataHora));
    return lista;
  }

  List<ApontamentoEtapa> getByOrdemEtapa(String ordemId, int seqEtapa) {
    final lista = _apontamentos
        .where((a) => a.ordemId == ordemId && a.seqEtapa == seqEtapa)
        .toList();
    lista.sort((a, b) => a.dataHora.compareTo(b.dataHora));
    return lista;
  }
}
