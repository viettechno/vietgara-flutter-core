import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/common.dart';
import 'auth_scaffold.dart';
import 'session_controller.dart';
import 'user.dart';

/// The second step of a sign-in (FR-IAM-09): the code of the authenticator
/// app, or a recovery code when the phone is lost. Five wrong codes lock it
/// for 15 minutes; [onBack] returns to the password.
class MfaChallengePage extends ConsumerStatefulWidget {
  const MfaChallengePage({
    super.key,
    required this.challenge,
    required this.onBack,
  });

  final MfaChallenge challenge;
  final VoidCallback onBack;

  @override
  ConsumerState<MfaChallengePage> createState() => _MfaChallengePageState();
}

class _MfaChallengePageState extends ConsumerState<MfaChallengePage> {
  final _code = TextEditingController();
  bool _recovery = false;
  bool _busy = false;
  Object? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  bool get _complete =>
      _recovery ? _code.text.trim().length >= 10 : _code.text.length == 6;

  Future<void> _submit() async {
    if (!_complete) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(sessionControllerProvider.notifier)
          .verifyMfa(widget.challenge, _code.text);
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _switchMode() => setState(() {
    _recovery = !_recovery;
    _code.clear();
    _error = null;
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.coreL10n;
    return AuthScaffold(
      title: l10n.mfaChallengeTitle,
      error: _error,
      children: [
        Text(
          _recovery ? l10n.mfaChallengeRecoveryBody : l10n.mfaChallengeBody,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        formGap,
        if (_recovery)
          TextField(
            key: const Key('mfa-recovery-code'),
            controller: _code,
            decoration: InputDecoration(
              labelText: l10n.mfaRecoveryCode,
              hintText: 'XXXXX-XXXXX',
            ),
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [LengthLimitingTextInputFormatter(12)],
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _submit(),
          )
        else
          TextField(
            key: const Key('mfa-code'),
            controller: _code,
            decoration: InputDecoration(labelText: l10n.mfaCode),
            autofocus: true,
            keyboardType: TextInputType.number,
            autofillHints: const [AutofillHints.oneTimeCode],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _submit(),
          ),
        const SizedBox(height: 20),
        BusyButton(
          key: const Key('mfa-submit'),
          label: l10n.mfaVerify,
          busy: _busy,
          onPressed: _complete ? _submit : null,
        ),
        formGap,
        TextButton(
          key: const Key('mfa-toggle'),
          onPressed: _switchMode,
          child: Text(_recovery ? l10n.mfaUseApp : l10n.mfaUseRecovery),
        ),
        TextButton(
          key: const Key('mfa-back'),
          onPressed: widget.onBack,
          child: Text(l10n.mfaBack),
        ),
      ],
    );
  }
}
