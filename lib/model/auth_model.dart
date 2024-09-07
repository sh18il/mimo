class UserModel {
  String? username;
  String? email;
  String? uid;

  UserModel({
    this.username,
    this.email,
    this.uid,
  });

  UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    username = json["username"];
    email = json["email"];
    uid = json["uid"];
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "uid": uid,
    };
  }
}
