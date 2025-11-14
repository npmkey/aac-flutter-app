class PictogramData {
  // Usado nos componentes originais
  final String text;
  final String image;

  // Usado para instâncias na frase
  final int? id;
  final bool isClone;

  PictogramData({
    required this.text,
    required this.image,
    this.id,
    this.isClone = false,
  });

  // Cria uma cópia com novos valores
  PictogramData copyWith({int? id, bool? isClone}) => PictogramData(
      text: text, image: image, id: id ?? this.id, isClone: isClone ?? this.isClone);
}