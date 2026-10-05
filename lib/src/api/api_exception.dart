/// One field-level issue of a VALIDATION_ERROR (API Specification 1.3).
class ApiErrorDetail {
  const ApiErrorDetail({this.field, this.issue});

  final String? field;
  final String? issue;
}

/// An error answer of the API, carrying the stable error code the UI
/// translates (`{"error": {"code", "message", "details"}}`).
class ApiException implements Exception {
  const ApiException({
    required this.status,
    required this.code,
    this.message = '',
    this.details = const [],
  });

  /// Parses an error body; anything unexpected becomes `INTERNAL`.
  factory ApiException.fromBody(int status, Object? body) {
    final error = body is Map<String, dynamic> ? body['error'] : null;
    if (error is! Map<String, dynamic>) {
      return ApiException(status: status, code: 'INTERNAL');
    }
    final details = error['details'];
    return ApiException(
      status: status,
      code: (error['code'] as String?) ?? 'INTERNAL',
      message: (error['message'] as String?) ?? '',
      details: [
        if (details is List)
          for (final detail in details.whereType<Map<String, dynamic>>())
            ApiErrorDetail(
              field: detail['field'] as String?,
              issue: detail['issue'] as String?,
            ),
      ],
    );
  }

  /// No answer at all (offline, DNS, TLS, timeout).
  factory ApiException.network() =>
      const ApiException(status: 0, code: 'NETWORK');

  final int status;
  final String code;
  final String message;
  final List<ApiErrorDetail> details;

  /// The issue reported for [field], if any.
  String? fieldIssue(String field) {
    for (final detail in details) {
      if (detail.field == field) return detail.issue;
    }
    return null;
  }

  @override
  String toString() => 'ApiException($status, $code, $message)';
}
