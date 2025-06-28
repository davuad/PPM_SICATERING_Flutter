import 'package:flutter/services.dart';

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);
  @override
  String toString() {
    return "$_message $_prefix";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
    : super(message, "error during communication");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "invalid request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class UnprocessableEntityException extends AppException {
  UnprocessableEntityException([message])
    : super(message, "Unprocessable Entity: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}
