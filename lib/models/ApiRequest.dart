import 'package:flutterme/models/User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ApiRequest.g.dart';

@JsonSerializable()
class ApiRequest extends Object with _$ApiRequestSerializerMixin {
  String operation;
  User user;

  ApiRequest({this.operation, this.user});

  factory ApiRequest.fromJson(Map<String, dynamic> json) => _$ApiRequestFromJson(json);
}
