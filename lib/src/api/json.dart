// Readers of the proto3 JSON the API answers: int64 values travel as strings,
// timestamps as RFC 3339 strings, and fields at their default value may be
// omitted entirely.

typedef Json = Map<String, dynamic>;

extension JsonRead on Json {
  String str(String key) => (this[key] as String?) ?? '';

  String? strOrNull(String key) {
    final value = this[key] as String?;
    return value == null || value.isEmpty ? null : value;
  }

  bool flag(String key) => (this[key] as bool?) ?? false;

  int int32(String key) => (this[key] as num?)?.toInt() ?? 0;

  /// An int64 (a string in proto3 JSON, but a number is accepted too).
  int int64(String key) {
    final value = this[key];
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  DateTime? time(String key) {
    final value = this[key];
    return value is String ? DateTime.tryParse(value)?.toLocal() : null;
  }

  List<String> strings(String key) => [
    for (final value in (this[key] as List?) ?? const []) value as String,
  ];

  List<T> list<T>(String key, T Function(Json json) parse) => [
    for (final value in (this[key] as List?) ?? const []) parse(value as Json),
  ];

  Json obj(String key) => (this[key] as Json?) ?? const {};
}

/// Parses a decimal quantity ("1.5"); 0 when empty or malformed.
double parseQuantity(String value) => double.tryParse(value) ?? 0;
