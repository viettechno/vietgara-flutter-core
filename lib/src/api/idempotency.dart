import 'dart:math';

final _random = Random.secure();

/// A new `Idempotency-Key` for [ApiClient.postIdempotent]: 128 random bits
/// as 32 hex characters. Make one per user action (opening a payment form,
/// tapping "Create settlement") and reuse it for that action's retries.
String newIdempotencyKey() => List.generate(
  16,
  (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
).join();
