class Time {
  final int id;
  final String nome;
  final String escudo;
  final int pontos;
  final int jogos;
  final int vitorias;
  final int empates;
  final int derrotas;
  final int golsPro;
  final int golsContra;
  final List<int> titulos;

  Time({
    required this.id,
    required this.nome,
    required this.escudo,
    required this.pontos,
    required this.jogos,
    required this.vitorias,
    required this.empates,
    required this.derrotas,
    required this.golsPro,
    required this.golsContra,
    required this.titulos,
  });

  int get saldoGols => golsPro - golsContra;
  double get aproveitamento => jogos > 0 ? (pontos / (jogos * 3)) * 100 : 0;

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      id: json['id'],
      nome: json['nome'],
      escudo: json['escudo'],
      pontos: json['pontos'],
      jogos: json['jogos'],
      vitorias: json['vitorias'],
      empates: json['empates'],
      derrotas: json['derrotas'],
      golsPro: json['golsPro'],
      golsContra: json['golsContra'],
      titulos: List<int>.from(json['titulos'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'escudo': escudo,
      'pontos': pontos,
      'jogos': jogos,
      'vitorias': vitorias,
      'empates': empates,
      'derrotas': derrotas,
      'golsPro': golsPro,
      'golsContra': golsContra,
      'titulos': titulos,
    };
  }
}