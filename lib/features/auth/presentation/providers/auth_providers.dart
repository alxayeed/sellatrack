import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/core/di/providers.dart';
import 'package:sellatrack/features/auth/presentation/notifiers/auth_notifier.dart';
import 'package:sellatrack/features/auth/presentation/notifiers/auth_state.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthScreenState>((ref) {
      return AuthNotifier(
        verifyPhoneNumberUseCase: ref.watch(verifyPhoneNumberUseCaseProvider),
        signInWithOtpUseCase: ref.watch(signInWithOtpUseCaseProvider),
        updateUserProfileUseCase: ref.watch(updateUserProfileUseCaseProvider),
        getCurrentUserUseCase: ref.watch(getCurrentUserUseCaseProvider),
        signOutUseCase: ref.watch(signOutUseCaseProvider),
      );
    });
