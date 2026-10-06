/// Build-time configuration, set with `--dart-define`.
abstract final class AppConfig {
  /// The base URL of the VietGara REST API (Kong), without `/v1`.
  ///
  /// Defaults to the local Kong gateway as the Android emulator sees it; the
  /// iOS simulator uses `http://localhost:8000/api`. Real devices use the
  /// API host, which serves the API only:
  /// `https://vietgara-api-staging.viettechno.com/api` (staging) or
  /// `https://vietgara-api.viettechno.com/api` (production).
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );

  /// The company's support mailbox.
  static const supportEmail = 'support@viettechno.com';

  /// Page size of the infinite lists.
  static const pageSize = 20;
}
