// ══════════════════════════════════════════════════════════════════════════
// DADOS MOCKADOS - BASEADOS NO TESTE DE MESA
// ══════════════════════════════════════════════════════════════════════════

// ─────────────────────────────────────────────────────────────────────────
// ARTIGO (tbClassifAnimal)
// ─────────────────────────────────────────────────────────────────────────
class Artigo {
  final int codClassif;
  final String codProdutoRP;
  final int codRefRP;
  final String nomeArtigo;

  const Artigo({
    required this.codClassif,
    required this.codProdutoRP,
    required this.codRefRP,
    required this.nomeArtigo,
  });

  String get descricaoCompleta => '$codProdutoRP - $nomeArtigo';
}

final List<Artigo> artigosMock = [
  const Artigo(codClassif: 7, codProdutoRP: 'PRP001', codRefRP: 0, nomeArtigo: 'QUARTZO'),
];

// ─────────────────────────────────────────────────────────────────────────
// CADASTRO DE OPERAÇÃO (tbCodOperacao)
// ─────────────────────────────────────────────────────────────────────────
class Operacao {
  final int codOperacao;
  final String codTipoMv;
  final String descOperacao;
  final int status;

  const Operacao({
    required this.codOperacao,
    required this.codTipoMv,
    required this.descOperacao,
    required this.status,
  });

  String get statusTexto => status == 1 ? 'Ativo' : 'Inativo';
  String get operacaoFormatada => '$codOperacao - $descOperacao';
}

final List<Operacao> operacoesMock = [
  const Operacao(codOperacao: 1000, codTipoMv: 'C901', descOperacao: 'REMOLHO', status: 1),
  const Operacao(codOperacao: 1001, codTipoMv: 'C902', descOperacao: 'ENXUGADEIRA', status: 1),
  const Operacao(codOperacao: 1002, codTipoMv: 'C903', descOperacao: 'DIVISORA', status: 1),
];

// ─────────────────────────────────────────────────────────────────────────
// SEQUÊNCIA DO ROTEIRO (tbSeqOperacao)
// ─────────────────────────────────────────────────────────────────────────
class SeqOperacao {
  final String codProduto;
  final int codRef;
  final int codOperacao;
  final String descOperacao;
  final String codPosto;
  final int opcaoPcp;
  final String unidadeTempo;
  final double leadtimeSetup;
  final double leadtimeEspera;
  final double leadtimeOperacao;
  final double leadtimeRepouso;
  final double leadtimeTransporte;

  const SeqOperacao({
    required this.codProduto,
    required this.codRef,
    required this.codOperacao,
    required this.descOperacao,
    required this.codPosto,
    required this.opcaoPcp,
    this.unidadeTempo = 'M',
    this.leadtimeSetup = 0,
    this.leadtimeEspera = 0,
    this.leadtimeOperacao = 0,
    this.leadtimeRepouso = 0,
    this.leadtimeTransporte = 0,
  });
}

final List<SeqOperacao> seqOperacoesMock = [
  const SeqOperacao(
    codProduto: 'PRP001', codRef: 0, codOperacao: 1000,
    descOperacao: '1A REMOLHO', codPosto: 'ENX', opcaoPcp: 0,
  ),
  const SeqOperacao(
    codProduto: 'PRP001', codRef: 0, codOperacao: 1001,
    descOperacao: '2A ENXUGADEIRA', codPosto: 'RML', opcaoPcp: 0,
  ),
  const SeqOperacao(
    codProduto: 'PRP001', codRef: 0, codOperacao: 1002,
    descOperacao: '3A DIVISORA', codPosto: 'DIV', opcaoPcp: 0,
  ),
];

// ─────────────────────────────────────────────────────────────────────────
// VARIÁVEIS DE APONTAMENTO (tbSeqOperacaoPrm)
// ─────────────────────────────────────────────────────────────────────────
class VariavelApontamento {
  final int id;
  final String codProduto;
  final int codRef;
  final int opcaoPcp;
  final int codOperacao;
  final int seq;
  final String descPrm;
  final String descPadrao;
  final String descUnidade;
  final String? travaPrm;

  const VariavelApontamento({
    required this.id,
    required this.codProduto,
    required this.codRef,
    required this.opcaoPcp,
    required this.codOperacao,
    required this.seq,
    required this.descPrm,
    required this.descPadrao,
    required this.descUnidade,
    this.travaPrm,
  });
}

final List<VariavelApontamento> variaveisMock = [
  // REMOLHO (1000)
  const VariavelApontamento(
    id: 1, codProduto: 'PRP001', codRef: 0, opcaoPcp: 0, codOperacao: 1000, seq: 1,
    descPrm: 'Volume de Água', descPadrao: '100% do Peso do Couro', descUnidade: 'Litros',
  ),
  const VariavelApontamento(
    id: 2, codProduto: 'PRP001', codRef: 0, opcaoPcp: 0, codOperacao: 1000, seq: 2,
    descPrm: 'Temperatura da Água', descPadrao: 'Faixa 50 a 70', descUnidade: 'ºC',
  ),
  const VariavelApontamento(
    id: 3, codProduto: 'PRP001', codRef: 0, opcaoPcp: 0, codOperacao: 1000, seq: 3,
    descPrm: 'Tensoativo', descPadrao: 'Faixa 4.8 - 5.2', descUnidade: 'Litros',
  ),
  // ENXUGADEIRA (1001)
  const VariavelApontamento(
    id: 4, codProduto: 'PRP001', codRef: 0, opcaoPcp: 0, codOperacao: 1001, seq: 1,
    descPrm: 'Pressão do Rolo (1º manômetro)', descPadrao: '40 a 110', descUnidade: 'Bar',
  ),
  const VariavelApontamento(
    id: 5, codProduto: 'PRP001', codRef: 0, opcaoPcp: 0, codOperacao: 1001, seq: 2,
    descPrm: 'Pressão do Rolo (2º manômetro)', descPadrao: '60 a 110', descUnidade: 'Bar',
  ),
  const VariavelApontamento(
    id: 6, codProduto: 'PRP001', codRef: 0, opcaoPcp: 0, codOperacao: 1001, seq: 3,
    descPrm: 'Velocidade do Feltro', descPadrao: '15 +/- 3', descUnidade: 'm/min',
  ),
  const VariavelApontamento(
    id: 7, codProduto: 'PRP001', codRef: 0, opcaoPcp: 0, codOperacao: 1001, seq: 4,
    descPrm: 'Velocidade do Tapete', descPadrao: '13 +/- 3', descUnidade: 'm/min',
  ),
  // DIVISORA (1002)
  const VariavelApontamento(
    id: 8, codProduto: 'PRP001', codRef: 0, opcaoPcp: 0, codOperacao: 1002, seq: 1,
    descPrm: 'Velocidade da Máquina', descPadrao: '23 +/- 2', descUnidade: 'm/min',
  ),
  const VariavelApontamento(
    id: 9, codProduto: 'PRP001', codRef: 0, opcaoPcp: 0, codOperacao: 1002, seq: 2,
    descPrm: 'Distância da Navalha', descPadrao: '8,0 a 8,5', descUnidade: 'mm',
  ),
  const VariavelApontamento(
    id: 10, codProduto: 'PRP001', codRef: 0, opcaoPcp: 0, codOperacao: 1002, seq: 3,
    descPrm: 'Fio da Navalha Inferior', descPadrao: '5,0 +/- 0,5', descUnidade: 'mm',
  ),
  const VariavelApontamento(
    id: 11, codProduto: 'PRP001', codRef: 0, opcaoPcp: 0, codOperacao: 1002, seq: 4,
    descPrm: 'Fio da Navalha Superior', descPadrao: '6,0 +/- 0,5', descUnidade: 'mm',
  ),
];

// ─────────────────────────────────────────────────────────────────────────
// PRODUTOS QUÍMICOS (tbSeqOperacaoProd) - Apenas REMOLHO
// ─────────────────────────────────────────────────────────────────────────
class ProdutoQuimico {
  final String codProduto;
  final int codRef;
  final int codOperacao;
  final String codProdutoComp;
  final int codRefComp;
  final int seq;
  final String descricao;
  final String unidade;

  const ProdutoQuimico({
    required this.codProduto,
    required this.codRef,
    required this.codOperacao,
    required this.codProdutoComp,
    required this.codRefComp,
    required this.seq,
    required this.descricao,
    required this.unidade,
  });
}

final List<ProdutoQuimico> quimicosMock = [
  const ProdutoQuimico(
    codProduto: 'PRP001', codRef: 0, codOperacao: 1000,
    codProdutoComp: '89396', codRefComp: 0, seq: 2,
    descricao: 'CAL VIRGEM 20 KG', unidade: 'kg',
  ),
  const ProdutoQuimico(
    codProduto: 'PRP001', codRef: 0, codOperacao: 1000,
    codProdutoComp: '95001', codRefComp: 0, seq: 3,
    descricao: 'SULFETO DE SODIO 60%', unidade: 'kg',
  ),
  const ProdutoQuimico(
    codProduto: 'PRP001', codRef: 0, codOperacao: 1000,
    codProdutoComp: '95209', codRefComp: 0, seq: 4,
    descricao: 'TENSOATIVO', unidade: 'kg',
  ),
];

// ─────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────
List<VariavelApontamento> getVariaveisPorOperacao(int codOperacao) {
  return variaveisMock.where((v) => v.codOperacao == codOperacao).toList();
}

List<ProdutoQuimico> getQuimicosPorOperacao(int codOperacao) {
  return quimicosMock.where((q) => q.codOperacao == codOperacao).toList();
}

List<SeqOperacao> getRoteiroPorArtigo(String codProduto) {
  return seqOperacoesMock.where((s) => s.codProduto == codProduto).toList();
}

Operacao? getOperacaoPorCodigo(int codOperacao) {
  try {
    return operacoesMock.firstWhere((o) => o.codOperacao == codOperacao);
  } catch (_) {
    return null;
  }
}

// Postos de trabalho disponíveis
const List<String> postosMock = ['ENX', 'RML', 'DIV', 'REB', 'TIN', 'CAL'];
