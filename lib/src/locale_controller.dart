import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

const supportedLanguageCodes = ['vi', 'en'];

/// The UI language: Vietnamese by default, the user's preference once
/// signed in, remembered between launches.
class LocaleController extends Notifier<Locale> {
  static const _key = 'vietgara.language';

  @override
  Locale build() {
    final saved = ref.watch(sharedPreferencesProvider).getString(_key);
    return Locale(supportedLanguageCodes.contains(saved) ? saved! : 'vi');
  }

  Future<void> set(String languageCode) async {
    if (!supportedLanguageCodes.contains(languageCode)) return;
    state = Locale(languageCode);
    await ref.read(sharedPreferencesProvider).setString(_key, languageCode);
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);
