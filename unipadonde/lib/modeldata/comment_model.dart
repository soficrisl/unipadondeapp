class Comment {
  final int iduser;
  final int idbusiness;
  final String date;
  final String content;
  final int rating;
  String? name;
  String? lastname;

  Comment({
    required this.iduser,
    required this.idbusiness,
    required this.date,
    required this.content,
    required this.rating,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      iduser: map['id_usuario'],
      idbusiness: map['id_negocio'],
      date: map['date'] ?? "",
      content: map['content'] ?? "",
      rating: map['calificacion'],
    );
  }

  void setNames(String name, String lastname) {
    this.name = name;
    this.lastname = lastname;
  }
}
