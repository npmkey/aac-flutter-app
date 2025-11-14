import 'package:flutter/material.dart';
import 'pictogram_data.dart';
import 'draggable_pictogram.dart';

class SentenceBox extends StatelessWidget {
  final List<PictogramData> sentenceWords;
  final bool isReading;
  final VoidCallback onPlay;
  final Function(PictogramData) onAccept;
  final Function(int, int) onReorder;

  const SentenceBox({
    super.key,
    required this.sentenceWords,
    required this.isReading,
    required this.onPlay,
    required this.onAccept,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFdfefff),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: DragTarget<PictogramData>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  height: 137,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: candidateData.isNotEmpty ? Colors.blue.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: sentenceWords.isEmpty
                      ? const Center(child: Text('Arraste aqui', style: TextStyle(color: Colors.grey)))
                      : ReorderableListView(
                          buildDefaultDragHandles: false,
                          scrollDirection: Axis.horizontal,
                          onReorder: onReorder,
                          children: sentenceWords
                              .map((word) => DraggablePictogram(
                                    key: ValueKey(word.id), // Chave é crucial para reordenar
                                    data: word,
                                    isFromSentence: true,
                                    reorderIndex: sentenceWords.indexOf(word),
                                  ))
                              .toList(),
                        ),
                );
              },
              onAccept: onAccept,
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: onPlay,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
            ),
            child: isReading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : const Icon(Icons.play_arrow, size: 30),
          ),
        ],
      ),
    );
  }
}