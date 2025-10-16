import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart';
import '../providers/times_provider.dart';
import '../models/time_model.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom_widgets;
import 'detalhes_time_screen.dart';
import 'comparacao_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TimesProvider>().carregarDados();
    });
  }

  Color _getZonaColor(int posicao) {
    if (posicao <= 4) return AppColors.libertadores;
    if (posicao <= 6) return AppColors.preLibertadores;
    if (posicao <= 12) return AppColors.sulAmericana;
    if (posicao >= 17) return AppColors.rebaixamento;
    return Colors.transparent;
  }

  Color _getRowColor(int posicao) {
    if (posicao <= 4) return AppColors.libertadores.withOpacity(0.1);
    if (posicao <= 6) return AppColors.preLibertadores.withOpacity(0.1);
    if (posicao <= 12) return AppColors.sulAmericana.withOpacity(0.1);
    if (posicao >= 17) return AppColors.rebaixamento.withOpacity(0.1);
    return Colors.transparent;
  }

  Widget _buildClassificacao() {
    return Consumer<TimesProvider>(
      builder: (context, provider, child) {
        if (provider.loading) {
          return const LoadingWidget();
        }

        if (provider.error.isNotEmpty) {
          return custom_widgets.ErrorWidget(
            error: provider.error,
            onRetry: () => provider.carregarDados(),
          );
        }

        return Column(
          children: [
            // BARRA DE BUSCA
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar time',
                  hintText: 'Digite o nome do time...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                onChanged: (value) {
                  provider.filtrarTimes(value);
                },
              ),
            ),
            
            // LEGENDA DAS CORES
            _buildLegendaCores(),
            const SizedBox(height: 8),
            
            // TABELA
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _buildTabela(provider.times),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendaCores() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          _buildItemLegenda('Libertadores', AppColors.libertadores),
          _buildItemLegenda('Pré-Libertadores', AppColors.preLibertadores),
          _buildItemLegenda('Sul-Americana', AppColors.sulAmericana),
          _buildItemLegenda('Zona de Rebaixamento', AppColors.rebaixamento),
        ],
      ),
    );
  }

  Widget _buildItemLegenda(String texto, Color cor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          texto,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildTabela(List<Time> times) {
    return DataTable(
      headingRowColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) => AppColors.primary.withOpacity(0.1),
      ),
      columns: const [
        DataColumn(label: Text('Pos', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Time', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('PTS', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
        DataColumn(label: Text('PJ', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
        DataColumn(label: Text('V', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
        DataColumn(label: Text('E', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
        DataColumn(label: Text('D', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
        DataColumn(label: Text('GP', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
        DataColumn(label: Text('GC', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
        DataColumn(label: Text('SG', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
        DataColumn(label: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: times.asMap().entries.map((entry) {
        final index = entry.key;
        final time = entry.value;
        final posicao = index + 1;
        final zonaColor = _getRowColor(posicao);
        
        return DataRow(
          color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return zonaColor.withOpacity(0.3);
              }
              return zonaColor;
            },
          ),
          cells: [
            DataCell(
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: _getZonaColor(posicao),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  posicao.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            DataCell(
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalhesTimeScreen(time: time),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          time.escudo,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.flag, size: 16, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        time.nome,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DataCell(
              Center(
                child: Text(
                  time.pontos.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            DataCell(Center(child: Text(time.jogos.toString()))),
            DataCell(Center(child: Text(time.vitorias.toString()))),
            DataCell(Center(child: Text(time.empates.toString()))),
            DataCell(Center(child: Text(time.derrotas.toString()))),
            DataCell(Center(child: Text(time.golsPro.toString()))),
            DataCell(Center(child: Text(time.golsContra.toString()))),
            DataCell(
              Center(
                child: Text(
                  '${time.saldoGols > 0 ? '+' : ''}${time.saldoGols}',
                  style: TextStyle(
                    color: time.saldoGols > 0 ? Colors.green : time.saldoGols < 0 ? Colors.red : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            DataCell(
              Consumer<TimesProvider>(
                builder: (context, provider, child) {
                  final isFavorito = provider.isFavorito(time.id);
                  return IconButton(
                    icon: Icon(
                      isFavorito ? Icons.favorite : Icons.favorite_border,
                      color: isFavorito ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                    onPressed: () => provider.toggleFavorito(time.id),
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildFavoritos() {
    return Consumer<TimesProvider>(
      builder: (context, provider, child) {
        final favoritos = provider.getTimesFavoritos();
        
        if (favoritos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Nenhum time favorito', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                const SizedBox(height: 8),
                Text('Toque no coração para adicionar favoritos', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => setState(() => _selectedIndex = 0),
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('Ver Classificação'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // LEGENDA DAS CORES
            _buildLegendaCores(),
            const SizedBox(height: 8),
            
            // TABELA DE FAVORITOS
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: _buildTabela(favoritos),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campeonato Brasileiro', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.compare_arrows, color: AppColors.accent),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ComparacaoScreen())),
          ),
          Consumer<TimesProvider>(
            builder: (context, provider, child) => IconButton(
              icon: Icon(provider.modoEscuro ? Icons.light_mode : Icons.dark_mode, color: AppColors.accent),
              onPressed: () => provider.toggleModoEscuro(),
            ),
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildClassificacao() : _buildFavoritos(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Classificação'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        ],
      ),
    );
  }
}