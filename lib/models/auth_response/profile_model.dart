import 'dart:convert';

ProfileResponseModel profileResponseFromJson(String str) => ProfileResponseModel.fromJson(json.decode(str));

String profileResponseModelToJson(ProfileResponseModel data) => json.encode(data.toJson());

class ProfileResponseModel {
    ProfileResponseModel({
        required this.id,
        required this.username,
        required this.email,
        required this.password,
        required this.location,
    });

    final String id;
    final String username;
    final String email;
    final String password;
    final String location;

    factory ProfileResponseModel.fromJson(Map<String, dynamic> json) => ProfileResponseModel(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        location: json["location"],
       
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "password": password,
        "location": location,
    };
}
