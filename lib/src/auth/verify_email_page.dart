import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../validators.dart';
import '../widgets/common.dart';
import 'auth_repository.dart';
import 'auth_scaffold.dart';
import 'resend_countdown.dart';
import 'session_controller.dart';

/// E-mail verification by a 6-digit OTP (FR-IAM-01): a code is sent when the
/// screen opens, and the verified session replaces the current one.
class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  final _form = GlobalKey<FormState>();
  final _code = TextEditingController();
  DateTime? _resendAvailableAt;
  bool _busy = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_send(initial: true));
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _send({bool initial = false}) async {
    try {
      final challenge = await ref
          .read(authRepositoryProvider)
          .sendVerification();
      if (!mounted) return;
      setState(() {
        _resendAvailableAt = challenge.resendAvailableAt;
        _error = null;
      });
      if (!initial) context.showMessage(context.coreL10n.verifySent);
    } catch (error) {
      // A code sent moments ago (OTP_RESEND_TOO_SOON) is still valid.
      if (mounted && !initial) setState(() => _error = error);
    }
  }

  Future<void> _verify() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(sessionControllerProvider.notifier)
          .verifyEmail(_code.text.trim());
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.coreL10n;
    final email = ref.watch(
      sessionControllerProvider.select((session) => session.value?.email ?? ''),
    );
    return AuthScaffold(
      title: l10n.verifyTitle,
      error: _error,
      children: [
        Text(l10n.verifyBody(email), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Form(
          key: _form,
          child: TextFormField(
            controller: _code,
            decoration: InputDecoration(labelText: l10n.fieldOtp),
            keyboardType: TextInputType.number,
            autofillHints: const [AutofillHints.oneTimeCode],
            maxLength: 6,
            onFieldSubmitted: (_) => _verify(),
            validator: Validators(l10n).otp,
          ),
        ),
        formGap,
        BusyButton(label: l10n.verifySubmit, busy: _busy, onPressed: _verify),
        formGap,
        ResendButton(availableAt: _resendAvailableAt, onPressed: _send),
        TextButton(
          onPressed: () =>
              ref.read(sessionControllerProvider.notifier).signOut(),
          child: Text(l10n.verifyWrongAccount),
        ),
      ],
    );
  }
}
