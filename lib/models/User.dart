import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User extends Object with _$UserSerializerMixin {
  String id;
  String name;
  String email;
  String password;
  String old_password;
  String new_password;

  User(
    {
      this.id,
      this.name,
      this.email,
      this.password,
      this.old_password,
      this.new_password
    }
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
