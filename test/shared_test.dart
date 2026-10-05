import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vietgara_core/vietgara_core.dart';

Future<CoreLocalizations> strings(String code) =>
    CoreLocalizations.delegate.load(Locale(code));

void main() {
  group('format', () {
    // Apps get intl's date data from the localization delegates.
    setUpAll(initializeDateFormatting);

    test('money in VND per language', () {
      expect(formatMoney(1250000, 'en'), '₫1,250,000');
      expect(formatMoney(1250000, 'vi'), contains('1.250.000'));
    });

    test('quantities without a trailing .0', () {
      expect(formatQuantity('2.0'), '2');
      expect(formatQuantity('1.5'), '1.5');
      expect(formatQuantity('abc'), 'abc');
    });

    test('dates are empty when missing', () {
      expect(formatDate(null, 'en'), '');
      expect(formatDate(DateTime(2026, 10, 5), 'en'), '10/5/2026');
    });
  });

  group('validators', () {
    late Validators validators;
    setUpAll(() async => validators = Validators(await strings('en')));

    test('e-mail, password and OTP rules', () {
      expect(validators.email(''), 'Required.');
      expect(validators.email('owner'), 'Enter a valid e-mail.');
      expect(validators.email('owner@example.com'), isNull);
      expect(validators.password('short'), 'At least 8 characters.');
      expect(validators.password('long enough'), isNull);
      expect(validators.otp('12345'), 'Enter the 6-digit code.');
      expect(validators.otp('123456'), isNull);
    });
  });

  group('errorText', () {
    test('translates stable error codes, else the server message', () async {
      final l10n = await strings('en');
      expect(
        errorText(l10n, const ApiException(status: 0, code: 'NETWORK')),
        'Cannot reach VietGara. Check your connection.',
      );
      expect(
        errorText(
          l10n,
          const ApiException(status: 409, code: 'PLAN_CODE_TAKEN'),
        ),
        'A plan with this code already exists.',
      );
      expect(
        errorText(
          l10n,
          const ApiException(status: 400, code: 'NEW_CODE', message: 'Nope'),
        ),
        'Nope',
      );
      expect(errorText(l10n, Exception()), l10n.errorGeneric);
    });

    test('has a Vietnamese text for each code', () async {
      final vi = await strings('vi');
      expect(
        errorText(vi, const ApiException(status: 401, code: 'OTP_INVALID')),
        'Mã không đúng.',
      );
    });
  });

  test('Account has value equality and reads platformAdmin', () {
    final a = Account.fromJson({
      'id': 'a',
      'email': 'a@b.c',
      'fullName': 'A',
      'platformAdmin': true,
    });
    final b = Account.fromJson({
      'id': 'a',
      'email': 'a@b.c',
      'fullName': 'A',
      'platformAdmin': true,
    });
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a.platformAdmin, isTrue);
    expect(a.emailVerified, isFalse);
  });
}
