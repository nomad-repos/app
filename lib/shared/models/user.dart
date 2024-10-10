
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    String userEmail;
    int userId;
    String userName;
    String userSurname;

    User({
        required this.userEmail,
        required this.userId,
        required this.userName,
        required this.userSurname,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userEmail: json["email"],
        userId: json["id"],
        userName: json["name"],
        userSurname: json["surname"],
    );

    Map<String, dynamic> toJson() => {
        "email": userEmail,
        "id": userId,
        "name": userName,
        "surname": userSurname,
    };
}
