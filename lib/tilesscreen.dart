import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'pictogram_data.dart'; 
import 'package:teste_flutter/pictogram_repository.dart';
import 'package:teste_flutter/add_pictogram_dialog.dart';
import 'sentence_box.dart'; 
import 'component_box.dart'; 

class Tilesscreen extends StatefulWidget {
  const Tilesscreen({super.key});

  @override
  State<Tilesscreen> createState() => _AACScreenStatee();
}

class _AACScreenStatee extends State<Tilesscreen> with SingleTickerProviderStateMixin { 
  // --- ESTADO DA APLICAÇÃO ---
  final List<PictogramData> _sentenceWords = [];
  int _nextWordId = 0;

  bool _isReading = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final Map<String, List<PictogramData>> _displayCategories;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _updateDisplayCategories();
    PictogramRepository().addListener(_updateDisplayCategories);
  }

  Future<void> _addPictogram() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => const AddPictogramDialog(),
    );

    if (result != null) {
      final newPictogram = result['pictogram'] as PictogramData;
      final category = result['category'] as String;
      PictogramRepository().addPictogram(category, newPictogram);
    }
  }

  void _updateDisplayCategories() {
    final repository = PictogramRepository();
    final allPictograms = repository.categorizedWords.values.expand((list) => list).toList();

    setState(() {
      _displayCategories = {
        'Todos': allPictograms,
        ...repository.categorizedWords,
      };
      _tabController?.dispose();
      _tabController = TabController(
        length: _displayCategories.length,
        vsync: this,
      );
    });
  }

  // --- FUNÇÕES DE LÓGICA ---

  // Gera a string da frase e chama a API para ler
  void _readSentence() async {
    if (_sentenceWords.isEmpty || _isReading) return;

    setState(() {
      _isReading = true;
    });

    String textToRead = _sentenceWords.map((word) => word.text).join(' ');
    print('Frase formada: $textToRead');

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
    PictogramRepository().removeListener(_updateDisplayCategories);
    _audioPlayer.dispose();
    super.dispose();
  }

  // --- CONSTRUÇÃO DA INTERFACE (WIDGETS) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Adiciona um Scaffold para poder usar o FloatingActionButton
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Caixa de Texto (Frase + Botão Ler)
            SentenceBox(
              sentenceWords: _sentenceWords,
              isReading: _isReading,
              onPlay: _readSentence,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _sentenceWords.removeAt(oldIndex);
                  _sentenceWords.insert(newIndex, item);
                });
              },
              onAccept: (data) {
                setState(() {
                  if (data.isClone) {
                    _sentenceWords.add(data.copyWith(id: _nextWordId++, isClone: false));
                  }
                });
              },
            ),
            const SizedBox(height: 10),

            // 2. Caixa de Componentes
            Expanded(
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: _displayCategories.keys.map((String category) {
                      return Tab(text: category);
                    }).toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: _displayCategories.values.map((pictograms) => ComponentBox(componentWords: pictograms)).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPictogram,
        tooltip: 'Adicionar Ficha',
        child: const Icon(Icons.add),
      ),
    );
  }
}
