import 'package:flutter/foundation.dart';

/// Variável de apontamento (parâmetro) de uma operação
class VariavelApontamento {
  final int id;
  final int seq;
  final String descricao;
  final String unidade;
  final String valorPadrao;

  const VariavelApontamento({
    required this.id,
    required this.seq,
    required this.descricao,
    required this.unidade,
    required this.valorPadrao,
  });
}

/// Etapa do roteiro produtivo (ex.: REMOLHO, ENXUGADEIRA, DIVISORA)
class EtapaRoteiro {
  final int seq;
  final int codOperacao;
  final String descricaoOperacao;
  final String codPosto;
  final List<VariavelApontamento> variaveis;

  const EtapaRoteiro({
    required this.seq,
    required this.codOperacao,
    required this.descricaoOperacao,
    required this.codPosto,
    required this.variaveis,
  });
}

/// Artigo de roteiro produtivo (ex.: PRP001 – QUARTZO)
class ArtigoRoteiro {
  final String codProdutoRp;
  final int codClassif;
  final String descricaoArtigo;
  final List<EtapaRoteiro> etapas;

  const ArtigoRoteiro({
    required this.codProdutoRp,
    required this.codClassif,
    required this.descricaoArtigo,
    required this.etapas,
  });
}

/// Item da Ordem de Produção
class ItemOrdemProducao {
  final int numItem;
  final String codProduto;
  final String descricaoProduto;
  final double quantidade;

  const ItemOrdemProducao({
    required this.numItem,
    required this.codProduto,
    required this.descricaoProduto,
    required this.quantidade,
  });
}

/// Ordem de Produção (ORP – Semi Acabado)
class OrdemProducao {
  final String id; // Chave_fato simulada (ex.: XYD459939)
  final String filial;
  final String documento; // ORP
  final String serie;
  final int numero;
  final DateTime dataMovimento;
  final DateTime dataProducao;
  final DateTime dataEstoque;
  final String linhaProducao; // C90 – Linha Semi Acabado
  final int codCliente;
  final String nomeCliente;
  final String codProduto; // CSA001
  final String descricaoProduto; // QUARTZO BLACK
  final int codClassif; // 7
  final ArtigoRoteiro roteiro; // herdado do cadastro
  final List<ItemOrdemProducao> itens;

  String observacao; // editável na tela

  OrdemProducao({
    required this.id,
    required this.filial,
    required this.documento,
    required this.serie,
    required this.numero,
    required this.dataMovimento,
    required this.dataProducao,
    required this.dataEstoque,
    required this.linhaProducao,
    required this.codCliente,
    required this.nomeCliente,
    required this.codProduto,
    required this.descricaoProduto,
    required this.codClassif,
    required this.roteiro,
    required this.itens,
    this.observacao = '',
  });
}

/// Helper simples para formatação de datas
@immutable
class DateFormats {
  static String formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year.toString()}';
  }
}
