import 'package:equatable/equatable.dart';
import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  error,
  profileIncomplete,
  authenticated,
  unauthenticated,
  passwordResetEmailSent,
  // Optional: emailVerificationSent,
}

class AuthScreenState extends Equatable {
  final AuthStatus status;
  final AuthUserEntity? user;
  final String? errorMessage;
  final bool isLoadingSignUp;
  final bool isLoadingSignIn;
  final bool isLoadingUpdateProfile;
  final bool isLoadingPasswordReset;

  // Optional: final bool isLoadingEmailVerification;

  const AuthScreenState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.isLoadingSignUp = false,
    this.isLoadingSignIn = false,
    this.isLoadingUpdateProfile = false,
    this.isLoadingPasswordReset = false,
    // this.isLoadingEmailVerification = false,
  });

  AuthScreenState copyWith({
    AuthStatus? status,
    AuthUserEntity? user,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool? isLoadingSignUp,
    bool? isLoadingSignIn,
    bool? isLoadingUpdateProfile,
    bool? isLoadingPasswordReset,
    // bool? isLoadingEmailVerification,
  }) {
    return AuthScreenState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      isLoadingSignUp: isLoadingSignUp ?? this.isLoadingSignUp,
      isLoadingSignIn: isLoadingSignIn ?? this.isLoadingSignIn,
      isLoadingUpdateProfile:
          isLoadingUpdateProfile ?? this.isLoadingUpdateProfile,
      isLoadingPasswordReset:
          isLoadingPasswordReset ?? this.isLoadingPasswordReset,
      // isLoadingEmailVerification:
      //     isLoadingEmailVerification ?? this.isLoadingEmailVerification,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    errorMessage,
    isLoadingSignUp,
    isLoadingSignIn,
    isLoadingUpdateProfile,
    isLoadingPasswordReset,
    // isLoadingEmailVerification,
  ];
}
