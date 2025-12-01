import 'package:flutter/material.dart';
import 'pictogram_data.dart';
import 'dart:io'; // Importa a biblioteca para usar a classe File

class DraggablePictogram extends StatelessWidget {
  final PictogramData data;
  final bool isFromSentence;
  final int reorderIndex;

  const DraggablePictogram({
    super.key,
    required this.data,
    this.isFromSentence = false,
    this.reorderIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final Widget pictogram = Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 3, offset: const Offset(0, 1))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lógica para decidir se a imagem vem dos assets ou de um arquivo
              SizedBox(
                height: 60, // Define uma altura fixa para a imagem
                child: data.image.startsWith('assets/')
                    ? Image.asset(data.image, fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported, size: 40, color: Colors.grey))
                    : data.image.isNotEmpty
                        ? Image.file(File(data.image), fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 40, color: Colors.grey))
                        : const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(data.text.replaceAll(',', ''), style: const TextStyle(fontSize: 16)),
              if (isFromSentence) const SizedBox(height: 12),
            ],
          ),
        ),
        if (isFromSentence)
          Positioned(
            bottom: 2,
            child: ReorderableDragStartListener(
              index: reorderIndex,
              child: const Icon(Icons.drag_handle, color: Colors.grey, size: 20),
            ),
          ),
      ],
    );

    return Draggable<PictogramData>(
      key: ValueKey(data.id ?? data.text),
      data: data,
      feedback: Material(
        elevation: 4.0,
        color: Colors.transparent,
        child: pictogram,
      ),
      childWhenDragging: isFromSentence ? const SizedBox.shrink() : pictogram,
      child: pictogram,
    );
  }
}