import 'package:flutter/material.dart';
import 'pictogram_data.dart';
import 'draggable_pictogram.dart';

class ComponentBox extends StatelessWidget {
  final List<PictogramData> componentWords;

  const ComponentBox({super.key, required this.componentWords});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: componentWords.map((data) => DraggablePictogram(data: data.copyWith(isClone: true))).toList(),
        ),
      ),
    );
  }
}