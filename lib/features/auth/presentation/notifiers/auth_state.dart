import 'package:equatable/equatable.dart';
import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  error,
  codeSent,
  profileIncomplete,
  authenticated,
  unauthenticated,
}

class AuthScreenState extends Equatable {
  final AuthStatus status;
  final AuthUserEntity? user;
  final String? errorMessage;
  final String? verificationId;
  final int? resendToken;
  final bool isLoadingVerifyPhoneNumber;
  final bool isLoadingSignInWithOtp;
  final bool isLoadingUpdateProfile;

  const AuthScreenState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.verificationId,
    this.resendToken,
    this.isLoadingVerifyPhoneNumber = false,
    this.isLoadingSignInWithOtp = false,
    this.isLoadingUpdateProfile = false,
  });

  AuthScreenState copyWith({
    AuthStatus? status,
    AuthUserEntity? user,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? verificationId,
    bool clearVerificationId = false,
    int? resendToken,
    bool clearResendToken = false,
    bool? isLoadingVerifyPhoneNumber,
    bool? isLoadingSignInWithOtp,
    bool? isLoadingUpdateProfile,
  }) {
    return AuthScreenState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      verificationId:
          clearVerificationId ? null : verificationId ?? this.verificationId,
      resendToken: clearResendToken ? null : resendToken ?? this.resendToken,
      isLoadingVerifyPhoneNumber:
          isLoadingVerifyPhoneNumber ?? this.isLoadingVerifyPhoneNumber,
      isLoadingSignInWithOtp:
          isLoadingSignInWithOtp ?? this.isLoadingSignInWithOtp,
      isLoadingUpdateProfile:
          isLoadingUpdateProfile ?? this.isLoadingUpdateProfile,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    errorMessage,
    verificationId,
    resendToken,
    isLoadingVerifyPhoneNumber,
    isLoadingSignInWithOtp,
    isLoadingUpdateProfile,
  ];
}
