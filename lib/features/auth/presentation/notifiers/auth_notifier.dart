import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/sign_in_with_email_password_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/sign_up_with_email_password_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/update_user_profile_usecase.dart';

// Optional: import 'package:sellatrack/features/auth/domain/usecases/send_current_user_email_verification_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthScreenState> {
  final SignUpWithEmailPasswordUseCase _signUpWithEmailPasswordUseCase;
  final SignInWithEmailPasswordUseCase _signInWithEmailPasswordUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignOutUseCase _signOutUseCase;

  // Optional: final SendCurrentUserEmailVerificationUseCase _sendCurrentUserEmailVerificationUseCase;

  AuthNotifier({
    required SignUpWithEmailPasswordUseCase signUpWithEmailPasswordUseCase,
    required SignInWithEmailPasswordUseCase signInWithEmailPasswordUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignOutUseCase signOutUseCase,

    // Optional: required SendCurrentUserEmailVerificationUseCase sendCurrentUserEmailVerificationUseCase,
  }) : _signUpWithEmailPasswordUseCase = signUpWithEmailPasswordUseCase,
       _signInWithEmailPasswordUseCase = signInWithEmailPasswordUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _signOutUseCase = signOutUseCase,
       super(const AuthScreenState());

  Future<void> signUpWithEmailPassword(String email, String password) async {
    state = state.copyWith(
      isLoadingSignUp: true,
      status: AuthStatus.loading,
      clearErrorMessage: true,
    );
    try {
      final user = await _signUpWithEmailPasswordUseCase.call(
        email: email,
        password: password,
      );
      if (user != null) {
        if (user.displayName == null || user.displayName!.isEmpty) {
          state = state.copyWith(
            user: user,
            isLoadingSignUp: false,
            status: AuthStatus.profileIncomplete,
          );
        } else {
          state = state.copyWith(
            user: user,
            isLoadingSignUp: false,
            status: AuthStatus.authenticated,
          );
        }
        // Optional: Trigger email verification
        // await _sendCurrentUserEmailVerificationUseCase?.call();
      } else {
        state = state.copyWith(
          isLoadingSignUp: false,
          errorMessage: 'Failed to sign up.',
          status: AuthStatus.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingSignUp: false,
        errorMessage: e.toString(),
        status: AuthStatus.error,
      );
    }
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    state = state.copyWith(
      isLoadingSignIn: true,
      status: AuthStatus.loading,
      clearErrorMessage: true,
    );
    try {
      final user = await _signInWithEmailPasswordUseCase.call(
        email: email,
        password: password,
      );
      if (user != null) {
        // Optional: Check if email is verified if that's a requirement for your app
        // if (!user.emailVerified) { // Assuming AuthUserEntity gets an emailVerified field
        //   state = state.copyWith(user: user, isLoadingSignIn: false, status: AuthStatus.emailNotVerified);
        //   return;
        // }
        if (user.displayName == null || user.displayName!.isEmpty) {
          state = state.copyWith(
            user: user,
            isLoadingSignIn: false,
            status: AuthStatus.profileIncomplete,
          );
        } else {
          state = state.copyWith(
            user: user,
            isLoadingSignIn: false,
            status: AuthStatus.authenticated,
          );
        }
      } else {
        state = state.copyWith(
          isLoadingSignIn: false,
          errorMessage: 'Failed to sign in.',
          status: AuthStatus.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingSignIn: false,
        errorMessage: e.toString(),
        status: AuthStatus.error,
      );
    }
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? email,
    String? photoURL,
  }) async {
    state = state.copyWith(
      isLoadingUpdateProfile: true,
      status: AuthStatus.loading,
      clearErrorMessage: true,
    );
    try {
      await _updateUserProfileUseCase.call(
        displayName: displayName,
        email: email,
        photoURL: photoURL,
      );
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

  // Future<void> sendPasswordResetEmail(String email) async {
  //   state = state.copyWith(status: AuthStatus.loading, clearErrorMessage: true);
  //   try {
  //     await _sendPasswordResetEmailUseCase.call(email: email);
  //     state = state.copyWith(
  //       status: AuthStatus.initial,
  //     ); // Or a specific status like passwordResetEmailSent
  //   } catch (e) {
  //     state = state.copyWith(
  //       errorMessage: e.toString(),
  //       status: AuthStatus.error,
  //     );
  //   }
  // }

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
          isLoadingSignUp: false,
          isLoadingSignIn: false,
          isLoadingUpdateProfile: false,
        );
      } else {
        state = state.copyWith(
          user: user,
          status: AuthStatus.authenticated,
          isLoadingSignUp: false,
          isLoadingSignIn: false,
          isLoadingUpdateProfile: false,
        );
      }
    } else {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isLoadingSignUp: false,
        isLoadingSignIn: false,
        isLoadingUpdateProfile: false,
      );
    }
  }
}
