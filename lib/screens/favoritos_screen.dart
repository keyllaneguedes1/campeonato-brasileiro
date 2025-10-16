import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart';
import '../models/time_model.dart';
import '../providers/times_provider.dart';
import '../widgets/classificacao_item.dart';
import 'detalhes_time_screen.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({Key? key}) : super(key: key);

  Color _getZonaColor(int posicao) {
    if (posicao <= 4) return AppColors.libertadores;
    if (posicao <= 6) return AppColors.preLibertadores;
    if (posicao <= 12) return AppColors.sulAmericana;
    if (posicao >= 17) return AppColors.rebaixamento;
    return Colors.grey[200]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Times Favoritos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Consumer<TimesProvider>(
            builder: (context, provider, child) {
              final favoritosCount = provider.favoritos.length;
              if (favoritosCount > 0) {
                return Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite, color: AppColors.accent),
                      onPressed: () {},
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          favoritosCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return IconButton(
                icon: Icon(Icons.favorite, color: AppColors.accent),
                onPressed: () {},
              );
            },
          ),
        ],
      ),
      body: Consumer<TimesProvider>(
        builder: (context, provider, child) {
          final timesFavoritos = provider.getTimesFavoritos();
          
          if (provider.loading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Carregando...'),
                ],
              ),
            );
          }

          if (timesFavoritos.isEmpty) {
            return _buildEmptyState(context);
          }

          return Column(
            children: [
              
              _buildHeaderStats(context, timesFavoritos),
              
              
              Expanded(
                child: _buildListaFavoritos(context, provider, timesFavoritos),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum time favorito',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Toque no coração ❤️ na tela de classificação para adicionar times aos favoritos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.emoji_events),
              label: const Text('Ver Classificação'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStats(BuildContext context, List<Time> timesFavoritos) {
    final totalPontos = timesFavoritos.fold(0, (sum, time) => sum + time.pontos);
    final mediaPontos = timesFavoritos.isNotEmpty ? totalPontos / timesFavoritos.length : 0;
    final timesLibertadores = timesFavoritos.where((time) {
      final posicao = _findPosicaoTime(context, time);
      return posicao <= 4;
    }).length;
    final timesRebaixados = timesFavoritos.where((time) {
      final posicao = _findPosicaoTime(context, time);
      return posicao >= 17;
    }).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.accent.withOpacity(0.05),
        ],
        ),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meus Favoritos (${timesFavoritos.length})',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildStatChip(
                'Média de Pontos',
                mediaPontos.toStringAsFixed(1),
                Icons.emoji_events,
                Colors.orange,
              ),
              _buildStatChip(
                'Na Libertadores',
                timesLibertadores.toString(),
                Icons.flag,
                AppColors.libertadores,
              ),
              _buildStatChip(
                'Rebaixados',
                timesRebaixados.toString(),
                Icons.warning,
                AppColors.rebaixamento,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaFavoritos(BuildContext context, TimesProvider provider, List<Time> timesFavoritos) {
    timesFavoritos.sort((a, b) {
      final posA = _findPosicaoTime(context, a);
      final posB = _findPosicaoTime(context, b);
      return posA.compareTo(posB);
    });

    return ListView.builder(
      itemCount: timesFavoritos.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final time = timesFavoritos[index];
        final posicao = _findPosicaoTime(context, time);
        
        return Dismissible(
          key: Key('favorito_${time.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
          ),
          confirmDismiss: (direction) async {
            return await _showConfirmacaoRemover(context, time.nome);
          },
          onDismissed: (direction) {
            provider.toggleFavorito(time.id);
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${time.nome} removido dos favoritos'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Desfazer',
                  textColor: Colors.white,
                  onPressed: () {
                    provider.toggleFavorito(time.id);
                  },
                ),
              ),
            );
          },
          child: ClassificacaoItem(
            time: time,
            posicao: posicao,
            corFundo: _getZonaColor(posicao),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesTimeScreen(time: time),
                ),
              );
            },
          ),
        );
      },
    );
  }

  int _findPosicaoTime(BuildContext context, Time time) {
    final provider = Provider.of<TimesProvider>(context, listen: false);
    final todosTimes = provider.todosTimes;
    final index = todosTimes.indexWhere((t) => t.id == time.id);
    return index + 1;
  }

  Future<bool> _showConfirmacaoRemover(BuildContext context, String nomeTime) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover dos favoritos?', style: TextStyle(color: AppColors.primary)),
          content: Text('Tem certeza que deseja remover $nomeTime dos seus favoritos?', style: TextStyle(color: AppColors.textSecondary)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancelar', style: TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Remover',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }
}