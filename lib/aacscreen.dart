import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste_flutter/pictogram_data.dart';

class AACScreen extends StatefulWidget {
  const AACScreen({super.key});

  @override
  State<AACScreen> createState() => _AACScreenState();
}

class _AACScreenState extends State<AACScreen> with SingleTickerProviderStateMixin {
  // --- ESTADO DA APLICAÇÃO ---
  // Nova estrutura de dados com categorias
  final Map<String, List<PictogramData>> _categorizedWords = {
  'Pessoas': [
    PictogramData(text: 'eu,', image: 'assets/images/eu.png'),
    PictogramData(text: 'você,', image: 'assets/images/voce.png'),
    PictogramData(text: 'ele,', image: 'assets/images/ele.png'),
    PictogramData(text: 'ela,', image: 'assets/images/ela.png'),
    PictogramData(text: 'nós,', image: 'assets/images/nos.png'),
    PictogramData(text: 'eles,', image: 'assets/images/eles.png'),
    PictogramData(text: 'família,', image: 'assets/images/familia.png'),
    PictogramData(text: 'mãe,', image: 'assets/images/mae.png'),
    PictogramData(text: 'pai,', image: 'assets/images/pai.png'),
    PictogramData(text: 'amigo,', image: 'assets/images/amigo.png'),
  ],

  'Ações': [
    PictogramData(text: 'querer,', image: 'assets/images/querer.png'),
    PictogramData(text: 'ir,', image: 'assets/images/ir.png'),
    PictogramData(text: 'precisar,', image: 'assets/images/precisar.png'),
    PictogramData(text: 'fazer,', image: 'assets/images/fazer.png'),
    PictogramData(text: 'pegar,', image: 'assets/images/pegar.png'),
    PictogramData(text: 'soltar,', image: 'assets/images/soltar.png'),
    PictogramData(text: 'comer,', image: 'assets/images/comer.png'),
    PictogramData(text: 'beber,', image: 'assets/images/beber.png'),
    PictogramData(text: 'brincar,', image: 'assets/images/brincar.png'),
    PictogramData(text: 'parar,', image: 'assets/images/parar.png'),
    PictogramData(text: 'abrir,', image: 'assets/images/abrir.png'),
    PictogramData(text: 'fechar,', image: 'assets/images/fechar.png'),
    PictogramData(text: 'sentar,', image: 'assets/images/sentar.png'),
    PictogramData(text: 'levantar,', image: 'assets/images/levantar.png'),
    PictogramData(text: 'ajudar,', image: 'assets/images/ajudar.png'),
    PictogramData(text: 'olhar,', image: 'assets/images/olhar.png'),
    PictogramData(text: 'ouvir,', image: 'assets/images/ouvir.png'),
    PictogramData(text: 'falar,', image: 'assets/images/falar.png'),
    PictogramData(text: 'mostrar,', image: 'assets/images/mostrar.png'),
    PictogramData(text: 'colocar,', image: 'assets/images/colocar.png'),
    PictogramData(text: 'tirar,', image: 'assets/images/tirar.png'),
    PictogramData(text: 'gostar,', image: 'assets/images/gostar.png'),
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

  bool _isReading = false;
  String? _currentlyReadingText; // Para saber qual pictograma está falando
  late final Map<String, List<PictogramData>> _displayCategories;
  final AudioPlayer _audioPlayer = AudioPlayer();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    // Cria uma lista com todos os pictogramas
    final allPictograms = _categorizedWords.values.expand((list) => list).toList();

    // Monta o mapa de categorias para exibição, com "Todos" primeiro
    _displayCategories = {
      'Todos': allPictograms,
      ..._categorizedWords,
    };

    _tabController = TabController(length: _displayCategories.length, vsync: this);
  }

  // --- FUNÇÕES DE LÓGICA ---

  // Pega o texto de um pictograma e chama a API para ler
  void _speakWord(PictogramData pictogram) async {
    if (_isReading) return;

    setState(() {
      _isReading = true;
      _currentlyReadingText = pictogram.text;
    });

    String textToRead = pictogram.text;
    print('Falando a palavra: $textToRead');

    try {
      // --- CHAMADA À API ELEVENLABS ---
      final apiKey = dotenv.env['ELEVENLABS_API_KEY'];
      final prefs = await SharedPreferences.getInstance();
      // Busca a voz salva, ou usa a padrão do .env como fallback.
      final voiceId = prefs.getString('selected_voice_id') ?? dotenv.env['ELEVENLABS_VOICE_ID'];

      // Verifica se as chaves foram carregadas antes de usá-las
      if (apiKey == null || voiceId == null) {
        print('Erro: Chave da API ou ID da Voz não encontrados no arquivo .env');
        _showErrorDialog('As credenciais da API não foram configuradas corretamente.');
        setState(() {
          _currentlyReadingText = null;
          _isReading = false;
        });
        return;
      }

      final url = Uri.parse('https://api.elevenlabs.io/v1/text-to-speech/$voiceId');
      final headers = {
        'Accept': 'audio/mpeg',
        'Content-Type': 'application/json',
        'xi-api-key': apiKey,
      };
      final body = json.encode({
        'text': textToRead,
        'model_id': 'eleven_multilingual_v2',
        'voice_settings': {
          'stability': 0.5,
          'similarity_boost': 0.75,
        },
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        await _audioPlayer.play(BytesSource(response.bodyBytes));
      } else {
        print('Erro na API: ${response.body}');
        _showErrorDialog('Erro ao gerar o áudio.');
      }
    } catch (e) {
      print('Erro de conexão: $e');
      _showErrorDialog('Erro de conexão ao tentar ler a frase.');
    } finally {
      setState(() {
        _currentlyReadingText = null;
        _isReading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um Erro'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

    // --- CONSTRUÇÃO DA INTERFACE (WIDGETS) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0, // Esconde a barra de ferramentas, mostrando apenas as abas
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // Permite rolar as abas se houver muitas
          tabs: _displayCategories.keys.map((String category) {
            return Tab(text: category);
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        // Mapeia cada lista de pictogramas (incluindo "Todos") para uma grade
        children: _displayCategories.values.map((List<PictogramData> pictograms) {
          return _buildCategoryGrid(pictograms);
        }).toList(),
      ),
    );
  }

  // Constrói a grade de pictogramas para uma categoria específica
  Widget _buildCategoryGrid(List<PictogramData> pictograms) {

    final screenWidth = MediaQuery.of(context).size.width;

    // cada cartão com ~120px
    final crossAxisCount = (screenWidth / 100).floor().clamp(2, 6);

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount, 
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8, // Ajuste a proporção para caber imagem e texto
      ),
      itemCount: pictograms.length,
      itemBuilder: (context, index) {
        final pictogram = pictograms[index];
        final bool isThisOneReading = _isReading && _currentlyReadingText == pictogram.text;

        return GestureDetector(
          onTap: () => _speakWord(pictogram),
          child: Material(
            elevation: 2.0,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(pictogram.image, fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported, size: 50, color: Colors.grey)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pictogram.text.replaceAll(',', ''),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                if (isThisOneReading)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
