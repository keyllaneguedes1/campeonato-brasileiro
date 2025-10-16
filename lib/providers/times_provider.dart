import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/time_model.dart';
import '../services/json_service.dart';

class TimesProvider with ChangeNotifier {
  List<Time> _times = [];
  List<Time> _timesFiltrados = [];
  List<int> _favoritos = [];
  bool _loading = false;
  String _error = '';
  bool _modoEscuro = false;

  List<Time> get times => _timesFiltrados;
  List<Time> get todosTimes => _times;
  List<int> get favoritos => _favoritos;
  bool get loading => _loading;
  String get error => _error;
  bool get modoEscuro => _modoEscuro;

  TimesProvider() {
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    _modoEscuro = prefs.getBool('modoEscuro') ?? false;
    final favoritosSalvos = prefs.getStringList('favoritos');
    if (favoritosSalvos != null) {
      _favoritos = favoritosSalvos.map(int.parse).toList();
    }
    notifyListeners();
  }

  Future<void> _salvarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favoritos',
      _favoritos.map((id) => id.toString()).toList(),
    );
  }

  Future<void> toggleModoEscuro() async {
    _modoEscuro = !_modoEscuro;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modoEscuro', _modoEscuro);
    notifyListeners();
  }

  Future<void> carregarDados() async {
    _loading = true;
    _error = '';
    notifyListeners();

    try {
      _times = await JsonService.carregarTimes();
      _timesFiltrados = _times;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void filtrarTimes(String query) {
    if (query.isEmpty) {
      _timesFiltrados = _times;
    } else {
      _timesFiltrados = _times
          .where((time) =>
              time.nome.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void toggleFavorito(int timeId) {
    if (_favoritos.contains(timeId)) {
      _favoritos.remove(timeId);
    } else {
      _favoritos.add(timeId);
    }
    _salvarFavoritos();
    notifyListeners();
  }

  bool isFavorito(int timeId) => _favoritos.contains(timeId);

  List<Time> getTimesFavoritos() {
    return _times.where((time) => _favoritos.contains(time.id)).toList();
  }

  Time encontrarTimePorId(int id) {
    return _times.firstWhere((time) => time.id == id);
  }

  List<Time> compararTimes(int time1Id, int time2Id) {
    final time1 = encontrarTimePorId(time1Id);
    final time2 = encontrarTimePorId(time2Id);
    return [time1, time2];
  }
}