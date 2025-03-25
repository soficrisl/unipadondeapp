// Definición de la clase Categoria
class Categoria {
  final int id;
  final String name;
  final String description;

  Categoria({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
        id: map['id'], name: map['name'], description: map['description']);
  }
}
