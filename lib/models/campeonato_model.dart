import 'time_model.dart';

class Campeonato {
  final List<Time> times;
  final DateTime atualizadoEm;

  Campeonato({
    required this.times,
    required this.atualizadoEm,
  });

  factory Campeonato.fromJson(Map<String, dynamic> json) {
    List<Time> timesList = (json['times'] as List)
        .map((timeJson) => Time.fromJson(timeJson))
        .toList();

    // Ordenar por pontos, vitórias, saldo de gols e gols pró
    timesList.sort((a, b) {
      if (b.pontos != a.pontos) return b.pontos.compareTo(a.pontos);
      if (b.vitorias != a.vitorias) return b.vitorias.compareTo(a.vitorias);
      if (b.saldoGols != a.saldoGols) return b.saldoGols.compareTo(a.saldoGols);
      return b.golsPro.compareTo(a.golsPro);
    });

    return Campeonato(
      times: timesList,
      atualizadoEm: DateTime.parse(json['atualizadoEm']),
    );
  }
}