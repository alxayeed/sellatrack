import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/core/di/providers.dart';
import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';
import 'package:sellatrack/features/auth/presentation/notifiers/auth_state.dart';
import 'package:sellatrack/features/auth/presentation/providers/auth_providers.dart';

class RouterListenable extends ChangeNotifier {
  final Ref _ref;
  bool _isLoggedIn = false;
  bool _isProfileComplete = false;

  RouterListenable(this._ref) {
    _ref.listen<AsyncValue<AuthUserEntity?>>(
      authStateChangesProvider, // From core/di/providers.dart
      (previous, next) {
        final newIsLoggedIn = next.valueOrNull != null;
        bool newIsProfileComplete = false;

        if (newIsLoggedIn) {
          final authNotifierState = _ref.read(authNotifierProvider);
          newIsProfileComplete =
              authNotifierState.status == AuthStatus.authenticated &&
              (authNotifierState.user?.displayName != null &&
                  authNotifierState.user!.displayName!.isNotEmpty);
        }

        if (_isLoggedIn != newIsLoggedIn ||
            _isProfileComplete != newIsProfileComplete) {
          _isLoggedIn = newIsLoggedIn;
          _isProfileComplete = newIsProfileComplete;
          notifyListeners();
        }
      },
      fireImmediately: true, // Ensure it fires with current value on listen
    );

    _ref.listen<AuthScreenState>(
      authNotifierProvider,
      // From features/auth/presentation/providers/auth_providers.dart
      (previous, next) {
        final newIsLoggedIn =
            next.status == AuthStatus.authenticated ||
            next.status == AuthStatus.profileIncomplete;
        final newIsProfileComplete =
            next.status == AuthStatus.authenticated &&
            (next.user?.displayName != null &&
                next.user!.displayName!.isNotEmpty);

        if (_isLoggedIn != newIsLoggedIn ||
            _isProfileComplete != newIsProfileComplete) {
          _isLoggedIn = newIsLoggedIn;
          _isProfileComplete = newIsProfileComplete;
          notifyListeners();
        }
      },
      fireImmediately: true, // Ensure it fires with current value on listen
    );

    // Perform initial check, and trigger AuthNotifier to check current user if needed
    // This ensures that if authStateChangesProvider is already resolved (e.g. user already logged in on app start)
    // and AuthNotifier hasn't yet determined profile completeness, it gets a chance.
    final initialAuthAsync = _ref.read(authStateChangesProvider);
    _isLoggedIn = initialAuthAsync.when(
      data: (user) => user != null,
      loading: () => false, // Or based on previous known state if persisted
      error: (_, __) => false,
    );

    if (_isLoggedIn) {
      final initialNotifierState = _ref.read(authNotifierProvider);
      _isProfileComplete =
          initialNotifierState.status == AuthStatus.authenticated &&
          (initialNotifierState.user?.displayName != null &&
              initialNotifierState.user!.displayName!.isNotEmpty);

      if (initialNotifierState.status == AuthStatus.initial) {
        Future.microtask(
          () => _ref.read(authNotifierProvider.notifier).checkCurrentUser(),
        );
      }
    } else {
      _isProfileComplete = false;
    }
  }

  bool get isLoggedIn => _isLoggedIn;

  bool get isProfileComplete => _isProfileComplete;
}

final routerListenableProvider = Provider<RouterListenable>((ref) {
  return RouterListenable(ref);
});
