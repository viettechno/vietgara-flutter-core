import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_exception.dart';
import '../locale_controller.dart';
import '../providers.dart';
import 'account.dart';
import 'auth_repository.dart';

/// The signed-in account, or null when signed out. App-specific state of
/// the session (e.g. the owner app's selected garage) is cleared by the app
/// itself, by listening to this provider. Loading at start-up while
/// the stored session is checked; an error when that check could not reach
/// the API (the splash screen offers a retry).
class SessionController extends AsyncNotifier<Account?> {
  AuthRepository get _auth => ref.read(authRepositoryProvider);

  @override
  Future<Account?> build() async {
    final api = ref.watch(apiClientProvider);
    api.onSessionExpired = _expired;

    if (await api.tokens() == null) return null;
    try {
      return _adopt(await _auth.me());
    } on ApiException catch (error) {
      if (error.status == 401) {
        await api.clearSession();
        return null;
      }
      rethrow;
    }
  }

  void _expired() {
    if (state.value != null) state = const AsyncData(null);
  }

  Account _adopt(Account account) {
    unawaited(
      ref.read(localeControllerProvider.notifier).set(account.language.name),
    );
    return account;
  }

  Future<void> _start(Session session) async {
    await ref.read(apiClientProvider).saveTokens(session.tokens);
    state = AsyncData(_adopt(session.account));
  }

  Future<void> signIn(String email, String password) async =>
      _start(await _auth.login(email, password));

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String phone = '',
  }) async {
    final language = AppLanguage.fromCode(
      ref.read(localeControllerProvider).languageCode,
    );
    await _start(
      await _auth.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        language: language,
      ),
    );
  }

  /// Verifies the e-mail with [otpCode]; the session is rotated so the new
  /// one carries the verified claim.
  Future<void> verifyEmail(String otpCode) async {
    final tokens = await ref.read(apiClientProvider).tokens();
    await _start(await _auth.verifyEmail(otpCode, tokens?.refreshToken ?? ''));
  }

  Future<void> updateAccount({
    String? fullName,
    String? phone,
    AppLanguage? language,
  }) async {
    final account = await _auth.updateMe(
      fullName: fullName,
      phone: phone,
      language: language,
    );
    state = AsyncData(_adopt(account));
  }

  /// Applies [language] right away, and saves it on the account when signed in.
  Future<void> changeLanguage(AppLanguage language) async {
    await ref.read(localeControllerProvider.notifier).set(language.name);
    if (state.value != null) await updateAccount(language: language);
  }

  Future<void> signOut() async {
    final api = ref.read(apiClientProvider);
    final tokens = await api.tokens();
    if (tokens != null) {
      try {
        await _auth.logout(tokens.refreshToken);
      } on ApiException {
        // Signing out locally is enough; the refresh token expires anyway.
      }
    }
    await api.clearSession();
    state = const AsyncData(null);
  }
}

final sessionControllerProvider =
    AsyncNotifierProvider<SessionController, Account?>(SessionController.new);
