import 'models.dart';

/// Serviço de dados em memória.
/// Simula o cadastro de roteiro + ORP CSA001 + Classifi 7.
class MockDataService {
  static final MockDataService _instance = MockDataService._internal();

  factory MockDataService() => _instance;

  MockDataService._internal() {
    _init();
  }

  late final List<ArtigoRoteiro> _artigos;
  late final List<OrdemProducao> _ordens;

  void _init() {
    // Variáveis de REMOLHO (operação 1000)
    final variaveisRemolho = <VariavelApontamento>[
      const VariavelApontamento(
        id: 1,
        seq: 1,
        descricao: 'Volume de água',
        unidade: 'L',
        valorPadrao: '80',
      ),
      const VariavelApontamento(
        id: 2,
        seq: 2,
        descricao: 'Temperatura da água',
        unidade: '°C',
        valorPadrao: '55',
      ),
      const VariavelApontamento(
        id: 3,
        seq: 3,
        descricao: 'Tensoativo',
        unidade: 'kg',
        valorPadrao: '5',
      ),
    ];

    // Variáveis de ENXUGADEIRA (operação 1001)
    final variaveisEnxugadeira = <VariavelApontamento>[
      const VariavelApontamento(
        id: 4,
        seq: 1,
        descricao: 'Pressão 1º manômetro',
        unidade: 'bar',
        valorPadrao: '4.0',
      ),
      const VariavelApontamento(
        id: 5,
        seq: 2,
        descricao: 'Pressão 2º manômetro',
        unidade: 'bar',
        valorPadrao: '4.5',
      ),
      const VariavelApontamento(
        id: 6,
        seq: 3,
        descricao: 'Velocidade feltro',
        unidade: 'm/min',
        valorPadrao: '12',
      ),
      const VariavelApontamento(
        id: 7,
        seq: 4,
        descricao: 'Velocidade tapete',
        unidade: 'm/min',
        valorPadrao: '10',
      ),
    ];

    // Variáveis de DIVISORA (operação 1002)
    final variaveisDivisora = <VariavelApontamento>[
      const VariavelApontamento(
        id: 8,
        seq: 1,
        descricao: 'Velocidade máquina',
        unidade: 'm/min',
        valorPadrao: '8',
      ),
      const VariavelApontamento(
        id: 9,
        seq: 2,
        descricao: 'Distância da navalha',
        unidade: 'mm',
        valorPadrao: '2',
      ),
      const VariavelApontamento(
        id: 10,
        seq: 3,
        descricao: 'Fio navalha inferior',
        unidade: '',
        valorPadrao: 'OK',
      ),
      const VariavelApontamento(
        id: 11,
        seq: 4,
        descricao: 'Fio navalha superior',
        unidade: '',
        valorPadrao: 'OK',
      ),
    ];

    // Etapas do roteiro PRP001 – QUARTZO
    final etapasQuartzo = <EtapaRoteiro>[
      EtapaRoteiro(
        seq: 1,
        codOperacao: 1000,
        descricaoOperacao: 'REMOLHO',
        codPosto: 'ENX',
        variaveis: variaveisRemolho,
      ),
      EtapaRoteiro(
        seq: 2,
        codOperacao: 1001,
        descricaoOperacao: 'ENXUGADEIRA',
        codPosto: 'RML',
        variaveis: variaveisEnxugadeira,
      ),
      EtapaRoteiro(
        seq: 3,
        codOperacao: 1002,
        descricaoOperacao: 'DIVISORA',
        codPosto: 'DIV',
        variaveis: variaveisDivisora,
      ),
    ];

    final artigoQuartzo = ArtigoRoteiro(
      codProdutoRp: 'PRP001',
      codClassif: 7,
      descricaoArtigo: 'QUARTZO',
      etapas: etapasQuartzo,
    );

    _artigos = [artigoQuartzo];

    // ORP CSA001 + Classifi 7 herdando o roteiro do PRP001
    final ordem = OrdemProducao(
      id: 'XYD459939',
      filial: '120',
      documento: 'ORP',
      serie: '3',
      numero: 1,
      dataMovimento: DateTime.now(),
      dataProducao: DateTime.now(),
      dataEstoque: DateTime.now(),
      linhaProducao: 'C90 - Linha Semi Acabado',
      codCliente: 6357,
      nomeCliente: 'Cliente Exemplo',
      codProduto: 'CSA001',
      descricaoProduto: 'QUARTZO BLACK',
      codClassif: 7,
      roteiro: artigoQuartzo,
      itens: const [
        ItemOrdemProducao(
          numItem: 1,
          codProduto: 'CSA001',
          descricaoProduto: 'QUARTZO BLACK',
          quantidade: 100,
        ),
      ],
    );

    _ordens = [ordem];
  }

  // ---- Artigos / Roteiros ----

  List<ArtigoRoteiro> getArtigos() => List.unmodifiable(_artigos);

  ArtigoRoteiro? getArtigoByCodProduto(String cod) {
    try {
      return _artigos.firstWhere((a) => a.codProdutoRp == cod);
    } catch (_) {
      return null;
    }
  }

  // ---- Ordens de Produção ----

  List<OrdemProducao> getOrdens() => List.unmodifiable(_ordens);

  OrdemProducao? getOrdemById(String id) {
    try {
      return _ordens.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  void salvarOrdem(OrdemProducao ordem) {
    // Neste protótipo, a ordem já está na lista.
    // Aqui você poderia futuramente gravar em banco/API.
  }
}
