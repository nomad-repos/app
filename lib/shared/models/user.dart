
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
        userEmail: json["user_email"],
        userId: json["user_id"],
        userName: json["user_name"],
        userSurname: json["user_surname"],
    );

    Map<String, dynamic> toJson() => {
        "user_email": userEmail,
        "user_id": userId,
        "user_name": userName,
        "user_surname": userSurname,
    };
}
