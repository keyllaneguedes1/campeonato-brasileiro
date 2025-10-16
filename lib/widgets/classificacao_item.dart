import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_colors.dart';
import '../models/time_model.dart';
import '../providers/times_provider.dart';

class ClassificacaoItem extends StatelessWidget {
  final Time time;
  final int posicao;
  final Color corFundo;
  final VoidCallback onTap;

  const ClassificacaoItem({
    super.key,
    required this.time,
    required this.posicao,
    required this.corFundo,
    required this.onTap,
  });

  String _getZonaTexto(int posicao) {
    if (posicao <= 4) return 'LIB';
    if (posicao <= 6) return 'PRE';
    if (posicao <= 12) return 'SUL';
    if (posicao >= 17) return 'ZR';
    return '';
  }

  Color _getZonaColor(int posicao) {
    if (posicao <= 4) return AppColors.libertadores;
    if (posicao <= 6) return AppColors.preLibertadores;
    if (posicao <= 12) return AppColors.sulAmericana;
    if (posicao >= 17) return AppColors.rebaixamento;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimesProvider>(context);
    final bool isFavorito = provider.isFavorito(time.id);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            height: 60,
            child: Row(
              children: [
                // POSIÇÃO
                SizedBox(
                  width: 40,
                  child: Text(
                    posicao.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
                // ESCUDO E NOME
                SizedBox(
                  width: 150,
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 8),
                        child: Image.asset(
                          time.escudo,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(Icons.flag, size: 16, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Text(
                          time.nome,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // ESTATÍSTICAS
                _buildCelula(time.pontos.toString(), 50, true),
                _buildCelula(time.jogos.toString(), 40, false),
                _buildCelula(time.vitorias.toString(), 40, false),
                _buildCelula(time.empates.toString(), 40, false),
                _buildCelula(time.derrotas.toString(), 40, false),
                _buildCelula(time.golsPro.toString(), 40, false),
                _buildCelula(time.golsContra.toString(), 40, false),
                _buildCelula(
                  '${time.saldoGols > 0 ? '+' : ''}${time.saldoGols}',
                  50,
                  true,
                  color: time.saldoGols > 0 
                      ? Colors.green 
                      : time.saldoGols < 0 
                          ? Colors.red 
                          : Colors.grey,
                ),
                // AÇÕES
                SizedBox(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorito ? Icons.favorite : Icons.favorite_border,
                          color: isFavorito ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          provider.toggleFavorito(time.id);
                        },
                        padding: EdgeInsets.zero,
                      ),
                      if (_getZonaTexto(posicao).isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getZonaColor(posicao).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _getZonaColor(posicao).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            _getZonaTexto(posicao),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getZonaColor(posicao),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCelula(String texto, double largura, bool negrito, {Color? color}) {
    return Container(
      width: largura,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: negrito ? FontWeight.bold : FontWeight.normal,
          color: color ?? Colors.black,
        ),
      ),
    );
  }
}