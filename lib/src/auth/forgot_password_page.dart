import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../validators.dart';
import '../widgets/common.dart';
import 'auth_repository.dart';
import 'auth_routes.dart';
import 'auth_scaffold.dart';
import 'resend_countdown.dart';

enum _Step { email, code, password }

/// Password reset by e-mail OTP (FR-IAM-04): e-mail → code → new password.
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  _Step _step = _Step.email;
  String _resetToken = '';
  DateTime? _resendAvailableAt;
  bool _busy = false;
  Object? _error;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendCode() async {
    final challenge = await ref
        .read(authRepositoryProvider)
        .requestPasswordReset(_email.text.trim());
    if (!mounted) return;
    setState(() {
      _resendAvailableAt = challenge.resendAvailableAt;
      _step = _Step.code;
    });
  }

  Future<void> _verifyCode() async {
    final token = await ref
        .read(authRepositoryProvider)
        .verifyPasswordReset(_email.text.trim(), _code.text.trim());
    if (!mounted) return;
    setState(() {
      _resetToken = token;
      _step = _Step.password;
    });
  }

  Future<void> _reset() async {
    await ref
        .read(authRepositoryProvider)
        .resetPassword(_resetToken, _password.text);
    if (!mounted) return;
    context.showMessage(context.coreL10n.forgotDone);
    context.go(AuthRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.coreL10n;
    final validators = Validators(l10n);
    final (body, field, submitLabel, action) = switch (_step) {
      _Step.email => (
        l10n.forgotEmailBody,
        TextFormField(
          controller: _email,
          decoration: InputDecoration(labelText: l10n.fieldEmail),
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          validator: validators.email,
        ),
        l10n.forgotSendCode,
        _sendCode,
      ),
      _Step.code => (
        l10n.forgotCodeBody(_email.text.trim()),
        TextFormField(
          controller: _code,
          decoration: InputDecoration(labelText: l10n.fieldOtp),
          keyboardType: TextInputType.number,
          autofillHints: const [AutofillHints.oneTimeCode],
          maxLength: 6,
          validator: validators.otp,
        ),
        l10n.actionContinue,
        _verifyCode,
      ),
      _Step.password => (
        l10n.forgotPasswordBody,
        TextFormField(
          controller: _password,
          decoration: InputDecoration(
            labelText: l10n.fieldNewPassword,
            helperText: l10n.validationPassword,
          ),
          obscureText: true,
          autofillHints: const [AutofillHints.newPassword],
          validator: validators.password,
        ),
        l10n.actionSave,
        _reset,
      ),
    };

    return AuthScaffold(
      title: l10n.forgotTitle,
      error: _error,
      showBack: true,
      children: [
        Text(body, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Form(key: _form, child: field),
        const SizedBox(height: 20),
        BusyButton(
          label: submitLabel,
          busy: _busy,
          onPressed: () => _run(action),
        ),
        if (_step == _Step.code)
          ResendButton(
            availableAt: _resendAvailableAt,
            onPressed: () async {
              try {
                final challenge = await ref
                    .read(authRepositoryProvider)
                    .requestPasswordReset(_email.text.trim());
                if (mounted) {
                  setState(
                    () => _resendAvailableAt = challenge.resendAvailableAt,
                  );
                }
              } catch (error) {
                if (mounted) setState(() => _error = error);
              }
            },
          ),
      ],
    );
  }
}
