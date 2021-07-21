import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  String name;
  String userId;

  UserEntity({this.name, this.userId});

  @override
  toString() {
    return '''
    Name: $name
    UserId $userId
    ''';
  }
}