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
      PictogramData(text: 'Eu,', image: 'assets/images/eu.png'),
      PictogramData(text: 'você,', image: 'assets/images/voce.png'),
    ],
    'Ações': [
      PictogramData(text: 'amo,', image: 'assets/images/amo.png'),
      // Adicione mais verbos aqui
    ],
    'Respostas': [
      PictogramData(text: 'sim,', image: 'assets/images/eu.png'),
      PictogramData(text: 'não,', image: 'assets/images/amo.png'),
    ],
    'Coisas': [
      PictogramData(text: 'água,', image: 'assets/images/voce.png'),
      // Adicione mais substantivos aqui
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
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 ícones por linha
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9, // Ajuste a proporção para caber imagem e texto
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
