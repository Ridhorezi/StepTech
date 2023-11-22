import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.location,
    required this.password,
    required this.email,
    required this.username,
  });

  final String location;
  final String password;
  final String email;
  final String username;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        location: json["location"],
        password: json["password"],
        email: json["email"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "password": password,
        "email": email,
        "username": username,
      };
}
