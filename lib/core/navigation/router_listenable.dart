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
  bool _initialCheckDone = false;

  RouterListenable(this._ref) {
    _performInitialSetup();

    _ref.listen<AsyncValue<AuthUserEntity?>>(
      authStateChangesProvider,
      (previous, next) => _evaluateAndNotify(),
      fireImmediately: true,
    );

    _ref.listen<AuthScreenState>(
      authNotifierProvider,
      (previous, next) => _evaluateAndNotify(),
      fireImmediately: true,
    );
  }

  Future<void> _performInitialSetup() async {
    final authAsync = _ref.read(authStateChangesProvider);
    final initialFirebaseUser = authAsync.valueOrNull;
    _isLoggedIn = initialFirebaseUser != null;

    if (_isLoggedIn) {
      final authNotifier = _ref.read(authNotifierProvider.notifier);
      final currentNotifierState = _ref.read(authNotifierProvider);

      if (currentNotifierState.status == AuthStatus.initial ||
          currentNotifierState.user?.uid != initialFirebaseUser!.uid) {
        await authNotifier.checkCurrentUser();
      }
    }

    _evaluateCurrentStatesFromProviders();
    _initialCheckDone = true;
    notifyListeners();
  }

  void _evaluateCurrentStatesFromProviders() {
    final authAsync = _ref.read(authStateChangesProvider);
    _isLoggedIn = authAsync.valueOrNull != null;

    if (_isLoggedIn) {
      final authNotifierState = _ref.read(authNotifierProvider);
      _isProfileComplete =
          authNotifierState.status == AuthStatus.authenticated &&
          (authNotifierState.user?.displayName != null &&
              authNotifierState.user!.displayName!.isNotEmpty);
      if (authNotifierState.status == AuthStatus.profileIncomplete) {
        _isProfileComplete = false;
      }
    } else {
      _isProfileComplete = false;
    }
  }

  void _evaluateAndNotify() {
    final oldIsLoggedIn = _isLoggedIn;
    final oldIsProfileComplete = _isProfileComplete;

    _evaluateCurrentStatesFromProviders();

    if (!_initialCheckDone) {
      return;
    }

    if (oldIsLoggedIn != _isLoggedIn ||
        oldIsProfileComplete != _isProfileComplete) {
      notifyListeners();
    }
  }

  bool get isLoggedIn => _isLoggedIn;

  bool get isProfileComplete => _isProfileComplete;

  bool get initialCheckDone => _initialCheckDone;
}

final routerListenableProvider = Provider<RouterListenable>((ref) {
  return RouterListenable(ref);
});
