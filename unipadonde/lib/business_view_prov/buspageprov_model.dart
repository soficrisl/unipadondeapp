// business_model.dart
class Business {
  final int id;
  final String name;
  final String description;
  final String picture;
  final String tiktok;
  final String instagram;
  final String webpage;

  Business({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.tiktok,
    required this.instagram,
    required this.webpage,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      picture: json['picture'],
      tiktok: json['tiktok'],
      instagram: json['instagram'],
      webpage: json['webpage'],
    );
  }
}