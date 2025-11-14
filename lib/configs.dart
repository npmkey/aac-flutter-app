import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoiceOption {
  final String name;
  final String voiceId;

  const VoiceOption({required this.name, required this.voiceId});
}

class Configs extends StatefulWidget {
  const Configs({super.key});

  @override
  State<Configs> createState() => _ConfigsState();
}

class _ConfigsState extends State<Configs> {
  String? _selectedVoiceId;

  // Lista de vozes disponíveis. A primeira é a padrão do seu .env
  final List<VoiceOption> _voiceOptions = [
    VoiceOption(name: 'Voz Masculina Jovem', voiceId: dotenv.env['ELEVENLABS_VOICE_ID'] ?? 'GhkQkxbimoIykF4iGYqh'),
    const VoiceOption(name: 'Voz Padrão Feminina', voiceId: 'GFPGeIuI7dxt6YeFLE7l'),
    const VoiceOption(name: 'Voz Padrão Masculina', voiceId: 'tS45q0QcrDHqHoaWdCDR'),
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedVoice();
  }

  Future<void> _loadSelectedVoice() async {
    final prefs = await SharedPreferences.getInstance();
    // Carrega a voz salva, ou usa a padrão se nenhuma foi salva ainda.
    setState(() {
      _selectedVoiceId = prefs.getString('selected_voice_id') ?? _voiceOptions.first.voiceId;
    });
  }

  Future<void> _setSelectedVoice(String voiceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_voice_id', voiceId);
    setState(() {
      _selectedVoiceId = voiceId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Escolha de Voz', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        ..._voiceOptions.map((option) => RadioListTile<String>(
              title: Text(option.name),
              value: option.voiceId,
              groupValue: _selectedVoiceId,
              onChanged: (value) {
                if (value != null) {
                  _setSelectedVoice(value);
                }
              },
            )),
      ],
    );
  }
}