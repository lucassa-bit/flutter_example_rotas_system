part 'login.g.dart';

class Login {
  String login;
  String password;

  Login({required this.login, required this.password});

  Map<String, dynamic> toJson() => _$LoginToJson(this);
}