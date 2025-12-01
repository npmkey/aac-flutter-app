import 'package:flutter/foundation.dart';
import 'package:teste_flutter/pictogram_data.dart';

/// Repositório central para os dados dos pictogramas.
/// Manter este mapa em um único local evita duplicação de código
/// e facilita a manutenção.
class PictogramRepository extends ChangeNotifier {
  // Padrão Singleton para garantir uma única instância do repositório.
  static final PictogramRepository _instance = PictogramRepository._internal();
  factory PictogramRepository() {
    return _instance;
  }
  PictogramRepository._internal();

  final Map<String, List<PictogramData>> _categorizedWords = {
    'Pessoas': [
      PictogramData(text: 'eu,', image: 'assets/images/eu.png'),
      PictogramData(text: 'você,', image: 'assets/images/voce.png'),
      PictogramData(text: 'ele,', image: 'assets/images/ele.png'),
      PictogramData(text: 'ela,', image: 'assets/images/ela.png'),
    ],
    'Ações': [
      PictogramData(text: 'brincar,', image: 'assets/images/brincar.png'),
      PictogramData(text: 'correr,', image: 'assets/images/correr.png'),
      PictogramData(text: 'dormir,', image: 'assets/images/dormir.png'),
      PictogramData(text: 'comer,', image: 'assets/images/comer.png'),
      PictogramData(text: 'beber', image: 'assets/images/beber.png'),
      PictogramData(text: 'sentar,', image: 'assets/images/sentar.png'),
      PictogramData(text: 'pegar,', image: 'assets/images/pegar.png'),
      PictogramData(text: 'soltar,', image: 'assets/images/soltar.png'),
      PictogramData(text: 'abrir,', image: 'assets/images/abrir.png'),
      PictogramData(text: 'amar,', image: 'assets/images/amar.png'),
    ],
    'Respostas': [
      PictogramData(text: 'sim,', image: 'assets/images/sim.png'),
      PictogramData(text: 'não,', image: 'assets/images/nao.png'),
      PictogramData(text: 'talvez,', image: 'assets/images/talvez.png'),
      PictogramData(text: 'ok,', image: 'assets/images/ok.png'),
      PictogramData(text: 'pronto,', image: 'assets/images/pronto.png'),
    ],
    'Coisas': [
      PictogramData(text: 'água,', image: 'assets/images/agua.png'),
      PictogramData(text: 'comida,', image: 'assets/images/comida.png'),
      PictogramData(text: 'roupa,', image: 'assets/images/roupa.png'),
      PictogramData(text: 'brinquedo,', image: 'assets/images/brinquedo.png'),
      PictogramData(text: 'copo,', image: 'assets/images/copo.png'),
      PictogramData(text: 'celular,', image: 'assets/images/celular.png'),
      PictogramData(text: 'livro,', image: 'assets/images/livro.png'),
      PictogramData(text: 'mesa,', image: 'assets/images/mesa.png'),
      PictogramData(text: 'cadeira,', image: 'assets/images/cadeira.png'),
    ],
    'Locais': [
      PictogramData(text: 'casa,', image: 'assets/images/casa.png'),
      PictogramData(text: 'escola,', image: 'assets/images/escola.png'),
      PictogramData(text: 'banheiro,', image: 'assets/images/banheiro.png'),
      PictogramData(text: 'cozinha,', image: 'assets/images/cozinha.png'),
      PictogramData(text: 'quarto,', image: 'assets/images/quarto.png'),
      PictogramData(text: 'fora,', image: 'assets/images/fora.png'),
      PictogramData(text: 'dentro,', image: 'assets/images/dentro.png'),
      PictogramData(text: 'carro,', image: 'assets/images/carro.png'),
    ],
    'Sentimentos': [
      PictogramData(text: 'feliz,', image: 'assets/images/feliz.png'),
      PictogramData(text: 'triste,', image: 'assets/images/triste.png'),
      PictogramData(text: 'bravo,', image: 'assets/images/bravo.png'),
      PictogramData(text: 'assustado,', image: 'assets/images/assustado.png'),
      PictogramData(text: 'cansado,', image: 'assets/images/cansado.png'),
      PictogramData(text: 'com medo,', image: 'assets/images/medo.png'),
      PictogramData(text: 'calmo,', image: 'assets/images/calmo.png'),
    ],
    'Perguntas': [
      PictogramData(text: 'o quê?', image: 'assets/images/oque.png'),
      PictogramData(text: 'quem?', image: 'assets/images/quem.png'),
      PictogramData(text: 'onde?', image: 'assets/images/onde.png'),
      PictogramData(text: 'quando?', image: 'assets/images/quando.png'),
      PictogramData(text: 'por quê?', image: 'assets/images/porque.png'),
      PictogramData(text: 'como?', image: 'assets/images/como.png'),
    ],
    'Descrições': [
      PictogramData(text: 'bom,', image: 'assets/images/bom.png'),
      PictogramData(text: 'ruim,', image: 'assets/images/ruim.png'),
      PictogramData(text: 'grande,', image: 'assets/images/grande.png'),
      PictogramData(text: 'pequeno,', image: 'assets/images/pequeno.png'),
      PictogramData(text: 'quente,', image: 'assets/images/quente.png'),
      PictogramData(text: 'frio,', image: 'assets/images/frio.png'),
      PictogramData(text: 'rápido,', image: 'assets/images/rapido.png'),
      PictogramData(text: 'devagar,', image: 'assets/images/devagar.png'),
      PictogramData(text: 'bonito,', image: 'assets/images/bonito.png'),
      PictogramData(text: 'feio,', image: 'assets/images/feio.png'),
    ],
    'Conectores': [
      PictogramData(text: 'e,', image: 'assets/images/e.png'),
      PictogramData(text: 'mas,', image: 'assets/images/mas.png'),
      PictogramData(text: 'porque,', image: 'assets/images/porque.png'),
      PictogramData(text: 'então,', image: 'assets/images/entao.png'),
      PictogramData(text: 'com,', image: 'assets/images/com.png'),
      PictogramData(text: 'sem,', image: 'assets/images/sem.png'),
    ],
  };

  Map<String, List<PictogramData>> get categorizedWords => _categorizedWords;

  void addPictogram(String category, PictogramData pictogram) {
    // Adiciona o pictograma à categoria especificada.
    _categorizedWords[category]?.add(pictogram);
    // Notifica todos os 'ouvintes' (as telas) que houve uma mudança.
    notifyListeners();
  }
}