import 'dart:async';
import 'dart:io';

import 'package:sellatrack/core/errors/failures.dart';

class ErrorHandlerService {
  const ErrorHandlerService();

  String processError(Object errorObject) {
    if (errorObject is Failure) {
      if (errorObject is NetworkFailure) {
        return 'Unable to connect. Please check your internet connection.';
      }
      if (errorObject is AuthenticationFailure) {
        if (errorObject.message.toLowerCase().contains('user-not-found') ||
            errorObject.message.toLowerCase().contains('wrong-password') ||
            errorObject.message.toLowerCase().contains('invalid-credential')) {
          return 'Invalid email or password. Please try again.';
        }
        if (errorObject.message.toLowerCase().contains(
          'email-already-in-use',
        )) {
          return 'This email address is already registered. Please try logging in.';
        }
        if (errorObject.message.toLowerCase().contains('too-many-requests')) {
          return 'Too many attempts. Please try again later.';
        }
        return 'Authentication error: ${errorObject.message}';
      }
      if (errorObject is FirestoreFailure) {
        return 'A database error occurred. Please try again later.';
      }
      if (errorObject is InvalidInputFailure) {
        return errorObject.message;
      }
      return errorObject.message;
    }

    if (errorObject is SocketException) {
      return "Cannot connect to the server. Please check your internet connection.";
    }
    if (errorObject is FormatException) {
      return "There was an issue with the data format. Please try again.";
    }
    if (errorObject is TimeoutException) {
      return "The operation timed out. Please check your connection and try again.";
    }
    if (errorObject is TypeError) {
      return "An internal application error occurred (Type).";
    }
    if (errorObject is StateError) {
      return "An internal application error occurred (State).";
    }
    if (errorObject is Exception) {
      return 'An application error occurred. Please try again.';
    }
    return "An unexpected problem occurred. Please try again later.";
  }
}
