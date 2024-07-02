class UserModel {
  String? uid;
  String name;
  String email;
  String bio;
  String description;
  String imageUrl;

  UserModel(
      {required this.bio,
      required this.email,
      required this.imageUrl,
      required this.description,
      required this.name,
      this.uid});

  Map<String, dynamic> tojson(id) => {
        "uid": id,
        "description":description,
        "name": name,
        "email": email,
        "bio": bio,
        "imageUrl": imageUrl
      };
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        bio: json["bio"],
      description:json ["description"],
        email: json["email"],
        imageUrl: json["imageUrl"],
        name: json["name"],
        uid: json["uid"]);
  }
}
