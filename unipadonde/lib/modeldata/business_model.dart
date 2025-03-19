class Business {
  final int id;
  final String name;
  final String description;
  final String tiktok;
  final String instagram;
  final String webpage;
  final String picture;
  final int idproveedor;
  final String mail;
  final String imageurl;

  Business({
    required this.id,
    required this.name,
    required this.description,
    required this.tiktok,
    required this.instagram,
    required this.webpage,
    required this.picture,
    required this.idproveedor,
    required this.mail,
    required this.imageurl,
  });

  factory Business.fromMap(Map<String, dynamic> json) {
    return Business(
        id: json['id'],
        name: json['name'],
        description: json['description'] ?? "No disponible",
        tiktok: json['tiktok'] ?? "No disponible",
        mail: json['mail'] ?? "No disponible",
        instagram: json['instagram'] ?? "No disponible",
        webpage: json['webpage'] ?? "No disponible",
        picture: json['picture'] ?? "No disponible",
        idproveedor: json['id_proveedor'] ?? "No disponible",
        imageurl: json['image_url'] ?? "");
  }
}
