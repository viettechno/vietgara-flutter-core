import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../auth/auth_repository.dart';
import '../auth/session_controller.dart';
import '../auth/user.dart';
import '../error_text.dart';
import '../format.dart';
import '../widgets/common.dart';
import '../widgets/form_sheet.dart';

/// Two-step verification (FR-IAM-09) on the account page: an optional
/// authenticator-app code at every sign-in with e-mail and password. It
/// never applies to Google sign-in, and nothing forces it on a user.
class SecuritySection extends ConsumerWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.coreL10n;
    final status = ref.watch(mfaStatusProvider);
    return SectionCard(
      title: l10n.mfaSectionTitle,
      children: [
        Text(
          l10n.mfaSectionBody,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        switch (status) {
          AsyncData(:final value) => _Controls(status: value),
          AsyncError(:final error) => Row(
            children: [
              Expanded(child: Text(errorText(l10n, error))),
              TextButton(
                onPressed: () => ref.invalidate(mfaStatusProvider),
                child: Text(l10n.actionRetry),
              ),
            ],
          ),
          _ => const LinearProgressIndicator(),
        },
      ],
    );
  }
}

class _Controls extends ConsumerWidget {
  const _Controls({required this.status});

  final MfaStatus status;

  void _changed(WidgetRef ref, {required bool enabled}) {
    ref.read(sessionControllerProvider.notifier).setMfaEnabled(enabled);
    ref.invalidate(mfaStatusProvider);
  }

  Future<void> _turnOn(BuildContext context, WidgetRef ref) async {
    final codes = await showFormSheet<List<String>>(
      context,
      const _EnableSheet(),
    );
    if (codes == null) return;
    _changed(ref, enabled: true);
    if (context.mounted) {
      await showFormSheet<void>(context, _RecoveryCodesSheet(codes: codes));
    }
  }

  Future<void> _newCodes(BuildContext context, WidgetRef ref) async {
    final l10n = context.coreL10n;
    final codes = await showFormSheet<List<String>>(
      context,
      _CodeSheet<List<String>>(
        title: l10n.mfaRegenerateTitle,
        body: l10n.mfaRegenerateBody,
        label: l10n.mfaCode,
        submitLabel: l10n.mfaNewCodes,
        onSubmit: (code) =>
            ref.read(mfaRepositoryProvider).regenerateRecoveryCodes(code),
      ),
    );
    if (codes == null) return;
    ref.invalidate(mfaStatusProvider);
    if (context.mounted) {
      await showFormSheet<void>(context, _RecoveryCodesSheet(codes: codes));
    }
  }

  Future<void> _turnOff(BuildContext context, WidgetRef ref) async {
    final l10n = context.coreL10n;
    final done = await showFormSheet<bool>(
      context,
      _CodeSheet<bool>(
        title: l10n.mfaDisableTitle,
        body: l10n.mfaDisableBody,
        label: l10n.mfaCodeOrRecovery,
        submitLabel: l10n.mfaTurnOff,
        allowRecovery: true,
        onSubmit: (code) async {
          await ref.read(mfaRepositoryProvider).disable(code);
          return true;
        },
      ),
    );
    if (done != true) return;
    _changed(ref, enabled: false);
    if (context.mounted) context.showMessage(l10n.mfaDisabled);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.coreL10n;
    final enabledAt = status.enabledAt;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            StatusChip(
              label: status.enabled ? l10n.mfaOn : l10n.mfaOff,
              tone: status.enabled ? ChipTone.success : ChipTone.neutral,
            ),
            if (status.enabled && enabledAt != null)
              Text(
                '${l10n.mfaSince(formatDate(enabledAt, context.languageCode))} · '
                '${l10n.mfaCodesLeft(status.recoveryCodesRemaining)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (status.enabled) ...[
          OutlinedButton(
            key: const Key('mfa-new-codes'),
            onPressed: () => _newCodes(context, ref),
            child: Text(l10n.mfaNewCodes),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            key: const Key('mfa-turn-off'),
            onPressed: () => _turnOff(context, ref),
            child: Text(l10n.mfaTurnOff),
          ),
        ] else
          FilledButton(
            key: const Key('mfa-turn-on'),
            onPressed: () => _turnOn(context, ref),
            child: Text(l10n.mfaTurnOn),
          ),
      ],
    );
  }
}

/// A sheet that asks for one code and runs [onSubmit] with it.
class _CodeSheet<T> extends StatefulWidget {
  const _CodeSheet({
    required this.title,
    required this.body,
    required this.label,
    required this.submitLabel,
    required this.onSubmit,
    this.allowRecovery = false,
  });

  final String title;
  final String body;
  final String label;
  final String submitLabel;
  final bool allowRecovery;
  final Future<T> Function(String code) onSubmit;

  @override
  State<_CodeSheet<T>> createState() => _CodeSheetState<T>();
}

class _CodeSheetState<T> extends State<_CodeSheet<T>> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.coreL10n;
    return FormSheet<T>(
      title: widget.title,
      submitLabel: widget.submitLabel,
      onSubmit: () => widget.onSubmit(_code.text.trim()),
      fields: (_) => [
        Text(widget.body),
        TextFormField(
          key: const Key('mfa-sheet-code'),
          controller: _code,
          decoration: InputDecoration(labelText: widget.label),
          autofocus: true,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: widget.allowRecovery
              ? TextInputType.text
              : TextInputType.number,
          autofillHints: const [AutofillHints.oneTimeCode],
          inputFormatters: [
            if (!widget.allowRecovery) FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(widget.allowRecovery ? 12 : 6),
          ],
          validator: (value) {
            final code = (value ?? '').trim();
            if (code.isEmpty) return l10n.validationRequired;
            if (widget.allowRecovery ? code.length < 6 : code.length != 6) {
              return l10n.mfaCodeFormat;
            }
            return null;
          },
        ),
      ],
    );
  }
}

/// Turning MFA on: a new secret drawn as a QR code (and as a key to type),
/// and a code from the authenticator app that proves it holds the secret.
/// Pops the recovery codes.
class _EnableSheet extends ConsumerStatefulWidget {
  const _EnableSheet();

  @override
  ConsumerState<_EnableSheet> createState() => _EnableSheetState();
}

class _EnableSheetState extends ConsumerState<_EnableSheet> {
  final _code = TextEditingController();
  late final Future<MfaEnrollment> _enrollment = ref
      .read(mfaRepositoryProvider)
      .enroll();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.coreL10n;
    return FormSheet<List<String>>(
      title: l10n.mfaSetupTitle,
      submitLabel: l10n.mfaConfirm,
      onSubmit: () => ref.read(mfaRepositoryProvider).confirm(_code.text),
      fields: (_) => [
        Text(l10n.mfaSetupBody),
        FutureBuilder<MfaEnrollment>(
          future: _enrollment,
          builder: (context, snapshot) {
            final enrollment = snapshot.data;
            if (enrollment == null) {
              final error = snapshot.error;
              return error == null
                  ? const Center(child: CircularProgressIndicator())
                  : Text(errorText(l10n, error));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(12),
                    child: QrImageView(
                      key: const Key('mfa-qr'),
                      data: enrollment.otpauthUri,
                      size: 176,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                InfoRow(label: l10n.mfaKey, value: enrollment.secret),
                Text(
                  l10n.mfaKeyHint,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          },
        ),
        TextFormField(
          key: const Key('mfa-sheet-code'),
          controller: _code,
          decoration: InputDecoration(labelText: l10n.mfaCode),
          keyboardType: TextInputType.number,
          autofillHints: const [AutofillHints.oneTimeCode],
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          validator: (value) =>
              (value ?? '').length == 6 ? null : l10n.mfaCodeFormat,
        ),
      ],
    );
  }
}

/// The recovery codes, shown once; closing needs the user to confirm they
/// saved them.
class _RecoveryCodesSheet extends StatefulWidget {
  const _RecoveryCodesSheet({required this.codes});

  final List<String> codes;

  @override
  State<_RecoveryCodesSheet> createState() => _RecoveryCodesSheetState();
}

class _RecoveryCodesSheetState extends State<_RecoveryCodesSheet> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.coreL10n;
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.mfaCodesTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(l10n.mfaCodesBody),
            const SizedBox(height: 12),
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                for (final code in widget.codes)
                  SelectableText(
                    code,
                    style: const TextStyle(fontFamily: 'JetBrainsMono'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                key: const Key('mfa-copy-codes'),
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: widget.codes.join('\n')),
                  );
                  if (context.mounted) context.showMessage(l10n.mfaCodesCopied);
                },
                child: Text(l10n.mfaCopyAll),
              ),
            ),
            CheckboxListTile(
              key: const Key('mfa-recovery-saved'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _saved,
              onChanged: (value) => setState(() => _saved = value ?? false),
              title: Text(l10n.mfaSaved),
            ),
            const SizedBox(height: 8),
            FilledButton(
              key: const Key('mfa-recovery-done'),
              onPressed: _saved ? () => Navigator.pop(context) : null,
              child: Text(l10n.mfaDone),
            ),
          ],
        ),
      ),
    );
  }
}
