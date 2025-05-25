import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/core/di/providers.dart';
import 'package:sellatrack/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:sellatrack/features/auth/presentation/notifiers/auth_state.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthScreenState>((ref) {
      return AuthNotifier(
        signUpWithEmailPasswordUseCase: ref.watch(
          signUpWithEmailPasswordUseCaseProvider,
        ),
        signInWithEmailPasswordUseCase: ref.watch(
          signInWithEmailPasswordUseCaseProvider,
        ),
        updateUserProfileUseCase: ref.watch(updateUserProfileUseCaseProvider),
        getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
        signOutUseCase: ref.watch(signOutUseCaseProvider),
        resetPasswordUseCase: ref.watch(resetPasswordUseCaseProvider),
      );
    });
