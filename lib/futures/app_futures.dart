import 'dart:async';
import 'dart:convert';

import 'package:flutterme/models/ApiRequest.dart';
import 'package:flutterme/models/ApiResponse.dart';
import 'package:flutterme/models/User.dart';
import 'package:flutterme/models/base/EventObject.dart';
import 'package:flutterme/utils/constants.dart';
import 'package:http/http.dart' as http;

Future<EventObject> loginUser(String emailId, String password) async {
  ApiRequest apiRequest = new ApiRequest();
  User user = new User(email: emailId, password: password);

  apiRequest.operation = APIOperations.LOGIN;
  apiRequest.user = user;

  try {
    final encoding = APIConstants.OCTET_STREAM_ENCODING;
    final response = await http.post(APIConstants.API_BASE_URL,
        body: json.encode(apiRequest.toJson()),
        encoding: Encoding.getByName(encoding));
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK &&
          response.body != null) {
        final responseJson = json.decode(response.body);
        ApiResponse apiResponse = ApiResponse.fromJson(responseJson);
        if (apiResponse.result == APIOperations.SUCCESS) {
          return new EventObject(
              id: EventConstants.LOGIN_USER_SUCCESSFUL,
              object: apiResponse.user);
        } else {
          return new EventObject(id: EventConstants.LOGIN_USER_UN_SUCCESSFUL);
        }
      } else {
        return new EventObject(id: EventConstants.LOGIN_USER_UN_SUCCESSFUL);
      }
    } else {
      return new EventObject();
    }
  } catch (Exception) {
    return EventObject();
  }
}

Future<EventObject> registerUser(
    String name, String emailId, String password) async {
  ApiRequest apiRequest = new ApiRequest();
  User user = new User(name: name, email: emailId, password: password);

  apiRequest.operation = APIOperations.REGISTER;
  apiRequest.user = user;

  try {
    final encoding = APIConstants.OCTET_STREAM_ENCODING;
    final response = await http.post(APIConstants.API_BASE_URL,
        body: json.encode(apiRequest.toJson()),
        encoding: Encoding.getByName(encoding));
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK &&
          response.body != null) {
        final responseJson = json.decode(response.body);
        ApiResponse apiResponse = ApiResponse.fromJson(responseJson);
        if (apiResponse.result == APIOperations.SUCCESS) {
          return new EventObject(
              id: EventConstants.USER_REGISTRATION_SUCCESSFUL, object: null);
        } else if (apiResponse.result == APIOperations.FAILURE) {
          return new EventObject(id: EventConstants.USER_ALREADY_REGISTERED);
        } else {
          return new EventObject(
              id: EventConstants.USER_REGISTRATION_UN_SUCCESSFUL);
        }
      } else {
        return new EventObject(
            id: EventConstants.USER_REGISTRATION_UN_SUCCESSFUL);
      }
    } else {
      return new EventObject();
    }
  } catch (Exception) {
    return EventObject();
  }
}

Future<EventObject> changePassword(
    String emailId, String oldPassword, String newPassword) async {
  ApiRequest apiRequest = new ApiRequest();
  User user = new User(
      email: emailId, old_password: oldPassword, new_password: newPassword);

  apiRequest.operation = APIOperations.CHANGE_PASSWORD;
  apiRequest.user = user;

  try {
    final encoding = APIConstants.OCTET_STREAM_ENCODING;
    final response = await http.post(APIConstants.API_BASE_URL,
        body: json.encode(apiRequest.toJson()),
        encoding: Encoding.getByName(encoding));
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK &&
          response.body != null) {
        final responseJson = json.decode(response.body);
        ApiResponse apiResponse = ApiResponse.fromJson(responseJson);
        if (apiResponse.result == APIOperations.SUCCESS) {
          return new EventObject(
              id: EventConstants.CHANGE_PASSWORD_SUCCESSFUL, object: null);
        } else if (apiResponse.result == APIOperations.FAILURE) {
          return new EventObject(id: EventConstants.INVALID_OLD_PASSWORD);
        } else {
          return new EventObject(
              id: EventConstants.CHANGE_PASSWORD_UN_SUCCESSFUL);
        }
      } else {
        return new EventObject(
            id: EventConstants.CHANGE_PASSWORD_UN_SUCCESSFUL);
      }
    } else {
      return new EventObject();
    }
  } catch (Exception) {
    return EventObject();
  }
}
