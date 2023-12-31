import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nuntium/core/resorces/manager_strings.dart';

class Failure {
  int code;
  String message;

  Failure(this.code, this.message);
}

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    try {
      if (error is DioException) {
        failure = Failure(
          400,
          error.response?.data['message'] ??
              error.response?.data['errors'].toString() ?? ManagerStrings.error,
        );
      } else if (error is FirebaseAuthException) {
        failure = Failure(
            error.code.compareTo('400'), error.message ?? 'Bad Request');
      } else {
        failure = Failure(400, ManagerStrings.badRequest);
      }
    } catch (e){
      failure = Failure(400, ManagerStrings.badRequest);
    }
  }
}
