import 'package:flutter/material.dart';
import 'pictogram_data.dart';
import 'draggable_pictogram.dart';
import 'trash_area.dart';

class SentenceBox extends StatefulWidget {
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
  State<SentenceBox> createState() => _SentenceBoxState();
}

class _SentenceBoxState extends State<SentenceBox> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 700;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DragTarget<PictogramData>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    height: 150,
                    padding: const EdgeInsets.only(
                        top: 4, left: 12, right: 12, bottom: 0), // 🔥 cards mais para o topo
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey.shade400),
                    ),

                    child: widget.sentenceWords.isEmpty
                        ? const Center(
                            child: Text(
                              'Arraste aqui',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            trackVisibility: true,
                            radius: const Radius.circular(10),
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,

                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20), // 🔥 grande espaço entre cards e scrollbar
                                child: ReorderableListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: widget.sentenceWords.length,
                                  onReorder: widget.onReorder,

                                  itemBuilder: (context, index) {
                                    final item = widget.sentenceWords[index];

                                    return LongPressDraggable<PictogramData>(
                                      key: ValueKey(item.id),
                                      data: item,

                                      feedback: Material(
                                        color: Colors.transparent,
                                        child: DraggablePictogram(
                                          data: item,
                                          isFromSentence: true,
                                          reorderIndex: index,
                                        ),
                                      ),

                                      childWhenDragging: Opacity(
                                        opacity: 0.3,
                                        child: DraggablePictogram(
                                          data: item,
                                          isFromSentence: true,
                                          reorderIndex: index,
                                        ),
                                      ),

                                      child: DraggablePictogram(
                                        data: item,
                                        isFromSentence: true,
                                        reorderIndex: index,
                                      ),
                                    );
                                  },

                                  proxyDecorator: (child, index, animation) {
                                    return Transform.scale(
                                      scale: 1.1,
                                      child: child,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                  );
                },
                onAccept: widget.onAccept,
              ),
            ),

            // → Botões tablet
            if (isTablet) const SizedBox(width: 16),
            if (isTablet)
              Column(
                children: [
                  TrashArea(
                    onAccept: (data) {
                      setState(() {
                        widget.sentenceWords
                            .removeWhere((w) => w.id == data.id);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 100, // Define uma largura fixa
                    height: 60, // Define uma altura fixa
                    child: ElevatedButton(
                      onPressed: widget.onPlay,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero, // Remove o padding interno para centralizar o ícone
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: widget.isReading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Icon(Icons.play_arrow, size: 32), // Ícone um pouco maior
                    ),
                  ),
                ],
              ),
          ],
        ),

        const SizedBox(height: 10),

        // → Botões celular
        if (!isTablet)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TrashArea(
                onAccept: (data) {
                  setState(() {
                    widget.sentenceWords.removeWhere((w) => w.id == data.id);
                  });
                },
              ),
              SizedBox(
                width: 60, // Define uma largura fixa
                height: 60, // Define uma altura fixa
                child: ElevatedButton(
                  onPressed: widget.onPlay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero, // Remove o padding interno para centralizar o ícone
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: widget.isReading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.play_arrow, size: 32), // Ícone um pouco maior
                ),
              ),
            ],
          ),
      ],
    );
  }
}