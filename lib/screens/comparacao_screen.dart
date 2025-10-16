import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../app_colors.dart';
import '../models/time_model.dart';
import '../providers/times_provider.dart';

class ComparacaoScreen extends StatefulWidget {
  const ComparacaoScreen({Key? key}) : super(key: key);

  @override
  _ComparacaoScreenState createState() => _ComparacaoScreenState();
}

class _ComparacaoScreenState extends State<ComparacaoScreen> {
  Time? _time1;
  Time? _time2;
  bool _mostrarResultado = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimesProvider>(context);
    final todosTimes = provider.todosTimes;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comparar Times',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Seleção dos times
            _buildSelecaoTimes(todosTimes),
            const SizedBox(height: 20),
            
            // Botão de comparação
            if (_time1 != null && _time2 != null) 
              _buildBotaoComparar(),
            
            const SizedBox(height: 20),
            
            // Resultado da comparação
            if (_mostrarResultado && _time1 != null && _time2 != null)
              _buildResultadoComparacao(),
              
            // Espaço expandido quando não há resultado
            if (!_mostrarResultado)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Selecione dois times para comparar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelecaoTimes(List<Time> times) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdownTime(
              label: 'Primeiro Time',
              value: _time1,
              onChanged: (Time? time) {
                setState(() {
                  _time1 = time;
                  _mostrarResultado = false;
                });
              },
              times: times,
            ),
            const SizedBox(height: 16),
            _buildDropdownTime(
              label: 'Segundo Time',
              value: _time2,
              onChanged: (Time? time) {
                setState(() {
                  _time2 = time;
                  _mostrarResultado = false;
                });
              },
              times: times,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownTime({
    required String label,
    required Time? value,
    required Function(Time?) onChanged,
    required List<Time> times,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Time>(
              value: value,
              isExpanded: true,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Selecione um time'),
              ),
              items: times.map((Time time) {
                return DropdownMenuItem<Time>(
                  value: time,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Image.asset(
                          time.escudo,
                          width: 24,
                          height: 24,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.flag, size: 16),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            time.nome,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotaoComparar() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _mostrarResultado = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics),
            SizedBox(width: 8),
            Text(
              'Comparar Times',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Os métodos _buildResultadoComparacao, _buildCabecalhoComparacao, etc.
  // permanecem os mesmos do código original, apenas atualize as cores
  // onde houver referências ao verde (Colors.green) para AppColors.accent

  Widget _buildResultadoComparacao() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCabecalhoComparacao(),
            const SizedBox(height: 24),
            _buildGraficoPontos(),
            const SizedBox(height: 24),
            _buildEstatisticasComparativas(),
            const SizedBox(height: 24),
            _buildGraficoDesempenho(),
            const SizedBox(height: 24),
            _buildComparacaoGols(),
          ],
        ),
      ),
    );
  }

  Widget _buildCabecalhoComparacao() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            _buildTimeHeader(_time1!, Color(0xFF3498DB)),
            const Expanded(
              child: Column(
                children: [
                  Icon(Icons.sports_soccer, size: 40, color: Colors.grey),
                  Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            _buildTimeHeader(_time2!, Color(0xFFE74C3C)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeHeader(Time time, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: color, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(38),
              child: Image.asset(
                time.escudo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.flag, size: 40, color: color),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            time.nome,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${time.pontos} pts',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ... (os outros métodos _buildGraficoPontos, _buildEstatisticasComparativas, etc.
  // permanecem iguais, apenas atualize as cores se necessário)

  Widget _buildGraficoPontos() {
    final maxPontos = [_time1!.pontos, _time2!.pontos].reduce((a, b) => a > b ? a : b);
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comparação de Pontos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxPontos.toDouble() * 1.2,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              value == 0 ? _time1!.nome : _time2!.nome,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: _time1!.pontos.toDouble(),
                          color: Color(0xFF3498DB),
                          width: 30,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: _time2!.pontos.toDouble(),
                          color: Color(0xFFE74C3C),
                          width: 30,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstatisticasComparativas() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estatísticas Comparativas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatComparada('Pontos', _time1!.pontos, _time2!.pontos, Icons.emoji_events),
            _buildStatComparada('Vitórias', _time1!.vitorias, _time2!.vitorias, Icons.thumb_up),
            _buildStatComparada('Empates', _time1!.empates, _time2!.empates, Icons.swap_horiz),
            _buildStatComparada('Derrotas', _time1!.derrotas, _time2!.derrotas, Icons.thumb_down),
            _buildStatComparada('Saldo de Gols', _time1!.saldoGols, _time2!.saldoGols, Icons.trending_up),
            _buildStatComparada('Aproveitamento', _time1!.aproveitamento.round(), _time2!.aproveitamento.round(), Icons.percent),
          ],
        ),
      ),
    );
  }

  Widget _buildStatComparada(String label, int valor1, int valor2, IconData icon) {
    final vencedor = valor1 > valor2 ? 1 : (valor2 > valor1 ? 2 : 0);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
          ),
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: vencedor == 1 ? Color(0xFF3498DB).withOpacity(0.2) : Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: vencedor == 1 ? Color(0xFF3498DB) : Colors.transparent,
              ),
            ),
            child: Text(
              valor1.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: vencedor == 1 ? FontWeight.bold : FontWeight.normal,
                color: vencedor == 1 ? Color(0xFF3498DB) : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: vencedor == 2 ? Color(0xFFE74C3C).withOpacity(0.2) : Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: vencedor == 2 ? Color(0xFFE74C3C) : Colors.transparent,
              ),
            ),
            child: Text(
              valor2.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: vencedor == 2 ? FontWeight.bold : FontWeight.normal,
                color: vencedor == 2 ? Color(0xFFE74C3C) : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraficoDesempenho() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Desempenho (%)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: _buildPieChartTime(_time1!, Color(0xFF3498DB)),
                  ),
                  Expanded(
                    child: _buildPieChartTime(_time2!, Color(0xFFE74C3C)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartTime(Time time, Color color) {
    return Column(
      children: [
        Text(
          time.nome,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: time.vitorias.toDouble(),
                  color: Colors.green,
                  title: '${((time.vitorias / time.jogos) * 100).toStringAsFixed(0)}%',
                  radius: 40,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: time.empates.toDouble(),
                  color: Colors.orange,
                  title: '${((time.empates / time.jogos) * 100).toStringAsFixed(0)}%',
                  radius: 40,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: time.derrotas.toDouble(),
                  color: Colors.red,
                  title: '${((time.derrotas / time.jogos) * 100).toStringAsFixed(0)}%',
                  radius: 40,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
              centerSpaceRadius: 20,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildLegendaDesempenho(),
      ],
    );
  }

  Widget _buildLegendaDesempenho() {
    return Column(
      children: [
        _buildItemLegenda('Vitórias', Colors.green),
        _buildItemLegenda('Empates', Colors.orange),
        _buildItemLegenda('Derrotas', Colors.red),
      ],
    );
  }

  Widget _buildItemLegenda(String texto, Color cor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 12,
            height: 12,
            color: cor,
          ),
          const SizedBox(width: 4),
          Text(
            texto,
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildComparacaoGols() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Eficiência Ofensiva/Defensiva',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildBarraGols('Gols Pró', _time1!.golsPro, _time2!.golsPro, Colors.green),
            const SizedBox(height: 12),
            _buildBarraGols('Gols Contra', _time1!.golsContra, _time2!.golsContra, Colors.red),
            const SizedBox(height: 12),
            _buildBarraGols('Saldo de Gols', _time1!.saldoGols, _time2!.saldoGols, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildBarraGols(String label, int valor1, int valor2, Color color) {
    final maxValor = [valor1, valor2].reduce((a, b) => a.abs() > b.abs() ? a.abs() : b.abs());
    final maxWidth = maxValor.toDouble();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 30,
                    width: (valor1.abs() / (maxWidth == 0 ? 1 : maxWidth)) * MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        valor1.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 30,
                    width: (valor2.abs() / (maxWidth == 0 ? 1 : maxWidth)) * MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        valor2.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}