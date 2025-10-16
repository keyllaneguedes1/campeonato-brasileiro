import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/time_model.dart';

class JsonService {
  static Future<List<Time>> carregarTimes() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1500)); // Simular loading
      
      final String response = await rootBundle.loadString('assets/data/times.json');
      final data = await json.decode(response);
      
      List<Time> times = (data['times'] as List)
          .map((timeJson) => Time.fromJson(timeJson))
          .toList();
      
      // Ordenar por pontos, vitórias, saldo de gols e gols pró
      times.sort((a, b) {
        if (b.pontos != a.pontos) return b.pontos.compareTo(a.pontos);
        if (b.vitorias != a.vitorias) return b.vitorias.compareTo(a.vitorias);
        if (b.saldoGols != a.saldoGols) return b.saldoGols.compareTo(a.saldoGols);
        return b.golsPro.compareTo(a.golsPro);
      });
      
      return times;
    } catch (e) {
      throw Exception('Erro ao carregar dados: $e');
    }
  }
}