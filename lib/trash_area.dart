import 'package:flutter/material.dart';
import 'pictogram_data.dart';

class TrashArea extends StatelessWidget {
  final Function(PictogramData) onAccept;

  const TrashArea({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return DragTarget<PictogramData>(
      builder: (context, candidateData, rejectedData) {
        bool isHovering = candidateData.isNotEmpty;
        return Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isHovering ? Colors.red.withOpacity(0.2) : Colors.transparent,
            border: Border.all(color: isHovering ? Colors.red : Colors.grey.shade400, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              isHovering ? Icons.delete_forever : Icons.delete_outline,
              color: isHovering ? Colors.red : Colors.grey.shade600,
              size: 40,
            ),
          ),
        );
      },
      onWillAccept: (data) => data != null && !data.isClone,
      onAccept: onAccept,
    );
  }
}