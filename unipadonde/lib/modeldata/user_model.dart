class User {
  final int id;
  final String password;
  final String name;
  final String lastname;
  final String mail;
  final String sex;
  final String usertype;
  final String uid;
  final String imageUrl;
  String? universidad;

  User({
    required this.id,
    required this.password,
    required this.name,
    required this.lastname,
    required this.mail,
    required this.sex,
    required this.usertype,
    required this.uid,
    required this.imageUrl,
    this.universidad,
  });

  // Factory method to create a User from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      password: map['password'] ?? "",
      name: map['name'] ?? "",
      lastname: map['lastname'] ?? "",
      mail: map['mail'] ?? "",
      sex: map['sex'] ?? "",
      usertype: map['usertype'] ?? "",
      uid: map['uid'] ?? "",
      imageUrl: map['image_url'] ?? "",
    );
  }

  void updateUniversity(String university) {
    universidad = university;
  }

  // Convert the User object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'password': password,
      'name': name,
      'lastname': lastname,
      'mail': mail,
      'sex': sex,
      'usertype': usertype,
      'uid': uid,
      'image_url': imageUrl,
    };
  }
}
