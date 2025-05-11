import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';
import 'package:sellatrack/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/sign_in_with_otp_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/verify_phone_number_usecase.dart';

import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthScreenState> {
  final VerifyPhoneNumberUseCase _verifyPhoneNumberUseCase;
  final SignInWithOtpUseCase _signInWithOtpUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignOutUseCase _signOutUseCase;

  AuthNotifier({
    required VerifyPhoneNumberUseCase verifyPhoneNumberUseCase,
    required SignInWithOtpUseCase signInWithOtpUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _verifyPhoneNumberUseCase = verifyPhoneNumberUseCase,
       _signInWithOtpUseCase = signInWithOtpUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _signOutUseCase = signOutUseCase,
       super(const AuthScreenState());

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    state = state.copyWith(
      isLoadingVerifyPhoneNumber: true,
      status: AuthStatus.loading,
      clearErrorMessage: true,
    );
    await _verifyPhoneNumberUseCase.call(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, resendToken) {
        state = state.copyWith(
          isLoadingVerifyPhoneNumber: false,
          verificationId: verificationId,
          resendToken: resendToken,
          status: AuthStatus.codeSent,
        );
      },
      verificationCompleted: (AuthUserEntity authUserEntity) async {
        if (authUserEntity.displayName == null ||
            authUserEntity.displayName!.isEmpty) {
          state = state.copyWith(
            user: authUserEntity,
            isLoadingVerifyPhoneNumber: false,
            status: AuthStatus.profileIncomplete,
          );
        } else {
          state = state.copyWith(
            user: authUserEntity,
            isLoadingVerifyPhoneNumber: false,
            status: AuthStatus.authenticated,
          );
        }
      },
      verificationFailed: (error) {
        state = state.copyWith(
          isLoadingVerifyPhoneNumber: false,
          errorMessage: error,
          status: AuthStatus.error,
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        state = state.copyWith(
          isLoadingVerifyPhoneNumber: false,
          verificationId: verificationId,
        );
      },
    );
  }

  Future<void> signInWithOtp(String smsCode) async {
    if (state.verificationId == null) {
      state = state.copyWith(
        errorMessage: 'Verification ID not found. Please try again.',
        status: AuthStatus.error,
      );
      return;
    }
    state = state.copyWith(
      isLoadingSignInWithOtp: true,
      status: AuthStatus.loading,
      clearErrorMessage: true,
    );
    try {
      final user = await _signInWithOtpUseCase.call(
        verificationId: state.verificationId!,
        smsCode: smsCode,
      );
      if (user != null) {
        if (user.displayName == null || user.displayName!.isEmpty) {
          state = state.copyWith(
            user: user,
            isLoadingSignInWithOtp: false,
            status: AuthStatus.profileIncomplete,
            clearVerificationId: true,
            clearResendToken: true,
          );
        } else {
          state = state.copyWith(
            user: user,
            isLoadingSignInWithOtp: false,
            status: AuthStatus.authenticated,
            clearVerificationId: true,
            clearResendToken: true,
          );
        }
      } else {
        state = state.copyWith(
          isLoadingSignInWithOtp: false,
          errorMessage: 'Failed to sign in with OTP.',
          status: AuthStatus.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingSignInWithOtp: false,
        errorMessage: e.toString(),
        status: AuthStatus.error,
      );
    }
  }

  Future<void> updateUserProfile(String displayName) async {
    state = state.copyWith(
      isLoadingUpdateProfile: true,
      status: AuthStatus.loading,
      clearErrorMessage: true,
    );
    try {
      await _updateUserProfileUseCase.call(displayName: displayName);
      final updatedUser = await _getCurrentUserUseCase.call();
      state = state.copyWith(
        user: updatedUser,
        isLoadingUpdateProfile: false,
        status: AuthStatus.authenticated,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingUpdateProfile: false,
        errorMessage: e.toString(),
        status: AuthStatus.error,
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _signOutUseCase.call();
      state = const AuthScreenState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        status: AuthStatus.error,
      );
    }
  }

  Future<void> checkCurrentUser() async {
    state = state.copyWith(status: AuthStatus.loading, clearErrorMessage: true);
    final user = await _getCurrentUserUseCase.call();
    if (user != null) {
      if (user.displayName == null || user.displayName!.isEmpty) {
        state = state.copyWith(
          user: user,
          status: AuthStatus.profileIncomplete,
          isLoadingVerifyPhoneNumber: false,
          isLoadingSignInWithOtp: false,
          isLoadingUpdateProfile: false,
        );
      } else {
        state = state.copyWith(
          user: user,
          status: AuthStatus.authenticated,
          isLoadingVerifyPhoneNumber: false,
          isLoadingSignInWithOtp: false,
          isLoadingUpdateProfile: false,
        );
      }
    } else {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoadingVerifyPhoneNumber: false,
        isLoadingSignInWithOtp: false,
        isLoadingUpdateProfile: false,
      );
    }
  }
}
