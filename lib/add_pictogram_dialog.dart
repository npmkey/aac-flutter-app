import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Para File
import 'package:teste_flutter/pictogram_data.dart';
import 'package:teste_flutter/pictogram_repository.dart';

class AddPictogramDialog extends StatefulWidget {
  const AddPictogramDialog({super.key});

  @override
  State<AddPictogramDialog> createState() => _AddPictogramDialogState();
}

class _AddPictogramDialogState extends State<AddPictogramDialog> {
  final _textController = TextEditingController();
  String? _imagePath;
  String? _selectedCategory;
  final _formKey = GlobalKey<FormState>();

  List<String> _availableCategories = [];

  @override
  void initState() {
    super.initState();
    // Inicializa as categorias disponíveis a partir do repositório
    _availableCategories = PictogramRepository().categorizedWords.keys.toList();
    if (_availableCategories.isNotEmpty) {
      _selectedCategory = _availableCategories.first;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Novo Pictograma'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(labelText: 'Texto do Pictograma'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um texto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: _availableCategories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma categoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _imagePath != null
                  ? Image.file(File(_imagePath!), height: 100)
                  : const Text('Nenhuma imagem selecionada'),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Selecionar Imagem (Opcional)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o dialog sem adicionar
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newPictogram = PictogramData(
                text: _textController.text,
                image: _imagePath ?? '', // Usa string vazia se nenhuma imagem for selecionada
              );
              Navigator.of(context).pop({'pictogram': newPictogram, 'category': _selectedCategory});
            }
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}