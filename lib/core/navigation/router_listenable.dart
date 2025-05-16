import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/core/di/providers.dart';
import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';

class RouterListenable extends ChangeNotifier {
  final Ref _ref;
  bool _isLoggedIn = false;
  bool _initialAuthCheckDone = false;

  RouterListenable(this._ref) {
    _ref.listen<AsyncValue<AuthUserEntity?>>(authStateChangesProvider, (
      previous,
      next,
    ) {
      final newIsLoggedIn = next.valueOrNull != null;
      if (!_initialAuthCheckDone || _isLoggedIn != newIsLoggedIn) {
        _isLoggedIn = newIsLoggedIn;
        _initialAuthCheckDone =
            true; // Mark as done after first actual value (or null)
        notifyListeners();
      }
    }, fireImmediately: true);
  }

  bool get isLoggedIn => _isLoggedIn;

  bool get initialAuthCheckDone => _initialAuthCheckDone;
}

final routerListenableProvider = Provider<RouterListenable>((ref) {
  return RouterListenable(ref);
});
