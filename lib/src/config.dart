/// Build-time configuration, set with `--dart-define`.
abstract final class AppConfig {
  /// The base URL of the VietGara REST API (Kong), without `/v1`.
  ///
  /// Defaults to the local Kong gateway as the Android emulator sees it; the
  /// iOS simulator uses `http://localhost:8000/api` and real devices the
  /// staging or production host, e.g.
  /// `--dart-define=API_BASE_URL=https://staging.vietgara.vn/api`.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );

  static const supportEmail = 'support@vietgara.vn';

  /// Page size of the infinite lists.
  static const pageSize = 20;
}
