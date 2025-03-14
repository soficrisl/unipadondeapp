class Business {
  int id;
  String name;
  String description;
  String picture;
  String tiktok;
  String instagram;
  String webpage;

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