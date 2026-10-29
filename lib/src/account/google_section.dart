import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_repository.dart';
import '../auth/google_id_token_source.dart';
import '../auth/session_controller.dart';
import '../auth/user.dart';
import '../widgets/common.dart';
import '../widgets/form_sheet.dart';

/// The Google account linked to the signed-in user (FR-IAM-06) on the account
/// page. Linking and unlinking are confirmed with the password; a user with
/// no password signs in with Google only and has nothing to change here.
class GoogleSection extends ConsumerWidget {
  const GoogleSection({super.key});

  Future<void> _link(BuildContext context, WidgetRef ref) async {
    final l10n = context.coreL10n;
    final source = ref.read(googleIdTokenSourceProvider);
    final user = await showFormSheet<User?>(
      context,
      _PasswordSheet<User?>(
        title: l10n.googleLinkTitle,
        body: l10n.googleLinkBody,
        submitLabel: l10n.googleLink,
        // The picker comes after the password, so a typo does not cost one.
        onSubmit: (password) async {
          final idToken = await source.signIn();
          if (idToken == null) return null;
          return ref.read(googleLinkRepositoryProvider).link(idToken, password);
        },
      ),
    );
    if (user == null) return;
    await source.signOut();
    ref.read(sessionControllerProvider.notifier).setUser(user);
    if (context.mounted) context.showMessage(l10n.googleLinkedDone);
  }

  Future<void> _unlink(BuildContext context, WidgetRef ref) async {
    final l10n = context.coreL10n;
    final session = await showFormSheet<Session>(
      context,
      _PasswordSheet<Session>(
        title: l10n.googleUnlinkTitle,
        body: l10n.googleUnlinkBody,
        submitLabel: l10n.googleUnlink,
        onSubmit: (password) =>
            ref.read(googleLinkRepositoryProvider).unlink(password),
      ),
    );
    if (session == null) return;
    await ref.read(sessionControllerProvider.notifier).adoptSession(session);
    if (context.mounted) context.showMessage(l10n.googleUnlinkedDone);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.coreL10n;
    final user = ref.watch(sessionControllerProvider).value;
    if (user == null) return const SizedBox.shrink();
    final configured = ref.watch(googleIdTokenSourceProvider).configured;
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return SectionCard(
      title: l10n.googleSectionTitle,
      children: [
        Text(l10n.googleSectionBody, style: textStyle),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: StatusChip(
            label: user.googleLinked ? l10n.googleLinked : l10n.googleNotLinked,
            tone: user.googleLinked ? ChipTone.success : ChipTone.neutral,
          ),
        ),
        const SizedBox(height: 12),
        if (!user.hasPassword)
          Text(l10n.googleNoPassword, style: textStyle)
        else if (user.googleLinked)
          OutlinedButton(
            key: const Key('google-unlink'),
            onPressed: () => _unlink(context, ref),
            child: Text(l10n.googleUnlink),
          )
        else if (configured)
          FilledButton(
            key: const Key('google-link'),
            onPressed: () => _link(context, ref),
            child: Text(l10n.googleLink),
          )
        else
          Text(l10n.googleNotConfigured, style: textStyle),
      ],
    );
  }
}

/// A sheet that asks for the password and runs [onSubmit] with it.
class _PasswordSheet<T> extends StatefulWidget {
  const _PasswordSheet({
    required this.title,
    required this.body,
    required this.submitLabel,
    required this.onSubmit,
  });

  final String title;
  final String body;
  final String submitLabel;
  final Future<T> Function(String password) onSubmit;

  @override
  State<_PasswordSheet<T>> createState() => _PasswordSheetState<T>();
}

class _PasswordSheetState<T> extends State<_PasswordSheet<T>> {
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.coreL10n;
    return FormSheet<T>(
      title: widget.title,
      submitLabel: widget.submitLabel,
      onSubmit: () => widget.onSubmit(_password.text),
      fields: (_) => [
        Text(widget.body),
        TextFormField(
          key: const Key('google-sheet-password'),
          controller: _password,
          decoration: InputDecoration(labelText: l10n.fieldPassword),
          autofocus: true,
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          autofillHints: const [AutofillHints.password],
          validator: (value) =>
              (value ?? '').isEmpty ? l10n.validationRequired : null,
        ),
      ],
    );
  }
}
